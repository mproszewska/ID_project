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

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
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
        TextField[] fields = {textF11, textF12, textF13, textF21};
        boolean success = false;

        if(choice == null) {
            success = false;
            Alerts.alertCustom("Input Error","Results:","Choose what you want to delete.");
        } else if(choice.equals("user") && FXMLMachine.checkContent(fields,4)) {
           try {
               success = true;
               String query = "DELETE FROM users " +
                       "WHERE name LIKE '" + fMachine.format(textF11.getText()) +
                       "' AND surname LIKE '" + fMachine.format(textF12.getText()) +
                       "' AND sex LIKE '" + textF13.getText().toLowerCase() +
                       "' AND birthday = '" + textF21.getText() + "';";
               qMachine.query(query);
           } catch (Throwable e) {
               success = false;
               Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
           }
        } else if(choice.equals("activity") && FXMLMachine.checkContent(fields,1)) {
            try {
                success = true;
                String query = "DELETE FROM activities WHERE name LIKE '" + textF11.getText().toLowerCase() + "';";
                qMachine.query(query);
            } catch (Throwable e) {
                success = false;
                Alerts.alertCustom("Insertion Error", "Results: ", e.getMessage());
            }
        } else if(choice.equals("section") && FXMLMachine.checkContent(fields,4)) {
            try {
                success = true;

                List<SelectContainer> container = null;
                String query = "SELECT activity_id FROM activities WHERE name LIKE '" + textF11.getText().toLowerCase() + "';";
                System.out.println(query);

                try {
                    container = qMachine.select(query, SelectContainer.class);
                } catch (Throwable e) {
                    Alerts.alert();
                }

                String query2 = "DELETE FROM sections " +
                        "WHERE activity_id = '" + container.get(0).getAt(0) +
                        "' AND trainer_id = '" + fMachine.format(textF12.getText()) +
                        "' AND city LIKE '" + fMachine.format(textF13.getText()) +
                        "' AND name LIKE '" + fMachine.format(textF21.getText()) + "';";
                qMachine.query(query2);
            } catch (Throwable e) {
                success = false;
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
        TextField[] tmp = {textF11, textF12, textF13, textF21};
        fields.addAll(Arrays.asList(tmp));

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                FXMLMachine setInfo = new FXMLMachine();
                textinfo.setText("Information needed to delete record:");
                if(choice.equals("user")) {
                    text.setText("(name, surname, sex, birthday)");
                    String[] id = {"name", "surname", "sex", "yyyy-mm-dd"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if(choice.equals("activity")) {
                    text.setText("(name)");
                    String[] id = {"name"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if(choice.equals("section")) {
                    text.setText("(sport, trainer, name, city)");
                    String[] id = {"sport", "trainer", "name", "city"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                }
            }
        });
    }
}
