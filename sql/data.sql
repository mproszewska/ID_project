--generator

COPY users (name, surname,sex,birthday) FROM stdin;
Keri	Brennan	k	1990-03-28
Cameron	Bass	k	2001-07-31
Roberta	Morse	k	1992-04-6
Colby	Boone	m	1987-08-15
Cornelius	Herring	m	1983-07-3
Teddy	Martin	m	1997-08-24
Lillian	Huerta	k	1999-07-04
Dianna	Chapman	k	1990-12-05
Geoffrey	Pacheco	m	1975-05-01
Sheldon	Lamb	m	1971-01-17
\.

COPY height_weight(user_id, height,weight,date) FROM stdin;
3	170	70	1990-03-28
2	166	73	2001-07-31
1	187	64	1992-04-6
1	202	90	1987-08-15
4	196	78	1983-07-3
3	170	89	1997-08-24
6	176	45	1999-07-04
4	187	58	1990-12-05
4	160	43	1975-05-01
3	190	83	1971-01-17
\.

COPY activities (name,sport) FROM stdin;
bieganie	1
pływanie	1
tenis	1
taniec	1
szachy	1
gotowanie	0
czytanie	0
piłka nożna	1
krykiet	1
gimnastyka	1
\.

COPY medications (name) FROM stdin;
witamina A
witamina B3
witamina B5
kreatyna
BCAA
\.

COPY heartrates (user_id, avg_heartrate, start_time, end_time) FROM stdin;
1	120	2008-07-24 11:00:00	2008-07-24 11:30:00
1	80	2008-07-22 14:00:00	2008-07-22 14:30:00
1	110	2008-07-25 08:30:00	2008-07-25 09:00:00
3	70	2008-07-21 08:00:00	2008-07-21 08:30:00
3	100	2008-07-23 11:00:00	2008-07-23 11:30:00
3	111	2008-07-25 12:00:00	2008-07-25 12:30:00
4	123	2008-07-25 13:30:00	2008-07-25 14:00:00
7	99	2008-07-21 11:30:00	2008-07-21 12:00:00
7	95	2008-07-25 09:30:00	2008-07-25 10:00:00
7	85	2008-07-25 08:00:00	2008-07-25 08:30:00
9	101	2008-07-25 13:00:00	2008-07-25 13:30:00
1	115	2008-07-23 13:30:00	2008-07-23 14:00:00
\.

COPY sections (activity_id, name,city,trainer_id) FROM stdin;
2	AZS UJ	Kraków	2
1	AZS AGH	Kraków	3
1	AZS AWF	Warszawa	1
7	AZS SGGW	Warszawa	9
9	AZS UJ	Kraków	2
\.
COPY sleep (user_id, start_time,end_time) FROM stdin;
1	2016-07-15 10:40:00	2016-07-16 11:40:00
1	2016-02-26 06:30:00	2016-02-28 07:15:00
1	2015-03-17 11:20:00	2015-03-19 15:00:00
1	2014-12-02 09:00:00	2014-12-06 09:58:00
2	2016-11-01 11:15:00	2016-11-02 13:15:00
2	2016-10-22 09:30:00	2016-10-24 10:30:00
\.
COPY sessions (activity_id, start_time,end_time,description,trainer_id) FROM stdin;
1	2016-07-12 10:40:00	2016-07-12 11:40:00	\N	2
1	2016-02-28 06:30:00	2016-02-28 07:15:00	\N	2
1	2015-03-12 11:20:00	2015-03-12 15:00:00	\N	\N
1	2014-12-06 09:00:00	2014-12-06 09:58:00	\N	9
2	2016-11-02 11:15:00	2016-11-02 13:15:00	2:0	\N
2	2016-10-24 09:30:00	2016-10-24 10:30:00	\N	\N
3	2017-03-03 09:03:00	2017-03-03 12:03:00	\N	7
7	2016-07-16 08:45:00	2016-07-16 10:20:00	3:1	\N
5	2016-04-19 15:18:00	2016-04-19 16:07:00	\N	\N
3	2016-09-11 22:00:00	2016-09-12 06:00:00	\N	\N
5	2016-01-10 07:00:00	2016-01-10 08:05:00	\N	\N
3	2015-01-15 05:45:00	2015-01-15 06:30:00	\N	\N
4	2017-01-18 13:12:00	2017-01-18 14:00:00	\N	\N
5	2017-02-20 12:00:00	2017-02-20 14:00:00	\N	\N
6	2015-03-21 15:05:00	2015-03-21 16:30:00	\N	\N
2	2016-06-06 12:00:00	2016-06-06 14:45:00	\N	5
2	2016-04-06 15:45:00	2016-04-06 16:02:00	\N	5
3	2015-03-04 15:00:00	2015-03-04 17:15:00	\N	\N
4	2016-02-20 23:55:00	2016-02-21 01:05:00	\N	\N
5	2016-02-20 11:00:00	2016-02-20 12:00:00	\N	\N
\.

COPY user_medication (user_id, medication_id, "date", portion) FROM stdin;
1	1	2016-07-23 12:20:00	2
1	4	2016-05-15 12:15:00	4.5
1	3	2015-03-03 03:14:00	3
1	3	2016-12-04 07:30:00	1
1	2	2017-11-23 08:00:00	2
7	2	2016-07-23 06:40:00	3.5
8	3	2016-11-12 06:30:00	3.2
9	3	2016-04-14 19:50:00	5
9	4	2015-02-01 17:50:00	1
9	4	2016-01-01 13:58:00	2
\.

COPY user_section (user_id, section_id,start_time) FROM stdin;
1	1	2001-07-31
1	3	2007-07-31
1	2	2009-07-31
2	2	2010-07-31
3	1	2001-07-31
6	1	2001-07-31
6	3	2008-07-31
7	4	2011-07-31
8	4	2011-07-31
9	1	2006-07-31
\.

COPY user_session (user_id, session_id,distance,start_time,end_time) FROM stdin;
2	1	3000	2016-07-12 10:40:00	2016-07-12 11:40:00
2	3	10000	2015-03-12 11:20:00	2015-03-12 15:00:00
2	19	\N	2016-02-20 23:55:00	2016-02-21 01:05:00
1	5	1200	2016-11-02 11:15:00	2016-11-02 13:15:00
1	2	5000	2016-02-28 06:30:00	2016-02-28 07:15:00
1	3	\N	2015-03-12 11:20:00	2015-03-12 15:00:00
1	15	\N	2015-03-21 15:05:00	2015-03-21 16:30:00
1	16	\N	2016-06-06 12:00:00	2016-06-06 14:45:00
1	17	\N	2016-04-06 15:45:00	2016-04-06 16:02:00
1	19	\N	2016-02-20 23:55:00	2016-02-21 01:05:00
2	7	1200	2017-03-03 09:03:00	2017-03-03 12:03:00
2	17	\N	2016-04-06 15:45:00	2016-04-06 16:02:00
2	15	\N	2015-03-21 15:05:00	2015-03-21 16:30:00
3	1	\N	2016-07-12 10:40:00	2016-07-12 11:40:00
4	2	4000	2016-02-28 06:30:00	2016-02-28 07:15:00
4	14	\N	2017-02-20 12:00:00	2017-02-20 14:00:00
4	3	\N	2015-03-12 11:20:00	2015-03-12 15:00:00
5	2	7400	2016-02-28 06:30:00	2016-02-28 07:15:00
5	16	\N	2016-06-06 12:00:00	2016-06-06 14:45:00
7	5	5000	2016-11-02 11:15:00	2016-11-02 13:15:00
7	18	\N	2015-03-04 15:00:00	2015-03-04 17:15:00
8	3	\N	2015-03-12 11:20:00	2015-03-12 15:00:00
8	4	\N	2014-12-06 09:00:00	2014-12-06 09:58:00
8	7	\N	2017-03-03 09:03:00	2017-03-03 12:03:00
8	10	\N	2016-09-11 22:00:00	2016-09-12 06:00:00
8	11	\N	2016-01-10 07:00:00	2016-01-10 08:05:00
9	8	800	2016-07-16 08:45:00	2016-07-16 10:20:00
9	12	\N	2015-01-15 05:45:00	2015-01-15 06:30:00
9	13	\N	2017-01-18 13:12:00	2017-01-18 14:00:00
\.

COPY accidents ("date") FROM stdin;
2016-07-12 10:50:00
2016-04-06 16:00:00
2016-05-06 18:00:00
2016-12-31 23:51:00
2017-03-02 10:51:00
\.
COPY injuries (user_id, accident_id, description,duration) FROM stdin;
1	2	złamana noga	3 weeks
5	1	złamana ręka	10 days
\.