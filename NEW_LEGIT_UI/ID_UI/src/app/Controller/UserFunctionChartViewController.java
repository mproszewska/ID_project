package app.Controller;

import app.DB.QueriesMachine;
import app.Main;
import app.Model.SelectContainer;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.chart.Axis;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;

import java.io.IOException;
import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

/**
 * Created by piotrhelm on 10.06.18.
 */
public class UserFunctionChartViewController implements Initializable{
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
        System.out.println(Main.getFunc());
        if(Main.getFunc().equals("heartrate")) {
            yAxis.setLabel("Beats per min");
            XYChart.Series dataSeries1 = new XYChart.Series();

            List<SelectContainer> container = null;
            String query = "SELECT avg_heartrate " +
                    "FROM heartrates " +
                    "WHERE user_id = 1 " +
                    "AND start_time >= '" + Main.getArgs()[0] + "'::TIMESTAMP " +
                    "AND end_time <= '" + Main.getArgs()[0] + "  24:00:00.00000'::TIMESTAMP;";
            System.out.println(query);
            try {
                container = qMachine.select(query, SelectContainer.class);
            } catch (Throwable e) {

            }
            for(int i = 0; i < container.size(); i++) {
                int foo = Integer.parseInt(container.get(i).getAt(0).toString());
                dataSeries1.getData().add(new XYChart.Data<>(i,foo));
            }

            lineChart.getData().add(dataSeries1);
            lineChart.setCreateSymbols(false);
        }
    }
}
