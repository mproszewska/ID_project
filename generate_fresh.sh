if [[ $1 == "" ]]; then
	echo "give me database name"
	exit
fi
java -jar ./gienerator2/out/artifacts/gienerator2_jar/gienerator2.jar
echo "concatening..."
cat heartrates.sql sleeps.sql supplies.sql sessions.sql user_session.sql h_w.sql sections.sql sessions_sect.sql user_session_sect.sql > generated_data.sql
rm heartrates.sql sleeps.sql supplies.sql sessions.sql user_session.sql range.txt h_w.sql sections.sql user_session_sect.sql sessions_sect.sql
# psql "$1" < ./sql/drop.sql
echo "rebuilding database..."
psql "$1" < ./sql/tables.sql #--quiet > /dev/null 2>&1
echo "injecting functions..."
psql "$1" < ./sql/functions.sql #--quiet > /dev/null 2>&1
psql "$1" < ./sql/views_rules.sql #--quiet > /dev/null 2>&1
echo "injecting data..."
psql "$1" < ./sql/data.sql #--quiet > /dev/null 2>&1
psql "$1" < ./generated_data.sql #--quiet > /dev/null 2>&1
echo "injecting triggers..."
psql "$1" < ./sql/triggers.sql
echo "removing trash..."
rm generated_data.sql > /dev/null 2>&1
echo "finished!"

