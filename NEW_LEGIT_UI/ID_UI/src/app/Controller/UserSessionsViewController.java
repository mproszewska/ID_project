package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import app.Model.User;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ListView;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 09.06.18.
 */
public class UserSessionsViewController implements Initializable{
    @FXML
    private ListView listView;

    @FXML
    private ChoiceBox choiceBox;

    private String choice = "";

    private SelectContainer selectContainer;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    public void handleApply(ActionEvent actionEvent) throws IOException {
        if(selectContainer != null && !choice.equals("")) {
            Main.setContainer(selectContainer);
            if(choice.equals("kcal"))
                Main.changeFunc("kcal_during_session");
            else if(choice.equals("session type"))
                Main.changeFunc("heartrate_session_type");

            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserSessionsOutView.fxml"));
            Main.changeScene(actionEvent,loader,"UserSessionsOutView");
        }
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        List<SelectContainer> sessions = null;
        try {
            sessions = qMachine.select("SELECT user_session.session_id, start_time, end_time, distance, name " +
                    "FROM user_session " +
                    "LEFT JOIN sessions ON user_session.session_id = sessions.session_id " +
                    "LEFT JOIN activities ON sessions.activity_id = activities.activity_id;",
                    SelectContainer.class);
        } catch (Throwable e) {

        }

        for(SelectContainer s : sessions){
            listView.getItems().add(s);
        }

        listView.getSelectionModel().selectedItemProperty().addListener(new ChangeListener<SelectContainer>() {
            @Override
            public void changed(ObservableValue<? extends SelectContainer> observable,
                                SelectContainer oldValue, SelectContainer newValue) {
                selectContainer = newValue;
            }
        });

        choiceBox.getItems().addAll("kcal", "session type");

        choiceBox.getSelectionModel().selectedIndexProperty().addListener(new ChangeListener<Number>() {
            @Override
            public void changed(ObservableValue<? extends Number> observableValue, Number number, Number number2) {
                choice = choiceBox.getItems().get((Integer) number2).toString();
            }
        });

    }
}
