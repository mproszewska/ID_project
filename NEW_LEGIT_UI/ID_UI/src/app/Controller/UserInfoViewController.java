package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.StringFormatMachine;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 03.06.18.
 */
public class UserInfoViewController {
    @FXML
    private TextField textFieldName;

    @FXML
    private TextField textFieldSurname;

    boolean isAccesible = false;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent,loader,"Main");
    }

    @FXML
    private void handleApply(ActionEvent actionEvent) throws IOException, ClassNotFoundException, SQLException, InstantiationException, IllegalAccessException {
        initialize();
        if(isAccesible) {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
            Main.changeScene(actionEvent, loader, "UserDetailedView");
        } else {
            alert("ERROR!!! NO SUCH USER IN DATABASE.");
        }
    }

    public void initialize() throws ClassNotFoundException, SQLException, InstantiationException, IllegalAccessException {
        if(Main.getUser() == null) {
            QueriesMachine qMachine = new QueriesMachine();
            StringFormatMachine fMachine = new StringFormatMachine();
            List<User> users = qMachine.getUser(fMachine.format(textFieldName.getText()),fMachine.format(textFieldSurname.getText()));
            if(users.size() != 0) {
                isAccesible = true;
                Main.setUser(users.get(0));
            }
        }
    }

    private void alert(String text) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Connection Error");
        alert.setHeaderText("Results:");
        alert.setContentText(text);
        alert.showAndWait();
    }
}
