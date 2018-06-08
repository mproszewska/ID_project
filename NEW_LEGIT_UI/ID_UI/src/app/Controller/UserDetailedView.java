package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 03.06.18.
 */
public class UserDetailedView implements Initializable {
    @FXML
    private TextFlow textFlow;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        if(!Main.getUserName().equals("") && !Main.getUserSurname().equals("")) {
            QueriesMachine qMachine = new QueriesMachine();
            List<User> users = qMachine.getUser(Main.getUserName(), Main.getUserSurname());
            String sb = "";
            for (User i : users) {
                sb = sb + i.toString() + "\n";
            }

            Text text;

            if(users.size() == 0)
                text = new Text("ERROR!!! NO SUCH USER IN DATABASE. TRY AGAIN.");
            else
                text = new Text(sb);

            textFlow.getChildren().add(text);
        } else {
            Text text = new Text("ERROR!!! INVALID DATA FOR USER. TRY AGAIN.");
            textFlow.getChildren().add(text);
        }
    }
}

