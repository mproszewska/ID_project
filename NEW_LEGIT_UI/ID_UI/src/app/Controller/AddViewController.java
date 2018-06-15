package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
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
import javafx.scene.text.TextFlow;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 04.06.18.
 */
public class AddViewController implements Initializable {
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
    private TextField textF23;

    @FXML
    private TextField textF24;

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
    private void handleApply(ActionEvent actionEvent) throws IOException, SQLException, ClassNotFoundException {
        QueriesMachine qMachine = new QueriesMachine();
        StringFormatMachine fMachine = new StringFormatMachine();

        if(choice.equals("session")) {
            if(!textF11.getText().equals("") && !textF12.getText().equals("") && !textF13.getText().equals("")
                    && !textF21.getText().equals("") && !textF22.getText().equals("")) {
                List<SelectContainer> container = null;
                String query = "SELECT activity_id FROM activities WHERE name LIKE '" + textF13.getText() + "';";
                System.out.println(query);

                try {
                    container = qMachine.select(query, SelectContainer.class);
                } catch (Throwable e) {
                    alert();
                }

                List<SelectContainer> container2 = null;
                String query2 = "SELECT user_id FROM users WHERE name LIKE '"
                        + fMachine.format(textF11.getText()) + "' AND surname LIKE '"
                        + fMachine.format(textF12.getText()) + "';";
                System.out.println(query2);

                try {
                    container2 = qMachine.select(query2, SelectContainer.class);
                } catch (Throwable e) {
                    alert();
                }

                /*qMachine.query(
                        "INSERT INTO session()"
                );*/
            }
        } else if(choice.equals("user")) {
            if(!textF11.getText().equals("") && !textF12.getText().equals("") && !textF13.getText().equals("") && !textF21.getText().equals("")) {
                qMachine.query(
                        "INSERT INTO users(name, surname, sex, birthday) VALUES ('" +
                                fMachine.format(textF11.getText()) + "','" +
                                fMachine.format(textF12.getText()) + "','" +
                                textF13.getText().toLowerCase() + "','" +
                                textF21.getText() + "');"
                );
                ///adding height / weight
            }
        } else if(choice.equals("activity")) {
            if(!textF11.getText().equals("") && !textF12.getText().equals("")) {
                qMachine.query(
                        "INSERT INTO activities(name, sport) VALUES ('" +
                                textF11.getText().toLowerCase() + "','" +
                                textF12.getText() + "');"
                );
            }
        } else if(choice.equals("section")) {
            if(!textF11.getText().equals("") && !textF12.getText().equals("") && !textF13.getText().equals("")
                    && !textF21.getText().equals("")) {
                List<SelectContainer> container = null;
                String query = "SELECT activity_id FROM activities WHERE name LIKE '" + textF11.getText() + "';";
                System.out.println(query);

                try {
                    container = qMachine.select(query, SelectContainer.class);
                } catch (Throwable e) {
                    alert();
                }

                if(!container.isEmpty())
                    qMachine.query(
                            "INSERT INTO sections(activity_id, trainer_id, name, city, min_members, max_members) VALUES (" +
                                    container.get(0).getAt(0) + "," +
                                    textF12.getText() + ",'" +
                                    fMachine.format(textF13.getText()) + "','" +
                                    fMachine.format(textF21.getText()) + "'," +
                                    textF22.getText() + "," +
                                    textF23.getText() + ");"
                    );
            }
        } else {
           alert();
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("user", "session", "activity", "section");

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                textinfo.setText("Information needed to add record:");

                if(choice.equals("session")) {
                    text.setText("(name, surname, activity, start time, end time, description, trainer (optional), section (optional))");
                    textF11.setPromptText("name");
                    textF12.setPromptText("surname");
                    textF13.setPromptText("activity");
                    textF21.setPromptText("start time");
                    textF22.setPromptText("end time");
                    textF23.setPromptText("trainer");
                    textF24.setPromptText("section");
                    textArea.setPromptText("description");
                    textF13.setDisable(false);
                    textF21.setDisable(false);
                    textF22.setDisable(false);
                    textF23.setDisable(false);
                    textF24.setDisable(false);
                    textArea.setDisable(false);
                } else if(choice.equals("user")) {
                    text.setText("(name, surname, sex, birthday, height (optional), weight (optional))");
                    textF11.setPromptText("name");
                    textF12.setPromptText("surname");
                    textF13.setPromptText("sex");
                    textF21.setPromptText("yyyy-mm-dd");
                    textF22.setPromptText("height");
                    textF23.setPromptText("weight");
                    textF24.setPromptText("");
                    textArea.setPromptText("");
                    textF13.setDisable(false);
                    textF21.setDisable(false);
                    textF22.setDisable(false);
                    textF23.setDisable(false);
                    textF24.setDisable(true);
                    textArea.setDisable(true);
                } else if(choice.equals("activity")) {
                    text.setText("(name, sport)");
                    textF11.setPromptText("name");
                    textF12.setPromptText("0/1");
                    textF13.setPromptText("");
                    textF21.setPromptText("");
                    textF22.setPromptText("");
                    textF23.setPromptText("");
                    textF24.setPromptText("");
                    textArea.setPromptText("");
                    textF13.setDisable(true);
                    textF21.setDisable(true);
                    textF22.setDisable(true);
                    textF23.setDisable(true);
                    textF24.setDisable(true);
                    textArea.setDisable(true);
                } else if(choice.equals("section")) {
                    text.setText("(sport, trainer, name, city, min members, max members)");
                    textF11.setPromptText("sport");
                    textF12.setPromptText("trainer");
                    textF13.setPromptText("name");
                    textF21.setPromptText("city");
                    textF22.setPromptText("min members");
                    textF23.setPromptText("max members");
                    textF24.setPromptText("");
                    textArea.setPromptText("");
                    textF13.setDisable(false);
                    textF21.setDisable(false);
                    textF22.setDisable(false);
                    textF23.setDisable(false);
                    textF24.setDisable(true);
                    textArea.setDisable(true);
                }
            }
        });
    }

    public void alert() {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Input Error");
        alert.setHeaderText("Results:");
        alert.setContentText("INVALID DATA. TRY AGAIN.");
        alert.showAndWait();
    }
}
