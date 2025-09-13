Ce repository est le premier d'une chaine, pour aider les élèves de BTS informatiques (SISR) à monter un service web (GLPI pour le moment) pour des cas d'école. 
Le script a trois option :
  1. La première option vous permet d'installer GLPI sur une machine, ce qui comprend le LAMP, une BDD et un utilisateur pour cette BDD.
     Il faudra spécifier :
       - Le nom de la base de donnée.
       - Le nom de l'utilisateur de la BDD (les privilèges lui seront automatiquement attribués).
       - Son mot de passe.
  2. La deuxième option vou permet d'installer MariaDB et de créer un utilisateur (à votre bon vouloir).
  3. La troisième et dernière, option, vous permet d'installer GLPI seul sur la machine, dans le scénario où vous utiliseriez un serveur de base de données.
     Vous devrez spécifier :
       - L'adresse IP ou le nom de la machine qui abrite votre base de donnée.
       - Le nom de la BDD
       - Le nom de l'utilisateur et son mot de passe.
