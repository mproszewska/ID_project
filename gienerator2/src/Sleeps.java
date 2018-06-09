import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.PrintWriter;
import java.util.Random;

public class Sleeps {
    public static void generate(String date, int users) throws Exception {
        Random random = new Random();
        DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime startTime = fmt.parseDateTime(date);
        DateTime today = new DateTime().minusDays(1);

        try (PrintWriter out = new PrintWriter("sleeps.sql")) {
            out.println("COPY sleep (user_id, start_time,end_time) FROM stdin;");
            for (int j = 1; j <= users; j++) {
                DateTime day = new DateTime(startTime);
                while (!day.isAfter(today)) {
                    day = day.plusDays(1);
                    DateTime start = day.plusHours(22).plusMinutes(10 * random.nextInt(15));
                    DateTime end = start.plusHours(6).plusMinutes(10 * random.nextInt(15));
                    out.println(j + "\t" + fmt.print(start) + "\t" + fmt.print(end));
                }
            }
            out.println("\\.");
        }
    }
}
