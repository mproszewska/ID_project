--CREATE SCHEMA id_project;
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
	height               NUMERIC(3)  ,
	weight               NUMERIC(3)  ,
	"date"               TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT uq_height_weight_0 UNIQUE ( user_id,"date" ) ,
	CONSTRAINT fk_height_weight_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ON DELETE CASCADE
 );

ALTER TABLE height_weight ADD CONSTRAINT cns_height_weight CHECK ( "date" <= CURRENT_TIMESTAMP );

ALTER TABLE height_weight ADD CONSTRAINT cns_height_weight_0 CHECK ( (height is not NULL OR weight is not NULL) AND (weight is not NULL OR weight > 0) AND  ( height is NULL OR height > 0));

CREATE INDEX idx_height_weight_user_id ON height_weight ( user_id );

DROP TABLE IF EXISTS accidents CASCADE;
CREATE TABLE accidents ( 
	accident_id          SERIAL,
	"date"               TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT pk_accidents_accident_id PRIMARY KEY ( accident_id )
 );

DROP TABLE IF EXISTS injuries CASCADE;
CREATE TABLE injuries ( 
	user_id              INTEGER  NOT NULL,
	accident_id          INTEGER  ,
	description          VARCHAR(100),
	duration             INTERVAL  ,
	"date"		     DATE NOT NULL,
	CONSTRAINT uq_injuries_accident_id_users_id UNIQUE ( user_id,"date" ),
	CONSTRAINT fk_injuries_accidents FOREIGN KEY ( accident_id ) REFERENCES accidents( accident_id )  ON DELETE SET NULL,
	CONSTRAINT fk_injuries_users FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE CASCADE 
 );

CREATE INDEX idx_injuries_accident_id ON injuries ( accident_id );

CREATE INDEX idx_injuries_user_id ON injuries ( user_id );

ALTER TABLE injuries ADD CONSTRAINT cns_injuries CHECK ( "date" <= CURRENT_TIMESTAMP );

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


