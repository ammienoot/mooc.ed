USE `vpodata_warhol002`; -- change database name here to process different Coursera datasets
SET @course_start = '2014-10-19 16:00:00'; -- put course start date in here (in Pacific Seaboard Time) in the form 'Year-Month-Day Hour:Minute:Second'
SET @course_name = 'warhol002:User'; -- Put Course Name and Iteration in the form '<course><iteration>:User'

/*
// DO NOT EDIT BELOW THIS LINE
//////////////////////////////////*/

ALTER TABLE `hash_mapping` CHARACTER SET = utf8mb4 ;
ALTER TABLE `hash_mapping` CHANGE COLUMN `eventing_user_id` `eventing_user_id` VARCHAR(255) CHARACTER SET 'utf8mb4' NOT NULL  , CHANGE COLUMN `session_user_id` `session_user_id` VARCHAR(255) CHARACTER SET 'utf8mb4' NOT NULL  , CHANGE COLUMN `public_user_id` `public_user_id` VARCHAR(255) CHARACTER SET 'utf8mb4' NOT NULL  ;
ALTER TABLE `hash_mapping` CHANGE COLUMN `session_user_id` `session_user_id` VARCHAR(120) NOT NULL  ;
ALTER TABLE `hash_mapping` ADD INDEX `session_user_id` (`session_user_id` ASC) ;

ALTER TABLE `course_grades` CHARACTER SET = utf8mb4 ;
ALTER TABLE `course_grades` CHANGE COLUMN `session_user_id` `session_user_id` VARCHAR(160) CHARACTER SET 'utf8mb4' NOT NULL  ;
ALTER TABLE `course_grades` ADD INDEX `session_user_id` (`session_user_id` ASC) ;

ALTER TABLE `lecture_submission_metadata` ADD INDEX `session_user_id` (`session_user_id` ASC) ;

ALTER TABLE `quiz_submission_metadata` ADD INDEX `session_user_id` (`session_user_id` ASC) ;

ALTER TABLE `hg_assessment_submission_metadata` CHARACTER SET = utf8mb4 ;
ALTER TABLE `hg_assessment_submission_metadata` CHANGE COLUMN `author_id` `author_id` VARCHAR(160) CHARACTER SET 'utf8mb4' NOT NULL ;

ALTER TABLE `forum_reputation_points` ADD INDEX `user_id` (`user_id` ASC) ;

ALTER TABLE `coursera_pii` ADD INDEX `coursera_user_id` (`coursera_user_id` ASC) ;

DROP TABLE IF EXISTS `coursera_summary`;
SET SQL_SAFE_UPDATES=0;

# 1. BUILD MAIN SUMMARY TABLE
CREATE TABLE coursera_summary (
	id INT NOT NULL AUTO_INCREMENT,
	session_user_id VARCHAR(120) NOT NULL,
	user_id int(11),
	threads int(10),
	posts int(10),
	comments int(10),
	subs_forums int(10),
	subs_threads int(10),
	forums_visited int(10),
	threads_read int(10),
	reputation int(10),
	lecture_distinct int(10),
	lecture_watches int(10),
	quiz_distinct int(10),
	quiz_total_attempts int(10),
	peer_final_grade int(10),
	peer_assessments_completed int(10),
	registration_time int(10),
	last_access_time int(10),
	timezone varchar(255),
	last_access_ip varchar(45),
    ip_country varchar(45),
	ip_continent varchar(45),
	email_announcement tinyint(4),
	email_forum tinyint(4),
	normal_grade float,
	distinction_grade float,
	achievement_level varchar(255),	
	deleted tinyint(4),
	PRIMARY KEY (id),
	INDEX (user_id),
	INDEX (session_user_id)
) ENGINE=InnoDB CHARACTER SET = utf8mb4
select session_user_id, 
TIMESTAMPDIFF(day, @course_start, FROM_UNIXTIME(last_access_time, '%Y.%m.%d %H:%i:%s')) as last_access_time, 
TIMESTAMPDIFF(day, @course_start, FROM_UNIXTIME(registration_time, '%Y.%m.%d %H:%i:%s')) as registration_time, 
email_announcement, email_forum, timezone 
from users
where access_group_id in ('4','5','6','9')
and last_access_time != 0;

# ADD IN USER_ID FROM THE MAPPING TABLE. USED TO JOIN THE FORUM DATA INTO THE MAIN SUMMARY.
UPDATE coursera_summary cs
    INNER JOIN hash_mapping hm
        ON cs.session_user_id = hm.session_user_id
    SET cs.user_id = hm.user_id;

# ADD IN OVERALL GRADE INFORMATION
UPDATE coursera_summary cs
    INNER JOIN course_grades cg
        ON cs.session_user_id = cg.session_user_id
    SET cs.normal_grade = cg.normal_grade, 
		cs.distinction_grade = cg.distinction_grade, 
		cs.achievement_level = cg.achievement_level;


# 2. ADD IN FORUM DATA

# How many threads did a user start
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
            SELECT DISTINCT(user_id) as user_id, count(id) as threads
            FROM forum_threads
            GROUP BY user_id
        ) c ON  cs.user_id = c.user_id
SET     cs.threads = c.threads;

# how many posts in a thread did a user make
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
            SELECT DISTINCT(user_id) as user_id, count(id) as posts
            FROM forum_posts
            GROUP BY user_id
        ) c ON  cs.user_id = c.user_id
SET     cs.posts = c.posts;

# how many replies to a post did a user make
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
            SELECT DISTINCT(user_id) as user_id, count(id) as comments
            FROM forum_comments
            GROUP BY user_id
        ) c ON  cs.user_id = c.user_id
SET     cs.comments = c.comments;

# what reputation ranking does a user have
SET SQL_SAFE_UPDATES=0;
UPDATE coursera_summary cs
    INNER JOIN forum_reputation_points fpr
        ON cs.user_id = fpr.user_id
    SET cs.reputation = fpr.points;

# how many forums did they opt for email updates from
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
            SELECT DISTINCT(user_id) as user_id, count(*) as subs_forums
            FROM forum_subscribe_forums
            GROUP BY user_id
        ) c ON  cs.user_id = c.user_id
SET     cs.subs_forums = c.subs_forums;

# how many threads did they opt for email updates from
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
            SELECT DISTINCT(user_id) as user_id, count(*) as subs_threads
            FROM forum_subscribe_threads
            GROUP BY user_id
        ) c ON  cs.user_id = c.user_id
SET     cs.subs_threads = c.subs_threads;

# how many forums did they view
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
            select distinct(substring(`key`,instr(`key`, '.') + 1)) as user_id, 
			count(SUBSTRING_INDEX(SUBSTR(`key`,instr(`key`, '_') + 1),'.',1)) as forums_visited
			from `kvs_course.forum_readrecord`
			group by substring(`key`,instr(`key`, '.') + 1)
        ) c ON  cs.user_id = c.user_id
SET     cs.forums_visited = c.forums_visited;

# How many threads did they view
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
			select distinct(substring(`key`,instr(`key`, '.') + 1)) as user_id, 
			sum(SUBSTRING_INDEX(substr(`value`,(instr(`value`, 'a') + 2)),':',1)) as threads_read
			from `kvs_course.forum_readrecord`
			where `value` not like '%_all%'
			group by substring(`key`,instr(`key`, '.') + 1)
        ) c ON  cs.user_id = c.user_id
SET     cs.threads_read = c.threads_read;

# 3. ADDIN OTHER TOOLS

# how many lectures did they watch and how many times?
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
			select distinct(session_user_id), count(distinct(item_id)) as lecture_distinct, count(*) as lecture_watches
			FROM lecture_submission_metadata
			group by session_user_id
        ) c ON  cs.session_user_id = c.session_user_id
SET     cs.lecture_distinct = c.lecture_distinct, cs.lecture_watches = c.lecture_watches;

# how many quizzes did they take and how many times?
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
			select distinct(session_user_id), count(distinct(item_id)) as quiz_distinct, count(*) as quiz_total_attempts
			FROM quiz_submission_metadata
			group by session_user_id
        ) c ON  cs.session_user_id = c.session_user_id
SET     cs.quiz_distinct = c.quiz_distinct, cs.quiz_total_attempts = c.quiz_total_attempts;

# how many peer assessments did they do?
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
		SELECT distinct(aem.author_id), count(*) as peer_assessments_completed
		FROM hg_assessment_evaluation_metadata aem
		group by aem.author_id
        ) c ON  cs.session_user_id = c.author_id
SET     cs.peer_assessments_completed = c.peer_assessments_completed;

# what grade did they get in their final peer assessment?
SET SQL_SAFE_UPDATES=0;
UPDATE  coursera_summary cs
        INNER JOIN
        (
			SELECT distinct(asm.author_id), aoem.final_grade as peer_final_grade
			FROM hg_assessment_submission_metadata asm, hg_assessment_metadata am, hg_assessment_overall_evaluation_metadata aoem
			where am.id = asm.assessment_id
			and aoem.submission_id = asm.id
			and am.deleted = 0
			group by asm.author_id
        ) c ON  cs.session_user_id = c.author_id
SET     cs.peer_final_grade = c.peer_final_grade;

CREATE TABLE coursera_gradebook (
    session_user_id VARCHAR(120),
    coursera_user_id VARCHAR(120),
    Achievement VARCHAR(255),
    PRIMARY KEY (coursera_user_id),
    INDEX (coursera_user_id)
) ENGINE=InnoDB CHARACTER SET = utf8mb4;

SET SQL_SAFE_UPDATES=0;
UPDATE coursera_summary cs
    INNER JOIN coursera_gradebook cg
        ON cs.session_user_id = cg.session_user_id
    SET cs.achievement_level = cg.Achievement;