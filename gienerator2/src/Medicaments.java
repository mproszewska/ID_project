import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.PrintWriter;
import java.util.Random;

public class Medicaments {
    public static void generate(String date, int users, int downBound, int upBound, int medCount) throws Exception {
        Random random = new Random();
        DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss.SSSSS");
        DateTime startTime = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss").parseDateTime(date);
        DateTime today = new DateTime().minusDays(1);
        Integer daysBetween = Days.daysBetween(startTime, today).getDays();
        try (PrintWriter out = new PrintWriter("supplies.sql")) {
            out.println("COPY user_medication (user_id, medication_id, \"date\", portion) FROM stdin;");
            for (int j = 1; j <= users; j++) {
                Integer count = random.nextInt(upBound-downBound) + downBound;
                for (int i = 0; i < count; i++) {
                    DateTime when = startTime.plusDays(random.nextInt(daysBetween));
                    when = when.withHourOfDay(7).plusMillis(random.nextInt(46800000));
                    out.println(j + "\t" + (random.nextInt(medCount)+1) + "\t" + fmt.print(when) + "\t" + (random.nextInt(4)+1));
                }
            }
            out.println("\\.");
        }
    }
}
