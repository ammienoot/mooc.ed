USE `vpodata_warhol002`; -- change schema name here to process different Coursera datasets
SET @course_name = 'warhol' ; -- change course name

/*
// DO NOT EDIT BELOW THIS LINE
//////////////////////////////////*/

DROP TABLE IF EXISTS `coursera_tool_usage_summary`;
SET SQL_SAFE_UPDATES=0;

# 1. BUILD MAIN SUMMARY TABLE
CREATE TABLE coursera_tool_usage_summary (
	activity VARCHAR(255),
	user_group VARCHAR(255),
	user_count VARCHAR(255)
) ENGINE=InnoDB;

-- All students
INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Posting to Forums' as activity, 'All Students' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null);

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Reading Forums' as activity, 'All Students' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE (threads_read is not null or forums_visited is not null);

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Watching Lectures' as activity, 'All Students' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE lecture_distinct is not null;

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Taking Quizzes' as activity, 'All Students' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE quiz_distinct is not null;

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Peer Assessments' as activity, 'All Students' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE peer_final_grade is not null;

-- Not completed
INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Posting to Forums' as activity, 'Not completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null)
	AND achievement_level like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Reading Forums' as activity, 'Not completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE (threads_read is not null or forums_visited is not null)
	AND achievement_level like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Watching Lectures' as activity, 'Not completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE lecture_distinct is not null
	AND achievement_level like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Taking Quizzes' as activity, 'Not completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE quiz_distinct is not null
	AND achievement_level like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Peer Assessments' as activity, 'Not completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE peer_final_grade is not null
	AND achievement_level like 'none';

-- Completed (SOA)
INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Posting to Forums' as activity, 'Completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null)
	AND achievement_level not like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Reading Forums' as activity, 'Completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE (threads_read is not null or forums_visited is not null)
	AND achievement_level not like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Watching Lectures' as activity, 'Completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE lecture_distinct is not null
	AND achievement_level not like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Taking Quizzes' as activity, 'Completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE quiz_distinct is not null
	AND achievement_level not like 'none';

INSERT INTO coursera_tool_usage_summary (activity, user_group, user_count)
	SELECT 'Peer Assessments' as activity, 'Completed' as user_group, COUNT(user_id) as user_count
	FROM coursera_summary
	WHERE peer_final_grade is not null
	AND achievement_level not like 'none';

DROP TABLE IF EXISTS `coursera_tool_usage`;
SET SQL_SAFE_UPDATES=0;

# 1. BUILD MAIN SUMMARY TABLE
CREATE TABLE coursera_tool_usage (
	session_user_id VARCHAR(120) NOT NULL,
	posting int(2),
	reading int(2),
	lectures int(2),
	quizzes int(2),
	peer int(2),
	INDEX (session_user_id)
) ENGINE=InnoDB CHARACTER SET = utf8mb4
select session_user_id
from users
where access_group_id in ('4','5','6','9')
and last_access_time != 0;


# ADD IN WHETHER A USER DID A THING OR NOT
UPDATE coursera_tool_usage ctu
    INNER JOIN coursera_summary cs
        ON ctu.session_user_id = cs.session_user_id
    SET ctu.posting = '1'
	WHERE (cs.threads is not null or cs.posts is not null or cs.comments is not null);

UPDATE coursera_tool_usage ctu
    INNER JOIN coursera_summary cs
        ON ctu.session_user_id = cs.session_user_id
    SET ctu.reading = '1'
	WHERE (threads_read is not null or forums_visited is not null);

UPDATE coursera_tool_usage ctu
    INNER JOIN coursera_summary cs
        ON ctu.session_user_id = cs.session_user_id
    SET ctu.lectures = '1'
	WHERE lecture_distinct is not null;

UPDATE coursera_tool_usage ctu
    INNER JOIN coursera_summary cs
        ON ctu.session_user_id = cs.session_user_id
    SET ctu.quizzes = '1'
	WHERE quiz_distinct is not null;

UPDATE coursera_tool_usage ctu
    INNER JOIN coursera_summary cs
        ON ctu.session_user_id = cs.session_user_id
    SET ctu.peer = '1'
	WHERE peer_final_grade is not null;

SET SQL_SAFE_UPDATES=0;
DROP TABLE IF EXISTS `coursera_tool_summary_google`;

CREATE TABLE coursera_tool_summary_google (
	location varchar(255),
	parent varchar(255),
	tool_usage varchar(255),
	tool_colour varchar(255)
) ENGINE=InnoDB 
select 'Location' as location, 'Parent' as parent, 'Tools used (size)' as tool_usage, 'Tools used (color)' as tool_colour;

INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
select @course_name as location, '' as parent, 10 as tool_usage, 10 as tool_colour;

INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('All students (',count(distinct(user_id)), ')') using utf8) as location, @course_name as parent, 10 as tool_usage, 10 as tool_colour
	FROM coursera_summary;

INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('Completed students only (',count(distinct(user_id)), ')') using utf8) as location, @course_name as parent, 10 as tool_usage, 10 as tool_colour
	FROM coursera_summary
	WHERE achievement_level not like 'none';
	
-- (1) 1 writing in forums
SET SQL_SAFE_UPDATES=0;
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('writing in forums (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (2) 2 reading in forums
SET SQL_SAFE_UPDATES=0;
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading in forums (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (3) 3 watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (4) 4 taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (5) 5 taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (6) 1-2 posting and reading forums
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and reading forums (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	where (threads is not null or posts is not null or comments is not null)
	and (threads_read is not null or forums_visited is not null)
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (7) 1-3 posting and watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null)
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (8) 1-4 posting and taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	where (threads is not null or posts is not null or comments is not null)
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	and quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments;

-- (9) 1-5 posting and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	and peer_final_grade is not null; -- peer assessments
	

-- (10) 2-3 reading and watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading and watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null; -- peer assessments


-- (11) 2-4 reading and taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading and taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (12) 2-5 reading and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null; -- peer assessments;

-- (13) 3-4 watching lectures and taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures and taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (14) 3-5 watching lectures and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (15) 4-5 taking quizzes and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('taking quizzes and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (16) 1-2-3 posting, reading, watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (17) 1-2-4 posting, reading, taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (18) 1-2-5 posting, reading, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (19) 1-3-4 posting, watching lectures, taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, watching lectures, taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (20) 1-3-5 posting, watching lectures, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, watching lectures, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (21) 1-4-5 posting, taking quizzes, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, taking quizzes, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (22) 2-3-4 reading, watching lectures, taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, watching lectures, taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads and null or posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (23) 2-3-5 reading, watching lectures, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, watching lectures, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (24) 2-4-5 reading, taking quizzes, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, taking quizzes, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments and null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (25) 3-4-5 watching lectures, taking quizzes, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures, taking quizzes, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (26) 1-2-3-4 posting, reading, lectures, quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, lectures, quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null; -- peer assessments

-- (27) 1-2-3-5 posting, reading, lecture, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, lecture, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (28) 1-2-4-5 posting, reading, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (29) 1-3-4-5 posting, lectures, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, lectures, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (30) 2-3-4-5 reading, lectures, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, lectures, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- (31) 1-2-3-4-5 posting, reading, lectures, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, lectures, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'All students' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null; -- peer assessments

-- Tidy up parent records
SET SQL_SAFE_UPDATES=0;
UPDATE coursera_tool_summary_google dest, (SELECT convert(concat('All students (',count(distinct(user_id)), ')') using utf8) as parent FROM coursera_summary) src 
  SET dest.parent = src.parent 
  WHERE dest.parent like 'All students';

-- start data for SOA students 
-- (1) 1 writing in forums
SET SQL_SAFE_UPDATES=0;
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('writing in forums (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (2) 2 reading in forums
SET SQL_SAFE_UPDATES=0;
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading in forums (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (3) 3 watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (4) 4 taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (5) 5 taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (6) 1-2 posting and reading forums
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and reading forums (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	where (threads is not null or posts is not null or comments is not null)
	and (threads_read is not null or forums_visited is not null)
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (7) 1-3 posting and watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null)
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (8) 1-4 posting and taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	where (threads is not null or posts is not null or comments is not null)
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	and quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (9) 1-5 posting and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';
	
-- (10) 2-3 reading and watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading and watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (11) 2-4 reading and taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading and taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (12) 2-5 reading and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (13) 3-4 watching lectures and taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures and taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (14) 3-5 watching lectures and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (15) 4-5 taking quizzes and taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('taking quizzes and taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (16) 1-2-3 posting, reading, watching lectures
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, watching lectures (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (17) 1-2-4 posting, reading, taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (18) 1-2-5 posting, reading, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (19) 1-3-4 posting, watching lectures, taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, watching lectures, taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (20) 1-3-5 posting, watching lectures, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, watching lectures, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (21) 1-4-5 posting, taking quizzes, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, taking quizzes, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (22) 2-3-4 reading, watching lectures, taking quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, watching lectures, taking quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads and null or posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (23) 2-3-5 reading, watching lectures, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, watching lectures, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (24) 2-4-5 reading, taking quizzes, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, taking quizzes, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments and null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (25) 3-4-5 watching lectures, taking quizzes, taking peer assessments
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('watching lectures, taking quizzes, taking peer assessments (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (26) 1-2-3-4 posting, reading, lectures, quizzes
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, lectures, quizzes (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is null -- peer assessments 
	and achievement_level not like 'none';

-- (27) 1-2-3-5 posting, reading, lecture, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, lecture, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (28) 1-2-4-5 posting, reading, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (29) 1-3-4-5 posting, lectures, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, lectures, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is null and forums_visited is null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (30) 2-3-4-5 reading, lectures, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('reading, lectures, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is null and posts is null and comments is null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- (31) 1-2-3-4-5 posting, reading, lectures, quizzes, peer assessment
INSERT INTO coursera_tool_summary_google (location, parent, tool_usage, tool_colour)
	SELECT convert(concat('posting, reading, lectures, quizzes, peer assessment (',count(distinct(user_id)), ')') using utf8) as location, 'Completed students only' as parent, count(distinct(user_id)) as tool_usage, count(distinct(user_id)) as tool_colour
	FROM coursera_summary
	WHERE (threads is not null or posts is not null or comments is not null) -- posting
	AND (threads_read is not null or forums_visited is not null) -- reading
	AND lecture_distinct is not null -- lectures
	AND quiz_distinct is not null -- quizzes
	AND peer_final_grade is not null -- peer assessments 
	and achievement_level not like 'none';

-- Tidy up parent records
SET SQL_SAFE_UPDATES=0;
UPDATE coursera_tool_summary_google dest, (SELECT convert(concat('Completed students only (',count(distinct(user_id)), ')') using utf8) as parent FROM coursera_summary where achievement_level not like 'none') src 
  SET dest.parent = src.parent 
  WHERE dest.parent like 'Completed students only';