package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
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
 * Created by piotrhelm on 09.06.18.
 */
public class UserFunctionsViewController implements Initializable {
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

    private String choice = "";

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {

        if(!choice.equals("")) {
            if (choice.equals("medication per day")) {
                String[] tmp = {textF11.getText().toString()};
                Main.changeArgs(tmp);
                Main.changeFunc("get_my_med");
                FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserFunctionOutView.fxml"));
                Main.changeScene(actionEvent, loader, "UserFunctionOutView");
            }

            if (choice.equals("heartrate per day")) {
                String[] tmp = {textF11.getText().toString()};
                Main.changeArgs(tmp);
                Main.changeFunc("heartrate");
                FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserFunctionChartView.fxml"));
                Main.changeScene(actionEvent, loader, "UserFunctionChartView");
            }
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("medication per day", "heartrate per day");
        List<TextField> fields = new ArrayList<>();
        TextField[] tmp = {textF11, textF12, textF13, textF21};
        fields.addAll(Arrays.asList(tmp));

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                textinfo.setText("Arguments:");

                FXMLMachine setInfo = new FXMLMachine();
                textinfo.setText("Information needed: ");
                if(choice.equals("medication per day")) {
                    text.setText("(date)");
                    String[] id = {"date"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                } else if(choice.equals("heartrate per day")) {
                    text.setText("(date)");
                    String[] id = {"date"};
                    setInfo.updateFields(fields, Arrays.asList(id));
                }
            }
        });
    }
}
