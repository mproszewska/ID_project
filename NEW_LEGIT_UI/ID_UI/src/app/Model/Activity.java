package app.Model;

import app.DB.QueriesMachine;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Activity implements QueriesMachine.Selectable {
    private Integer activity_id;
    private String name;
    private boolean sport;

    public String getName() {
        return name;
    }

    public Integer getActivity_id() {
        return activity_id;
    }

    public boolean isSport() {
        return sport;
    }

    @Override
    public String toString() {
        return activity_id + " " + name + " " + sport;
    }

    @Override
    public void setMeFromResult(ResultSet resultSet) throws SQLException {
        activity_id = resultSet.getInt(1);
        name = resultSet.getString(2);
        sport = resultSet.getBoolean(3);
    }
}
