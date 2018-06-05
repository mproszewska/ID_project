import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.PrintWriter;
import java.util.Random;

public class Heartrate {
    public static void generate(String date, int users, int resolution) throws Exception{
        Random random = new Random();
        DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime startTime = fmt.parseDateTime(date);
        DateTime today = new DateTime().minusDays(1);
        Integer mappingBorder = 10;
        Integer border = 50;

        try (PrintWriter outRates = new PrintWriter("heartrates.sql"); PrintWriter outRange = new PrintWriter("range.txt")) {
            outRates.println("COPY heartrates (user_id, avg_heartrate, start_time, end_time) FROM stdin;");
            for (int j = 1; j <= users; j++) {
                DateTime time = new DateTime(startTime);
                Integer min = 50 + random.nextInt(20);
                Integer maks = 220 - random.nextInt(100);
                Integer value = min + 10;
                Integer realValue;
                Integer i = 0;
                while (!time.isAfter(today)) {
                    time = time.plusSeconds(resolution);
                    Integer newPeril = Double.valueOf(Noise.perlinNoise1D(i, 2, 5)).intValue();
                    if (value + newPeril > maks || value + newPeril < min - border)
                        value -= newPeril;
                    else
                        value += newPeril;
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
