package Model;

import DB.QueriesMachine;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class SelectContainer implements QueriesMachine.Selectable, Iterable<Object>{
    private List<Object> objects = new ArrayList<>();

    @Override
    public void setMeFromResult(ResultSet resultSet) throws SQLException {
        for (int i = 1; i <= resultSet.getMetaData().getColumnCount(); i++)
            objects.add(resultSet.getObject(i));
    }

    @Override
    public String toString() {
        StringBuilder str = new StringBuilder();
        for (Object obj : objects)
            str.append(obj).append(", ");
        str.setLength(str.length()-2);
        return str.toString();
    }

    @Override
    public Iterator<Object> iterator() {
        return objects.iterator();
    }

    public int getSize(){
        return objects.size();
    }
}
