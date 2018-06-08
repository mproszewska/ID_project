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
        System.out.println("Enter medicaments consumtion lower bound (100-1000):");
        int lower = reader.nextInt();
        System.out.println("Enter medicaments consumtion upper bound (500-2000):");
        int upper = reader.nextInt();
        System.out.println("Enter medicaments count (2-16):");
        int medicationsCount = reader.nextInt();
        System.out.println("Let's generate!");
        Medicaments.generate(date, 20, lower, upper, medicationsCount);
        Heartrate.generate(date, users, resolution);
        Sleeps.generate(date, 20);
        Sessions.generate(date, 20);
        reader.close();
        System.out.println("Finished!");
    }
}
