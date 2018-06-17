import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.PrintWriter;
import java.util.Random;

import static java.lang.StrictMath.max;

public class Heartrate {
    public static void generate(String date, int users, int accurateUsers, int accurateResolution, int resolution) throws Exception{
        Random random = new Random();
        DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime startTime = fmt.parseDateTime(date);
        DateTime today = new DateTime().minusDays(1);
        Integer mappingBorder = 10;
        Integer border = 50;

        try (PrintWriter outRates = new PrintWriter("heartrates.sql"); PrintWriter outRange = new PrintWriter("range.txt")) {
            outRates.println("COPY heartrates (user_id, avg_heartrate, start_time, end_time) FROM stdin;");
            for (int j = 1; j <= users; j++) {
                int myRes = j <= accurateUsers ? accurateResolution : resolution;
                DateTime time = new DateTime(startTime);
                Integer min = 60 + random.nextInt(10);
                Integer maks = 210 - random.nextInt(50);
                Integer value = min + 10;
                Integer realValue;
                Integer i = 0;
                while (!time.isAfter(today)) {
                    time = time.plusSeconds(myRes);
                    Integer newPeril = Double.valueOf(Noise.perlinNoise1D(i, 1.6f, 4)).intValue();
                    if(newPeril > 4)
                        newPeril = 4;
                    else if(newPeril < -4)
                        newPeril = -4;
                    if (value + newPeril > maks || value + newPeril < min - border)
                        value -= newPeril;
                    else
                        value += newPeril;
                    /*if(value < min)
                        value = min;
                    else if(value > maks)
                        value = maks;*/

                    realValue = value;
                    if (value < min)
                        realValue = min + ((min - value) * mappingBorder) / border;
                    outRates.println(j + "\t" + realValue + "\t" + fmt.print(time) + "\t" + fmt.print(time.plusSeconds(resolution)));
                    i++;
                    i %= 100000000;
                }
                outRange.println(j + " " + min + "\t" + maks);
            }
            outRates.println("\\.");
        }
    }
}
