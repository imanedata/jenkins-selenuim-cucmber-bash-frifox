package com.logwire.tools;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

public class WebDriverTool {

    static public WebDriver driver;

    static public void setUpDriver(){
        String browser = System.getProperty("browser", "chrome");
        switch (browser.toLowerCase()) {
            case "chrome":
                try {
                    // Créer un répertoire temporaire unique pour chaque session de Chrome
                    Path tempDir = Files.createTempDirectory("chrome-user-data-dir");
                    
                    // Options de Chrome
                    ChromeOptions options = new ChromeOptions();
                    options.addArguments("--user-data-dir=" + tempDir.toAbsolutePath().toString());
                    options.addArguments("--headless");  // Exécution sans interface graphique
                    options.addArguments("--disable-gpu"); // Utile dans les environnements sans GPU
                    options.addArguments("--no-sandbox");  // Souvent nécessaire dans les conteneurs Docker

                    // Utiliser Chrome avec ces options
                    driver = new ChromeDriver(options);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;

            case "firefox":
                try {
                    // Créer un répertoire temporaire unique pour chaque session de Firefox (similaire à Chrome)
                    Path tempDir = Files.createTempDirectory("firefox-user-data-dir");
                    
                    // Options de Firefox
                    FirefoxOptions options = new FirefoxOptions();
                    options.addArguments("--headless");  // Exécution sans interface graphique
                    options.addArguments("--no-sandbox"); // Souvent nécessaire dans les environnements Docker
                    options.setProfile(new org.openqa.selenium.firefox.FirefoxProfile(new java.io.File(tempDir.toAbsolutePath().toString()))); // Utiliser un profil utilisateur temporaire

                    // Utiliser Firefox avec ces options
                    driver = new FirefoxDriver(options);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;

            default:
                // Par défaut, utiliser Chrome sans options si le navigateur spécifié n'est pas supporté
                driver = new ChromeDriver();
                break;
        }

        // Maximiser la fenêtre du navigateur
        driver.manage().window().maximize();
    }

    static public WebDriver getDriver(){
        return driver;
    }

    static public void tearDown(){
        if (driver != null){
            driver.quit();
            driver = null;
        }
    }
}
