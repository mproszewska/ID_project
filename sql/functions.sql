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
      ((age_0 * 0.074) - (weight_0 * 0.05741) + (avg_heartrate_0 * 0.4472) - 20.4022) * (seconds / 60) / 4.184,
      2); END IF;

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
  RETURN ROUND(weight_0 / (height_0 * height_0), 2);
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
CREATE OR REPLACE FUNCTION timetable(user_idd INTEGER, day DATE)
  RETURNS TABLE(session_id INTEGER, name VARCHAR, start_time TIMESTAMP, end_time TIMESTAMP, distance NUMERIC, description VARCHAR) AS
$$
SELECT
  name, s.session_id, s.start_time, s.end_time, distance, description
FROM user_session us
  JOIN sessions s ON us.session_id = s.session_id
  JOIN activities a ON s.activity_id = a.activity_id
WHERE user_id = user_idd AND s.start_time::DATE = day;
$$
LANGUAGE sql;


----
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

------------TODO
CREATE OR REPLACE FUNCTION section_timesheet(section_id INTEGER, fist DATE, last DATE)
  RETURNS TABLE("date" DATE, present BOOL) AS $$
BEGIN
  RETURN QUERY EXECUTE
  'select user_id,0 from user_section us where us.section_id=section_id';
END;
$$
LANGUAGE plpgsql;

----
CREATE VIEW sections_info AS
  SELECT
    s.name,
    city,
    u.name || ' ' || u.surname as trener,
    a.name as sport
  FROM sections s
  JOIN users u ON s.trainer_id = u.user_id
  JOIN activities a ON s.activity_id = a.activity_id
  ORDER BY s.section_id;

----
/*CREATE OR REPLACE view get_section;

SELECT
  *
FROM user_section us
JOIN sessions s ON s.section_id = us.section_id*/

