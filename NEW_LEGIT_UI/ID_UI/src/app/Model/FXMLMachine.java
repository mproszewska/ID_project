package app.Model;

import javafx.scene.control.TextField;

import java.util.List;

/**
 * Created by piotrhelm on 16.06.18.
 */
public class FXMLMachine {
    public void updateFields(List<TextField> fields, List<String> id) {
        int i = 0;
        for (String str : id) {
            fields.get(i).setPromptText(str);
            fields.get(i).setDisable(false);
            i++;
        }

        if (i < fields.size()) {
            while (i < fields.size()) {
                fields.get(i).setPromptText("");
                fields.get(i).setDisable(true);
                i++;
            }
        }
    }

    static public boolean checkContent(TextField[] fields, int size) {
        int it = 0;
        while (it < size) {
            if (fields[it].getText().equals("")) {
                Alerts.alertCustom("Input Error","Results:","Not enough data.");
                return false;
            }
            it++;
        }
        return true;
    }
}
