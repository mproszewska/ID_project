--projekt_id

DROP TABLE IF EXISTS activities CASCADE;
CREATE TABLE activities ( 
	activity_id          integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	sport                bool  NOT NULL,
	CONSTRAINT pk_activities_activity_id PRIMARY KEY ( activity_id )
 );


DROP TABLE IF EXISTS medications CASCADE;
CREATE TABLE medications ( 
	medication_id        integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	CONSTRAINT pk_supplements_supplement_id PRIMARY KEY ( medication_id )
 );


DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users ( 
	user_id              integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	surname              varchar(100)  NOT NULL,
	height               numeric(5,2)  NOT NULL,
	weight               numeric(5,2)  NOT NULL,
	sex                  char(1)  NOT NULL,
	birthday             date  NOT NULL,
	CONSTRAINT pk_users_users_id PRIMARY KEY ( user_id )
 );

DROP TABLE IF EXISTS heartrates CASCADE;
CREATE TABLE heartrates ( 
	user_id              integer  NOT NULL,
	avg_heartrate        numeric(3,0)  NOT NULL,
	start_time           timestamp DEFAULT current_timestamp NOT NULL,
	end_time             timestamp  NOT NULL,
	CONSTRAINT fk_heartrate_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  
 );



ALTER TABLE heartrates ADD CONSTRAINT cns_heartrates CHECK ( start_time<end_time );

ALTER TABLE heartrates ADD CONSTRAINT cns_heartrates_0 CHECK ( avg_heartrate>=50 and avg_heartrate<=250 );

CREATE INDEX idx_heartrates_user_session_id ON heartrates ( user_id );

COMMENT ON COLUMN heartrates.avg_heartrate IS 'per minute';

DROP TABLE IF EXISTS sections CASCADE;
CREATE TABLE sections ( 
	section_id           integer  NOT NULL,
	activity_id          integer  NOT NULL,
	name                 varchar(100)  NOT NULL,
	city                 varchar(100)  NOT NULL,
	trainer_id           integer NOT NULL,
	CONSTRAINT pk_sections_section_id PRIMARY KEY ( section_id ),
	CONSTRAINT fk_sections_activities FOREIGN KEY ( activity_id ) REFERENCES activities( activity_id )  ,
	CONSTRAINT fk_sections_users FOREIGN KEY ( trainer_id ) REFERENCES users( user_id )  
 );



CREATE INDEX idx_sections_activity_id ON sections ( activity_id );

CREATE INDEX idx_sections_trainer_id ON sections ( trainer_id );

DROP TABLE IF EXISTS sessions CASCADE;
CREATE TABLE sessions ( 
	session_id           integer  NOT NULL,
	activity_id          integer  NOT NULL,
	start_time           timestamp  NOT NULL,
	end_time             timestamp  NOT NULL,
	description          varchar(300)  ,
	trainer_id           integer  ,
	CONSTRAINT pk_sessions_session_id PRIMARY KEY ( session_id ),
	CONSTRAINT fk_sessions_activities FOREIGN KEY ( activity_id ) REFERENCES activities( activity_id )  ,
	CONSTRAINT fk_sessions_users FOREIGN KEY ( trainer_id ) REFERENCES users( user_id )  
 );


ALTER TABLE sessions ADD CONSTRAINT cns_user_session CHECK ( start_time<end_time );

ALTER TABLE user_session ADD CONSTRAINT cns_user_session_0 CHECK ( distance>0 );

CREATE INDEX idx_sessions_activity_id ON sessions ( activity_id );

CREATE INDEX idx_sessions_description ON sessions ( description );

CREATE INDEX idx_sessions_trainer_id ON sessions ( trainer_id );

COMMENT ON COLUMN user_session.distance IS 'in meters';

DROP TABLE IF EXISTS user_medication CASCADE;
CREATE TABLE user_medication ( 
	user_id              integer  NOT NULL,
	medication_id        integer  NOT NULL,
	"date"               timestamp DEFAULT current_date NOT NULL,
	portion              numeric(4,2) DEFAULT 1 NOT NULL,
	CONSTRAINT fk_supplies_medications FOREIGN KEY ( medication_id ) REFERENCES medications( medication_id )  ,
	CONSTRAINT fk_supplies_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  
 );



ALTER TABLE user_medication ADD CONSTRAINT cns_user_medication CHECK ( portion>0 );

CREATE INDEX idx_supplies_medication_id ON user_medication ( medication_id );

CREATE INDEX idx_supplies_user_id ON user_medication ( user_id );

DROP TABLE IF EXISTS user_section CASCADE;
CREATE TABLE user_section ( 
	user_id              integer  NOT NULL,
	section_id           integer  NOT NULL,
	CONSTRAINT fk_people_users FOREIGN KEY ( user_id ) REFERENCES users( user_id ) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_people_sections FOREIGN KEY ( section_id ) REFERENCES sections( section_id )  
 );

CREATE INDEX idx_people_user_id ON user_section ( user_id );

CREATE INDEX idx_people_section_id ON user_section ( section_id );

DROP TABLE IF EXISTS user_session CASCADE;
CREATE TABLE user_session ( 
	user_id              integer  NOT NULL,
	session_id           integer  NOT NULL,
	distance             numeric  ,
	CONSTRAINT fk_trainings_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  ,
	CONSTRAINT fk_trainings_sessions FOREIGN KEY ( session_id ) REFERENCES sessions( session_id )  
 );


CREATE INDEX idx_trainings_user_id ON user_session ( user_id );

CREATE INDEX idx_trainings_session1_id ON user_session ( session_id );

DROP TABLE IF EXISTS accidents CASCADE;
CREATE TABLE accidents ( 
	accident_id          integer  NOT NULL,
	"date"               timestamp DEFAULT current_timestamp NOT NULL,
	session_id           integer  ,
	CONSTRAINT pk_accidents_accident_id PRIMARY KEY ( accident_id ),
	CONSTRAINT idx_accidents_session_id UNIQUE ( session_id ) ,
	CONSTRAINT fk_accidents_sessions FOREIGN KEY ( session_id ) REFERENCES sessions( session_id )  
 );


DROP TABLE IF EXISTS injuries CASCADE;
CREATE TABLE injuries ( 
	user_id              integer  NOT NULL,
	accident_id          integer  ,
	description          varchar(100)  NOT NULL,
	duration             interval  ,
	CONSTRAINT fk_injuries_accidents FOREIGN KEY ( accident_id ) REFERENCES accidents( accident_id )  ,
	CONSTRAINT fk_injuries_users FOREIGN KEY ( user_id ) REFERENCES users( user_id )  
 );


CREATE INDEX idx_injuries_accident_id ON injuries ( accident_id );

CREATE INDEX idx_injuries_user_id ON injuries ( user_id );


COPY users (user_id, name, surname,height,weight,sex,birthday) FROM stdin;
0	Keri	Brennan	176	95	k	1990-03-28
1	Cameron	Bass	193	67	k	2001-07-31
2	Roberta	Morse	181	59	k	1992-04-6
3	Colby	Boone	185	60	m	1987-08-15
4	Cornelius	Herring	173	75	m	1983-07-3
5	Teddy	Martin	168	80	m	1997-08-24
6	Lillian	Huerta	175	53	k	1999-07-04
7	Dianna	Chapman	170	63	k	1990-12-05
8	Geoffrey	Pacheco	201	110	m	1975-05-01
9	Sheldon	Lamb	188	98	m	1971-01-17
\.

COPY activities (activity_id, name, sport) FROM stdin;
0	bieganie	true
1	pływanie	true
2	tenis	true
3	taniec	false
4	spanie	false
5	gotowanie	false
6	czytanie	false
7	piłka nożna	true
8	krykiet	true
9	gimnastyka	true
\.

COPY medications (medication_id, name) FROM stdin;
0	witamina A
1	witamina B3
2	witamina B5
3	kreatyna
4	BCAA
\.

COPY heartrates (user_id, avg_heartrate, start_time, end_time) FROM stdin;
0	120	2008-07-24 11:00:00	2008-07-24 11:30:00
0	80	2008-07-22 14:00:00	2008-07-22 14:30:00
1	110	2008-07-25 08:30:00	2008-07-25 09:00:00
3	70	2008-07-21 08:00:00	2008-07-21 08:30:00
3	100	2008-07-23 11:00:00	2008-07-23 11:30:00
3	111	2008-07-25 12:00:00	2008-07-25 12:30:00
4	123	2008-07-25 13:30:00	2008-07-25 14:00:00
7	99	2008-07-21 11:30:00	2008-07-21 12:00:00
7	95	2008-07-25 09:30:00	2008-07-25 10:00:00
7	85	2008-07-25 08:00:00	2008-07-25 08:30:00
9	101	2008-07-25 13:00:00	2008-07-25 13:30:00
0	115	2008-07-23 13:30:00	2008-07-23 14:00:00
\.

COPY sections (section_id, activity_id, name,city,trainer_id) FROM stdin;
0	0	AZS UJ	Kraków	2
1	1	AZS AGH	Kraków	0
2	1	AZS AWF	Warszawa	1
3	7	AZS SGGW	Warszawa	9
4	9	AZS UJ	Kraków	2
\.
COPY sessions (session_id, activity_id, start_time,end_time,description,trainer_id) FROM stdin;
0	0	2016-07-12 10:40:00	2016-07-12 11:40:00	\N	2
1	0	2016-02-28 06:30:00	2016-02-28 07:15:00	\N	2
2	0	2015-03-12 11:20:00	2015-03-12 15:00:00	\N	\N
3	1	2014-12-06 09:00:00	2014-12-06 09:58:00	\N	9
4	2	2016-11-02 11:15:00	2016-11-02 13:15:00	2:0	\N
5	2	2016-10-24 09:30:00	2016-10-24 10:30:00	\N	\N
6	3	2017-03-03 09:03:00	2017-03-03 12:03:00	\N	7
7	7	2016-07-16 08:45:00	2016-07-16 10:20:00	3:1	\N
8	0	2016-04-19 15:18:00	2016-04-19 16:07:00	\N	\N
9	3	2016-09-11 22:00:00	2016-09-12 06:00:00	\N	\N
10	5	2016-01-10 07:00:00	2016-01-10 08:05:00	\N	\N
11	3	2015-01-15 05:45:00	2015-01-15 06:30:00	\N	\N
12	4	2017-01-18 13:12:00	2017-01-18 14:00:00	\N	\N
13	5	2017-02-20 12:00:00	2017-02-20 14:00:00	\N	\N
14	6	2015-03-21 15:05:00	2015-03-21 16:30:00	\N	\N
15	2	2016-06-06 12:00:00	2016-06-06 14:45:00	\N	5
16	2	2016-04-06 15:45:00	2016-04-06 16:02:00	\N	5
17	3	2015-03-04 15:00:00	2015-03-04 17:15:00	\N	\N
18	4	2016-02-20 23:55:00	2016-02-21 01:05:00	\N	\N
19	5	2016-02-20 11:00:00	2016-02-20 12:00:00	\N	\N
\.

COPY user_medication (user_id, medication_id, "date", portion) FROM stdin;
0	0	2016-07-23 12:20:00	2
0	4	2016-05-15 12:15:00	4.5
1	3	2015-03-03 03:14:00	3
1	3	2016-12-04 07:30:00	1
1	2	2017-11-23 08:00:00	2
7	2	2016-07-23 06:40:00	3.5
8	3	2016-11-12 06:30:00	3.2
9	3	2016-04-14 19:50:00	5
9	4	2015-02-01 17:50:00	1
9	4	2016-01-01 13:58:00	2
\.

COPY user_section (user_id, section_id) FROM stdin;
0	0
0	3
1	2
2	2
3	0
6	0
6	3
7	4
8	4
9	0
\.

COPY user_session (user_id, session_id,distance) FROM stdin;
0	1	3000
0	3	10000
0	19	\N
1	5	1200
1	2	5000
1	3	\N
1	15	\N
1	16	\N
1	17	\N
1	19	\N
2	0	1200
2	17	\N
2	15	\N
3	1	\N
4	2	4000
4	14	\N
4	3	\N
5	2	7400
5	16	\N
7	5	5000
7	18	\N
8	3	\N
8	4	\N
8	7	\N
8	10	\N
8	11	\N
9	8	800
9	12	\N
9	13	\N
\.

COPY accidents (accident_id, "date", session_id) FROM stdin;
0	2016-07-12 10:50:00	0
1	2016-04-06 16:00:00	16
2	2016-05-06 18:00:00	\N
3	2016-12-31 23:51:00	\N
4	2017-03-02 10:51:00	\N
\.
COPY injuries (user_id, accident_id, description,duration) FROM stdin;
0	0	złamana noga	3 weeks
5	1	złamana ręka	10 days
\.
