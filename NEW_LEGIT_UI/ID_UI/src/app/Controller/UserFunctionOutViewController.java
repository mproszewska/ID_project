package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.ListView;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 09.06.18.
 */
public class UserFunctionOutViewController implements Initializable {
    @FXML
    private ListView listView;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        java.util.List<SelectContainer> container = qMachine.select
                ("SELECT * FROM users " +
                                "WHERE name LIKE '" + Main.getUserName() + "' and surname like '" + Main.getUserSurname() + "'"
                        , SelectContainer.class);
        if(Main.getFunc().equals("get_my_med")) {
            java.util.List<SelectContainer> container2 = qMachine.select
                    ("SELECT * FROM " + Main.getFunc() + "(" + container.get(0).getAt(0).toString() + ",'" + Main.getArgs()[0] + "');"
                            , SelectContainer.class);
            for (SelectContainer tmp : container2) {
                listView.getItems().add(tmp.toString());
            }
        }
    }
}
