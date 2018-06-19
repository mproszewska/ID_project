package app.Model;

import javafx.scene.control.Alert;

/**
 * Created by piotrhelm on 16.06.18.
 */
public class Alerts {
    static public void alert() {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Input Error");
        alert.setHeaderText("Results:");
        alert.setContentText("Invalid data. Try again.");
        alert.showAndWait();
    }

    static public void alertCustom(String title, String header, String content) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(header);
        alert.setContentText(content);
        alert.showAndWait();
    }
}
