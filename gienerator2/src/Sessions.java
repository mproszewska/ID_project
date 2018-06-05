import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.PrintWriter;
import java.util.Random;

public class Sessions {
    public static void generate(String date, int users) throws Exception {
        Random random = new Random();
        DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime startTime = fmt.parseDateTime(date);
        DateTime today = new DateTime().minusDays(1);

        try (PrintWriter userOut = new PrintWriter("user_session.sql"); PrintWriter sessionOut = new PrintWriter("sessions.sql")) {
            userOut.println("COPY user_session (user_id, session_id,distance,start_time,end_time) FROM stdin;");
            sessionOut.println("COPY sessions (session_id, activity_id, start_time,end_time,description,trainer_id) FROM stdin;");
            int sessionId = 1;
            for (int j = 1; j <= users; j++) {
                DateTime day = new DateTime(startTime);
                while (!day.isAfter(today)) {
                    day = day.plusDays(1);
                    Integer count = random.nextInt(2);
                    for (int i = 0; i < count; i++) {
                        Integer discipline = random.nextInt(10)+1;
                        DateTime when;
                        DateTime until;
                        if(count == 1){
                            if(random.nextInt(2) == 0)
                                when = day.withHourOfDay(8).plusMinutes(10*random.nextInt(18));
                            else
                                when = day.withHourOfDay(14).plusMinutes(10*random.nextInt(18));
                        }
                        else if(i==0)
                            when = day.withHourOfDay(8).plusMinutes(10*random.nextInt(18));
                        else
                            when = day.withHourOfDay(14).plusMinutes(10*random.nextInt(18));

                        until = when.plusMinutes(30 + 10*random.nextInt(10));
                        userOut.println(j + "\t" + sessionId + "\t" + getDistance(discipline) + "\t" + fmt.print(when) + "\t" + fmt.print(until));
                        sessionOut.println(sessionId + "\t" + discipline + "\t" + fmt.print(when) + "\t" + fmt.print(until) + "\t" + "\\N" + "\t" + "\\N");
                        sessionId++;
                    }
                }
            }
            userOut.println("\\.");
            sessionOut.println("\\.");
        }
    }

    private static String getDistance(Integer discipline){
        Random random = new Random();
        if(discipline == 1){
            return Integer.valueOf(500 + 100*random.nextInt(200)).toString();
        }
        else if(discipline == 2){
            return Integer.valueOf(200 + 25*random.nextInt(50)).toString();
        }
        else
            return "\\N";
    }
}
