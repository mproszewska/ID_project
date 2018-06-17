import java.util.Scanner;

public class Main {
    public static void main(String... args) throws Exception{
        /*for (int i = 0; i < 300; i++) {
            System.out.println(Noise.perlinNoise1D(i, 1.5f, 4));
        }*/
        Scanner reader = new Scanner(System.in);
        final int users = 22;
        final int sectionsNumber = 11;
        final int disciplines = 11;
        final int resolution = 1000;

        String date = "2018-01-01 00:00:00";
        System.out.println("TYPE RANDOMOWY ZNAK FOR DEFAULT");
        System.out.println("Enter start date (like 2018-01-01 00:00:00):");
        String nextLine = reader.nextLine();
        if(nextLine.length() > 15)
            date = nextLine;
        System.out.println("Enter number of users with accurate heartrate meassurment (0-3) :");
        int usersAccurate = reader.nextInt();
        System.out.println("Enter accurate heartrate meassurment duration (5-60):");
        int accurateResolution = reader.nextInt();
        System.out.println("Enter medicaments consumption lower bound (100-1000):");
        int lower = reader.nextInt();
        System.out.println("Enter medicaments consumption upper bound (500-2000):");
        int upper = reader.nextInt();
        System.out.println("Enter medicaments count (2-16):");
        int medicationsCount = reader.nextInt();
        System.out.println("generating...");

        Medicaments.generate(date, users, lower, upper, medicationsCount);
        Heartrate.generate(date, users, usersAccurate,accurateResolution,resolution);
        Sleeps.generate(date, users);
        Sessions.generate(date, users, disciplines);
        HeigthWeight.generate(date, users, 70);
        UserSections.generate(date, users, sectionsNumber, 99);

        reader.close();
        System.out.println("generated!");
    }
}
