package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 03.06.18.
 */
public class UserInfoViewController {
    @FXML
    private TextField textFieldName;

    @FXML
    private TextField textFieldSurname;

    boolean isAccesible = false;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {
        Main.changeName(textFieldName.getText());
        Main.changeSurname(textFieldSurname.getText());
        initialize();
        if(isAccesible) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
            Main.changeScene(actionEvent, loader, "UserDetailedViewController");
        } else {
            alert("ERROR!!! NO SUCH USER IN DATABASE.");
        }
    }

    public void initialize() {
        if(!Main.getUserName().equals("") && !Main.getUserSurname().equals("")) {
            QueriesMachine qMachine = new QueriesMachine();
            List<User> users = qMachine.getUser(Main.getUserName(), Main.getUserSurname());
            if(users.size() != 0)
                isAccesible = true;
        }
    }

    private void alert(String text) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Connection Error");
        alert.setHeaderText("Results:");
        alert.setContentText(text);
        alert.showAndWait();
    }
}
