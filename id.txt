CREATE SCHEMA id_project;

CREATE TABLE id_project.activities ( 
	activity_id          integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	individual           bool  NOT NULL,
	CONSTRAINT pk_activities_activity_id PRIMARY KEY ( activity_id )
 );

CREATE TABLE id_project.medications ( 
	medication_id        integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	CONSTRAINT pk_supplements_supplement_id PRIMARY KEY ( medication_id )
 );

CREATE TABLE id_project.sessions ( 
	session_id           integer  NOT NULL,
	activity_id          integer  NOT NULL,
	distance             numeric  NOT NULL,
	start_time           timestamp  NOT NULL,
	end_time             timestamp  NOT NULL,
	CONSTRAINT pk_sessions_session_id PRIMARY KEY ( session_id ),
	CONSTRAINT fk_sessions_activities FOREIGN KEY ( activity_id ) REFERENCES id_project.activities( activity_id )  
 );

CREATE INDEX idx_sessions_activity_id ON id_project.sessions ( activity_id );

CREATE TABLE id_project."table" ( 
 );

CREATE TABLE id_project.users ( 
	user_id              integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	surname              varchar(100)  NOT NULL,
	weight               numeric(5,2)  NOT NULL,
	height               numeric(5,2)  ,
	sex                  char(1)  NOT NULL,
	birthday             date  NOT NULL,
	CONSTRAINT pk_users_users_id PRIMARY KEY ( user_id )
 );

CREATE TABLE id_project.accidents ( 
	accident_id          integer  NOT NULL,
	"date"               timestamp DEFAULT current_timestamp NOT NULL,
	session_id           integer  ,
	CONSTRAINT pk_accidents_accident_id PRIMARY KEY ( accident_id ),
	CONSTRAINT idx_accidents_session_id UNIQUE ( session_id ) ,
	CONSTRAINT fk_accidents_sessions FOREIGN KEY ( session_id ) REFERENCES id_project.sessions( session_id )  
 );

CREATE TABLE id_project.heartrate_node ( 
	user_id              integer  NOT NULL,
	avg_heartrate        numeric  NOT NULL,
	start_time           timestamp  NOT NULL,
	end_time             timestamp  ,
	CONSTRAINT fk_heartrate_node_users FOREIGN KEY ( user_id ) REFERENCES id_project.users( user_id )  
 );

CREATE INDEX idx_heartrate_node_user_session_id ON id_project.heartrate_node ( user_id );

CREATE TABLE id_project.injuries ( 
	injury_id            integer  NOT NULL,
	user_id              integer  NOT NULL,
	category             varchar(100)  NOT NULL,
	accident_id          integer  ,
	duration             timestamp  ,
	CONSTRAINT pk_injuries_injure_id PRIMARY KEY ( injury_id ),
	CONSTRAINT fk_injuries_accidents FOREIGN KEY ( accident_id ) REFERENCES id_project.accidents( accident_id )  ,
	CONSTRAINT fk_injuries_users FOREIGN KEY ( user_id ) REFERENCES id_project.users( user_id )  
 );

CREATE INDEX idx_injuries_accident_id ON id_project.injuries ( accident_id );

CREATE INDEX idx_injuries_user_id ON id_project.injuries ( user_id );

COMMENT ON COLUMN id_project.injuries.duration IS 'interval';

CREATE TABLE id_project.sections ( 
	section_id           integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	activity_id          integer  NOT NULL,
	city                 varchar(100)  NOT NULL,
	motto                varchar(300)  ,
	trainer_id           varchar(100)  ,
	CONSTRAINT pk_sections_section_id PRIMARY KEY ( section_id ),
	CONSTRAINT fk_sections_activities FOREIGN KEY ( activity_id ) REFERENCES id_project.activities( activity_id )  ,
	CONSTRAINT fk_sections_users FOREIGN KEY ( trainer_id ) REFERENCES id_project.users( user_id )  
 );

CREATE INDEX idx_sections_activity_id ON id_project.sections ( activity_id );

CREATE INDEX idx_sections_trainer_id ON id_project.sections ( trainer_id );

CREATE TABLE id_project.sleep ( 
	user_id              integer  NOT NULL,
	start_time           timestamp  NOT NULL,
	end_time             timestamp  NOT NULL,
	rems                 numeric  ,
	CONSTRAINT idx_sleep_user_id UNIQUE ( user_id ) ,
	CONSTRAINT fk_sleep_users FOREIGN KEY ( user_id ) REFERENCES id_project.users( user_id ) ON DELETE CASCADE ON UPDATE CASCADE
 );

CREATE TABLE id_project.supplies ( 
	user_id              integer  NOT NULL,
	medication_id        integer  NOT NULL,
	portion              numeric DEFAULT 1 NOT NULL,
	"date"               timestamp DEFAULT current_date NOT NULL,
	CONSTRAINT fk_supplies_medications FOREIGN KEY ( medication_id ) REFERENCES id_project.medications( medication_id )  ,
	CONSTRAINT fk_supplies_users FOREIGN KEY ( user_id ) REFERENCES id_project.users( user_id )  
 );

CREATE INDEX idx_supplies_medication_id ON id_project.supplies ( medication_id );

CREATE INDEX idx_supplies_user_id ON id_project.supplies ( user_id );

CREATE TABLE id_project.user_session ( 
	user_id              integer  NOT NULL,
	session_id           integer  ,
	CONSTRAINT fk_trainings_users FOREIGN KEY ( user_id ) REFERENCES id_project.users( user_id )  ,
	CONSTRAINT fk_trainings_sessions FOREIGN KEY ( session_id ) REFERENCES id_project.sessions( session_id )  
 );

CREATE INDEX idx_trainings_user_id ON id_project.user_session ( user_id );

CREATE INDEX idx_trainings_session1_id ON id_project.user_session ( session_id );

CREATE TABLE id_project.people ( 
	user_id              integer  NOT NULL,
	section_id           integer  NOT NULL,
	CONSTRAINT fk_people_users FOREIGN KEY ( user_id ) REFERENCES id_project.users( user_id ) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_people_sections FOREIGN KEY ( section_id ) REFERENCES id_project.sections( section_id )  
 );

CREATE INDEX idx_people_user_id ON id_project.people ( user_id );

CREATE INDEX idx_people_section_id ON id_project.people ( section_id );

