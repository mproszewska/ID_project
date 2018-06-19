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
Iwonicja	Bajtocka	k	1960-04-28
Bieżysław	Popędny	m	1989-05-20
Sławomir	Przytańczuk	m	1989-06-21
Jędrula	Drań	m	1998-08-21
Keri	Brennan	k	1990-03-28
Cameron	Bass	k	1990-07-31
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
klepanie	1
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

COPY sections (activity_id, name,city,trainer_id,min_age) FROM stdin;
11	Weekendowy Klub Przyjaciół ID	Kraków	3	19
11	TCS UJ	Niezdalandia	9	19
1	Klub Bieżnika	Bieżanów	10	\N
9	Krokietnicy	Kraków	4	\N
12	Golonka&Beer	Tłuszcz	3	\N
12	Samonieżąd Uczniowski	Kraków	12	\N
12	The Legends	Kraków	11	\N
2	AZS UJ	Kraków	8	10
1	AZS AGH	Kraków	7	11
1	AZS AWF	Warszawa	6	16
9	AZS UJ	Kraków	2	6
\.

COPY user_section (user_id, section_id,start_time) FROM stdin;
1	1	2017-06-06
2	1	2017-06-06
3	1	2017-06-06
1	2	2017-06-06
2	2	2017-06-06
3	2	2017-06-06
\.

COPY injuries (user_id, start_time, end_time, description) FROM stdin;
10	2018-01-01	2018-02-01	skolioza
1	2018-01-07	2018-01-08	inżynierioza
2	2018-01-08	2018-01-20	grypa żołądkowa gorzka
3	2018-03-09	2018-03-11	odgromnienie
7	2018-01-10	2018-02-11	apoteoza głupoty
20	2018-01-11	2018-01-17	szprycha w rowerze
19	2018-02-12	2018-02-15	nadprędkość
11	2018-03-13	2018-03-18	wyrzucenie z butów
17	2018-03-14	2018-03-20	katar jesienny
1	2018-04-15	2018-04-21	rżączka
4	2018-04-16	2018-04-22	zagłupienie wtórne
5	2018-05-17	2018-05-23	weneric collections
6	2018-03-18	2018-03-24	zwichnięcie trzustki
7	2018-01-17	2018-01-25	wszetecznica powrzechna
8	2018-02-16	2018-02-26	katzenjammer
10	2018-02-15	2018-02-28	prawoskręt kiszek
\.

