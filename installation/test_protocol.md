# En Français 🇫🇷🇫🇷🇫🇷🇫🇷

Pour la Jetson Nano, il y a deux versions très légerement différentes possibles : 
 - le Developper Kit officiel de Nvidia (référence P3450)
 - La version "C100" de Okdo. Les connecteurs sur la carte porteuse sont colorés.

Ils sont quasiment identiques, parce que le C100 est une copie du développeur kit officiel qui offre les mêmes fonctionnalités. Le connecteur de carte SD est simplement décalé de la carte du haut (la jetson elle-même) à la carte porteuse.
Pour utiliser la C100 au lieu du kit officiel, il a fallu installer la distribution de Okdo sur la carte SD au lieu de celle de Nvidia (à cause de ce changement sur le connecteur SD) : https://github.com/LetsOKdo/c100-bootupd


Pour installer la carte, voici la procédure sans "dd" : 
Avec balena etcher, verser sur une carte SD la distribution officielle jetson nano de nvidia, ou bien celle de okdo plus haut.
Booter, accepter les conditions d'utilisation, définir utilisateur et mot de passe à "vitirover" sans "require my password to log in" (un client préferait avoir le log in automatique).
Laisser le clavier en français le temps de setup, on mettra en anglais après (ou pas) ou selon le client final.

J'ai (mathieu) essayé de flasher directement une image copiée sur une nouvelle carte C100, et ça échoue au démarrage, sûrement parce que l'OS copié (via dd puis balena etcher) considère que le changement de uboot est déjà fait, alors que sur la nouvelle carte ce n'est pas le cas. Pour le moment, il faut donc taper les commandes d'installation à la main. Un script en wget arrivera bientôt.

Entrez les commandes de [installation/installation_commands.sh](installation_commands.sh) dans la jetson nano


Ce document décrit les tests qui sont réalisés avant l'expédition du robot académique. Les tests sur le robot lui-même ne sont pas décrit ici, ils ont été réalisés avant.

Préparation du test :
 - S'assurer que le robot est allumé (connecté au cloud, ou réseau wifi émis)
 - S'assurer que le robot a une version de software académique (elle est dans /Engineering/software/distribution_yocto_academic sur notre système privé), faire deux fois la mise à jour
 - Ouvrir le robot
 - S'assurer que le cavalier soit mis
 - Connecter la jetson nano à la [carte d'alimentation](/power_card/README.md)
 - Connecter le robot à un clavier et à une souris (idéalement sans fil) en branchant le dongle sur un USB de la Jetson
 - Connecter le robot à un écran en HDMI (ou via un adaptateur VGA)
 - Si la Jetson Nano ne se boote pas directement en même temps que le robot, reconnecter le cable d'alimentation jusqu'à avoir la led verte de la jetson alumée


Test de l'envoi de commandes par protobuf : 
 - Sur le Jetson, dans un terminal, taper __sudo ifconfig eth0 up 192.168.2.106 netmask 255.255.255.0__
 - __cd Desktop/vitirover_ws/src/mobile_robot/vitirover_bringup__
 - Puis faire __python3 basic-python-protobuf.py__
 - Vous devriez voir les roues bouger aléatoirement, et voir la télémétrie du robot défiler sur le terminal de la jetson

Test de l'envoi de commandes avec ROS : 
 - ouvrir un terminal et simplement taper *roscore* (pour lancer le serveur principal ROS)
 - sur un autre terminal, lancer le lien vitirover/ros avec :
   - __cd ~/Desktop/vitirover_ws/__
   - __catkin_make__
   - __source devel/setup.bash__
   - __cd ~/Desktop/vitirover_ws/src/mobile_robot/vitirover_bringup__
   - Si le fichier *command_ROS.py* contient "YOUR IP HERE", remplacer par votre IP, "192.168.2.106", définie à l'étape précédente
   - __python3 command_ROS.py__
 - sur un troisième terminal, lancer __rosrun teleop_twist_keyboard teleop_twist_keyboard.py__
 - utiliser la touche "__i__" minuscule par exemple pour faire avancer le robot, et "__,__" pour le faire reculer
 - Tapez __Ctrl+C__ pour quitter ce terminal

Test de deux caméras connectées à la Jetson : 
 - Taper "webcam" dans la recherche d'application Ubuntu (appuyer sur le bouton Windows pour l'ouvrir)
 - Ouvrir "Cheese Webcam Booth"
 - l'affichage devrait afficher la vue en live d'une des deux caméras "USB HDR Camera".
 - Passer la main devant pour vérifier laquelle
 - Ouvrir les préférences (Cheese => Preferences).
 - Dans l'onglet Webcam => Device, sélectionner l'autre caméra (les deux ont le même nom)
 - Vérifier en passant la main devant que c'est bien l'autre caméra qui est connectée.
 - Ok, fermer l'application



Fin du test : 
 - Reprendre le dongle de la souris et déconnecter le clavier
 - Déconnecter l'écran, remettre le hub HDMI


# English Translation 🇬🇧🇬🇧🇬🇧🇬🇧

This document describes the tests conducted before shipping the academic robot to the robot.

Test Preparation:

 - Ensure the robot is turned on (connected to the cloud or emitting a wifi network)
 - Ensure the robot has an academic software version (located in /Engineering/software/distribution_yocto_academic on our private system), update twice
 - Open the robot
 - Ensure the jumper is in place
 - Connect the Jetson Nano to the power card
 - Connect the robot to a keyboard and mouse (ideally wireless) by plugging the dongle into a USB port on the Jetson
 - Connect the robot to a screen via HDMI (or using a VGA adapter)
 - If the Jetson Nano does not boot directly with the robot, reconnect the power cable until the green LED on the Jetson is lit

Test for Sending Commands via Protobuf:

 - On the Jetson, in a terminal, type "sudo ifconfig eth0 up 192.168.2.106 netmask 255.255.255.0"
 - cd Desktop/vitirover_ws/src/mobile_robot/vitirover_bringup
 - Then run "python3 basic-python-protobuf.py"
 - You should see the wheels move randomly, and see the robot's telemetry scrolling on the Jetson terminal

Test for Two Cameras Connected to the Jetson:

 - Type "webcam" in the Ubuntu application search (press the Windows button to open it)
 - Open "Cheese Webcam Booth"
 - The display should show the live view of one of the two "USB HDR Camera" cameras.
 - Pass your hand in front to check which one
 - Open preferences (Cheese => Preferences).
 - In the Webcam => Device tab, select the other camera (both have the same name)
 - Verify by passing your hand in front that it is indeed the other camera connected.
 - Ok, close the application


Test for Sending Commands with ROS:

 - Open a terminal and simply type roscore (to start the main ROS server)
 - In another terminal, start the vitirover/ros link with:
 - __cd ~/Desktop/vitirover_ws/__
 - __catkin_make__
 - __source devel/setup.bash__
 - *cd ~/Desktop/vitirover_ws/src/mobile_robot/vitirover_bringup*
 - If the file *command_ROS.py* contains "YOUR IP HERE", replace it with your IP, "192.168.2.106", defined in the previous step
 - *python3 command_ROS.py*
 - In a third terminal, run *rosrun teleop_twist_keyboard teleop_twist_keyboard.py*
 - Use the "i" key in lowercase, for example, to move the robot forward, and "," to move it backward
 - Use __Ctrl+C__ to quit





End of the Test:
- Retrieve the mouse dongle
- Disconnect the screen, reassemble
