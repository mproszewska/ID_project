--generator


COPY users (name, surname,sex,birthday) FROM stdin;
Dzwonisław	Krzakiel	m	1989-02-20
Brzęczysław	Brząk	m	1990-12-03
Brokułacy	Falafel	m	1967-03-20
Mrokusław	Ptrzmiel	m	1988-04-20
Piotr	Kask	m	1997-01-01
Maria	Magdalena	k	1997-01-01
Krzysztof	Klaps	m	1998-01-01
Miceksy	Szekeres	m	1945-01-04
Iwonicja	Bajtocka	k	1945-04-28
Bieżysław	Popędny	m	1989-05-20
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
1 	187	67	2010-04-6
1	202	90	2017-08-15
2	166	73	2017-07-31
3	170	70	2017-03-28
3	170	89	2017-08-24
3	190	83	1971-01-17
4	187	58	1990-12-05
4	160	43	1975-05-01
4	196	78	1983-07-3
6	176	45	1999-07-04
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
kokaina
sok z ziemi
wywar z pędzifiołku
sól
TCS
C2H5OH
adrenalina
ekstrakt z Odyna
woda destylowana
aspiryna
kruszony azbest
\.

COPY sections (activity_id, name,city,trainer_id,max_age) FROM stdin;
2	AZS UJ	Kraków	8	\N
1	AZS AGH	Kraków	7	\N
1	AZS AWF	Warszawa	6	\N
7	AZS SGGW	Warszawa	4	\N
9	AZS UJ	Kraków	2	\N
9	TCS UJ	Niezdalandia	9	\N
1	Klub Bieżnika	Bieżanów	10	\N
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
COPY user_section (user_id, section_id,start_time) FROM stdin;
1	1	2001-07-31
1	3	2007-07-31
1	2	2009-07-31
2	2	2010-07-31
3	1	2001-07-31
6	1	1999-07-31
6	3	2008-07-31
7	4	2011-07-31
8	4	2011-07-31
9	1	2006-07-31
\.
COPY sessions (activity_id, start_time,end_time,description,trainer_id,section_id) FROM stdin;
1	2016-07-12 10:40:00	2016-07-12 11:40:00	\N	2	\N
6	2016-07-12 14:40:00	2016-07-12 16:40:00	\N	2	\N
5	2016-07-12 17:40:00	2016-07-12 18:40:00	\N	2	\N
1	2016-02-28 06:30:00	2016-02-28 07:15:00	\N	2	\N
1	2015-03-12 11:20:00	2015-03-12 15:00:00	\N	\N	\N
1	2014-12-06 09:00:00	2014-12-06 09:58:00	\N	9	\N
2	2016-11-02 11:15:00	2016-11-02 13:15:00	2:0	\N	\N
2	2016-10-24 09:30:00	2016-10-24 10:30:00	\N	\N	\N
3	2017-03-03 09:03:00	2017-03-03 12:03:00	\N	7	\N
7	2016-07-16 08:45:00	2016-07-16 10:20:00	3:1	\N	\N
5	2016-04-19 15:18:00	2016-04-19 16:07:00	\N	\N	\N
3	2016-09-11 22:00:00	2016-09-12 06:00:00	\N	\N	\N
5	2016-01-10 07:00:00	2016-01-10 08:05:00	\N	\N	\N
\.
COPY user_session (user_id, session_id,distance) FROM stdin;
1	1	3000
1	2	\N
1	3	\N
2	1	10000
1	5	1200
1	2	5000
1	3	\N
3	2	5000
4	1	5000
\.
COPY sleep(user_id,start_time, end_time) FROM stdin;
1 	2016-07-11 20:40:00	2016-07-12 08:40:00
1 	2016-07-12 20:40:00	2016-07-13 08:40:00
\.
COPY heartrates (user_id, avg_heartrate, start_time, end_time) FROM stdin;
1	120	2016-07-12 10:30:00	2016-07-12 11:00:00
1	80	2016-07-12 11:00:00	2016-07-12 11:10:00
1	110	2016-07-12 11:10:00	2016-07-12 11:30:00
1	70	2016-07-12 11:30:00	2016-07-12 11:56:00
\.
