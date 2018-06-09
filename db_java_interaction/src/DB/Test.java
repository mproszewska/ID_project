package DB;

import Model.SelectContainer;

public class Test {
    public static void main(String... arg){
        QueriesMachine machine = new QueriesMachine();
        System.out.println(machine.getUsers());
//        System.out.println(machine.getUser("Dzwonisław", "Krzakiel"));
        System.out.println(machine.select("select * from users", SelectContainer.class));
    }
}
