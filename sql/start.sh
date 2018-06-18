psql < drop.sql --quiet
psql < tables.sql --quiet
psql < functions.sql --quiet
psql < trigger.sql --quiet
psql < views_rules.sql --quiet
psql < data.sql --quiet

