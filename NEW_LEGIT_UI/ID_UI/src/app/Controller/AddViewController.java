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
import javafx.scene.control.Alert;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.*;

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
    private Text text;

    @FXML
    private Text textinfo;

    private String choice;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent, loader, "Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException, SQLException, ClassNotFoundException {
        QueriesMachine qMachine = new QueriesMachine();
        StringFormatMachine fMachine = new StringFormatMachine();
        TextField[] fields = {textF11, textF12, textF13, textF21, textF22, textF23};
        boolean success = false;

        if (choice == null) {
            Alerts.alertCustom("Input Error","Results:","Choose what you want to add.");
        } else if (choice.equals("user") && FXMLMachine.checkContent(fields, 4)) {
            success = true;
            String query = "INSERT INTO users(name, surname, sex, birthday) VALUES ('" +
                    fMachine.format(textF11.getText()) + "','" +
                    fMachine.format(textF12.getText()) + "','" +
                    textF13.getText().toLowerCase() + "','" +
                    textF21.getText() + "');";

            try {
                qMachine.query(query);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
            ///adding height / weight
        } else if (choice.equals("activity") && FXMLMachine.checkContent(fields, 2)) {
            success = true;
            String query = "INSERT INTO activities(name, sport) VALUES ('" +
                    textF11.getText().toLowerCase() + "','" +
                    textF12.getText() + "');";
            try {
                qMachine.query(query);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        } else if (choice.equals("section") && FXMLMachine.checkContent(fields, 4)) {
            List<SelectContainer> container = null;
            String query = "SELECT activity_id FROM activities WHERE name LIKE '" + textF11.getText().toLowerCase() + "';";
            System.out.println(query);

            try {
                container = qMachine.select(query, SelectContainer.class);
            } catch (Throwable e) {
                Alerts.alert();
            }

            success = true;
            String query2 = "";
            try {
                query2 = "INSERT INTO sections(activity_id, trainer_id, name, city, min_members, max_members) VALUES (" +
                        container.get(0).getAt(0) + "," +
                        textF12.getText() + ",'" +
                        fMachine.format(textF13.getText()) + "','" +
                        fMachine.format(textF21.getText()) + "'," +
                        textF22.getText() + "," +
                        textF23.getText() + ");";
            }catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Input error." ,"Result:", e.getMessage());
            }

            try {
                qMachine.query(query2);
            } catch (Throwable e) {
                success = false;
                if (container.size() == 0)
                    Alerts.alertCustom("Insertion Error", "Results: ", "Wrong activity name.");
                else
                    Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        }

        if(success) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
            Main.changeScene(actionEvent, loader, "Main");
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("user", "activity", "section");
        List<TextField> fields = new ArrayList<>();
        TextField[] tmp = {textF11, textF12, textF13, textF21, textF22, textF23};
        fields.addAll(Arrays.asList(tmp));

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                textinfo.setText("Information needed to add record:");
                FXMLMachine setInfo = new FXMLMachine();

                if (choice.equals("user")) {
                    text.setText("(name, surname, sex, birthday, height (optional), weight (optional))");
                    String[] id = {"name", "surname", "sex", "yyyy-mm-dd", "height", "weight"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if (choice.equals("activity")) {
                    text.setText("(name, sport)");
                    String[] id = {"name", "sport"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if (choice.equals("section")) {
                    text.setText("(sport, trainer, name, city, min members, max members)");
                    String[] id = {"sport", "trainer", "name", "city", "min members", "max members"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                }
            }
        });
    }
}
