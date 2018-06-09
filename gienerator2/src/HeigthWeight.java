import com.sun.org.apache.xerces.internal.impl.dv.xs.DateTimeDV;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.PrintWriter;
import java.util.Random;

public class HeigthWeight {
    public static void generate(String date, int users, int fraction) throws Exception {
        Random random = new Random();
        DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime startTime = fmt.parseDateTime(date);
        DateTime today = new DateTime().minusDays(1);
        Integer daysBetween = Days.daysBetween(startTime, today).getDays();
        try (PrintWriter out = new PrintWriter("h_w.sql")) {
            out.println("COPY height_weight(user_id, height, weight,date) FROM stdin;");
            for (int j = 1; j <= users; j++) {
                DateTime day = new DateTime(startTime);
                int height = 150 + random.nextInt(60);
                int weight = 40 + random.nextInt(140);
                int maks = weight*(100 + random.nextInt(20))/100;
                int mini = weight*(100 - random.nextInt(20))/100;
                while (!day.isAfter(today)){
                    if(random.nextInt(100) < fraction){
                        Integer newPeril = Double.valueOf(Noise.perlinNoise1D(random.nextInt(), 2, 5)).intValue();
                        if (weight + newPeril > maks || weight + newPeril < mini)
                            weight -= newPeril;
                        else
                            weight += newPeril;
                        int rdm = random.nextInt(100);
                        out.println(j + "\t" + (height-(random.nextInt(100) < 4 ? 1 : 0)) + "\t" + weight + "\t" + fmt.print(day));
                    }
                    day = day.plusDays(1);
                }
            }
            out.println("\\.");
        }

    }
}
