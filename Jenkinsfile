pipeline {
    parameters {
        choice(name: 'ENV', choices: ['-chrome', 'node-firefox'], description: 'Environment de test')
        choice(name: 'ENVE', choices: ['chrome', 'firefox'], description: 'Environment de test')
    }

    agent {
        docker {
            // Utilisation de la substitution de la variable `${params.ENV}` pour définir l'image Docker
            image "selenium/standalone${params.ENV}:latest"
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'  // Permet à Docker d'utiliser le socket de l'hôte
        }
    }

    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    // Installer Maven et Java dans le conteneur
                    sh '''
                    sudo apt-get update && \
                    sudo apt-get install -y maven openjdk-21-jdk
                    '''
                    
                    // Créer le répertoire cache de Selenium pour éviter les problèmes de permission
                    sh 'sudo mkdir -p /home/seluser/.cache/selenium'
                    sh 'sudo chmod -R 777 /home/seluser/.cache/selenium'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Exécuter les tests Maven dans le conteneur
                    sh 'mvn test -D cucumber.plugin="json:reports/cucumber-report.json" -D browser=${params.ENVE}'
                    sh 'cat reports/cucumber-report.json'
                }
            }
        }
    }

    post {
        always {
            script {
                cucumber buildStatus: 'UNSTABLE',
                    failedFeaturesNumber: 1,
                    failedScenariosNumber: 1,
                    skippedStepsNumber: 1,
                    failedStepsNumber: 1,
                    classifications: [
                        [key: 'Commit', value: 'Commit ID non disponible'],
                        [key: 'Submitter', value: 'Nom du soumetteur non disponible']
                    ],
                    reportTitle: 'My report',
                    fileIncludePattern: 'reports/cucumber-report.json',
                    sortingMethod: 'ALPHABETICAL',
                    trendsLimit: 100

                echo 'Tests finished. Check the console output for details!'
            }
        }
    }
}
