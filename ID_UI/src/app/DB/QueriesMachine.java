package app.DB;

import app.Model.Activity;
import app.Model.User;

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

    public void addUser(User user){
        database.insert("users", user);
    }

    public List<Activity> getActivities(){
        return database.select("SELECT * FROM activities", Activity.class);
    }
}
