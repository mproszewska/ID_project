package app.Controller;

import app.Main;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 03.06.18.
 */
public class UserInfoViewController implements Initializable {
    @FXML
    private TextField textFieldName;

    @FXML
    private TextField textFieldSurname;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {
        Main.changeName(textFieldName.getText());
        Main.changeSurname(textFieldSurname.getText());
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
    }
}
