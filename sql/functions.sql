--funtions

CREATE OR REPLACE FUNCTION kcal_during_session(userid integer, sessionid integer) RETURNS numeric AS $$
declare
i numeric;
j timestamp;
k timestamp;
m numeric;
start_0 timestamp;
end_0 timestamp;
sex_0 char;
age_0 numeric;
weight_0 numeric;
seconds numeric;
heartrates_0 numeric;
lasttime timestamp;
avg_heartrate_0 numeric;

BEGIN
sex_0 = (select sex from users where user_id=userid);
start_0 = (select start_time from sessions s where s.session_id=sessionid);
end_0 = (select end_time from sessions s where s.session_id=sessionid);
age_0 = (select DATE_PART('year',start_0::date) - DATE_PART('year',birthday::date) from users where user_id=userid);
weight_0 = (select weight from height_weight where weight is not null and user_id=userid and "date" = (select max("date") from height_weight where user_id=userid and "date"<=start_0));
seconds =(SELECT EXTRACT (EPOCH FROM (end_0-start_0)));
lasttime = start_0;
heartrates_0 = 0;

for i,j,k in select avg_heartrate,start_time,end_time from heartrates h where h.user_id=userid and h.end_time>=start_0 and h.start_time<=end_0
	loop
		if lasttime < j then raise notice 'NOT CONTINUOUS DATA'; return null; end if;
		lasttime = k;
		m = (SELECT EXTRACT (EPOCH FROM (k-j)));
		if j<start_0 then m=m-(SELECT EXTRACT (EPOCH FROM (start_0-j))); end if;
		if k>end_0 then m=m-(SELECT EXTRACT (EPOCH FROM (k-end_0))); end if;
		heartrates_0 = heartrates_0 + i*m;
	end loop;

if lasttime < end_0 then raise notice 'NOT CONTINUOUS DATA'; return null; end if;

avg_heartrate_0 = heartrates_0/seconds;

if sex_0 = 'm' 
	then return  ROUND(((age_0 * 0.2017) - (weight_0 * 0.09036) + (avg_heartrate_0 * 0.6309) - 55.0969) * (seconds/60) / 4.184,2); 
else return ROUND(((age_0 * 0.074) - (weight_0 * 0.05741) + (avg_heartrate_0 * 0.4472) - 20.4022) * (seconds/60) / 4.184,2); end if;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION  bmi(user_id_0 integer,date_0 date) RETURNS numeric AS $$
declare
weight_0 numeric;
height_0 numeric;

BEGIN
if date_0 is null then date_0 = CURRENT_DATE; end if;
weight_0 = (select weight from height_weight where user_id=user_id_0 and weight is not null and 
	"date" = (select max("date") from height_weight where user_id=user_id_0 and "date"<=date_0 and weight is not null));
height_0 = (select height from height_weight where user_id=user_id_0 and height is not null and 
	"date" = (select max("date") from height_weight where user_id=user_id_0 and "date"<=date_0 and height is not null) )/100;
return ROUND(weight_0/(height_0*height_0),2);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION height_weight_changes() RETURNS TABLE (user_id integer,start_time timestamp,end_time timestamp,hight_change numeric,weight_change numeric) AS $$
BEGIN
    RETURN QUERY EXECUTE
        'select user_id,
	(
	select "date" from height_weight where (height is not null or weight is not null)  
		and "date" = (select max("date") from height_weight where user_id=hw.user_id 
		and "date"<hw."date" and (height is not null or weight is not null))
	) as start_time, 
	"date" as end_time , 
	height - (select height from height_weight where height is not null 
		and "date" = (select max("date") from height_weight where user_id=hw.user_id and "date"<hw."date" and height is not null)) as height_change,
	weight - (select weight from height_weight where weight is not null 
		and "date" = (select max("date") from height_weight where user_id=hw.user_id and "date"<hw."date" and weight is not null)) as weight_change
from height_weight hw  where date!=(select min("date") from height_weight where user_id=hw.user_id) order by "date"';
END;
$$ LANGUAGE plpgsql;

------------TODO
CREATE OR REPLACE FUNCTION heartrate_session_type(user_id integer,session_id integer) RETURNS varchar AS $$
BEGIN
    RETURN "x";
END;
$$ LANGUAGE plpgsql;


-------------TODO
CREATE OR REPLACE FUNCTION timetable(user_id integer,day date) RETURNS TABLE (id integer) AS $$
BEGIN
    RETURN QUERY EXECUTE
        'select 0 from sessions';
END;
$$ LANGUAGE plpgsql;

------------TODO
CREATE OR REPLACE FUNCTION section_timesheet(section_id integer,fist date, last date) RETURNS TABLE ("date" date, present bool) AS $$
BEGIN
    RETURN QUERY EXECUTE
        'select user_id,0 from user_section us where us.section_id=section_id';
END;
$$ LANGUAGE plpgsql;
---------------------TODO
CREATE OR REPLACE FUNCTION  medications_sessions(user_id integer,fist date, last date) RETURNS TABLE (mediaction_id integer) AS $$
BEGIN
    RETURN QUERY EXECUTE
        'select 0 from mediaction_user';
END;
$$ LANGUAGE plpgsql;

------------------


--other functions
CREATE OR REPLACE FUNCTION get_table(input_table text)
    RETURNS TABLE (user_id int, start_time timestamp, end_time timestamp) AS $$
BEGIN
    RETURN QUERY EXECUTE
        concat('SELECT user_id, start_time, end_time FROM ', input_table);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION time_interval_check( id int, start timestamp, endd timestamp, tab text) RETURNS bool AS $f$
BEGIN
if (
	select t.user_id from (select * from get_table(tab)) t
	where t.user_id = id and ( 
		(t.start_time >= start and t.start_time < endd) or
		(t.end_time > start and t.end_time <= endd) or 
		(start>= t.start_time and start < t.end_time) or
		(endd > t.start_time and endd <= t.end_time)
	)
) is not null then return false; end if;

return true;
END;
$f$ LANGUAGE plpgsql;
