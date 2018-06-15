package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.ListView;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 10.06.18.
 */
public class UserSessionsOutViewContorller implements Initializable{
    @FXML
    private ListView listView;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        if(Main.getFunc().equals("kcal_during_session")) {
            String query = "SELECT * FROM " + Main.getFunc() + "(" + Main.getUser().getUserId() + "," + Main.getContainer().getAt(0) + ");";
            System.out.println(query);
            List<SelectContainer> container = null;

            try {
                container = qMachine.select(query, SelectContainer.class);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }

            for (SelectContainer tmp : container) {
                listView.getItems().add(tmp.toString());
            }
        }
    }
}
