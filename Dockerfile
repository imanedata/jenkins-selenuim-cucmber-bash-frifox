# Utiliser l'image de base selenium/standalone-chrome pour Chrome
FROM selenium/standalone-chrome:latest

# Passer à l'utilisateur root pour installer des outils
USER root

# Mettre à jour et installer Java et Maven
RUN apt-get update && \
    apt-get install -y maven openjdk-21-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Créer un répertoire de cache pour Selenium et ajuster les permissions
RUN mkdir -p /home/seluser/.cache/selenium && \
    chown -R seluser:seluser /home/seluser/.cache/selenium

# Revenir à l'utilisateur selenium pour exécuter Selenium en toute sécurité
USER seluser

# Exposer le port WebDriver (4444 par défaut pour Selenium)
EXPOSE 4444

# Si vous avez des configurations spécifiques pour les drivers, vous pouvez ajouter ici :
# Ajouter un volume pour les drivers
