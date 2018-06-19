
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users ( 
	user_id              SERIAL,
	name                 VARCHAR(100)  NOT NULL,
	surname              VARCHAR(100)  NOT NULL,
	sex                  CHAR(1)  NOT NULL,
	birthday             DATE  NOT NULL,
	CONSTRAINT pk_users_users_id PRIMARY KEY ( user_id )
 );

ALTER TABLE users ADD CONSTRAINT cns_users CHECK ( birthday <= CURRENT_DATE AND ( sex='k' OR sex='m'));

DROP TABLE IF EXISTS sleep CASCADE;
CREATE TABLE  sleep (
	user_id              INTEGER  NOT NULL,
	start_time           TIMESTAMP  NOT NULL,
	end_time             TIMESTAMP  NOT NULL,
	CONSTRAINT fk_sleep FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE CASCADE
 );

ALTER TABLE sleep ADD CONSTRAINT cns_sleep_0 CHECK ( start_time < end_time );

DROP TABLE IF EXISTS activities CASCADE;
CREATE TABLE activities ( 
	activity_id          SERIAL,
	name                 VARCHAR(100)  NOT NULL,
	sport                BOOL  NOT NULL,
	CONSTRAINT pk_activities_activity_id PRIMARY KEY ( activity_id )
 );

DROP TABLE IF EXISTS medications CASCADE;
CREATE TABLE medications ( 
	medication_id        SERIAL,
	name                 VARCHAR(100)  NOT NULL,
	CONSTRAINT pk_medications_medication_id PRIMARY KEY ( medication_id )
 );



DROP TABLE IF EXISTS heartrates CASCADE;
CREATE TABLE heartrates ( 
	user_id              INTEGER  NOT NULL,
	avg_heartrate        NUMERIC(3,0)  NOT NULL,
	start_time           TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	end_time             TIMESTAMP  NOT NULL,
	CONSTRAINT fk_heartrate_node_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE CASCADE
 );

ALTER TABLE heartrates ADD CONSTRAINT cns_heartrates CHECK ( start_time<end_time AND end_time <= CURRENT_TIMESTAMP );

CREATE INDEX idx_heartrates_user_session_id ON heartrates ( user_id );


DROP TABLE IF EXISTS height_weight CASCADE;
CREATE TABLE height_weight ( 
	user_id              INTEGER  NOT NULL,
	height               NUMERIC(3)  NOT NULL,
	weight               NUMERIC(3) NOT NULL ,
	"date"               TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT uq_height_weight_0 UNIQUE ( user_id,"date" ) ,
	CONSTRAINT fk_height_weight_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE CASCADE
 );

ALTER TABLE height_weight ADD CONSTRAINT cns_height_weight CHECK ( "date" <= CURRENT_TIMESTAMP );

ALTER TABLE height_weight ADD CONSTRAINT cns_height_weight_0 CHECK ( weight > 0 AND  height>0);

CREATE INDEX idx_height_weight_user_id ON height_weight ( user_id );

DROP TABLE IF EXISTS injuries CASCADE;
CREATE TABLE injuries ( 
	user_id              INTEGER  NOT NULL,
	description          VARCHAR(100),
	start_time		     TIMESTAMP NOT NULL,
	end_time	TIMESTAMP,
	CONSTRAINT fk_injuries_users FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE CASCADE 
 );


CREATE INDEX idx_injuries_user_id ON injuries ( user_id );

ALTER TABLE injuries ADD CONSTRAINT cns_injuries CHECK ( "start_time" <= CURRENT_TIMESTAMP );

DROP TABLE IF EXISTS sections CASCADE;
CREATE TABLE sections ( 
	section_id           SERIAL,
	activity_id          INTEGER  NOT NULL,
	trainer_id           INTEGER  ,
	name                 VARCHAR(100)  NOT NULL,
	city                 VARCHAR(100)  NOT NULL,
	min_age              NUMERIC(3)  ,
	max_age              NUMERIC(3)  ,
	min_members          NUMERIC(6)  ,
	max_members          NUMERIC(6)  ,
	sex                  CHAR(1)  ,
	CONSTRAINT pk_sections_section_id PRIMARY KEY ( section_id ),
	CONSTRAINT fk_sections_activities FOREIGN KEY ( activity_id ) REFERENCES activities( activity_id )  ON DELETE CASCADE,
	CONSTRAINT fk_sections_users FOREIGN KEY ( trainer_id ) REFERENCES users( user_id )  ON DELETE SET NULL
 );

ALTER TABLE sections ADD CONSTRAINT cns_sections CHECK ( COALESCE(min_age,0) >= 0 AND (COALESCE(min_age,0) <= coalesce(max_age,1000) ));

ALTER TABLE sections ADD CONSTRAINT cns_sections_0 CHECK ( COALESCE (min_members,0)>= 0 AND ( COALESCE (min_members,0) <=  COALESCE (max_members,1000000) ));

ALTER TABLE sections ADD CONSTRAINT cns_sections_1 CHECK ( sex IS NULL OR sex='k' OR sex='m' );

CREATE INDEX idx_sections_trainer_id ON sections ( trainer_id );

DROP TABLE IF EXISTS sessions CASCADE;
CREATE TABLE sessions ( 
	session_id           serial,
	activity_id          INTEGER  NOT NULL,
	start_time           TIMESTAMP  NOT NULL,
	end_time             TIMESTAMP  NOT NULL,
	description          VARCHAR(300) ,
	trainer_id           INTEGER  ,
	section_id           INTEGER  , 
	CONSTRAINT pk_sessions_session_id PRIMARY KEY ( session_id ),
	CONSTRAINT fk_sessions_activities FOREIGN KEY ( activity_id ) REFERENCES activities( activity_id ) ON DELETE CASCADE ,
	CONSTRAINT fk_sessions_users FOREIGN KEY ( trainer_id ) REFERENCES users( user_id ) ON DELETE SET NULL ,
	CONSTRAINT fk_sessions_sections FOREIGN KEY ( section_id ) REFERENCES sections( section_id )   ON DELETE SET NULL 
 );

ALTER TABLE sessions ADD CONSTRAINT cns_sessions CHECK ( start_time<end_time );

CREATE INDEX idx_sessions_activity_id ON sessions ( activity_id );

CREATE INDEX idx_sessions_description ON sessions ( description );

CREATE INDEX idx_sessions_trainer_id ON sessions ( trainer_id );

CREATE INDEX idx_sessions_section_id ON sessions ( section_id );

DROP TABLE IF EXISTS user_medication CASCADE;
CREATE TABLE user_medication ( 
	user_id              INTEGER  NOT NULL,
	medication_id        INTEGER  NOT NULL,
	"date"               TIMESTAMP DEFAULT CURRENT_DATE NOT NULL,
	pORtion              NUMERIC DEFAULT 1 NOT NULL,
	CONSTRAINT uq_user_medication UNIQUE ( user_id,medication_id,"date"),
	CONSTRAINT fk_user_medication FOREIGN KEY ( medication_id ) REFERENCES medications( medication_id )  ON DELETE CASCADE,
	CONSTRAINT fk_user_medication_0 FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE CASCADE  
 );

ALTER TABLE user_medication ADD CONSTRAINT cns_user_medication CHECK ( portion>0 );

CREATE INDEX idx_user_medication_medication_id ON user_medication ( medication_id );

CREATE INDEX idx_user_medication_user_id ON user_medication ( user_id );

DROP TABLE IF EXISTS user_section CASCADE;
CREATE TABLE user_section ( 
	user_id              INTEGER  NOT NULL,
	section_id           INTEGER  NOT NULL,
	start_time           DATE DEFAULT CURRENT_DATE NOT NULL,
	end_time             DATE  ,
	CONSTRAINT fk_people_users FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE CASCADE,
	CONSTRAINT fk_people_sections FOREIGN KEY ( section_id ) REFERENCES sections( section_id ) ON DELETE CASCADE
 );

ALTER TABLE user_section ADD CONSTRAINT cns_user_section CHECK ( start_time<end_time);

CREATE INDEX idx_people_user_id ON user_section ( user_id );

CREATE INDEX idx_people_section_id ON user_section ( section_id );

DROP TABLE IF EXISTS user_session CASCADE;
CREATE TABLE user_session ( 
	user_id              INTEGER  NOT NULL,
	session_id           INTEGER  NOT NULL,
	distance             NUMERIC  ,
	CONSTRAINT uq_user_session_0 UNIQUE ( user_id,session_id ) ,
	CONSTRAINT fk_trainings_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE CASCADE,
	CONSTRAINT fk_trainings_sessions FOREIGN KEY ( session_id ) REFERENCES sessions( session_id )  ON DELETE CASCADE
 );


ALTER TABLE user_session ADD CONSTRAINT cns_user_session_0 CHECK ( distance IS NULL OR distance > 0 );

CREATE INDEX idx_user_session_user_id ON user_session ( user_id );

CREATE INDEX idx_user_session_session1_id ON user_session ( session_id );


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
r numeric;
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
  
    if last_weight != weight_0 OR age_0!=last_age OR seconds>300 THEN

	IF seconds>0 THEN
	    avg_heartrate_0 = heartrates_0 / seconds;
		  IF sex_0 = 'm' THEN
		  		r= ((last_age * 0.2017) - (last_weight * 0.09036) + (avg_heartrate_0 * 0.6309) - 55.0969) * (seconds / 60) / 4.184;
		  	ELSE 
				r=((last_age * 0.074) - (last_weight  * 0.05741) + (avg_heartrate_0 * 0.4472) - 20.4022) * (seconds / 60) / 4.184; 
			END IF;
	   seconds = 0;
	   heartrates_0=0;
if r>=0 then result=result+r; end if;
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
  RETURNS TABLE(session_id INTEGER, name VARCHAR, start_time TIMESTAMP, end_time TIMESTAMP,  description VARCHAR, "with" text[]) AS
$$
SELECT
   s.session_id, name, s.start_time, s.end_time, 
CASE WHEN distance IS NOT NULL THEN 
CONCAT('Dystans: ',(SELECT distance FROM user_session WHERE user_id=user_idd AND session_id=us.session_id),' ',description) ELSE description END,

 (SELECT ARRAY(SELECT CONCAT(surname,' ',name) FROM users LEFT JOIN user_session USING(user_id)where session_id=us.session_id AND user_id !=user_idd))
FROM user_session us
  JOIN sessions s ON us.session_id = s.session_id
  JOIN activities a ON s.activity_id = a.activity_id
WHERE user_id = user_idd AND s.start_time::DATE <= day AND s.end_time::DATE >= day
UNION
SELECT NULL,'spanie', start_time, end_time, NULL,NULL
FROM sleep 
WHERE user_id = user_idd AND start_time::DATE <= day AND end_time::DATE >= day
UNION
SELECT NULL,'kontuzja', start_time, end_time, description,NULL
FROM injuries 
WHERE user_id = user_idd AND start_time::DATE = day
UNION
SELECT NULL,'badanie', NULL, NULL, CONCAT('Wynik badan: wzrost: ',height,', waga: ',weight),NULL
FROM height_weight 
WHERE user_id = user_idd AND "date" = day
UNION
SELECT NULL,'doloczenie do sekcji', start_time, NULL, CONCAT('Nazwa sekcji: ',name),NULL
FROM sections LEFT JOIN user_section USING(section_id)
WHERE user_id = user_idd AND start_time = day
UNION
SELECT NULL,'odejscie od sekcji', start_time, NULL, CONCAT('Nazwa sekcji: ',name),NULL
FROM sections LEFT JOIN user_section USING(section_id)
WHERE user_id = user_idd AND end_time = day
UNION
SELECT NULL,'leki', "date", NULL, CASE WHEN portion is not null THEN CONCAT('Nazwa leku: ',name,'Porcja: ',portion) ELSE CONCAT('Nazwa leku: ',name) END,NULL
FROM medications LEFT JOIN user_medication USING(medication_id)
WHERE user_id = user_idd AND "date"::DATE = day;
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
------
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
			WHERE user_id=us.user_id AND end_time::DATE>=start_0 AND start_time::DATE<=end_0
		) IS NOT NULL 
	THEN true 
	ELSE false 
END

 FROM user_section us WHERE section_id=sectionid AND start_time::DATE<= end_0 AND COALESCE(end_time,start_0)::DATE >= start_0 ;

$$
LANGUAGE sql;
-----------------

CREATE OR REPLACE FUNCTION find_section(userid INTEGER, start_0 DATE,activityid INTEGER)
 RETURNS TABLE(section_id INTEGER, name VARCHAR) AS $$

 SELECT section_id,
(
	SELECT name
		FROM sections 
		WHERE s.section_id=section_id
)
 FROM sections s 
	WHERE activity_id = activityid 
	AND section_id NOT IN (
		SELECT section_id 
			FROM user_section 
			WHERE user_id=userid AND start_time<=start_0 AND coalesce(end_time,start_0)>=start_0) AND coalesce(min_age,get_age(userid,start_0))<=get_age(userid,start_0) 
			AND coalesce(max_age,get_age(userid,start_0))>=get_age(userid,start_0) AND
			(select count(*) FROM user_section WHERE start_time<=start_0 AND coalesce(end_time,start_0)>=start_0 )<coalesce(max_members,1000000) 
			AND (SELECT sex FROM users where user_id=userid) = COALESCE(sex,(SELECT sex FROM users where user_id=userid))
			AND (section_id IN (
				SELECT section_id 
					FROM sections 
					WHERE section_id=s.section_id 
					order by 
						abs(
						kcal(userid,(start_0-interval '2 years')::DATE,start_0)
						-
						(SELECT AVG(kcal) 
							FROM section_ranking(section_id,(start_0-INTERVAL '2 years')::DATE,start_0)
							)
						) 
			limit 5 ) 
			OR 
			section_id IN (
				SELECT section_id 
					FROM sections 
					WHERE section_id=s.section_id 
					ORDER BY
						(SELECT count(user_id) 
							FROM user_section 
							WHERE start_time<=start_0 AND coalesce(end_time,start_0)>=start_0 
							AND user_id IN (SELECT user_id FROM user_session WHERE session_id IN (SELECT session_id FROM user_session WHERE user_id=userid)))
			 limit 5))
GROUP BY section_id
ORDER BY ((SELECT coalesce(count(*),0) 
		FROM user_section 
		WHERE start_time<=start_0 AND coalesce(end_time,start_0)>=start_0 )-coalesce(min_members,0)/(coalesce(max_members,count(*)*2)-coalesce(min_members,0))) 
		LIMIT 5
;

$$
LANGUAGE sql;


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
       WHERE t.user_id = id AND 
         t.start_time < endd AND t.end_time>start
	ORDER BY 1 LIMIT 1
       
     ) IS NOT NULL
  THEN RETURN FALSE; END IF;

  RETURN TRUE;
END;
$f$
LANGUAGE plpgsql;

--triggers named "table_name_check"

CREATE OR REPLACE FUNCTION sleep_check() RETURNS TRIGGER AS $f$
DECLARE
u_birthday DATE;
BEGIN
u_birthday = (SELECT birthday FROM users WHERE user_id=NEW.user_id);
IF NEW.start_time<u_birthday
	THEN RAISE NOTICE 'USER IS NOT BORN'; 
	RETURN NULL; END IF;

IF  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,
	'user_session LEFT JOIN sessions USING (session_id)') IS false 
		THEN RAISE NOTICE 'USER DURING SESSION';
		RETURN NULL; END IF;

IF  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'sleep') IS false 
	THEN RAISE NOTICE 'USER ALREADY SLEEPS';
	RETURN NULL; END IF;

RETURN NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION user_session_check() RETURNS TRIGGER AS $f$
DECLARE
t1 TIMESTAMP;
t2 TIMESTAMP;
section INTEGER;
u_birthday DATE;
BEGIN
t1 = (SELECT start_time FROM sessions WHERE session_id = NEW.session_id);
t2 = (SELECT end_time FROM sessions WHERE session_id = NEW.session_id);
section = (SELECT section_id FROM sessions WHERE session_id = NEW.session_id);
u_birthday = (SELECT birthday FROM users WHERE user_id=NEW.user_id);

IF t1<u_birthday 
	THEN RAISE NOTICE 'USER IS NOT BORN'; 
	RETURN NULL; END IF;

IF  time_interval_check(NEW.user_id,t1,t2,'user_session LEFT JOIN sessions USING (session_id)') IS false 
	THEN RAISE NOTICE 'USER DURING SESSION'; 
	RETURN NULL; END IF;

IF  time_interval_check(NEW.user_id,t1,t2,'sleep') IS false 
	THEN RAISE NOTICE 'USER SLEEPS';
	RETURN NULL; END IF;

IF  time_interval_check(NEW.user_id,t1,t2,'injuries') IS false 
		THEN RAISE NOTICE 'USER HAS INJURY'; 
		 RETURN NULL; END IF;

IF section IS NOT NULL AND 
	(SELECT user_id FROM user_section WHERE user_id=NEW.user_id AND section_id=section AND start_time<=t1 AND COALESCE(end_time,t2)>=t2) IS NULL 
		THEN RAISE NOTICE 'USER NOT IN SECTION'; 
		RETURN NULL; END IF;

RETURN NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION heartrates_check() RETURNS TRIGGER AS $f$
DECLARE
u_birthday DATE;
age NUMERIC(3,0);
last_heartrate NUMERIC(3,0);
seconds INTEGER;
last_date TIMESTAMP;
BEGIN
u_birthday = (SELECT birthday FROM users WHERE user_id=NEW.user_id);
age = get_age(NEW.user_id,NEW.start_time);

IF( age < 18 ) THEN age = 18; RAISE NOTICE 'CALUCULATIONS MIGHT BE INACURATE BECAUSE OF AGE';END if;
IF (age > 89 ) THEN age = 89; RAISE NOTICE 'CALUCULATIONS MIGHT BE INACURATE BECAUSE OF AGE';END if;

IF NEW.avg_heartrate>max_heartrate(age) 
	THEN RAISE NOTICE 'TOO HIGH HEARTRATE'; 
	RETURN NULL; END IF;

IF NEW.avg_heartrate<min_heartrate(age)
	THEN RAISE NOTICE 'TOO LOW HEARTRATE'; 
	RETURN NULL; END IF;

IF NEW.start_time<u_birthday
	THEN RAISE NOTICE 'USER IS NOT BORN'; 
	RETURN NULL; END IF;

IF  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'heartrates') IS false 
	THEN  RAISE NOTICE 'ALREADY MEASURED'; 
	RETURN NULL; END IF;

IF get_age(NEW.user_id,NEW.start_time)!=get_age(NEW.user_id,NEW.end_time) THEN RAISE NOTICE 'CALUCULATIONS MIGHT BE INACURATE BECAUSE OF AGE CHANGE';END if;
IF get_weight(NEW.user_id,NEW.start_time)!=get_weight(NEW.user_id,NEW.end_time) THEN RAISE NOTICE 'CALUCULATIONS MIGHT BE INACURATE BECAUSE OF WIGHT';END if;

last_heartrate = (SELECT avg_heartrate FROM heartrates WHERE user_id = NEW.user_id AND start_time<NEW.start_time ORDER BY start_time DESC LIMIT 1);
last_date = (SELECT end_time FROM heartrates WHERE user_id = NEW.user_id AND start_time<NEW."start_time" ORDER BY start_time DESC LIMIT 1);
IF last_date IS NULL  THEN RETURN NEW; END if;
seconds  = (SELECT EXTRACT(EPOCH FROM (NEW.start_time - last_date)));
IF ABS(last_heartrate-NEW.avg_heartrate)>(seconds+1)*5 
	THEN RAISE NOTICE 'TOO BIG HEARTRATE CHANGE'; 
	RETURN NULL; END IF;
RETURN NEW;
END;
$f$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION height_weight_check() RETURNS TRIGGER AS $f$
DECLARE
u_age NUMERIC;
u_sex CHAR(1);
max_height NUMERIC;
min_height NUMERIC;
BEGIN
u_age = get_age(NEW.user_id,NEW."date");
u_sex = (SELECT sex FROM users WHERE user_id=NEW.user_id);

IF u_sex = 'm' AND (u_age*0.2017)-(NEW.weight *0.09036)+min_heartrate(u_age)*0.6+55.0969<=0 
	THEN RAISE NOTICE 'WRONG WEIGHT TO AGE RATIO'; 
	RETURN NULL; END IF;
IF u_sex = 'k' AND (u_age*0.074)-(NEW.weight *0.05741)+min_heartrate(u_age)*0.4+40.4022<=0
	THEN RAISE NOTICE 'WRONG WEIGHT TO AGE RATIO';
	RETURN NULL; END IF;
IF (NEW.weight*10000)/(NEW.height*NEW.height) not between 10 and 50
	THEN RAISE NOTICE 'WRONG HEIGHT TO WEIGHT RATIO';
	RETURN NULL; END IF;
max_height = (SELECT MAX(height) FROM height_weight WHERE user_id=NEW.user_id AND "date"<NEW."date");
if max_height IS NOT NULL AND (max_height-2>NEW.height)
	THEN RAISE NOTICE 'TOO SHORT';
	RETURN NULL; END IF;
min_height = (SELECT MIN(height) FROM height_weight WHERE user_id=NEW.user_id AND "date">NEW."date");
if min_height IS NOT NULL AND (min_height+2<NEW.height)
	THEN RAISE NOTICE 'TOO HIGH';
	RETURN NULL; END IF;
RETURN NEW;
END;
$f$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION injuries_check() RETURNS TRIGGER AS $f$
DECLARE
u_birthday DATE;
BEGIN
u_birthday = (SELECT birthday FROM users WHERE user_id=NEW.user_id) ;
IF NEW.start_time<u_birthday
	THEN RAISE NOTICE 'USER IS NOT BORN'; 
	RETURN NULL; END IF;

IF  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,
	'user_session LEFT JOIN sessions USING (session_id)') IS false 
		THEN RAISE NOTICE 'USER DURING SESSION';
		RETURN NULL; END IF;

RETURN NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sessions_check() RETURNS TRIGGER AS $f$
BEGIN

IF NEW.section_id IS NOT NULL AND (SELECT sport FROM sections LEFT JOIN activities USING(activity_id) WHERE section_id = NEW.section_id) IS false 
	THEN RAISE NOTICE 'ACTIVITY SHOULD BE SPORT'; 
	RETURN NULL; END IF;

RETURN NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sections_check() RETURNS TRIGGER AS $f$
declare
members NUMERIC;
t DATE;
BEGIN

IF (SELECT sport FROM  activities a WHERE a.activity_id=NEW.activity_id) IS false 
	THEN RAISE NOTICE 'IS NOT SPORT'; 
	RETURN NULL; END IF;

FOR t IN SELECT start_time FROM user_section WHERE section_id=NEW.section_id UNION SELECT COALESCE(end_time,CURRENT_DATE) FROM user_section WHERE section_id=NEW.section_id
	LOOP
	members = (SELECT count(user_id) FROM user_section WHERE section_id=NEW.section_id AND COALESCE(end_time,t)>=t AND start_time<=t);
	IF members < COALESCE(NEW.min_members,members) OR 
		members>COALESCE(NEW.max_members,members)
			THEN RAISE NOTICE 'WRONG NUMBER OF MEMBERS'; 
			RETURN NULL; 
	END IF;
	END LOOP;

IF NEW.min_age IS NOT NULL 
	AND
	(SELECT user_id 
		FROM user_section left join users USING (user_id) 
		WHERE section_id=NEW.section_id 
			AND get_age(user_id,start_time)<NEW.min_age ORDER BY 1 LIMIT 1) 
	IS NOT NULL 
		THEN RAISE NOTICE 'WRONG MIN AGE'; 
		RETURN NULL; END IF;

IF NEW.max_age IS NOT NULL 
	AND 
	(SELECT user_id FROM user_section left join users USING (user_id) 
		WHERE section_id=NEW.section_id 
			AND get_age(user_id,end_time)>NEW.max_age ORDER BY 1 LIMIT 1) 
	IS NOT NULL 
		THEN RAISE NOTICE 'WRONG MAX AGE'; 
		RETURN NULL; END IF;

IF NEW.sex IS NOT NULL 
	AND 
	(SELECT user_id FROM user_section LEFT JOIN users u USING (user_id) 
		WHERE section_id=NEW.section_id AND u.sex != NEW.sex) 
	IS NOT NULL 
		THEN RAISE NOTICE 'WRONG SEX'; 
		RETURN NULL; END IF;

RETURN NEW;
END;
$f$ LANGUAGE plpgsql;

----
CREATE OR REPLACE FUNCTION user_section_check() RETURNS TRIGGER AS $f$
declare
minage NUMERIC;
maxage NUMERIC;
age NUMERIC;
minmem  NUMERIC;
maxmem numeric;
t DATE;
u_birthday DATE;
u_sex CHAR;
members NUMERIC;
BEGIN
minage = (SELECT min_age FROM sections WHERE section_id=NEW.section_id);
maxage = (SELECT max_age FROM sections WHERE section_id=NEW.section_id);
minmem = (SELECT min_members FROM sections WHERE section_id=NEW.section_id);
maxmem = (SELECT max_members FROM sections WHERE section_id=NEW.section_id);
u_birthday = (SELECT birthday FROM users WHERE user_id=NEW.user_id);
u_sex = (SELECT sex FROM users WHERE user_id=NEW.user_id);

IF NEW.start_time<u_birthday
	THEN RAISE NOTICE 'USER IS NOT BORN YET'; 	
	RETURN NULL; END IF;

IF (SELECT user_id 
	FROM user_section 
	WHERE user_id=NEW.user_id AND section_id=NEW.section_id AND COALESCE(end_time,NEW.start_time+INTERVAL '1 day')>NEW.start_time AND start_time<COALESCE(NEW.end_time,start_time+INTERVAL '1 day')) 
IS NOT NULL 		
	THEN RAISE NOTICE 'USER ALREADY IN THAT SECTION'; 
	RETURN NULL; END IF;

IF(SELECT COALESCE(sex,u_sex) FROM sections WHERE section_id=NEW.section_id) != u_sex
	THEN RAISE NOTICE 'WRONG SEX'; 
	RETURN NULL; END IF;

IF minage IS NOT NULL AND get_age(NEW.user_id,NEW.start_time)<minage 
	THEN RAISE NOTICE 'WRONG MINIMAL AGE'; 
	RETURN NULL;END IF;

IF  maxage IS NOT NULL AND NEW.end_time IS NOT NULL AND get_age(NEW.user_id,NEW.end_time)>maxage 
	THEN RAISE NOTICE 'WRONG MAXIMAL AGE'; 
	RETURN NULL;END IF;

IF  maxage IS NOT NULL AND NEW.end_time IS NOT NULL AND get_age(NEW.user_id,CURRENT_DATE)>maxage
	THEN RAISE NOTICE 'WRONG MAXIMAL AGE'; 
	RETURN NULL;END IF;

	minmem = (SELECT min_members FROM sections WHERE section_id=NEW.section_id);
	maxmem = (SELECT max_members FROM sections WHERE section_id=NEW.section_id);
	FOR t IN SELECT start_time FROM user_section WHERE section_id=NEW.section_id UNION SELECT COALESCE(end_time,CURRENT_DATE) FROM user_section WHERE section_id=NEW.section_id
		LOOP
		members = (SELECT COALESCE(COUNT(user_id),0) FROM user_section WHERE section_id=NEW.section_id AND COALESCE(end_time,t)>=t AND start_time<=t);
		IF members < COALESCE(minmem,members) OR 
			members>=COALESCE(maxmem,members+1)
				THEN RAISE NOTICE 'WRONG NUMBER OF MEMBERS IN NEW SECTION'; 
				RETURN NULL; END IF;
		END LOOP;
	IF TG_OP = 'UPDATE' AND OLD.section_id IS NOT NULL THEN
		minmem = (SELECT min_members FROM sections WHERE section_id=OLD.section_id);
		maxmem = (SELECT max_members FROM sections WHERE section_id=OLD.section_id);
		FOR t IN SELECT start_time FROM user_section WHERE section_id=OLD.section_id UNION SELECT COALESCE(end_time,CURRENT_DATE) FROM user_section WHERE section_id=OLD.section_id
		LOOP
		members = (SELECT COALESCE(COUNT(user_id),0) FROM user_section WHERE section_id=OLD.section_id AND COALESCE(end_time,t)>=t AND start_time<=t);
		IF members <= COALESCE(minmem,members-1) OR 
			members>COALESCE(maxmem,members)
				THEN RAISE NOTICE 'WRONG NUMBER OF MEMBERS IN OLD SECTION'; 
				RETURN NULL; END IF;
		END LOOP;
	END IF;	


RETURN NEW;
END;
$f$ LANGUAGE plpgsql;


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
      WHERE user_id=us.user_id AND end_time>=start_0 AND start_time<=end_0
      LIMIT 1
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
CREATE OR REPLACE VIEW too_old_memebers AS
SELECT
  u.name,
  u.surname,
  s.name,
  get_age(u.user_id, current_date),
  max_age
FROM user_section us2
JOIN users u ON us2.user_id = u.user_id
JOIN sections s ON s.section_id = us2.section_id
WHERE max_age > get_age(u.user_id, current_date);



DROP TRIGGER IF EXISTS sleep_trigger ON sleep;
CREATE TRIGGER sleep_trigger BEFORE INSERT OR UPDATE ON sleep
FOR EACH ROW EXECUTE PROCEDURE sleep_check();

DROP TRIGGER IF EXISTS injuries_trigger ON injuries;
CREATE TRIGGER injuries_trigger BEFORE INSERT OR UPDATE ON injuries
FOR EACH ROW EXECUTE PROCEDURE injuries_check();

DROP TRIGGER IF EXISTS sections_tigger ON sections;
CREATE TRIGGER sections_tigger BEFORE INSERT OR UPDATE ON sections
FOR EACH ROW EXECUTE PROCEDURE sections_check();

DROP TRIGGER IF EXISTS sessions_trigger ON sessions;
CREATE TRIGGER sessions_trigger BEFORE INSERT OR UPDATE ON sessions
FOR EACH ROW EXECUTE PROCEDURE sessions_check();

DROP TRIGGER IF EXISTS height_weight_trigger ON height_weight;
CREATE TRIGGER height_weight_trigger BEFORE INSERT OR UPDATE ON height_weight
FOR EACH ROW EXECUTE PROCEDURE height_weight_check();

DROP TRIGGER IF EXISTS user_section_trigger ON user_section;
CREATE TRIGGER user_section_trigger BEFORE INSERT OR UPDATE ON user_section
FOR EACH ROW EXECUTE PROCEDURE user_section_check();

DROP TRIGGER IF EXISTS user_session_trigger ON user_session;
CREATE TRIGGER user_session_trigger BEFORE INSERT OR UPDATE ON user_session
FOR EACH ROW EXECUTE PROCEDURE user_session_check();

CREATE OR REPLACE VIEW actual_sections AS SELECT user_id,section_id,start_time FROM user_section WHERE COALESCE(end_time,CURRENT_DATE)>=CURRENT_DATE;

CREATE OR REPLACE RULE actual_sections_INSERT AS ON INSERT TO actual_sections
        DO INSTEAD INSERT INTO user_section values(NEW.user_id,NEW.section_id,NEW.start_time,NULL);

CREATE OR REPLACE VIEW section_session AS SELECT section_id,session_id,activity_id,start_time,end_time,description,trainer_id,(SELECT SUM(distance) FROM user_session WHERE session_id=s.session_id) as distance FROM sessions s WHERE section_id IS NOT NULL;

CREATE OR REPLACE RULE section_session_INSERT AS ON INSERT TO section_session
        DO INSTEAD (
        INSERT INTO sessions VALUES(NEW.session_id,NEW.activity_id,NEW.start_time,NEW.end_time,NEW.description,NEW.trainer_id,NEW.section_id);
	INSERT INTO user_session SELECT user_id,NEW.session_id,NULL FROM user_section
                WHERE section_id=NEW.section_id AND start_time<=NEW.start_time AND COALESCE(end_time,NEW.end_time)>=NEW.end_time;
        );


CREATE OR REPLACE RULE section_session_DELETE AS ON DELETE TO section_session
        DO INSTEAD (
	DELETE FROM sessions WHERE session_id=OLD.session_id;
	);

CREATE OR REPLACE RULE section_session_UPDATE AS ON UPDATE TO section_session
        DO INSTEAD(
	UPDATE sessions
	SET
		section_id = NEW.section_id,
		session_id = NEW.session_id,
		activity_id = NEW.activity_id,
		start_time=NEW.start_time,
		end_time=NEW.end_time,
		description=NEW.description,
		trainer_id=NEW.trainer_id
	WHERE	 session_id = OLD.session_id;
	UPDATE user_session
	SET
		session_id = NEW.session_id
	WHERE	 session_id = OLD.session_id;
	
	);

CREATE OR REPLACE VIEW individual_session AS SELECT user_id,session_id,activity_id,start_time,end_time,description,trainer_id,distance FROM sessions LEFT JOIN user_session USING (session_id) WHERE session_id in (SELECT session_id FROM user_session WHERE user_id!=COALESCE(trainer_id,-1) GROUP BY session_id HAVING count(*)<=1) and user_id!=coalesce(trainer_id,-1);

CREATE OR REPLACE RULE individual_session_INSERT AS ON INSERT TO individual_session
        DO INSTEAD (
        INSERT INTO sessions SELECT NEW.session_id,NEW.activity_id,NEW.start_time,NEW.end_time,NEW.description,NEW.trainer_id WHERE NEW.user_id != NEW.trainer_id  ;
	INSERT INTO user_session  SELECT NEW.user_id,NEW.session_id,NEW.distance WHERE NEW.user_id != NEW.trainer_id ;
        );


CREATE OR REPLACE RULE individual_session_DELETE AS ON DELETE TO individual_session
        DO INSTEAD (
	DELETE FROM sessions WHERE session_id=OLD.session_id;
	);

CREATE OR REPLACE RULE individual_session_UPDATE AS ON UPDATE TO individual_session
       DO INSTEAD(
	UPDATE sessions
	SET
		session_id = NEW.session_id,
		activity_id = NEW.activity_id,
		start_time=NEW.start_time,
		end_time=NEW.end_time,
		description=NEW.description,
		trainer_id=NEW.trainer_id
	WHERE	 session_id = OLD.session_id AND NEW.user_id!=NEW.trainer_id;
	UPDATE user_session
	SET
		session_id = NEW.session_id,
		distance = NEW.distance
	WHERE	 session_id = OLD.session_id AND NEW.user_id!=NEW.trainer_id;
	
	);

CREATE OR REPLACE RULE trainer_session_INSERT AS ON INSERT TO sessions WHERE NEW.trainer_id IS NOT NULL
        DO (
                INSERT INTO user_session values(NEW.trainer_id,NEW.session_id,NULL)
        );

CREATE OR REPLACE RULE trainer_session_d_0 AS ON DELETE TO sessions WHERE OLD.trainer_id IS NOT NULL
        DO (
                DELETE FROM user_session WHERE user_id = OLD.trainer_id AND session_id = OLD.session_id
        );

CREATE OR REPLACE RULE trainer_session_d_3 AS ON UPDATE TO sessions WHERE (OLD.trainer_id IS NULL AND NEW.trainer_id IS NOT NULL) OR OLD.trainer_id!=NEW.trainer_id
        DO (
                UPDATE user_session SET user_id=NEW.trainer_id WHERE user_id=OLD.trainer_id AND session_id=OLD.session_id;
        );

CREATE OR REPLACE RULE trainer_session_d_1 AS ON DELETE TO user_session WHERE OLD.user_id=(SELECT trainer_id FROM sessions WHERE session_id=OLD.session_id)
        DO (
                UPDATE sessions SET trainer_id=NULL WHERE session_id = OLD.session_id
        );

CREATE OR REPLACE FUNCTION create_session(userid INTEGER,activity_id INTEGER, startt TIMESTAMP,endt TIMESTAMP,descr VARCHAR(300),dist numeric,trainer integer,section integer) RETURNS VOID AS $f$
declare
sessionid integer;
BEGIN
sessionid = coalesce((select min(session_id)+1 from sessions where session_id+1 not in (select session_id from sessions)),1);
insert into sessions values(sessionid,activity_id,startt,endt,descr,trainer,section);
insert into user_session values(userid,sessionid,dist);
END;
$f$ LANGUAGE plpgsql;
