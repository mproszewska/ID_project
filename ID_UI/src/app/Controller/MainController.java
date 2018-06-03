package app.Controller;

import app.Main;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;

import java.awt.*;
import java.io.IOException;

public class MainController {
    @FXML
    private Button activities;
    private Button users;

    public void showActivities(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/ActivitiesView.fxml"));
        Main.changeScene(actionEvent,loader,"ActivitiesView");
    }

    public void showUsers(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserInfoView.fxml"));
        Main.changeScene(actionEvent,loader,"UserInfoView");
    }
}
