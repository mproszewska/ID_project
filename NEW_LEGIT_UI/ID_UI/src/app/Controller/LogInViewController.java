package app.Controller;

import app.Model.Activity;
import app.Main;
import app.DB.QueriesMachine;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 01.06.18.
 */
public class LogInViewController implements Initializable {
    @FXML
    private TextField textFieldDatabase;

    @FXML
    private TextField textFieldPassword;

    @FXML
    private TextField textFieldURL;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {
        Main.changeDatabase("piotrhelm"); //(textFieldDatabase.getText());
        Main.changePassword(textFieldPassword.getText());
        Main.changeURL("jdbc:postgresql://localhost:5432/piotrhelm"); ////(textFieldURL.getText());
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
    }
}
