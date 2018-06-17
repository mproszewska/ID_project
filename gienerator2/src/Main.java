import java.util.Scanner;

public class Main {
    public static void main(String... args) throws Exception{
        Scanner reader = new Scanner(System.in);
        final int users = 22;
        final int sectionsNumber = 12;
        final int disciplines = 11;
        String date = "2018-01-01 00:00:00";
        System.out.println("TYPE RANDOMOWY ZNAK FOR DEFAULT");
        System.out.println("Enter start date (like 2018-01-01 00:00:00):");
        String nextLine = reader.nextLine();
        if(nextLine.length() > 15)
            date = nextLine;
        System.out.println("Enter heartrate meassurment users number (1-22) (zalecane < 3):");
        int usersHeartrate = reader.nextInt();
        System.out.println("Enter heartrate meassurment duration (5-3600):");
        int resolution = reader.nextInt();
        System.out.println("Enter medicaments consumption lower bound (100-1000):");
        int lower = reader.nextInt();
        System.out.println("Enter medicaments consumption upper bound (500-2000):");
        int upper = reader.nextInt();
        System.out.println("Enter medicaments count (2-16):");
        int medicationsCount = reader.nextInt();
        System.out.println("generating...");

        Medicaments.generate(date, users, lower, upper, medicationsCount);
        Heartrate.generate(date, usersHeartrate, resolution);
        Sleeps.generate(date, users);
        Sessions.generate(date, users, disciplines);
        HeigthWeight.generate(date, users, 70);
        UserSections.generate(date, users, sectionsNumber, 99);

        reader.close();
        System.out.println("generated!");
    }
}
