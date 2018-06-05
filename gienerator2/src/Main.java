import java.util.Scanner;

public class Main {
    public static void main(String... args) throws Exception{
        Scanner reader = new Scanner(System.in);

        String date = "2018-01-01 00:00:00";

        System.out.println("TYPE RANDOMOWY ZNAK FOR DEFAULT");
        System.out.println("Enter start date (like 2018-01-01 00:00:00):");
        String nextLine = reader.nextLine();
        if(nextLine.length() > 15)
            date = nextLine;
        System.out.println("Enter users number (1-20):");
        int users = reader.nextInt();
        System.out.println("Enter heartrate meassurment duration (5-3600):");
        int resolution = reader.nextInt();
        System.out.println("Let's generate!");
        Medicaments.generate(date, users, 10, 1000, 16);
        Heartrate.generate(date, users, resolution);
        Sleeps.generate(date, users);
        Sessions.generate(date, users);
        reader.close();
        System.out.println("Finished!");
    }
}
