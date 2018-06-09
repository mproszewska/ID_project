package app.DB;

import app.Model.SelectContainer;
import app.Model.User;

import java.util.List;

public class Test {
    public static void main(String... arg){
        QueriesMachine machine = new QueriesMachine();
        System.out.println(machine.getUsers());
//        System.out.println(machine.getUser("Dzwonisław", "Krzakiel"));
        List<SelectContainer> list = machine.select("select * from users", SelectContainer.class);
        System.out.println(machine.select("select * from users", SelectContainer.class));
        for (SelectContainer container : list){
            System.out.println(container.toString("; "));
        }
        System.out.println(machine.select("select * from users", SelectContainer.class));
        machine.addUser(new User().setUserId(30).setBirthday("2018-04-02").setName("P").setSurname("P").setSex("m"));
        machine.query(
                "INSERT INTO users (name, surname, sex, birthday) VALUES ('Piotr_I', 'Kask_Zdobywca', 'm', 'Mon Jul 11 00:04:00 CET 7');"
        );
    }
}
