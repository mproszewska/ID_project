DROP TRIGGER IF EXISTS heartrates_trigger ON heartrates;
CREATE TRIGGER heartrates_trigger BEFORE INSERT OR UPDATE ON heartrates
FOR EACH ROW EXECUTE PROCEDURE heartrates_check();