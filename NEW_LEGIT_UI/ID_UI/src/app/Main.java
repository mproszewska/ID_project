package app;

import app.Model.SelectContainer;
import app.Model.User;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.File;
import java.io.IOException;

public class Main extends Application {
    static String database = "";
    static String password = "";
    static String URL = "";

    static String [] args;
    static String func;

    static User user;
    static SelectContainer selectContainer;

    @Override
    public void start(Stage primaryStage) throws Exception{
        Parent root = FXMLLoader.load(getClass().getResource("View/Main.fxml"));
        Scene scene = new Scene(root);
        primaryStage.setTitle("Data Base Interface");
        primaryStage.setScene(scene);
        primaryStage.setResizable(false);
        primaryStage.show();
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

    public static void changeArgs(String []in) {
        args = in;
    }

    public static String [] getArgs() {
        return args;
    }

    public static void changeFunc(String in) {
        func = in;
    }

    public static String getFunc() {
        return func;
    }

    public static void setUser(User u) {
        user = u;
    }

    public static User getUser() {
        return user;
    }

    public static void setContainer(SelectContainer sb) {
        selectContainer = sb;
    }

    public static SelectContainer getContainer() {
        return selectContainer;
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
        /*if(fxmlfile.equals("UserFunctionChartView")) {
            File f = new File("Chart.css");
            newScene.getStylesheets().clear();
            newScene.getStylesheets().add("file:///" + f.getAbsolutePath().replace("\\", "/"));
        }*/
        tmpStage.setScene(newScene);
        tmpStage.show();
    }

    public static void clearFunc(){
        func = null;
        args = null;
        selectContainer = null;
    }

    public static void clearData() {
        user = null;
        clearFunc();
    }
}
