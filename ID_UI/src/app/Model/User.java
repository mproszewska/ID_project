package app.Model;

import app.DB.QueriesMachine;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;

public class User implements QueriesMachine.Selectable, QueriesMachine.Insertable {
    private Integer userId;
    private String name;
    private String surname;
    private String sex;
    private Date birthday;

    public User setBirthday(Date birthday) {
        this.birthday = birthday;
        return this;
    }

    public User setBirthday(String date){
        DateFormat format = new SimpleDateFormat("dd-mm-yyyy");
        try {
            this.birthday = format.parse(date);
        }
        catch (ParseException p){
            throw new RuntimeException("unparsable :(((");
        }
        return this;
    }

    public User setName(String name) {
        this.name = name;
        return this;
    }

    public User setSex(String sex) {
        this.sex = sex;
        return this;
    }

    public User setSurname(String surname) {
        this.surname = surname;
        return this;
    }

    public User setUserId(Integer userId) {
        this.userId = userId;
        return this;
    }

    public Date getBirthday() {
        return birthday;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getSex() {
        return sex;
    }

    public String getSurname() {
        return surname;
    }

    @Override
    public void setMeFromResult(ResultSet resultSet) throws SQLException {
        userId = resultSet.getInt(1);
        name = resultSet.getString(2);
        surname = resultSet.getString(3);
        sex = resultSet.getString(4);
        birthday = resultSet.getDate(5);
    }

    @Override
    public String toString() {
        return userId + " " + name + " " + surname + " " + birthday + " (" + (Objects.equals(sex, "m") ?"male)" : "female)");
    }

    @Override
    public String[] getMySignature() {
        return new String[]{"user_id", "name", "surname", "sex", "birthday"};
    }

    @Override
    public Object[] getMyValues() {
        return new Object[]{userId, name, surname, sex, birthday};
    }
}
