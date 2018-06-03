package app;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        Parent root = FXMLLoader.load(getClass().getResource("View/Main.fxml"));
        Scene scene = new Scene(root);
        primaryStage.setTitle("Data Base Interface");
        primaryStage.setScene(scene);
        primaryStage.setResizable(false);
        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }

    public static void changeScene(ActionEvent actionEvent, FXMLLoader loader, String fxmlfile) throws IOException {
        Parent currentScene = loader.load();
        Scene newScene = new Scene(currentScene);
        Stage tmpStage = (Stage) ((Node) actionEvent.getSource()).getScene().getWindow();
        currentScene.setId(fxmlfile);
        tmpStage.setScene(newScene);
        tmpStage.show();
    }
}
