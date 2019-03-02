import javax.swing.*;
import java.awt.event.ActionEvent;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class CommandManager {

    private Editor editor;

    public AbstractAction newFileAction;
    public AbstractAction openFileAction;
    public AbstractAction saveFileAction;
    public AbstractAction closeFileAction;

    public CommandManager(Editor newEditor)
    {
        editor = newEditor;
        createFileMenuActions();
    }

    private void createFileMenuActions() {
        newFileAction = new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                TextFile newFile = new TextFile("Untitled");
                editor.newFile(newFile);
            }
        };
        openFileAction = new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                TextFile newFile;
                int result = editor.fileChooser.showOpenDialog(editor.getParent());
                if (result != JFileChooser.APPROVE_OPTION)
                    return;

                File ioFile = editor.fileChooser.getSelectedFile();
                if (!ioFile.canRead()) {
                    JOptionPane.showMessageDialog(null, "Cannot read file!", "Error occurred!", JOptionPane.ERROR_MESSAGE);
                    return;
                }
                if (editor.findFileByPath(ioFile.getPath()) != null) {
                    JOptionPane.showMessageDialog(null, "File already opened!", "Error occurred!", JOptionPane.ERROR_MESSAGE);
                    return;
                }
                newFile = new TextFile(ioFile);
                editor.newFile(newFile);
            }
        };
        saveFileAction = new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                editor.saveFile();
            }
        };
        closeFileAction = new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                editor.closeFile();
            }
        };
    }
}
