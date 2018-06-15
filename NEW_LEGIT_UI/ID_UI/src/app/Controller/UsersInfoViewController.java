package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.ListView;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 03.06.18.
 */
public class UsersInfoViewController implements Initializable {
    @FXML
    private ListView listView;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        java.util.List<User> users = null;

        try {
            users = qMachine.getUsers();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        for(User u : users){
            listView.getItems().add(u.toString());
        }
    }
}
