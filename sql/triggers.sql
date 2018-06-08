--triggers named "table_name_check"

CREATE OR REPLACE FUNCTION sleep_check() RETURNS trigger AS $f$
BEGIN
if NEW.start_time<(select birthday from users where user_id=NEW.user_id) then raise notice 'USER IS NOT BORN'; return null; end if;

if  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'user_session left join sessions using (session_id)')
	is false then raise notice 'INTERSECTION OF INTERVALS NOT EMPTY';return null; end if;

if  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'sleep')
	is false then raise notice 'INTERSECTION OF INTERVALS NOT EMPTY';return null; end if;

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

if t1<(select birthday from users where user_id=NEW.user_id) then raise notice 'USER IS NOT BORN'; return null; end if;

if  time_interval_check(NEW.user_id,t1,t2,'user_session left join sessions using (session_id)') is false 
	then raise notice 'INTERSECTION OF INTERVALS NOT EMPTY'; return null; end if;

if  time_interval_check(NEW.user_id,t1,t2,'sleep') is false 
	then raise notice 'INTERSECTION OF INTERVALS NOT EMPTY'; return null; end if;

if  time_interval_check(NEW.user_id,t1,t2,'(select user_id,a."date" as start_time,a."date"+duration as end_time from injuries left join accidents as a using(accident_id)) as inj') is false 
	then raise notice 'INTERSECTION OF INTERVALS NOT EMPTY'; return null; end if;

if section is not null and (select user_id from user_section where user_id=NEW.user_id and section_id=section and start_time<=t1 and coalesce(end_time,t2)<=t2) is null 
	then raise notice 'USER NOT IN SECTION'; return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION heartrates_check() RETURNS trigger AS $f$
BEGIN
if NEW.start_time<(select birthday from users where user_id=NEW.user_id) 
	then raise notice 'USER IS NOT BORN'; return null; end if;

if  time_interval_check(NEW.user_id,NEW.start_time,NEW.end_time,'heartrates') is false 
	then  raise notice 'INTERSECTION OF INTERVALS NOT EMPTY'; return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION injuries_check() RETURNS trigger AS $f$
BEGIN
if NEW."date"<(select birthday from users where user_id=NEW.user_id) 
	then raise notice 'USER IS NOT BORN'; return null; end if;

if NEW.accident_id is not null and (select "date" from accidents where accident_id = NEW.accident_id) != NEW."date" 
	then raise notice 'WRONG DATE'; return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sessions_check() RETURNS trigger AS $f$
BEGIN

if NEW.section_id is not null and (select sport from sections left join activities using(activity_id) where section_id = NEW.section_id) is false 
	then raise notice 'ACTIVITY SHOULD BE SPORT'; return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION sections_check() RETURNS trigger AS $f$
declare
members numeric;
BEGIN
if (select sport from sections left join activities using(activity_id) where section_id=NEW.section_id) is false 
	then raise notice 'IS NOT SPORT'; return null; end if;

members = (select count(user_id) from user_section where section_id=NEW.section_id and coalesce(end_time,current_date)=current_date);
if members < NEW.min_members or members>NEW.max_members 
	then raise notice 'WRONG NUMBER OF MEMBERS'; return null; end if;

if NEW.max_members is not null and (select user_id from user_section left join users using (user_id) where section_id=NEW.section_id and coalesce(end_time,current_date)=current_date and DATE_PART('year',CURRENT_DATE::date) - DATE_PART('year',birthday::date)>NEW.max_age) is not null 
	then raise notice 'WRONG MIN AGE'; return null; end if;

if NEW.max_age is not null and (select user_id from user_section left join users using (user_id) where section_id=NEW.section_id and coalesce(end_time,current_date)=current_date and DATE_PART('year',CURRENT_DATE::date) - DATE_PART('year',birthday::date)<NEW.min_age) is not null 
	then raise notice 'WRONG MAX AGE'; return null; end if;

if NEW.sex is not null and (select user_id from user_section left join users u using (user_id) where section_id=NEW.section_id and coalesce(end_time,current_date)=current_date and u.sex != NEW.sex) is not null 
	then raise notice 'WRONG SEX'; return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;

-------------TODO
CREATE OR REPLACE FUNCTION user_section_check() RETURNS trigger AS $f$
declare
minage numeric;
maxage numeric;
age numeric;
minmem  numeric;
maxmem numeric;
BEGIN
minage = (select min_age from sections where section_id=NEW.section_id);
maxage = (select max_age from sections where section_id=NEW.section_id);
minmem = (select min_members from sections where section_id=NEW.section_id);
maxmem = (select max_members from sections where section_id=NEW.section_id);

if NEW.start_time<(select birthday from users where user_id=NEW.user_id) 
	then raise notice 'USER IS NOT BORN YET'; return null; end if;

if (select user_id from user_section where user_id=NEW.user_id and section_id=NEW.section_id and coalesce(end_time,CURRENT_DATE)=CURRENT_DATE) is not null 		then raise notice 'USER ALREADY IN THAT SECTION'; return null; end if;

if(select sex from sections where section_id=NEW.section_id) != (select sex from users where user_id=NEW.user_id) 
	then raise notice 'WRONG SEX'; return null; end if;

age = (select DATE_PART('year',CURRENT_DATE::date)-DATE_PART('year',birthday::date) from users where user_id=NEW.user_id);
if age<minage or age>maxage 
	then raise notice 'WRONG AGE'; return null;end if;

if(select count(*) from user_section where section_id=OLD.section_id and coalesce(end_time,current_date)=current_date)<=minmem 
	then  raise notice 'WRONG NUMBER OF MEMBERS'; return null; end if;

if(select count(*) from user_section where section_id=NEW.section_id and coalesce(end_time,current_date)=current_date)>=maxmem 
	then raise notice 'WRONG NUMBER OF MEMBERS'; return null; end if;

return NEW;
END;
$f$ LANGUAGE plpgsql;


CREATE TRIGGER sleep_trigger BEFORE INSERT OR UPDATE ON sleep
FOR EACH ROW EXECUTE PROCEDURE sleep_check();

CREATE TRIGGER heartrates_trigger BEFORE INSERT OR UPDATE ON heartrates
FOR EACH ROW EXECUTE PROCEDURE heartrates_check();

CREATE TRIGGER injuries_trigger BEFORE INSERT OR UPDATE ON injuries
FOR EACH ROW EXECUTE PROCEDURE injuries_check();

CREATE TRIGGER sections_tigger BEFORE INSERT OR UPDATE ON sections
FOR EACH ROW EXECUTE PROCEDURE sections_check();

CREATE TRIGGER sessions_trigger BEFORE INSERT OR UPDATE ON sessions
FOR EACH ROW EXECUTE PROCEDURE sessions_check();

CREATE TRIGGER user_section_trigger BEFORE INSERT OR UPDATE ON user_section
FOR EACH ROW EXECUTE PROCEDURE user_section_check();

CREATE TRIGGER user_session_trigger BEFORE INSERT OR UPDATE ON user_session
FOR EACH ROW EXECUTE PROCEDURE user_session_check();

