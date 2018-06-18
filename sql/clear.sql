
 DROP FUNCTION IF EXISTS bmi(integer, date) CASCADE;
 DROP FUNCTION IF EXISTS bmi_description(numeric) CASCADE;
 DROP FUNCTION IF EXISTS find_section(integer, date, integer) CASCADE;
 DROP FUNCTION IF EXISTS get_age(integer, timestamp without time zone) CASCADE;
 DROP FUNCTION IF EXISTS get_age(integer, date) CASCADE;
 DROP FUNCTION IF EXISTS get_best_stuff(integer) CASCADE;
 DROP FUNCTION IF EXISTS get_heigth(integer, date) CASCADE;
 DROP FUNCTION IF EXISTS get_my_med(integer, date) CASCADE;
 DROP FUNCTION IF EXISTS get_table(text) CASCADE;
 DROP FUNCTION IF EXISTS get_weight(integer, timestamp without time zone) CASCADE;
 DROP FUNCTION IF EXISTS heartrate_session_type(integer, integer) CASCADE;
 DROP FUNCTION IF EXISTS heartrates_check() CASCADE;
 DROP FUNCTION IF EXISTS height_weight_changes() CASCADE;
 DROP FUNCTION IF EXISTS height_weight_check() CASCADE;
 DROP FUNCTION IF EXISTS injuries_check() CASCADE;
 DROP FUNCTION IF EXISTS kcal(integer, timestamp without time zone, timestamp without time zone) CASCADE;
 DROP FUNCTION IF EXISTS kcal_during_session(integer, integer) CASCADE;
 DROP FUNCTION IF EXISTS max_heartrate(numeric) CASCADE;
 DROP FUNCTION IF EXISTS min_heartrate(numeric) CASCADE;
 DROP FUNCTION IF EXISTS section_ranking(integer, date, date) CASCADE;
 DROP FUNCTION IF EXISTS sections_check() CASCADE;
 DROP FUNCTION IF EXISTS sessions_check() CASCADE;
 DROP FUNCTION IF EXISTS sleep_check() CASCADE;
 DROP FUNCTION IF EXISTS time_interval_check(integer, timestamp without time zone, timestamp without time zone, text) CASCADE;
 DROP FUNCTION IF EXISTS timetable(integer, date, date) CASCADE ;
 DROP FUNCTION IF EXISTS user_section_check() CASCADE;
 DROP FUNCTION IF EXISTS user_session_check() CASCADE;                     

 DROP TABLE IF EXISTS "users" CASCADE;
 DROP TABLE IF EXISTS "sleep" CASCADE;
 DROP TABLE IF EXISTS "injuries" CASCADE;
 DROP TABLE IF EXISTS "height_weight" CASCADE;
 DROP TABLE IF EXISTS "heartrates" CASCADE;
 DROP TABLE IF EXISTS "medications" CASCADE;
 DROP TABLE IF EXISTS "activities" CASCADE;
 DROP TABLE IF EXISTS "user_section" CASCADE;
 DROP TABLE IF EXISTS "user_medication" CASCADE;
 DROP TABLE IF EXISTS "sections" CASCADE;
 DROP TABLE IF EXISTS "user_session" CASCADE;
 DROP TABLE IF EXISTS "sessions" CASCADE;

