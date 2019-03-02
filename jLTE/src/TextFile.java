import javax.swing.*;
import java.io.*;
import java.nio.file.Files;
import java.util.Scanner;

public class TextFile {
    private static int NUMBER_OF_TEXTFILES = 0;

    private String name;
    private String path;
    private String text;
    private int id;
    public boolean shouldSave;


    TextFile(String name) {
        shouldSave = true;

        NUMBER_OF_TEXTFILES++;
        this.name = name;
        this.path = "";
        this.text = "";
        this.id = NUMBER_OF_TEXTFILES;
    }

    TextFile(File ioFile)
    {
        shouldSave = false;

        NUMBER_OF_TEXTFILES++;
        this.name = ioFile.getName();
        this.path = ioFile.getPath();
        this.text = "";
        this.id = NUMBER_OF_TEXTFILES;

        try {
            BufferedReader fileReader = Files.newBufferedReader(ioFile.toPath());

            int charByte;
            while ((charByte = fileReader.read()) != -1)
                text = text.concat(String.valueOf((char)charByte));

            fileReader.close();
        } catch (IOException ioException) {
            JOptionPane.showMessageDialog(null, ioException.getMessage(), "Error occurred while reading file.", JOptionPane.ERROR_MESSAGE);
        }

    }

    public void save(File ioFile) {
        if (ioFile == null)
            return;

        this.name = ioFile.getName();
        this.path = ioFile.getPath();

        try {
            BufferedWriter fileWriter = Files.newBufferedWriter(ioFile.toPath());
            byte[] bytes = text.getBytes();
            for (byte byteToRead : bytes) {
                fileWriter.write(byteToRead);
            }
            fileWriter.close();
            shouldSave = false;
        } catch (IOException ioException){
            JOptionPane.showMessageDialog(null, ioException.getMessage(), "Error occurred while writing file.", JOptionPane.ERROR_MESSAGE);
        }
        //FileWriter fileWriter = new FileWriter();



    }

    public void setText(String newText) { //Do we really need this?
        this.text = newText;
    }

    public String getName() {
        return name;
    }

    public String getPath() {
        return path;
    }

    public String getText() {
        return text;
    }

    public int getId() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null)
            return false;
        if (obj == this)
            return true;

        return false;
    }
}
