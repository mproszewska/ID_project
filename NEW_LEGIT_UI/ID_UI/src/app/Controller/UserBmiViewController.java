package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.text.Text;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 18.06.18.
 */
public class UserBmiViewController implements Initializable{
    @FXML
    Text tx1;

    @FXML
    Text tx2;

    @FXML
    Text tx3;

    @FXML
    Text tx4;

    @FXML
    private NumberAxis xAxis ;

    @FXML
    private NumberAxis yAxis ;

    @FXML
    private LineChart<Number, Number> lineChart ;

    public void setReturnButton(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("../View/UserDetailedView.fxml"));
        Main.changeScene(actionEvent,loader,"UserDetailedView");
    }

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        QueriesMachine qMachine = new QueriesMachine();

            yAxis.setLabel("");
            XYChart.Series dataSeries1 = new XYChart.Series();

            List<SelectContainer> container = null;
            String query = "SELECT weight " +
                    "FROM height_weight " +
                    "WHERE user_id = " + Main.getUser().getUserId() + " " +
                    "ORDER BY date;";
            System.out.println(query);
            try {
                container = qMachine.select(query, SelectContainer.class);
            } catch (Throwable e) {

            }
            if(!container.isEmpty()) {
                for (int i = 0; i < container.size(); i++) {
                    int foo = Integer.parseInt(container.get(i).getAt(0).toString());
                    dataSeries1.getData().add(new XYChart.Data<>(i, foo));
                }
            }

            lineChart.getData().add(dataSeries1);
            lineChart.setCreateSymbols(false);


            tx1.setText("BMI value:");
            tx2.setText("Description:");

        List<SelectContainer> container2 = null;
        String query2 = "SELECT * FROM bmi(" + Main.getUser().getUserId() + ",current_date);";
        System.out.println(query2);
        try {
            container2 = qMachine.select(query2, SelectContainer.class);
        } catch (Throwable e) {}

        if(!container2.isEmpty())
            tx3.setText(container2.get(0).getAt(0).toString());

        List<SelectContainer> container3 = null;
        String query3= "";
        if(!container2.isEmpty())
            query3 = "SELECT * FROM bmi_description(" + container2.get(0).getAt(0).toString()+ ");";
        System.out.println(query3);
        try {
            if(!container2.isEmpty())
                container3 = qMachine.select(query3, SelectContainer.class);
        } catch (Throwable e) {}

        if(!container3.isEmpty())
            tx4.setText(container3.get(0).getAt(0).toString());
    }
}
