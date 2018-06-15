CREATE OR REPLACE VIEW actual_sections AS SELECT user_id,section_id,start_time FROM user_section WHERE end_time IS NULL;

CREATE OR REPLACE RULE actual_sections_INSERT AS ON INSERT TO actual_sections
        DO INSTEAD INSERT INTO user_section values(NEW.user_id,NEW.section_id,NEW.start_time,NULL);

CREATE OR REPLACE VIEW section_session AS SELECT * FROM sessions WHERE section_id IS NOT NULL;

CREATE OR REPLACE RULE section_session_INSERT AS ON INSERT TO section_session
        DO INSTEAD (
        INSERT INTO sessions values(NEW.session_id,NEW.activity_id,NEW.start_time,NEW.end_time,NEW.description,NEW.trainer_id,NEW.section_id);
        INSERT INTO user_session SELECT user_id,NEW.session_id,NULL FROM user_section
                WHERE section_id=NEW.section_id AND start_time<=NEW.start_time AND COALESCE(end_time,NEW.end_time)>=NEW.end_time;
        );

CREATE OR REPLACE RULE trainer_session_INSERT AS ON INSERT TO sessions WHERE NEW.trainer_id IS NOT NULL
        DO (
                INSERT INTO user_session values(NEW.trainer_id,NEW.session_id,NULL)
        );

CREATE OR REPLACE RULE trainer_session_d_0 AS ON DELETE TO sessions WHERE OLD.trainer_id IS NOT NULL
        DO (
                delete FROM user_session WHERE user_id = OLD.trainer_id AND session_id = OLD.session_id
        );

CREATE OR REPLACE RULE trainer_session_d_3 AS ON UPDATE TO sessions WHERE OLD.trainer_id!=NEW.trainer_id
        DO (
                UPDATE user_session SET user_id=NEW.trainer_id WHERE user_id=OLD.trainer_id AND session_id=OLD.session_id;
        );

CREATE OR REPLACE RULE trainer_session_d_1 AS ON DELETE TO user_session WHERE OLD.user_id=(SELECT trainer_id FROM sessions WHERE session_id=OLD.session_id)
        DO (
                UPDATE sessions SET trainer_id=NULL WHERE session_id = OLD.session_id
        );

CREATE OR REPLACE RULE injuries_accidents_date AS ON UPDATE TO accidents WHERE (SELECT "date" FROM injuries WHERE accident_id IS NOT NULL AND accident_id=NEW.accident_id AND "date"!=NEW."date") IS NOT NULL
        DO INSTEAD NOTHING;

