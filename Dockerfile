# Utiliser l'image de base selenium/standalone-chrome
FROM selenium/standalone-chrome:latest

# Passer à l'utilisateur root pour installer des outils
USER root

# Mettre à jour et installer Java et Maven
RUN apt-get update && \
    apt-get install -y maven openjdk-21-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ajouter un volume pour le ChromeDriver
VOLUME ["/drivers:/usr/local/bin/chromedriver"]

# Créer le répertoire de cache pour Selenium et ajuster les permissions
RUN mkdir -p /home/seluser/.cache/selenium && \
    chown -R seluser:seluser /home/seluser/.cache/selenium

# Revenir à l'utilisateur selenium pour exécuter Selenium en toute sécurité
USER seluser

# Exposer le port WebDriver pour Chrome (port 4444 par défaut)
EXPOSE 4444

# Créer une instance pour Firefox (utiliser un autre port, par exemple 5555)
FROM selenium/standalone-firefox:latest

# Passer à l'utilisateur root pour installer des outils
USER root

# Mettre à jour et installer Java et Maven
RUN apt-get update && \
    apt-get install -y maven openjdk-21-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ajouter un volume pour le FirefoxDriver
VOLUME ["/drivers:/usr/local/bin/geckodriver"]

# Créer le répertoire de cache pour Selenium et ajuster les permissions
RUN mkdir -p /home/seluser/.cache/selenium && \
    chown -R seluser:seluser /home/seluser/.cache/selenium

# Revenir à l'utilisateur selenium pour exécuter Selenium en toute sécurité
USER seluser

# Exposer un nouveau port pour Firefox (par exemple, 5555)
EXPOSE 5555
