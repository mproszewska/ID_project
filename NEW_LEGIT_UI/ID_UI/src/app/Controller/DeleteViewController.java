package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.StringFormatMachine;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.Alert;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 04.06.18.
 */
public class DeleteViewController implements Initializable{
    @FXML
    private ChoiceBox choiceBox;

    @FXML
    private TextField textF11;

    @FXML
    private TextField textF12;

    @FXML
    private TextField textF13;

    @FXML
    private TextField textF21;

    @FXML
    private TextField textF22;

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
    private void handleApply(ActionEvent actionEvent) throws IOException, SQLException, ClassNotFoundException {
        QueriesMachine qMachine = new QueriesMachine();
        StringFormatMachine fMachine = new StringFormatMachine();

        if(choice.equals("session")) {
            if(true) {
                qMachine.query(
                        ""
                );
            }
        } else if(choice.equals("user")) {
            if(true) {
                qMachine.query(
                        ""
                );
            }
        } else if(choice.equals("activity")) {
            if(true) {
                qMachine.query(
                        ""
                );
            }
        } else if(choice.equals("section")) {
            if(true) {
                qMachine.query(
                        ""
                );
            }
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
        choiceBox.getItems().addAll("user", "session", "activity", "section");

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                textinfo.setText("Information needed to delete record:");

                if(choice.equals("session")) {
                    text.setText("(name, surname, activity, start time, end time)");
                    textF11.setPromptText("name");
                    textF12.setPromptText("surname");
                    textF13.setPromptText("activity");
                    textF21.setPromptText("start time");
                    textF22.setPromptText("end time");
                    textF12.setDisable(false);
                    textF13.setDisable(false);
                    textF21.setDisable(false);
                    textF22.setDisable(false);
                } else if(choice.equals("user")) {
                    text.setText("(name, surname, sex, birthday)");
                    textF11.setPromptText("name");
                    textF12.setPromptText("surname");
                    textF13.setPromptText("sex");
                    textF21.setPromptText("");
                    textF22.setPromptText("");
                    textF12.setDisable(false);
                    textF13.setDisable(false);
                    textF21.setDisable(true);
                    textF22.setDisable(true);
                } else if(choice.equals("activity")) {
                    text.setText("(name)");
                    textF11.setPromptText("name");
                    textF12.setPromptText("");
                    textF13.setPromptText("");
                    textF21.setPromptText("");
                    textF22.setPromptText("");
                    textF12.setDisable(true);
                    textF13.setDisable(true);
                    textF21.setDisable(true);
                    textF22.setDisable(true);
                } else if(choice.equals("section")) {
                    text.setText("(sport, trainer, name, city)");
                    textF11.setPromptText("city");
                    textF12.setPromptText("trainer");
                    textF13.setPromptText("name");
                    textF21.setPromptText("city");
                    textF22.setPromptText("");
                    textF12.setDisable(false);
                    textF13.setDisable(false);
                    textF21.setDisable(false);
                    textF22.setDisable(true);
                }
            }
        });
    }
}
