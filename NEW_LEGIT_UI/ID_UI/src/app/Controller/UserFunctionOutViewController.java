package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.ListView;

import java.io.IOException;
import java.net.URL;
import java.util.List;
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
        if(Main.getFunc().equals("get_my_med")) {
            List<SelectContainer> container = null;
            String query = "SELECT * FROM " + Main.getFunc() + "(" + Main.getUser().getUserId() + ",'" + Main.getArgs()[0] + "');";
            System.out.println(query);
            try {
                 container = qMachine.select(query, SelectContainer.class);
            } catch (Throwable e) {
                System.out.println(e);
                Alert alert = new Alert(Alert.AlertType.INFORMATION);
                alert.setTitle("Connection Error");
                alert.setHeaderText("Results:");
                alert.setContentText("Invalid data. Try again.");
                alert.showAndWait();
            }

            for (SelectContainer tmp : container) {
                listView.getItems().add(tmp.toString());
            }
        }
    }
}
