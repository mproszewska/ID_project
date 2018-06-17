--generator


COPY users (name, surname,sex,birthday) FROM stdin;
Piotr	Kask	m	1997-01-01
Maria	Magdalena	k	1997-01-01
Krzysztof	Klaps	m	1998-01-01
Dzwonisław	Krzakiel	m	1989-02-20
Brzęczysław	Brząk	m	1990-12-03
Brokułacy	Falafel	m	1967-03-20
Mrokusław	Ptrzmiel	m	1988-04-20
Miceksy	Szekeres	m	1945-01-04
Iwonicja	Bajtocka	k	1945-04-28
Bieżysław	Popędny	m	1989-05-20
Sławomir	Przytańczuk	m	1989-06-21
Jędrula	Drań	m	1998-08-21
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
klepanie	0
wudzitsu	1
\.

COPY medications (name) FROM stdin;
sok z ziemi
wywar z pędzifiołku
kokaina
sól
TCS
C2H5OH
adrenalina
ekstrakt z Odyna
woda destylowana
kruszony azbest
aspiryna
lordozan max
iksdeanian
transfuzja
kurz w kłaczkach
ABCAA
\.

COPY sections (activity_id, name,city,trainer_id,min_age,max_age) FROM stdin;
11	Weekendowy Klub Przyjaciół ID	Kraków	3	20	22
11	TCS UJ	Niezdalandia	9	20	35
1	Klub Bieżnika	Bieżanów	10	\N	\N
9	Krokietnicy	Kraków	4	\N	\N
6	Golonka&Beer	Tłuszcz	3	\N	\N
12	Samonieżąd Uczniowski	Kraków	12	\N	\N
12	The Legends	Kraków	11	\N	\N
2	AZS UJ	Kraków	8	10	99
1	AZS AGH	Kraków	7	11	70
1	AZS AWF	Warszawa	6	16	80
7	AZS SGGW	Warszawa	4	18	99
9	AZS UJ	Kraków	2	6	96
\.


COPY accidents ("date") FROM stdin;
2016-07-12 10:50:00
2016-04-06 16:00:00
2016-05-06 18:00:00
2016-12-31 23:51:00
2017-03-02 10:51:00
\.

COPY user_section (user_id, section_id,start_time) FROM stdin;
1	1	2017-06-06
2	1	2017-06-06
3	1	2017-06-06
1	2	2017-06-06
2	2	2017-06-06
3	2	2017-06-06
\.

