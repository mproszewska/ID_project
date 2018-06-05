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
1 	187	67	2017-04-6
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

COPY sections (activity_id, name,city,trainer_id) FROM stdin;
2	AZS UJ	Kraków	8
1	AZS AGH	Kraków	7
1	AZS AWF	Warszawa	6
7	AZS SGGW	Warszawa	4
9	AZS UJ	Kraków	2
9	TCS UJ	Niezdalandia	9
1	Klub Bieżnika	Bieżanów	10
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
