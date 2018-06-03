--CREATE SCHEMA id_project;

DROP TABLE IF EXISTS accidents CASCADE;
CREATE TABLE accidents ( 
	accident_id          serial,
	"date"               timestamp DEFAULT current_timestamp NOT NULL,
	CONSTRAINT pk_accidents_accident_id PRIMARY KEY ( accident_id )
 );

ALTER TABLE sleep ADD CONSTRAINT cns_sleep_0 CHECK ( start_time < end_time );

CREATE TRIGGER sleep_trigger BEFORE INSERT OR UPDATE ON sleep
FOR EACH ROW EXECUTE PROCEDURE sleep_check();

DROP TABLE IF EXISTS activities CASCADE;
CREATE TABLE activities ( 
	activity_id          serial,
	name                 varchar(100)  NOT NULL,
	sport                bool  NOT NULL,
	CONSTRAINT pk_activities_activity_id PRIMARY KEY ( activity_id )
 );

DROP TABLE IF EXISTS medications CASCADE;
CREATE TABLE medications ( 
	medication_id        serial,
	name                 varchar(100)  NOT NULL,
	ddd                  numeric  ,
	CONSTRAINT pk_medications_medication_id PRIMARY KEY ( medication_id ),
	CONSTRAINT uq_medications_name_0 UNIQUE ( name ) 
 );

ALTER TABLE medications ADD CONSTRAINT cns_medications CHECK ( ddd is null or ddd > 0 );

DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users ( 
	user_id              serial,
	name                 varchar(100)  NOT NULL,
	surname              varchar(100)  NOT NULL,
	sex                  char(1)  NOT NULL,
	birthday             date  NOT NULL,
	CONSTRAINT pk_users_users_id PRIMARY KEY ( user_id )
 );

ALTER TABLE users ADD CONSTRAINT cns_users CHECK ( birthday <= current_date and (sex is null or sex='k' or sex='m'));

DROP TABLE IF EXISTS heartrates CASCADE;
CREATE TABLE heartrates ( 
	user_id              integer  NOT NULL,
	avg_heartrate        numeric(3,0)  NOT NULL,
	start_time           timestamp DEFAULT current_timestamp NOT NULL,
	end_time             timestamp  NOT NULL,
	CONSTRAINT fk_heartrate_node_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE cascade
 );

ALTER TABLE heartrates ADD CONSTRAINT cns_heartrates CHECK ( start_time<end_time and end_time <= current_timestamp );

CREATE INDEX idx_heartrates_user_session_id ON heartrates ( user_id );

CREATE TRIGGER heartrates_trigger BEFORE INSERT OR UPDATE ON heartrates
FOR EACH ROW EXECUTE PROCEDURE heartrates_check();

DROP TABLE IF EXISTS height_weight CASCADE;
CREATE TABLE height_weight ( 
	user_id              integer  NOT NULL,
	height               numeric(3)  ,
	weight               numeric(3)  ,
	"date"               timestamp DEFAULT current_timestamp NOT NULL,
	CONSTRAINT uq_height_weight_0 UNIQUE ( user_id,"date" ) ,
	CONSTRAINT fk_height_weight_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE cascade
 );

ALTER TABLE height_weight ADD CONSTRAINT cns_height_weight CHECK ( "date" <= current_timestamp );

ALTER TABLE height_weight ADD CONSTRAINT cns_height_weight_0 CHECK ( (height is not null or weight is not null) and (weight is not null or weight > 0) and  ( height is null or height > 0));

CREATE INDEX idx_height_weight_user_id ON height_weight ( user_id );

DROP TABLE IF EXISTS injuries CASCADE;
CREATE TABLE injuries ( 
	user_id              integer  NOT NULL,
	accident_id          integer  ,
	description          varchar(100)  NOT NULL,
	duration             interval  ,
	"date"		     timestamp,
	CONSTRAINT fk_injuries_accidents FOREIGN KEY ( accident_id ) REFERENCES accidents( accident_id )  ,
	CONSTRAINT fk_injuries_users FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE cascade 
 );

CREATE INDEX idx_injuries_accident_id ON injuries ( accident_id );

CREATE INDEX idx_injuries_user_id ON injuries ( user_id );

ALTER TABLE injuries ADD CONSTRAINT cns_injuries CHECK ( "date" <= current_timestamp );

DROP TABLE IF EXISTS sections CASCADE;
CREATE TABLE sections ( 
	section_id           serial,
	activity_id          integer  NOT NULL,
	trainer_id           integer  ,
	name                 varchar(100)  NOT NULL,
	city                 varchar(100)  NOT NULL,
	min_age              numeric(3)  ,
	max_age              numeric(3)  ,
	min_members          numeric  ,
	max_members          numeric  ,
	sex                  char(1)  ,
	CONSTRAINT pk_sections_section_id PRIMARY KEY ( section_id ),
	CONSTRAINT fk_sections_activities FOREIGN KEY ( activity_id ) REFERENCES activities( activity_id )  ,
	CONSTRAINT fk_sections_users FOREIGN KEY ( trainer_id ) REFERENCES users( user_id )  ON DELETE set null
 );

ALTER TABLE sections ADD CONSTRAINT cns_sections CHECK ( coalesce(min_age,0) >= 0 and (min_age <= max_age or max_age is null) );

ALTER TABLE sections ADD CONSTRAINT cns_sections_0 CHECK ( coalesce (min_members,0)>= 0 and (min_members <= max_members or max_members is null) );

ALTER TABLE sections ADD CONSTRAINT cns_sections_1 CHECK ( sex is null or sex='k' or sex='m' );

CREATE INDEX idx_sections_trainer_id ON sections ( trainer_id );

CREATE TRIGGER sections_tigger BEFORE INSERT OR UPDATE ON sections
FOR EACH ROW EXECUTE PROCEDURE sections_check();

DROP TABLE IF EXISTS sessions CASCADE;
CREATE TABLE sessions ( 
	session_id           serial,
	activity_id          integer  NOT NULL,
	start_time           timestamp  NOT NULL,
	end_time             timestamp  NOT NULL,
	description          varchar(300)  ,
	trainer_id           integer  ,
	section_id           integer  ,
	CONSTRAINT pk_sessions_session_id PRIMARY KEY ( session_id ),
	CONSTRAINT fk_sessions_activities FOREIGN KEY ( activity_id ) REFERENCES activities( activity_id )  ,
	CONSTRAINT fk_sessions_users FOREIGN KEY ( trainer_id ) REFERENCES users( user_id ) ON DELETE set null ,
	CONSTRAINT fk_sessions_sections FOREIGN KEY ( section_id ) REFERENCES sections( section_id )  
 );

ALTER TABLE sessions ADD CONSTRAINT cns_sessions CHECK ( start_time<end_time );

CREATE INDEX idx_sessions_activity_id ON sessions ( activity_id );

CREATE INDEX idx_sessions_description ON sessions ( description );

CREATE INDEX idx_sessions_trainer_id ON sessions ( trainer_id );

CREATE INDEX idx_sessions_section_id ON sessions ( section_id );

CREATE TRIGGER sessions_trigger BEFORE INSERT OR UPDATE ON sessions
FOR EACH ROW EXECUTE PROCEDURE sessions_check();

DROP TABLE IF EXISTS user_medication CASCADE;
CREATE TABLE user_medication ( 
	user_id              integer  NOT NULL,
	medication_id        integer  NOT NULL,
	"date"               timestamp DEFAULT current_date NOT NULL,
	portion              numeric DEFAULT 1 NOT NULL,
	CONSTRAINT fk_user_medication FOREIGN KEY ( medication_id ) REFERENCES medications( medication_id )  ,
	CONSTRAINT fk_user_medication_0 FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE cascade  
 );

ALTER TABLE user_medication ADD CONSTRAINT cns_user_medication CHECK ( portion>0 );

CREATE INDEX idx_user_medication_medication_id ON user_medication ( medication_id );

CREATE INDEX idx_user_medication_user_id ON user_medication ( user_id );

DROP TABLE IF EXISTS user_section CASCADE;
CREATE TABLE user_section ( 
	user_id              integer  NOT NULL,
	section_id           integer  NOT NULL,
	start_time           date DEFAULT current_date NOT NULL,
	end_time             date  ,
	CONSTRAINT fk_people_users FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE cascade,
	CONSTRAINT fk_people_sections FOREIGN KEY ( section_id ) REFERENCES sections( section_id )
 );

CREATE INDEX idx_people_user_id ON user_section ( user_id );

CREATE INDEX idx_people_section_id ON user_section ( section_id );

CREATE TRIGGER user_section_trigger BEFORE INSERT OR UPDATE ON user_section
FOR EACH ROW EXECUTE PROCEDURE user_section_check();

DROP TABLE IF EXISTS user_session CASCADE;
CREATE TABLE user_session ( 
	user_id              integer  NOT NULL,
	session_id           integer  NOT NULL,
	distance             numeric  ,
	start_time           timestamp  NOT NULL,
	end_time             timestamp  NOT NULL,
	CONSTRAINT fk_trainings_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE cascade,
	CONSTRAINT fk_trainings_sessions FOREIGN KEY ( session_id ) REFERENCES sessions( session_id )  
 );

DROP TABLE IF EXISTS sleep CASCADE;
CREATE TABLE sleep (
	user_id              integer  NOT NULL,
	start_time           timestamp  NOT NULL,
	end_time             timestamp  NOT NULL,
	CONSTRAINT fk_sleep FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE cascade
 );

ALTER TABLE user_session ADD CONSTRAINT cns_user_session CHECK ( start_time<end_time );

ALTER TABLE user_session ADD CONSTRAINT cns_user_session_0 CHECK ( distance is null or distance > 0 );

CREATE INDEX idx_user_session_user_id ON user_session ( user_id );

CREATE INDEX idx_user_session_session1_id ON user_session ( session_id );

CREATE TRIGGER user_session_trigger BEFORE INSERT OR UPDATE ON user_session
FOR EACH ROW EXECUTE PROCEDURE user_session_check();


