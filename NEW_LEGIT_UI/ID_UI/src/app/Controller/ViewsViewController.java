package app.Controller;

import app.Main;
import app.Model.Alerts;
import app.Model.FXMLMachine;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 04.06.18.
 */
public class ViewsViewController implements Initializable {
    @FXML
    private ChoiceBox choiceBox;

    String choice;

    @FXML
    private TextField textF11;

    @FXML
    private TextField textF12;

    @FXML
    private TextField textF13;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent, loader, "Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {
        TextField[] fields = {textF11, textF12, textF13};

        boolean access = false;
        if (choice == null) {
            Alerts.alertCustom("Input Error","Results:","Choose what you want to add.");
        } else if(choice.equals("section ranking") && FXMLMachine.checkContent(fields, 3)) {
            access = true;
            String[] tmp = {textF11.getText().toString(),textF12.getText().toString(), textF13.getText().toString()};
            Main.changeArgs(tmp);
        } else {
            access = true;
        }

        if(access){
            try {
                FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/ViewOut.fxml"));
                Main.changeScene(actionEvent, loader, "ViewOut");
            } catch (Throwable e) {
                Alerts.alertCustom("Input Error.","Result:", "Not enough data.");
            }
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("best medication set", "months weight differences", "best sleep time", "section info", "section ranking");

        List<TextField> fields = new ArrayList<>();
        TextField[] tmp = {textF11, textF12, textF13};
        fields.addAll(Arrays.asList(tmp));

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();
                FXMLMachine setInfo = new FXMLMachine();
                if (choice.equals("best medication set")) {
                    Main.changeFunc("best_medication_sets");
                    String[] id = {};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if (choice.equals("months weight differences")) {
                    Main.changeFunc("months_weight_differences");
                    String[] id = {};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if (choice.equals("best sleep time")) {
                    Main.changeFunc("best_sleep_time");
                    String[] id = {};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if (choice.equals("section info")) {
                    Main.changeFunc("sections_info");
                    String[] id = {};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if (choice.equals("section ranking")) {
                    Main.changeFunc("section_ranking");
                    String[] id = {"section_id","start time","end time"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                }
            }
        });
    }
}
