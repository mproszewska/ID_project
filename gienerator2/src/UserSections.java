import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.io.PrintWriter;
import java.util.*;

class Section{
    Integer id;
    Integer act;
    List<Integer> people = new ArrayList<>();

    Section(int id, int act){
        this.id = id;
        this.act = act;
    }

    void add(Integer person){
        people.add(person);
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object o) {
        return o instanceof Section && id.equals(((Section) o).id);
    }
}

public class UserSections {
    public static void generate(String date, int users, int sectionsNumber, int fraction) throws Exception {
        Integer[] acts = new Integer[]{0,11,11,1,9,6,12,12,2,1,1,7,9};
        List<Section> list = new ArrayList<>();
        for (int i = 1; i <= sectionsNumber; i++)
            list.add(new Section(i, acts[i]));
        list.get(1).add(1); list.get(1).add(2); list.get(1).add(3);
        list.get(2).add(1); list.get(2).add(2); list.get(2).add(3);
        Random random = new Random();
        DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd");
        DateTimeFormatter fmtAcc = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime startTime = fmtAcc.parseDateTime(date);
        DateTime today = new DateTime().minusDays(1);
        try (PrintWriter out = new PrintWriter("sections.sql")) {
            out.println("COPY user_section (user_id, section_id,start_time) FROM stdin;");
            for (int j = 4; j <= users; j++) {
                Integer first = random.nextInt(11)+2;
                Integer second = random.nextInt(11)+2;
                list.get(first-1).people.add(j);
                list.get(second-1).people.add(j);
                while(second.equals(first))
                    second = random.nextInt(11)+2;

                out.println(j + "\t" + first + "\t" + fmt.print(startTime.minusDays(random.nextInt(1000))));
                out.println(j + "\t" + second + "\t" + fmt.print(startTime.minusDays(random.nextInt(1000))));
            }
            out.println("\\.");
        }

        try (PrintWriter userOut = new PrintWriter("user_session_sect.sql"); PrintWriter sessionOut = new PrintWriter("sessions_sect.sql"))
        {
            userOut.println("COPY user_session (user_id, session_id,distance) FROM stdin;");
            sessionOut.println("COPY sessions (session_id, section_id, activity_id, start_time,end_time) FROM stdin;");
            Integer sessionId = 1000000;
            DateTime day = new DateTime(startTime);
            while (!day.isAfter(today)){
                Section section = list.get(random.nextInt(list.size()));
                DateTime when = day.withHourOfDay(19).plusMinutes(10*random.nextInt(7));
                DateTime until = day.withHourOfDay(22).minusMinutes(10*(1+random.nextInt(6)));
                sessionOut.println(++sessionId + "\t" + section.id + "\t" + section.act + "\t" + fmtAcc.print(when) + "\t" + fmtAcc.print(until));
                for (Integer i : section.people)
                    if(random.nextInt(100) < fraction)
                        userOut.println(i + "\t" + sessionId + "\t" + Sessions.getDistance(section.act));
                day = day.plusDays(1);
            }
            userOut.println("\\.");
            sessionOut.println("\\.");
        }
    }
}

