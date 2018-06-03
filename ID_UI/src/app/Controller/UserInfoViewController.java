package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.Activity;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;

import java.awt.*;
import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 03.06.18.
 */
public class UserInfoViewController implements Initializable {
    @FXML
    private TextFlow textFlow;
    private Button returnButton;
    private Button button2;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        java.util.List<User> users = qMachine.getUsers();
        String sb = "";
        for(User u : users){
            sb = sb + u.toString() + "\n";
        }
        Text text = new Text(sb);
        textFlow.getChildren().add(text);
    }
}
