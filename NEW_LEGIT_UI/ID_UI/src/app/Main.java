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

    static String userName = "";
    static String userSurname = "";

    static String database = "";
    static String password = "";
    static String URL = "";

    @Override
    public void start(Stage primaryStage) throws Exception{
        Parent root = FXMLLoader.load(getClass().getResource("View/Main.fxml"));
        Scene scene = new Scene(root);
        primaryStage.setTitle("Data Base Interface");
        primaryStage.setScene(scene);
        primaryStage.setResizable(false);
        primaryStage.show();
    }

    public static void changeName(String in) {
        userName = in;
    }

    public static String getUserName() {
        return userName;
    }

    public static void changeSurname(String in) {
        userSurname = in;
    }

    public static String getUserSurname() {
        return userSurname;
    }

    public static void clearData() {
        userName = "";
        userSurname = "";
    }

    public static void changeDatabase(String in) {
        database = in;
    }

    public static String getDatabase() {
        return database;
    }

    public static void changePassword(String in) {
        password = in;
    }

    public static String getPassword() {
        return password;
    }

    public static void changeURL(String in) {
        URL = in;
    }

    public static String getURL() {
        return URL;
    }

    public static boolean checkDBargs() {
        if(URL.isEmpty() || password.isEmpty() || database.isEmpty())
            return false;
        return true;
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
