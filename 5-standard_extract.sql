select CONCAT('Warhol',id) as user_name, -- Replace 'Warhol' with your course name
IFNULL(threads, '') as threads, 
IFNULL(posts, '') as posts, 
IFNULL(comments, '') as comments, 
IFNULL(subs_forums, '') as subs_forums, 
IFNULL(subs_threads, '') as subs_threads,
IFNULL(forums_visited, '') as forums_visited,
IFNULL(threads_read, '') as threads_read, 
IFNULL(reputation, '') as reputation, 
IFNULL(lecture_distinct, '') as lecture_distinct,
IFNULL(lecture_watches, '') as lecture_watches, 
IFNULL((quiz_distinct-1), '') as quiz_distinct,	
IFNULL((quiz_total_attempts-1), '') as quiz_total_attempts, 
IFNULL(peer_final_grade, '') as peer_final_grade, 
IFNULL(peer_assessments_completed, '') as peer_assessments_completed, 
IFNULL(ip_country, '') as ip_country, 
IFNULL(ip_continent, '') as ip_continent, 
IFNULL(normal_grade, '') as normal_grade, 
IFNULL(distinction_grade, '') as distinction_grade, 
IFNULL(achievement_level, '') as achievement_level,
IFNULL(last_access_time, '') as last_access_time, 
IFNULL(registration_time, '') as registration_time, 
IFNULL(email_announcement, '') as email_announcement, 
IFNULL(email_forum, '') as email_forum, 
IFNULL(timezone, '') as timezone,
IFNULL(deleted,'') as deleted
FROM coursera_summary
-- where last_access_time != 0
LIMIT 0, 100000;