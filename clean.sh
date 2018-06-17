psql $1 < sql/drop.sql > /dev/null 2>&1
echo "cleaned!"