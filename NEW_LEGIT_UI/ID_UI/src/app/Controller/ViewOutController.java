package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.Alerts;
import app.Model.SelectContainer;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.control.ListView;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 18.06.18.
 */
public class ViewOutController implements Initializable{
    @FXML
    private ListView listView;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/Main.fxml"));
        Main.changeScene(actionEvent, loader, "Main");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        String query = "";
        try {
            if (Main.getFunc().equals("section_ranking")) {
                query = "SELECT * FROM " + Main.getFunc() + "(" + Main.getArgs()[0] +
                        ",'" + Main.getArgs()[1] + "','" + Main.getArgs()[2] + "');";
            } else {
                query = "SELECT * FROM " + Main.getFunc() + ";";
            }
        } catch (Throwable e) {
            //Alerts.alertCustom("Input Error.","Result:",e.getMessage());
        }

        System.out.println(query);
        List<SelectContainer> container = null;

        try {
            container = qMachine.select(query, SelectContainer.class);
        } catch (Throwable e) {
            Alerts.alertCustom("DB Error", "","Error");
        }

        for (SelectContainer tmp : container) {
            listView.getItems().add(tmp.toString());
        }
    }
}
