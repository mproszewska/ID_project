package app.Model;

/**
 * Created by piotrhelm on 15.06.18.
 */
public class StringFormatMachine {
    public String format(String s){
        if(!s.isEmpty())
            return s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase();
        return "";
    }
}
