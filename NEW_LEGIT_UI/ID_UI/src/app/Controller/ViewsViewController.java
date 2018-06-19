package app.Controller;

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
 * Created by piotrhelm on 04.06.18.
 */
public class ViewsViewController implements Initializable {
    @FXML
    private ChoiceBox choiceBox;

    String choice;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent, loader, "Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException {
        if (!choice.equals("")) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/ViewOut.fxml"));
            Main.changeScene(actionEvent, loader, "ViewOut");
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        choiceBox.getItems().addAll("best medication set", "months weight differences", "best sleep time", "section info", "section ranking");

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();

                if (choice.equals("best medication set")) {
                    Main.changeFunc("best_medication_sets");
                } else if (choice.equals("months weight differences")) {
                    Main.changeFunc("months_weight_differences");
                } else if (choice.equals("best sleep time")) {
                    Main.changeFunc("best_sleep_time");
                } else if (choice.equals("section info")) {
                    Main.changeFunc("sections_info");
                } else if (choice.equals("section ranking")) {
                    Main.changeFunc("section_ranking");
                }
            }
        });
    }
}
