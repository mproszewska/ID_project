package DB;

import Model.Activity;
import Model.User;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class QueriesMachine {
    public interface Selectable{
        void setMeFromResult(ResultSet resultSet) throws SQLException;
    }
    public interface Insertable{
        String[] getMySignature();
        Object[] getMyValues();
    }

    private PostgreSQLJDBC database;

    public QueriesMachine(){
        database = new PostgreSQLJDBC();
    }

    public QueriesMachine(String database, String username, String password){
        this.database = new PostgreSQLJDBC(database, username, password);
    }

    public List<User> getUsers(){
        return database.select("SELECT * FROM users", User.class);
    }

    public List<User> getUser(String name, String surname){
        String in = "SELECT * FROM users WHERE name LIKE '" + name + "' and surname like '" + surname + "'";
        return database.select(in, User.class);
    }

    public void query(String query){
        database.query(query);
    }

    public void addUser(User user){
        database.insert("users", user);
    }

    public List<Activity> getActivities(){
        return database.select("SELECT * FROM activities", Activity.class);
    }

    public <T extends Selectable> List<T> select(String query, Class<T> cl){
        return database.select(query, cl);
    }
}
