--triggers named "table_name_check"

CREATE OR REPLACE FUNCTION sleep_check() RETURNS trigger AS $f$
BEGIN

if  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'user_session')
	is false then return null; end if;

if  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'sleep')
	is false then return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION user_session_check() RETURNS trigger AS $f$
declare
t1 timestamp;
t2 timestamp;
section integer;
BEGIN
t1 = (select start_time from sessions where session_id = NEW.session_id);
t2 = (select end_time from sessions where session_id = NEW.session_id);
section = (select section_id from sessions where session_id = NEW.session_id);

if  time_interval_check(NEW.user_id,t1,t2,'user_session')
	is false then return null; end if;

if  time_interval_check(NEW.user_id,t1,t2,'sleep')
	is false then return null; end if;

if  time_interval_check(NEW.user_id,t1,t2,'(select user_id,a."date" as start_time,a."date"+duration as end_time from injuries left join accidents as a using(accident_id)) as inj') is false then return null; end if;

if section is not null and (select user_id from user_section where user_id=NEW.user_id and section_id=section and start_time<=t1 and coalesce(end_time,t2)<=t2) is null then return null; end if;

if t1>NEW.start_time or t2<NEW.end_time then return null; end if;
return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION heartrates_check() RETURNS trigger AS $f$
BEGIN

if  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'heartrates')
	is false then return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION accidents_check() RETURNS trigger AS $f$
BEGIN
if NEW."accident_id" is null then return NEW; end if;
if (select "date" from accidents where accident_id = NEW.accident_id) != NEW."date" then return null; end if;
return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sessions_check() RETURNS trigger AS $f$
BEGIN
if NEW.section_id is not null and (select sport from sections left join activities using(activity_id) where section_id = NEW.section_id) is false then return null; end if;
return NEW;
END;
$f$ LANGUAGE plpgsql;


-----------------TODO

CREATE OR REPLACE FUNCTION sections_check() RETURNS trigger AS $f$
declare
members numeric;
BEGIN

if (select sport from sections left join activities using(activity_id) where section_id=NEW.section_id) is false then return null; end if;
--min/max members
--sex
--min/max age
return NEW;
END;
$f$ LANGUAGE plpgsql;

-------------TODO
CREATE OR REPLACE FUNCTION user_section_check() RETURNS trigger AS $f$
BEGIN
--cant join one section two times
--cant join section if wrong sex, age or number of members
return NEW;

END;
$f$ LANGUAGE plpgsql;
