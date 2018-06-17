--funtions

----
CREATE OR REPLACE FUNCTION get_weight(userid INTEGER, day TIMESTAMP)
  RETURNS NUMERIC(3) AS
$$
SELECT
 weight
FROM height_weight
WHERE user_id = userid AND "date" <= day
ORDER BY "date" DESC
LIMIT 1;
$$
LANGUAGE sql;


----
CREATE OR REPLACE FUNCTION get_heigth(userid INTEGER, day DATE)
  RETURNS NUMERIC(3) AS
$$
SELECT
  height
FROM height_weight
WHERE user_id = userid AND "date" <= day
ORDER BY "date" DESC
LIMIT 1;
$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_age(userid INTEGER, day DATE)
  RETURNS NUMERIC AS
$$
SELECT
  DATE_PART('year',age(day,birthday))::NUMERIC
FROM users
WHERE user_id = userid;
$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_age(userid INTEGER, day TIMESTAMP)
  RETURNS NUMERIC AS
$$
SELECT
  DATE_PART('year',age(day,birthday))::NUMERIC
FROM users
WHERE user_id = userid;
$$
LANGUAGE sql;
----
CREATE OR REPLACE FUNCTION kcal(userid INTEGER, start_0 TIMESTAMP, end_0 TIMESTAMP)
  RETURNS NUMERIC AS $$
DECLARE
  i        NUMERIC;
  j        TIMESTAMP;
  k        TIMESTAMP;
  m        NUMERIC;
  sex_0    CHAR;
  age_0    NUMERIC;
  weight_0 NUMERIC;
  seconds  NUMERIC;
  heartrates_0    NUMERIC;
  lasttime        TIMESTAMP;
  avg_heartrate_0 NUMERIC;
  last_weight NUMERIC;
  last_age NUMERIC;
  result NUMERIC;
  t timestamp;
BEGIN
  IF end_0<=start_0 THEN RETURN 0.00; END IF;
  IF end_0 IS NULL THEN end_0  = CURRENT_TIMESTAMP::timestamp without time zone; END IF;
  t = (SELECT MIN("date"::TIMESTAMP) FROM height_weight where weight is not null GROUP BY user_id HAVING user_id=userid);
  IF t > start_0 THEN start_0=t; END IF;
  IF t IS NULL THEN RAISE NOTICE 'NO INFORMATION ABOUT WEIGHT'; RETURN 0.00; END IF;
  sex_0 = (SELECT sex
           FROM users
           WHERE user_id = userid);
  age_0 = get_age(userid,start_0);
  weight_0 = get_weight(userid, start_0::DATE);
  seconds = 0;
  heartrates_0 = 0;
  result=0;
  FOR i, j, k IN SELECT
                   avg_heartrate,
                   start_time,
                   end_time
                 FROM heartrates h
                 WHERE h.user_id = userid AND h.end_time >= start_0 AND h.start_time <= end_0
  LOOP

    m = (SELECT EXTRACT(EPOCH FROM (k - j)));
    IF j < start_0
    THEN m = m - (SELECT EXTRACT(EPOCH FROM (start_0 - j))) ;END IF;
    IF k > end_0
    THEN m = m - (SELECT EXTRACT(EPOCH FROM (k - end_0))) ; END IF;
    heartrates_0 = heartrates_0 + i * m;
    seconds = seconds + m;
last_weight = weight_0;
    weight_0 = get_weight(userid, j::TIMESTAMP);
 last_age = age_0;
    age_0 = get_age(userid,j);

    if last_weight != weight_0 OR age_0!=last_age THEN

  IF seconds>0 THEN
      avg_heartrate_0 = heartrates_0 / seconds;
      IF sex_0 = 'm' THEN
          result = result + ((last_age * 0.2017) - (last_weight * 0.09036) + (avg_heartrate_0 * 0.6309) - 55.0969) * (seconds / 60) / 4.184;
        ELSE
        result = result + ((last_age * 0.074) - (last_weight  * 0.05741) + (avg_heartrate_0 * 0.4472) - 20.4022) * (seconds / 60) / 4.184;
      END IF;
     seconds = 0;
     heartrates_0=0;
     END IF;
   END IF;
  END LOOP;
  IF seconds>0 THEN
  avg_heartrate_0 = heartrates_0 / seconds;
    IF sex_0 = 'm' THEN
        result = result + ((last_age * 0.2017) - (last_weight * 0.09036) + (avg_heartrate_0 * 0.6309) - 55.0969) * (seconds / 60) / 4.184;
      ELSE
      result = result + ((last_age * 0.074) - (last_weight  * 0.05741) + (avg_heartrate_0 * 0.4472) - 20.4022) * (seconds / 60) / 4.184;
    END IF;

  END IF;
  RETURN ROUND(result,2);
END;
$$
LANGUAGE plpgsql;


----
CREATE OR REPLACE FUNCTION kcal_during_session(userid INTEGER, sessionid INTEGER)
  RETURNS NUMERIC AS $$
DECLARE
  start_0  TIMESTAMP;
  end_0    TIMESTAMP;
BEGIN

  start_0 = (SELECT start_time
             FROM sessions s
             WHERE s.session_id = sessionid);
  end_0 = (SELECT end_time
           FROM sessions s
           WHERE s.session_id = sessionid);
  RETURN kcal(userid,start_0,end_0);
END;
$$
LANGUAGE plpgsql;


----
CREATE OR REPLACE FUNCTION max_heartrate(age NUMERIC)
  RETURNS NUMERIC AS $$
BEGIN
RETURN 211-(age*0.64);
END;
$$
LANGUAGE plpgsql;


----
CREATE OR REPLACE FUNCTION min_heartrate(age NUMERIC)
  RETURNS NUMERIC AS $$
BEGIN
RETURN max_heartrate(age)*0.3;
END;
$$
LANGUAGE plpgsql;


----
CREATE OR REPLACE FUNCTION bmi(user_id_0 INTEGER, date_0 DATE)
  RETURNS NUMERIC AS $$
DECLARE
  weight_0 NUMERIC;
  height_0 NUMERIC;

BEGIN
  IF date_0 IS NULL
    THEN date_0 = CURRENT_DATE; END IF;
  weight_0 = get_weight(user_id_0, date_0);
  height_0 = get_heigth(user_id_0, date_0) / 100;
  IF height_0 IS NULL OR weight_0 IS NULL
  THEN RAISE NOTICE 'NO DATA PROVIDED';
  RETURN NULL; END IF;
  RETURN ROUND(weight_0 / (height_0 * height_0), 2);
END;
$$
LANGUAGE plpgsql;


----
CREATE OR REPLACE FUNCTION bmi_description(bmi NUMERIC)
  RETURNS VARCHAR AS $$
DECLARE

BEGIN
  IF bmi<15 THEN RETURN 'very severely underweight';
  ELSIF bmi<16 THEN RETURN 'severely underweight';
  ELSIF bmi<18.5 THEN RETURN 'underweight';
  ELSIF bmi<25 THEN RETURN 'normal';
  ELSIF bmi<30 THEN RETURN 'obese class I';
  ELSIF bmi<35 THEN RETURN 'obese class II';
  ELSIF bmi<40 THEN RETURN 'obese class III';
  ELSIF bmi<45 THEN RETURN 'obese class IV';
  ELSE RETURN 'obese class V'; END IF;
END;
$$
LANGUAGE plpgsql;


----NIE DZIAŁA
CREATE OR REPLACE VIEW height_weight_changes(user_id, start_time, end_time, hight_change, weight_change) AS
  SELECT
    user_id,
    (
      SELECT "date"
      FROM height_weight
      WHERE (height IS NOT NULL OR weight IS NOT NULL)
            AND "date" = (SELECT max("date")
                          FROM height_weight
                          WHERE user_id = hw.user_id
                                AND "date" < hw."date" AND (height IS NOT NULL OR weight IS NOT NULL))
    )                                                                                          AS start_time,
    "date"                                                                                     AS end_time,
    height - (SELECT height
              FROM height_weight
              WHERE height IS NOT NULL
                    AND "date" = (SELECT max("date")
                                  FROM height_weight
                                  WHERE user_id = hw.user_id AND "date" < hw."date" AND height IS NOT
                                                                                        NULL)) AS height_change,
    weight - (SELECT weight
              FROM height_weight
              WHERE weight IS NOT NULL
                    AND "date" = (SELECT max("date")
                                  FROM height_weight
                                  WHERE user_id = hw.user_id AND "date" < hw."date" AND weight IS NOT
                                                                                        NULL)) AS weight_change
  FROM height_weight hw
  WHERE date != (SELECT min("date")
                 FROM height_weight
                 WHERE user_id = hw.user_id)
  ORDER BY "date";


----
CREATE OR REPLACE VIEW user_min_max_heartrate(user_id, min, max)
  AS
    SELECT
      u.user_id,
      min(avg_heartrate),
      max(avg_heartrate)
    FROM users u
      LEFT JOIN heartrates h ON u.user_id = h.user_id
    GROUP BY u.user_id
    ORDER BY 1;

----
DROP FUNCTION IF EXISTS heartrate_session_type(INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION heartrate_session_type(user_idd INTEGER, session_idd INTEGER)
  RETURNS VARCHAR AS
$$
DECLARE
  avg NUMERIC;
  mini NUMERIC;
  maxi NUMERIC;
  perc NUMERIC;
BEGIN
  avg = (SELECT avg(avg_heartrate)
         FROM heartrates
         WHERE start_time BETWEEN (SELECT start_time FROM sessions WHERE session_id = session_idd)
               AND (SELECT sessions.end_time FROM sessions WHERE session_id = session_idd)
               AND user_id = user_idd
         GROUP BY user_id);
  mini = (SELECT min FROM user_min_max_heartrate WHERE user_id = user_idd);
  maxi = (SELECT max FROM user_min_max_heartrate WHERE user_id = user_idd);
  perc = 100*(avg-mini)/(maxi-mini);
  IF perc < 50 THEN
    RETURN 'COACH PATATO WALK';
  END IF;
  IF perc < 60 THEN
    RETURN 'VERY LIGHT';
  END IF;
  IF perc < 70 THEN
    RETURN 'LIGHT';
  END IF;
  IF perc < 80 THEN
    RETURN 'MODERATE';
  END IF;
  IF perc < 90 THEN
    RETURN 'HARD';
  END IF;
  IF perc <= 100 THEN
    RETURN 'MAXIMUM';
  END IF;
END;
$$
LANGUAGE plpgsql;

----
DROP FUNCTION IF EXISTS timetable(INTEGER,DATE) CASCADE;
CREATE OR REPLACE FUNCTION timetable(user_idd INTEGER, day DATE)
  RETURNS TABLE(session_id INTEGER, name VARCHAR, start_time TIMESTAMP, end_time TIMESTAMP, distance NUMERIC, description VARCHAR) AS
$$
SELECT
   s.session_id, name, s.start_time, s.end_time, distance, description
FROM user_session us
  JOIN sessions s ON us.session_id = s.session_id
  JOIN activities a ON s.activity_id = a.activity_id
WHERE user_id = user_idd AND s.start_time::DATE = day OR s.end_time::DATE = day
UNION
SELECT NULL,'spanie', start_time, end_time, NULL, NULL
FROM sleep
WHERE user_id = user_idd AND start_time::DATE = day OR end_time::DATE = day;
$$
LANGUAGE sql;

----
DROP FUNCTION IF EXISTS get_my_med(INTEGER,DATE) CASCADE;
CREATE OR REPLACE FUNCTION get_my_med(id INTEGER, day DATE)
  RETURNS CHARACTER VARYING[] AS
$$
SELECT ARRAY(SELECT DISTINCT name
             FROM user_medication um
               JOIN medications m2 ON um.medication_id = m2.medication_id
             WHERE user_id = id AND um.date :: DATE = day
             ORDER BY name)
$$
LANGUAGE SQL;

----
CREATE OR REPLACE VIEW activities_meds
  AS
    SELECT
      user_id,
      s.start_time :: DATE,
      extract(EPOCH FROM (s.end_time - s.start_time))/60 as duration,
      a.activity_id,
      us.distance,
      description,
      get_my_med(user_id, s.start_time :: DATE) as medications
    FROM user_session us
      JOIN sessions s ON us.session_id = s.session_id
      JOIN activities a ON s.activity_id = a.activity_id;

----
DROP FUNCTION IF EXISTS get_best_stuff(INTEGER) CASCADE;
CREATE OR REPLACE FUNCTION get_best_stuff(act_id INTEGER)
  RETURNS TABLE(medications CHARACTER VARYING[],avg_result NUMERIC) AS
$$
SELECT
  a.medications,
  round(coalesce(avg(distance), avg(duration))::NUMERIC, 2) as result
FROM activities_meds a
WHERE activity_id = act_id
GROUP BY activity_id, medications
ORDER BY result DESC LIMIT 1;
$$
LANGUAGE sql;

----
CREATE VIEW best_medication_sets(activity, medication_set, result) AS
  SELECT
    a.name,
    (select gb.medications from get_best_stuff(a.activity_id) gb),
    (select gb.avg_result from get_best_stuff(a.activity_id) gb)
  FROM activities a;

----
CREATE OR REPLACE VIEW weight_differences(user_id, month, difference_sum) AS
  SELECT
    user_id,
    to_char("date", 'Month'),
    max(weight)-min(weight)
  FROM height_weight hw
  GROUP BY user_id, to_char("date", 'Month')
  ORDER BY 1, 2;

----
CREATE OR REPLACE VIEW months_weight_differences(month, difference_avg) AS
  SELECT
    month,
    avg(difference_sum)
  FROM weight_differences
  GROUP BY month
  ORDER BY  avg(difference_sum) DESC;

----
CREATE OR REPLACE VIEW activities_sleep_avg_result AS
  SELECT
    a.name,
    avg(coalesce(distance, extract(EPOCH FROM (ses.end_time - ses.start_time))/60) ) result,
    to_char(s.end_time - s.start_time, 'hh:MIh') sleep_duration
  FROM user_session us
  JOIN sessions ses ON us.session_id = ses.session_id
  JOIN activities a ON ses.activity_id = a.activity_id
  JOIN sleep s ON us.user_id = s.user_id AND ses.start_time::DATE = s.start_time::DATE
  GROUP BY name, sleep_duration
  ORDER BY name, 2 DESC;

----
CREATE OR REPLACE FUNCTION get_best_sleeps(act_id INTEGER)
  RETURNS TABLE(sleep_time VARCHAR, result NUMERIC) AS
$$
SELECT
  sleep_duration,
  result::NUMERIC
FROM activities_sleep_avg_result asr
JOIN activities a ON a.name = asr.name
WHERE act_id = a.activity_id
ORDER BY result DESC
LIMIT 1;
$$
LANGUAGE sql;

----
CREATE OR REPLACE VIEW best_sleep_time AS
  SELECT
    a.name,
    (select gb.sleep_time from get_best_sleeps(a.activity_id) gb),
    round((select gb.result from get_best_sleeps(a.activity_id) gb),2) "avg distance/time"
  FROM activities a;

----
DROP FUNCTION IF EXISTS section_ranking(INTEGER,DATE,DATE) CASCADE;
CREATE OR REPLACE FUNCTION section_ranking(sectionid INTEGER, start_0 DATE, end_0 DATE)
 RETURNS TABLE(user_id INTEGER, name VARCHAR,age NUMERIC,attendance bigint,distance NUMERIC,kcal NUMERIC,injured BOOL) AS $$

 SELECT user_id,
(
  SELECT CONCAT(name,' ',surname)
    FROM users
    WHERE us.user_id=user_id
),
get_age(user_id,start_0),
(
  SELECT CASE WHEN COUNT(*)>0
    THEN COUNT(*)/(SELECT COUNT(*) FROM sessions WHERE section_id=sectionid AND start_time::DATE<= end_0 AND end_time::DATE >= start_0) ELSE 0 END
  FROM user_session
    LEFT JOIN sessions s USING (session_id)
  WHERE us.user_id=user_id AND section_id=sectionid AND start_time::DATE<= end_0 AND end_time::DATE >= start_0
),
(
  SELECT SUM(distance)
    FROM user_session
      LEFT JOIN sessions USING (session_id)
    WHERE user_id=us.user_id AND start_time::DATE<= end_0 AND end_time::DATE >= start_0
),
kcal(user_id,start_0::TIMESTAMP,(end_0+INTERVAL '1 day')::TIMESTAMP),
CASE
  WHEN (
    SELECT user_id
      FROM injuries
      WHERE user_id=us.user_id AND "date"+duration>=start_0 AND "date"<=end_0
    ) IS NOT NULL
  THEN true
  ELSE false
END
FROM user_section us WHERE section_id=sectionid AND start_time::DATE<= end_0 AND COALESCE(end_time,start_0)::DATE >= start_0 ;
$$
LANGUAGE sql;


----
CREATE OR REPLACE FUNCTION get_users_number_from_section(sectionid INTEGER)
  RETURNS INTEGER AS
$$
SELECT
  count (*)::INTEGER
FROM user_section ss
WHERE section_id = sectionid
GROUP BY section_id;
$$
LANGUAGE sql;

----
CREATE OR REPLACE FUNCTION get_users_from_section(sectionid INTEGER)
  RETURNS TABLE (name VARCHAR) AS
$$
SELECT
  u.name || ' ' || u.surname as name
FROM users u
JOIN user_section ss ON u.user_id = ss.user_id
WHERE section_id = sectionid AND ss.end_time ISNULL
ORDER BY u.surname, u.name;
$$
LANGUAGE sql;


----
CREATE OR REPLACE FUNCTION get_meetings_number(sectionid INTEGER)
  RETURNS INTEGER AS
$$
SELECT
  count(*)::INTEGER
FROM sessions s
WHERE sectionid = s.section_id
GROUP BY section_id;
$$
LANGUAGE sql;


----
DROP VIEW IF EXISTS sections_info;
CREATE OR REPLACE VIEW sections_info AS
  SELECT
    s.name,
    city,
    u.name || ' ' || u.surname as trener,
    a.name as sport,
    get_users_number_from_section(s.section_id) as members,
    get_meetings_number(s.section_id) as meetings_number
  FROM sections s
  JOIN users u ON s.trainer_id = u.user_id
  JOIN activities a ON s.activity_id = a.activity_id
  ORDER BY s.section_id;

----
CREATE OR REPLACE FUNCTION time_interval_check(id INT, start TIMESTAMP, endd TIMESTAMP, tab TEXT)
  RETURNS BOOL AS $f$
BEGIN
  IF (
       SELECT t.user_id
       FROM (SELECT *
             FROM get_table(tab)) t
       WHERE t.user_id = id AND
         t.start_time < endd AND t.end_time>start
  ORDER BY 1 LIMIT 1

     ) IS NOT NULL
  THEN RETURN FALSE; END IF;

  RETURN TRUE;
END;
$f$
LANGUAGE plpgsql;

