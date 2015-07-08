SELECT 'session_user_id', 'user_id', 'submission_time', 'english', 'cert', 'learn_new', 'improve', 'new_people', 'try_online', 'try_MOOC', 'browse_ed', 'unsure', 'gender', 'age', 'academic_level', 'same_subject', 'ip_country', 'ip_continent', 'achievement_level', 'last_access_time', 'forum_new_threads', 'forums_posted', 'forums_visited', 'threads_read', 'lecture_watches', 'quiz_attempts', 'peers'
UNION ALL
SELECT ces.*, 
cs.ip_country, 
cs.ip_continent, 
cs.achievement_level, 
cs.last_access_time, 
cs.threads as forum_new_threads,
(IFNULL(cs.posts,0) + IFNULL(cs.comments,0)) as forums_posted,
cs.forums_visited as forums_visited,
cs.threads_read as threads_read,
cs.lecture_watches as lecture_watches,
(cs.quiz_total_attempts - 1) as quiz_attempts,
cs.peer_assessments_completed as peer
FROM coursera_summary cs, coursera_survey_merged ces
WHERE cs.session_user_id = ces.session_user_id