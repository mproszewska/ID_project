package app.Controller;

import app.Model.Activity;
import app.Main;
import app.DB.QueriesMachine;
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
 * Created by piotrhelm on 01.06.18.
 */
public class ActivitiesViewController implements Initializable {
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
        java.util.List<Activity> activities = qMachine.getActivities();
        String sb = "";
        for(Activity i : activities){
            sb = sb + i.toString() + "\n";
        }
        Text text = new Text(sb);
        textFlow.getChildren().add(text);
    }
}
