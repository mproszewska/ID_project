--funtions

----
CREATE OR REPLACE FUNCTION get_weight(userid INTEGER, day DATE)
  RETURNS NUMERIC(3) AS
$$
SELECT
 weight
FROM height_weight
WHERE weight IS NOT NULL AND user_id = userid AND date <= day
ORDER BY date DESC
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
WHERE height_weight.height IS NOT NULL AND user_id = userid AND date <= day
ORDER BY date DESC
LIMIT 1;
$$
LANGUAGE sql;


----
CREATE OR REPLACE FUNCTION kcal_during_session(userid INTEGER, sessionid INTEGER)
  RETURNS NUMERIC AS $$
DECLARE
  i        NUMERIC;
  j        TIMESTAMP;
  k        TIMESTAMP;
  m        NUMERIC;
  start_0  TIMESTAMP;
  end_0    TIMESTAMP;
  sex_0    CHAR;
  age_0    NUMERIC;
  weight_0 NUMERIC;
  seconds  NUMERIC;
  heartrates_0    NUMERIC;
  lasttime        TIMESTAMP;
  avg_heartrate_0 NUMERIC;

BEGIN
  sex_0 = (SELECT sex
           FROM users
           WHERE user_id = userid);
  start_0 = (SELECT start_time
             FROM sessions s
             WHERE s.session_id = sessionid);
  end_0 = (SELECT end_time
           FROM sessions s
           WHERE s.session_id = sessionid);
  age_0 = (SELECT DATE_PART('year', start_0 :: DATE) - DATE_PART('year', birthday :: DATE)
           FROM users
           WHERE user_id = userid);
  weight_0 = get_weight(userid, start_0::DATE);
  seconds = (SELECT EXTRACT(EPOCH FROM (end_0 - start_0)));
  lasttime = start_0;
  heartrates_0 = 0;

  FOR i, j, k IN SELECT
                   avg_heartrate,
                   start_time,
                   end_time
                 FROM heartrates h
                 WHERE h.user_id = userid AND h.end_time >= start_0 AND h.start_time <= end_0
  LOOP
    IF lasttime < j
    THEN RAISE NOTICE 'NOT CONTINUOUS DATA';
      RETURN NULL; END IF;
    lasttime = k;
    m = (SELECT EXTRACT(EPOCH FROM (k - j)));
    IF j < start_0
    THEN m = m - (SELECT EXTRACT(EPOCH FROM (start_0 - j))); END IF;
    IF k > end_0
    THEN m = m - (SELECT EXTRACT(EPOCH FROM (k - end_0))); END IF;
    heartrates_0 = heartrates_0 + i * m;
  END LOOP;

  IF lasttime < end_0
  THEN RAISE NOTICE 'NOT CONTINUOUS DATA';
    RETURN NULL; END IF;

  avg_heartrate_0 = heartrates_0 / seconds;

  IF sex_0 = 'm'
  THEN RETURN ROUND(
      ((age_0 * 0.2017) - (weight_0 * 0.09036) + (avg_heartrate_0 * 0.6309) - 55.0969) * (seconds / 60) / 4.184, 2);
  ELSE RETURN ROUND(
      ((age_0 * 0.074) - (weight_0  * 0.05741) + (avg_heartrate_0 * 0.4472) - 20.4022) * (seconds / 60) / 4.184,
      2); END IF;

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

CREATE OR REPLACE FUNCTION min_heartrate(age NUMERIC)
	RETURNS NUMERIC AS $$
BEGIN
RETURN max_heartrate(age)*0.4;
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
----
CREATE OR REPLACE FUNCTION height_weight_changes()
  RETURNS TABLE(user_id INTEGER, start_time TIMESTAMP, end_time TIMESTAMP, hight_change NUMERIC, weight_change NUMERIC) AS
$$
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
ORDER BY "date"
$$
LANGUAGE SQL;

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
WHERE user_id = user_idd AND s.start_time::DATE = day;
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
DROP VIEW IF EXISTS activities_meds;
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


------------TODO
DROP FUNCTION IF EXISTS section_timesheet(INTEGER,DATE,DATE) CASCADE;
CREATE OR REPLACE FUNCTION section_timesheet(section_id INTEGER, fist DATE, last DATE)
  RETURNS TABLE("date" DATE, present BOOL) AS $$
BEGIN
  RETURN QUERY EXECUTE
  'select user_id,0 from user_section us where us.section_id=section_id';
END;
$$
LANGUAGE plpgsql;

---------------------TODO
CREATE OR REPLACE FUNCTION medications_sessions(user_id INTEGER, fist DATE, last DATE)
  RETURNS TABLE(mediaction_id INTEGER) AS $$
BEGIN
  RETURN QUERY EXECUTE
  'select 0 from mediaction_user';
END;
$$
LANGUAGE plpgsql;

------------------


--other functions
CREATE OR REPLACE FUNCTION get_table(input_table TEXT)
  RETURNS TABLE(user_id INT, start_time TIMESTAMP, end_time TIMESTAMP) AS $$
BEGIN
  RETURN QUERY EXECUTE
  concat('SELECT user_id, start_time, end_time FROM ', input_table);
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION time_interval_check(id INT, start TIMESTAMP, endd TIMESTAMP, tab TEXT)
  RETURNS BOOL AS $f$
BEGIN
  IF (
       SELECT t.user_id
       FROM (SELECT *
             FROM get_table(tab)) t
       WHERE t.user_id = id AND (
         (t.start_time >= start AND t.start_time < endd) OR
         (t.end_time > start AND t.end_time <= endd) OR
         (start >= t.start_time AND start < t.end_time) OR
         (endd > t.start_time AND endd <= t.end_time)
       )
     ) IS NOT NULL
  THEN RETURN FALSE; END IF;

  RETURN TRUE;
END;
$f$
LANGUAGE plpgsql;

