if [[ $1 == "" ]]; then
	echo "give me database name"
	exit
fi
java -jar ./gienerator2/out/artifacts/gienerator2_jar/gienerator2.jar
echo "concatening..."
./concat.sh
# psql "$1" < ./sql/drop.sql
echo "rebuilding database..."
psql "$1" < ./sql/tables.sql --quiet > /dev/null 2>&1
echo "injecting triggers..."
# psql "$1" < ./sql/triggers.sql
echo "injecting functions..."
psql "$1" < ./sql/functions.sql --quiet > /dev/null 2>&1
psql "$1" < ./sql/views_rules.sql --quiet > /dev/null 2>&1
echo "injecting data..."
psql "$1" < ./sql/data.sql --quiet > /dev/null 2>&1
psql "$1" < ./generated_data.sql --quiet > /dev/null 2>&1
rm generated_data.sql --quiet > /dev/null 2>&1
echo "finished!"

