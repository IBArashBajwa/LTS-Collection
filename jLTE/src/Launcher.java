import javax.swing.*;

public class Launcher {
    static final int DEFAULT_WINDOW_WIDTH  = 200;
    static final int DEFAULT_WINDOW_HEIGHT = 200;


    public static void main(String[] args){
        Editor editor = new Editor();

        editor.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        editor.setSize(DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_HEIGHT);
        editor.setVisible(true);
    }
}
