package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;


import javafx.scene.text.Text;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 10.06.18.
 */
public class UserSessionsOutViewContorller implements Initializable {
    @FXML
    Text tx1;

    @FXML
    Text tx2;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent, loader, "UserDetailedView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        String query = "SELECT * FROM " + Main.getFunc() + "(" + Main.getUser().getUserId() + "," + Main.getContainer().getAt(0) + ");";
        System.out.println(query);
        List<SelectContainer> container = null;

        try {
            container = qMachine.select(query, SelectContainer.class);
        } catch (Throwable e) {

        }

        if (Main.getFunc().equals("kcal_during_session")) {
            tx2.setText("Burned calories:");
            tx1.setText(container.get(0).getAt(0).toString());
        } else if(Main.getFunc().equals("heartrate_session_type")) {
            tx2.setText("Session type: ");
            tx1.setText(container.get(0).getAt(0).toString());
        }
    }
}
