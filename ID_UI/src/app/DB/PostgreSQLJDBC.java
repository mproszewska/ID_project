package app.DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PostgreSQLJDBC {

    private String database = "jdbc:postgresql://localhost:5432/piotrhelm";
    private String username = "piotrhelm";
    private String password = "";

    public PostgreSQLJDBC(String database, String username, String password){
        this.database = database;
        this.username = username;
        this.password = password;
    }

    public PostgreSQLJDBC(){}

    public void insert(String table, String signature, Object... objects) {
        Connection c = null;
        Statement stmt = null;
        try {
            Class.forName("org.postgresql.Driver");
            c = DriverManager.getConnection(database, username, password);
            c.setAutoCommit(false);
            System.out.println("Opened database successfully");
            stmt = c.createStatement();
            StringBuilder sqlBuilder = new StringBuilder();
            sqlBuilder.append("INSERT INTO ").append(table).append(" ").append(signature).append(" VALUES (");
            for (Object obj : objects){
                sqlBuilder.append("'").append(obj.toString()).append("',");
            }
            sqlBuilder.setLength(sqlBuilder.length()-1);
            sqlBuilder.append(");");
            stmt.execute(sqlBuilder.toString());
            stmt.close();
            c.commit();
            c.close();
        } catch (Exception e) {
            System.err.println( e.getClass().getName()+": "+ e.getMessage() );
            System.exit(0);
        }
        System.out.println("Records created successfully");
    }

    public void insert(String table, QueriesMachine.Insertable obj){
        StringBuilder str = new StringBuilder();
        str.append("(");
        for (String signs : obj.getMySignature())
            str.append(signs).append(",");
        str.setLength(str.length()-1);
        str.append(")");
        insert(table, str.toString(), obj.getMyValues());
    }

    public <T extends QueriesMachine.Selectable> List<T> select(String query, Class<T> cl){
        Connection c = null;
        Statement stmt = null;
        List<T> list = new ArrayList<>();
        try {
            Class.forName("org.postgresql.Driver");
            c = DriverManager.getConnection(database, username, password);
            c.setAutoCommit(false);
            System.out.println("Opened database successfully");
            stmt = c.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while(rs.next()){
                T obj = cl.newInstance();
                obj.setMeFromResult(rs);
                list.add(obj);
            }
            rs.close();
            stmt.close();
            c.close();
        } catch ( Exception e ) {
            System.err.println( e.getClass().getName()+": "+ e.getMessage() );
            System.exit(0);
        }
        System.out.println("Operation done successfully");
        return list;
    }

}
