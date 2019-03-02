import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.plaf.ColorUIResource;
import javax.swing.plaf.MenuBarUI;
import javax.swing.plaf.basic.BasicScrollBarUI;
import javax.swing.plaf.nimbus.NimbusLookAndFeel;
import javax.swing.text.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Editor extends JFrame{

    public final JFileChooser fileChooser = new JFileChooser();

    private CommandManager commandManager;
    private List<TextFile> textFileList;
    private JMenuBar menuBar;
    private JTabbedPane tabbedPane;
    private StyledDocument styledDocument;
    private DocumentListener documentListener;
    private TextFile focusedFile;

    public Editor() {
        super("jLTE");
        setLayout(new BorderLayout());
        getContentPane().setBackground(Color.GRAY);

        fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
        commandManager = new CommandManager(this);
        textFileList = new ArrayList<>();

        setupUI();

        createMenu();
        createTabs();
        createStyledDocument();
        createDocumentListener();

        // On window closing listener
        // making sure we save files before closing
        this.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                List<TextFile> filesToSave = new ArrayList<>();
                for (TextFile file : textFileList) { //Store the files to save before closing.
                    if (file.shouldSave)            //It's important to store them separately, as "closeFile()" also removes the file from textFileList
                        filesToSave.add(file);      //We shouldn't be iterating textFileList while its decreasing in size
                }
                for (TextFile file : filesToSave) {
                    focusedFile = file;
                    tabbedPane.setSelectedIndex(findTabIndexByFile(focusedFile));
                    closeFile();
                }
                System.exit(0);
            }
        });
    }

    private void setupUI() {
        //LookAndFeel uiLookAndFeel = new NimbusLookAndFeel();
        //UIDefaults uiStyle = uiLookAndFeel.getDefaults();

        UIManager.put("MenuBar.background", Color.DARK_GRAY);
        UIManager.put("MenuBar.border", null);
        UIManager.put("Menu.background", Color.DARK_GRAY);
        UIManager.put("Menu.foreground", Color.WHITE);
        UIManager.put("Menu.border", null);
        UIManager.put("Menu.borderPainted", false);
        UIManager.put("Menu.selectionBackground", Color.BLACK);
        UIManager.put("Menu.selectionForeground", Color.WHITE);
        UIManager.put("MenuItem.background", Color.DARK_GRAY);
        UIManager.put("MenuItem.foreground", Color.WHITE);
        UIManager.put("MenuItem.selectionBackground", Color.BLACK);
        UIManager.put("MenuItem.selectionForeground", Color.WHITE);
        UIManager.put("MenuItem.borderPainted", false);

        UIManager.put("TabbedPane.tabLayoutPolicy", 1);
        UIManager.put("TabbedPane.border", null);
        UIManager.put("TabbedPane.borderPainted", false);
        //UIManager.put("TabbedPane.focus", Color.GRAY);
        UIManager.put("TabbedPane.contentAreaColor", Color.PINK);
        UIManager.put("TabbedPane.contentBorderInsets", new Insets(1, 0,0, 0));
        UIManager.put("TabbedPane.unselectedBackground", Color.BLACK);
        UIManager.put("TabbedPane.unselectedTabForeground", Color.LIGHT_GRAY);
        UIManager.put("TabbedPane.selected", Color.DARK_GRAY);
        UIManager.put("TabbedPane.selectedForeground", Color.WHITE);
        //UIManager.put("TabbedPane.unselectedTabBackground", Color.DARK_GRAY);
        //UIManager.put("TabbedPane.shadow", Color.BLACK);
        //try {

        //   UIManager.getDefaults().setDefaultLocale(uiStyle.getDefaultLocale());
        /*} catch (UnsupportedLookAndFeelException e)
        {
            System.out.println("Native look");
        }*/
    }

    private void createMenu() {
        menuBar = new JMenuBar();
        menuBar.setBorderPainted(false);
        createFileMenu();
        setJMenuBar(menuBar);
    }

    private void createFileMenu(){
        JMenu fileMenu = new JMenu("File");
        fileMenu.setMnemonic(KeyEvent.VK_1);

        JMenuItem newFileItem = new JMenuItem("New file");
        newFileItem.setAccelerator(KeyStroke.getKeyStroke('N', ActionEvent.CTRL_MASK));
        newFileItem.addActionListener(commandManager.newFileAction);
        fileMenu.add(newFileItem);
        JMenuItem openFileItem = new JMenuItem("Open file");
        openFileItem.setAccelerator(KeyStroke.getKeyStroke('O', ActionEvent.CTRL_MASK));
        openFileItem.addActionListener(commandManager.openFileAction);
        fileMenu.add(openFileItem);
        JMenuItem saveFileItem = new JMenuItem("Save file");
        saveFileItem.setAccelerator(KeyStroke.getKeyStroke('S', ActionEvent.CTRL_MASK));
        saveFileItem.addActionListener(commandManager.saveFileAction);
        fileMenu.add(saveFileItem);
        JMenuItem closeFileItem = new JMenuItem("Close file");
        closeFileItem.setAccelerator(KeyStroke.getKeyStroke('W', ActionEvent.CTRL_MASK));
        closeFileItem.addActionListener(commandManager.closeFileAction);
        fileMenu.add(closeFileItem);

        menuBar.add(fileMenu);
    }

    private void createTabs() {
        //currentTabIndex = 0;
        tabbedPane = new JTabbedPane();
        tabbedPane.setTabLayoutPolicy(1);
        add(tabbedPane, BorderLayout.CENTER);
    }

    private void createStyledDocument() {
        //Style keywordStyle;
        //keywordStyle.addAttribute();
        String[] keywords = {

        };

        styledDocument = new DefaultStyledDocument();
        Style keywordStyle = styledDocument.addStyle("keyword", null);
        StyleConstants.setForeground(keywordStyle, Color.ORANGE);
    }

    private void createDocumentListener() {
        documentListener = new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                if (focusedFile != null)
                    focusedFile.shouldSave = true;
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                if (focusedFile != null)
                    focusedFile.shouldSave = true;
            }

            @Override
            public void changedUpdate(DocumentEvent e) {

            }
        };
    }

    private JTextPane createCodingArea() {
        JTextPane codingArea = new JTextPane();
        codingArea.setStyledDocument(styledDocument);
        codingArea.getDocument().addDocumentListener(documentListener);

        codingArea.setBackground(Color.BLACK);
        codingArea.setBorder(null);
        codingArea.setForeground(Color.WHITE);
        //codingArea.setMargin(new Insets(2, 2, 2, 2));
        codingArea.setCaretColor(new Color(153,255,153));
        codingArea.setFont(new Font("Verdana", Font.PLAIN, 12));
        JScrollPane codingAreaScrollPane = new JScrollPane(codingArea, JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        codingAreaScrollPane.setBorder(null);
        codingAreaScrollPane.setBackground(Color.BLACK);
        changeScrollBarUI(codingAreaScrollPane.getVerticalScrollBar()).setPreferredSize(new Dimension(10, 0));
        changeScrollBarUI(codingAreaScrollPane.getHorizontalScrollBar()).setPreferredSize(new Dimension(0, 10));
        //getContentPane().add(codingAreaScrollPane, BorderLayout.CENTER);

        return codingArea;
    }

    private JScrollBar changeScrollBarUI(JScrollBar scrollBar) {
        scrollBar.setBorder(null);
        scrollBar.setBackground(Color.BLACK);
        scrollBar.setUI(new BasicScrollBarUI() {
            @Override
            protected JButton createDecreaseButton(int orientation) {
                JButton scrollButton = new JButton();
                scrollButton.setPreferredSize(new Dimension(0, 0));
                return scrollButton;
            }

            @Override
            protected JButton createIncreaseButton(int orientation) {
                JButton scrollButton = new JButton();
                scrollButton.setPreferredSize(new Dimension(0, 0));
                return scrollButton;
            }

            @Override
            protected void configureScrollBarColors() {
                thumbColor = new Color(0,50,0);
            }
        });

        return scrollBar;
    }

    public TextFile findFileByPath(String path) {
        if (path == "") //Unsaved/unopened or new files also have "" path, so it could return any unrelated file.
            return null;
        for (TextFile textFile : textFileList) {
            if (textFile.getPath().equals(path)) {
                return textFile;
            }
        }

        return null;
    }

    public TextFile findFileById(int id) {
        for (TextFile textFile : textFileList) {
            if (textFile.getId() == id) {
                return textFile;
            }
        }

        return null;
    }

    private int findTabIndexByFile(TextFile file) {
        final int tabCount = tabbedPane.getTabCount();
        if (tabCount < 1)
            return -1;

        String infoToLookFor = file.getPath();
        if (infoToLookFor == "")
            infoToLookFor = "#" + String.valueOf(file.getId());


        for (int tabIndex = 0; tabIndex < tabCount; tabIndex++) {
            if (infoToLookFor.equals(tabbedPane.getToolTipTextAt(tabIndex)))
                return tabIndex;
        }

        return -1;
    }

    public void newFile(TextFile file) {

        textFileList.add(file);

        tabbedPane.addTab(file.getName(), createCodingArea());
        //file.setTabIndex(tabbedPane.getTabCount()-1);
        JTextPane codingArea = (JTextPane)tabbedPane.getComponentAt(tabbedPane.getTabCount()-1);
        codingArea.setText(file.getText());

        tabbedPane.setSelectedIndex(tabbedPane.getTabCount()-1);
        if (file.getPath() == "")
            tabbedPane.setToolTipTextAt(tabbedPane.getTabCount() - 1, "#" + String.valueOf(file.getId()));
        else
            tabbedPane.setToolTipTextAt(tabbedPane.getTabCount() - 1, file.getPath());

        if (file.getName().endsWith(".lua")) {

        }
        file.shouldSave = false;
        focusedFile = file;
        //JTextPane codingArea = (JTextPane)tabbedPane.getComponentAt(currentTabIndex);
        //codingArea.setText(text);
    }

    public boolean saveFile() { //Only return false, when saving won't/can't be done and should be tried again.
        if (focusedFile == null)
            return true;

        File fileToSaveTo;
        if (focusedFile.getPath() == "") {
            int result = fileChooser.showSaveDialog(this.getParent());
            if (result != JFileChooser.APPROVE_OPTION) //Cancel saving
                return true;

            fileToSaveTo = fileChooser.getSelectedFile();
            if (!fileToSaveTo.exists()) {
                try {
                    fileToSaveTo.createNewFile();
                } catch (IOException ioException) {
                    JOptionPane.showMessageDialog(this.getParent(), ioException.getMessage(), "Error occurred while saving", JOptionPane.ERROR_MESSAGE);
                    return false;
                }
                return false;
            }
            if (!fileToSaveTo.canWrite()) {
                JOptionPane.showMessageDialog(this.getParent(), "File is not writable!", "Error occurred while saving", JOptionPane.ERROR_MESSAGE);
                return false;
            }
        } else {
            fileToSaveTo = new File(focusedFile.getPath());
            if (!fileToSaveTo.exists()) {
                JOptionPane.showMessageDialog(this.getParent(), "File does not exist anymore!\nPlease try saving again.", "Error occurred while saving", JOptionPane.ERROR_MESSAGE);
                return false;
            }

        }

        int tabIndex = findTabIndexByFile(focusedFile);
        JTextPane codingArea = (JTextPane)tabbedPane.getComponentAt(tabIndex);
        focusedFile.setText(codingArea.getText());
        focusedFile.save(fileToSaveTo);

        tabbedPane.setTitleAt(tabIndex, focusedFile.getName());
        tabbedPane.setToolTipTextAt(tabIndex, focusedFile.getPath());

        if (focusedFile.getName().endsWith(".lua")) {

        } else {

        }

        focusedFile.shouldSave = false;

        return true;
    }

    public void closeFile() {
        if (focusedFile == null)
            return;
        if (focusedFile.shouldSave) {
            int result = JOptionPane.showConfirmDialog(this.getParent(), "Do you want to save this file?", "Saving file", JOptionPane.YES_NO_OPTION);
            if (result == JOptionPane.YES_OPTION) {
                if (saveFile() == false)
                    return;
            }
        }

        int location = textFileList.indexOf(focusedFile);

        tabbedPane.removeTabAt(findTabIndexByFile(focusedFile));
        textFileList.remove(location);

        focusedFile = null;
        System.gc();
        if (location-1 >= 0) {
            focusedFile = textFileList.get(location - 1);
        }

        //Now we need to change the focusedFile to the tab that is currently indexed

    }

}
