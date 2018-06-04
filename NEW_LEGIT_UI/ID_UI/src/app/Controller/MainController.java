package app.Controller;

import app.Main;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

public class MainController implements Initializable {
    public boolean access = false;

    public void showLogIn(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/LogInView.fxml"));
        Main.changeScene(actionEvent, loader, "LogInView");
    }

    public void showUsers(ActionEvent actionEvent) throws IOException {
        if(access) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UsersInfoView.fxml"));
            Main.changeScene(actionEvent, loader, "UsersInfoView");
        } else {
            alert();
        }
    }

    public void showUserInfo(ActionEvent actionEvent) throws IOException {
        if(access) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserInfoView.fxml"));
            Main.changeScene(actionEvent, loader, "UserInfoView");
        } else {
            alert();
        }
    }

    public void showAdd(ActionEvent actionEvent) throws IOException {
        if(access) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/AddView.fxml"));
            Main.changeScene(actionEvent, loader, "AddView");
        } else {
            alert();
        }
    }

    public void showFunctions(ActionEvent actionEvent) throws IOException {
        if(access) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/FunctionsView.fxml"));
            Main.changeScene(actionEvent, loader, "FunctionsView");
        } else {
            alert();
        }
    }

    public void showDelete(ActionEvent actionEvent) throws IOException {
        if(access) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/DeleteView.fxml"));
            Main.changeScene(actionEvent, loader, "DeleteView");
        } else {
            alert();
        }
    }

    private void alert() {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Connection Error");
        alert.setHeaderText("Results:");
        alert.setContentText("No access to database. Please log in.");
        alert.showAndWait();
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        Main.clearData();
        if(Main.checkDBargs())
           access = true;
    }
}
