--funtions

------------TODO
CREATE OR REPLACE FUNCTION ddd_table(mediaction_id integer,user_id integer) RETURNS TABLE (medication_id integer) AS $$
BEGIN
    RETURN QUERY EXECUTE
        'select 0 from mediaction_user';
END;
$$ LANGUAGE plpgsql;

------------TODO
CREATE OR REPLACE FUNCTION heartrate_session_type(user_id integer,session_id integer) RETURNS varchar AS $$
BEGIN
    RETURN "x";
END;
$$ LANGUAGE plpgsql;

-------------TODO
CREATE OR REPLACE FUNCTION kcal_during_session(user_id integer, session_id integer) RETURNS integer AS $$
BEGIN
    RETURN 0;
END;
$$ LANGUAGE plpgsql;

-------------TODO
CREATE OR REPLACE FUNCTION timetable(user_id integer,first_day date, last_day date) RETURNS TABLE (id integer) AS $$
BEGIN
    RETURN QUERY EXECUTE
        'select 0 from sessions';
END;
$$ LANGUAGE plpgsql;

----------TODO
CREATE OR REPLACE FUNCTION height_weight_changes(user_id integer) RETURNS TABLE (change varchar) AS $$
BEGIN
    RETURN QUERY EXECUTE
        'select null from mediaction_user';
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
---------------
CREATE OR REPLACE FUNCTION  choose_secion_for_user(user_id integer) RETURNS integer AS $$
BEGIN
    RETURN 0;
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
