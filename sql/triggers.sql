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

IF u_sex = 'm' AND (u_age*0.2017)-(NEW.weight *0.09036)+(min_heartrate(u_age)* 0.6309)-55.0969<=0 
	THEN RAISE NOTICE 'WRONG WEIGHT TO AGE RATIO'; 
	RETURN NULL; END IF;
IF u_sex = 'k' AND (u_age*0.074)-(NEW.weight *0.05741)+(min_heartrate(u_age)* 0.4472)-20.4022<=0
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

-------------TODO
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

IF  maxage IS NOT NULL AND NEW.end_time IS NULL
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

DROP TRIGGER IF EXISTS sleep_trigger ON sleep;
CREATE TRIGGER sleep_trigger BEFORE INSERT OR UPDATE ON sleep
FOR EACH ROW EXECUTE PROCEDURE sleep_check();

DROP TRIGGER IF EXISTS heartrates_trigger ON heartrates;
CREATE TRIGGER heartrates_trigger BEFORE INSERT OR UPDATE ON heartrates
FOR EACH ROW EXECUTE PROCEDURE heartrates_check();

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

