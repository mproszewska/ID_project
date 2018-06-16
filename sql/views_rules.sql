CREATE OR REPLACE VIEW actual_sections as select user_id,section_id,start_time from user_section where end_time is null;

CREATE OR REPLACE RULE actual_sections_insert AS ON INSERT TO actual_sections
	DO INSTEAD insert into user_section values(NEW.user_id,NEW.section_id,NEW.start_time,null);

CREATE OR REPLACE VIEW section_session as select * from sessions where section_id is not null;

CREATE OR REPLACE RULE section_session_insert AS ON INSERT TO section_session
	DO INSTEAD (
	insert into sessions values(NEW.session_id,NEW.activity_id,NEW.start_time,NEW.end_time,NEW.description,NEW.trainer_id,NEW.section_id);
	insert into user_session select user_id,NEW.session_id,null from user_section 
		where section_id=NEW.section_id and start_time<=NEW.start_time and coalesce(end_time,NEW.end_time)>=NEW.end_time;
	);

CREATE OR REPLACE RULE trainer_session_insert AS ON INSERT TO sessions where NEW.trainer_id is not null
	DO (
		insert into user_session values(NEW.trainer_id,NEW.session_id,null)
	);

CREATE OR REPLACE RULE accident_delete AS ON DELETE TO accidents
  DO ALSO DELETE FROM injuries WHERE old.accident_id = injuries.accident_id;

CREATE OR REPLACE RULE trainer_session_d_3 AS ON UPDATE TO sessions where OLD.trainer_id!=NEW.trainer_id
	DO (
		update user_session set user_id=NEW.trainer_id where user_id=OLD.trainer_id and session_id=OLD.session_id;
	);

CREATE OR REPLACE RULE trainer_session_d_1 AS ON DELETE TO user_session where OLD.user_id=(select trainer_id from sessions where session_id=OLD.session_id)
	DO (
		update sessions set trainer_id=null where session_id = OLD.session_id
	);









