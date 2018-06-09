package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 08.06.18.
 */
public class UserInfoSimpleViewController implements Initializable {
    @FXML
    private Text textName;

    @FXML
    private Text textSurname;

    @FXML
    private Text textSex;

    @FXML
    private Text textBirthday;

    @FXML
    private Text textHeight;

    @FXML
    private Text textWeight;


    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {

    }
}
