package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 03.06.18.
 */
public class UserDetailedViewController {
    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent, loader, "Main");
    }

    public void showInfo(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserInfoSimpleView.fxml"));
        Main.changeScene(actionEvent, loader, "UserInfoSimpleView");
    }

    public void showFunctions(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserFunctionsView.fxml"));
        Main.changeScene(actionEvent, loader, "UserFunctionsView");
    }
}

