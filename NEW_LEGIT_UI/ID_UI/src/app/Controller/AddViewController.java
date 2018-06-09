package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextArea;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 04.06.18.
 */
public class AddViewController implements Initializable {
    @FXML
    private ChoiceBox choiceBox;

    @FXML
    private TextArea textArea;

    @FXML
    private Text text;

    @FXML
    private Text textinfo;

    private String choice;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {
        String line = textArea.getText();
        String [] in = line.split(",");
        String [] legit = new String[in.length];
        int it = 0;
        for(String x : in) {
            if(x.endsWith(")")) {
                legit[it] = x.substring(0, x.length() - 1);
            }
            legit[it] = x.replaceAll("\\s+","");
            it++;
        }

        QueriesMachine qMachine = new QueriesMachine();

        if(choice.equals("session") && in.length == 8) {
        } else if(choice.equals("user") && in.length == 6) {
            qMachine.query(
                    "INSERT INTO users(name, surname, sex, birthday) VALUES ('" +
                            legit[0] + "','" + legit[1] + "','" + legit[2] + "','" + legit[3] + "');"
            );
        } else if(choice.equals("medication") && in.length == 5) {

        } else if(choice.equals("accident") && in.length == 4) {

        } else if(choice.equals("section") && in.length == 4) {

        } else {
            Alert alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setTitle("Input Error");
            alert.setHeaderText("Results:");
            alert.setContentText("INVALID DATA. TRY AGAIN.");
            alert.showAndWait();
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("user", "medication", "session", "accident", "section");

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                textinfo.setText("Information needed to add record:");

                if(choice.equals("session")) {
                    text.setText("(name, surname, activity, start time, end time, description, trainer (optional), section (optional))");
                } else if(choice.equals("user")) {
                    text.setText("(name, surname, sex, birthday, height (optional), weight (optional))");
                } else if(choice.equals("medication")) {
                    text.setText("(name, surname, medication, date, portion)");
                } else if(choice.equals("accident")) {
                    text.setText("(name, surname, injure, date)");
                } else if(choice.equals("section")) {
                    text.setText("(sport, trainer, name, city)");
                }
            }
        });
    }
}
