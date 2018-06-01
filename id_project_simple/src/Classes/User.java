package Classes;

import Database.PostgreSQLJDBC;
import Database.QueriesMachine;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class User implements QueriesMachine.Selectable, QueriesMachine.Insertable {
    private Integer userId;
    private String name;
    private String surname;
    private Double height;
    private Double weight;
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

    public User setHeight(Double height) {
        this.height = height;
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

    public User setWeight(Double weight) {
        this.weight = weight;
        return this;
    }

    public Date getBirthday() {
        return birthday;
    }

    public Double getHeight() {
        return height;
    }

    public Double getWeight() {
        return weight;
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
        height = resultSet.getDouble(4);
        weight = resultSet.getDouble(5);
        sex = resultSet.getString(6);
        birthday = resultSet.getDate(7);
    }

    @Override
    public String toString() {
        return userId + " " + name + " " + surname +  " " + height + " " + weight + " " + sex + " " + birthday;
    }

    @Override
    public String[] getMySignature() {
        return new String[]{"user_id", "name", "surname", "height", "weight", "sex", "birthday"};
    }

    @Override
    public Object[] getMyValues() {
        return new Object[]{userId, name, surname, height, weight, sex, birthday};
    }
}
