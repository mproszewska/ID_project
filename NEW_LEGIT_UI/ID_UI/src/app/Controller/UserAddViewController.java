package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.Alerts;
import app.Model.FXMLMachine;
import app.Model.SelectContainer;
import app.Model.StringFormatMachine;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 18.06.18.
 */
public class UserAddViewController implements Initializable{
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
    private TextArea textArea;

    @FXML
    private Text text;

    @FXML
    private Text textinfo;

    private String choice;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException, SQLException, ClassNotFoundException {
        QueriesMachine qMachine = new QueriesMachine();
        StringFormatMachine fMachine = new StringFormatMachine();
        TextField[] fields = {textF11, textF12, textF13, textF21, textF22, textF23};
        boolean success = false;

        if (choice == null) {
            Alerts.alertCustom("Input Error","Results:","Choose what you want to add.");
        } else if (choice.equals("session") && FXMLMachine.checkContent(fields, 0)) {
            success = true;
            String query = "";
            try {
                qMachine.query(query);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        } else if (choice.equals("injure") && FXMLMachine.checkContent(fields, 0)) {
            success = true;
            String query = "";
            try {
                qMachine.query(query);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        } else if (choice.equals("medication") && FXMLMachine.checkContent(fields, 0)) {
            success = true;

            List<SelectContainer> container = null;
            String query = "SELECT medication_id FROM medications WHERE name LIKE '" + textF11.getText().toLowerCase() + "';";
            System.out.println(query);
            try {
                container = qMachine.select(query, SelectContainer.class);
            } catch (Throwable e) {
                Alerts.alert();
            }

            String query2 = "INSERT INTO user_medication(user_id, medication_id, date, portion) VALUES (" +
                    Main.getUser().getUserId() + ",'" +
                    container.get(0).getAt(0) + "','" +
                    textF12.getText() + "'," +
                    textF13.getText() + ");";
            try {
                qMachine.query(query2);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        } else if (choice.equals("sleep") && FXMLMachine.checkContent(fields, 0)) {
            success = true;
            String query = "INSERT INTO sleep(user_id, start_time, end_time) VALUES (" +
                    Main.getUser().getUserId() + ",'" +
                    textF11.getText() + "','" +
                    textF12.getText() + "');";
            try {
                qMachine.query(query);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        } else if (choice.equals("height_weight") && FXMLMachine.checkContent(fields, 0)) {
            success = true;
            String query = "INSERT INTO height_weight(user_id, height, weight, date) VALUES (" +
                    Main.getUser().getUserId() + "," +
                    textF11.getText() + ","+
                    textF12.getText() + ", current_date);";
            try {
                qMachine.query(query);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        }

        if(success) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
            Main.changeScene(actionEvent,loader,"UserDetailedView");
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("injure", "medication", "session", "sleep", "height_weight");
        List<TextField> fields = new ArrayList<>();
        TextField[] tmp = {textF11, textF12, textF13, textF21, textF22, textF23};
        fields.addAll(Arrays.asList(tmp));

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                textinfo.setText("Information needed to add record:");
                FXMLMachine setInfo = new FXMLMachine();

                if (choice.equals("session")) {
                    text.setText("(activity, start time, end time, description, trainer (optional), section (optional))");
                    String[] id = {"activity", "start time", "end time", "trainer", "section", "distance"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                    textArea.setPromptText("description");
                    textArea.setDisable(false);
                } else if (choice.equals("injure")) {
                    text.setText("(accident, start time, end time)");
                    String[] id = {"accident", "start time", "end time"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                    textArea.setPromptText("");
                    textArea.setDisable(true);
                } else if (choice.equals("medication")) {
                    text.setText("(medication, date, portion)");
                    String[] id = {"medication", "date", "portion"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                    textArea.setPromptText("");
                    textArea.setDisable(true);
                } else if (choice.equals("sleep")) {
                    text.setText("(start time, end time)");
                    String[] id = {"start time", "end time"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                    textArea.setPromptText("");
                    textArea.setDisable(true);
                } else if (choice.equals("height_weight")) {
                    text.setText("(height, weight)");
                    String[] id = {"height", "weight"};
                    setInfo.updateFields(fields, Arrays.asList(id));

                    QueriesMachine qMachine = new QueriesMachine();
                    List<SelectContainer> container = null;
                    try {
                        container = qMachine.select
                                ("SELECT * FROM users " +
                                                "LEFT JOIN height_weight ON users.user_id = height_weight.user_id " +
                                                "WHERE name LIKE '" + Main.getUser().getName() + "' and surname like '" + Main.getUser().getSurname() + "'"
                                        , SelectContainer.class);
                    } catch (Throwable e) {

                    }

                    List<SelectContainer> container2 = null;
                    try {
                        if(!container.isEmpty()) {
                            container2 = qMachine.select
                                    ("SELECT * FROM get_heigth(" + container.get(0).getAt(0).toString() + ",current_date);"
                                            , SelectContainer.class);
                        }
                    } catch (Throwable e) {

                    }

                    if(!container2.isEmpty())
                        textF11.setText(container2.get(0).getAt(0).toString());
                    textArea.setPromptText("");
                    textArea.setDisable(true);
                }
            }
        });
    }
}
