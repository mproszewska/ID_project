package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextArea;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 09.06.18.
 */
public class UserFunctionsViewController implements Initializable {
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
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {
        String line = textArea.getText();
        String [] in = line.split(",");
        String [] legit = new String[in.length];
        int it = 0;
        for(String x : in) {
            legit[it] = x.replaceAll("\\s+","");
            it++;
        }

        Main.changeArgs(legit);
        if(choice.equals("get my med"))
            Main.changeFunc("get_my_med");

        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserFunctionOutView.fxml"));
        Main.changeScene(actionEvent,loader,"UserFunctionOutView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("get my med");

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                textinfo.setText("Arguments:");

                if(choice.equals("get my med")) {
                    text.setText("(date)");
                }
            }
        });
    }
}
