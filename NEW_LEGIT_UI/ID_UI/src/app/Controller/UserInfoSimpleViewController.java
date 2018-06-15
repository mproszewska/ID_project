package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import app.Model.User;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 08.06.18.
 */
public class UserInfoSimpleViewController implements Initializable {
    @FXML
    private Text textName;

    @FXML
    private Text textSurname;

    @FXML
    private Text textSex;

    @FXML
    private Text textBirthday;

    @FXML
    private Text textHeight;

    @FXML
    private Text textWeight;


    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();
        List<SelectContainer> container = null;
        try {
            container = qMachine.select
                    ("SELECT * FROM users " +
                                    "LEFT JOIN height_weight ON users.user_id = height_weight.user_id " +
                                    "WHERE name LIKE '" + Main.getUser().getName() + "' and surname like '" + Main.getUser().getSurname() + "'"
                            , SelectContainer.class);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        List<SelectContainer> container2 = null;
        try {
            container2 = qMachine.select
                    ("SELECT * FROM get_heigth(" + container.get(0).getAt(0).toString() + ",current_date);"
                            , SelectContainer.class);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        List<SelectContainer> container3 = null;
        try {
            container3 = qMachine.select
                    ("SELECT * FROM get_weight(" + container.get(0).getAt(0).toString() + ",current_date);"
                            , SelectContainer.class);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        textName.setText(container.get(0).getAt(1).toString());
        textSurname.setText(container.get(0).getAt(2).toString());
        textSex.setText(Objects.equals(container.get(0).getAt(3), "m") ?"Male" : "Female");
        textBirthday.setText(container.get(0).getAt(4).toString());
        if(container2.get(0).getAt(0) != null)
            textHeight.setText(container2.get(0).getAt(0).toString());
        if(container3.get(0).getAt(0) != null)
            textWeight.setText(container3.get(0).getAt(0).toString());
    }
}
