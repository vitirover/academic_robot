# En Français 🇫🇷🇫🇷🇫🇷🇫🇷

Ce document décrit les tests qui sont réalisés avant l'expédition du robot académique au robot.

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
 - Sur le Jetson, dans un terminal, taper "sudo ifconfig eth0 up 192.168.2.106 netmask 255.255.255.0"
 - cd Desktop/vitirover_ws/src/mobile_robot/vitirover_bringup
 - Puis faire "python3 basic-python-protobuf.py"
 - Vous devriez voir les roues bouger aléatoirement, et voir la télémétrie du robot défiler sur le terminal de la jetson

Test de deux caméras connectées à la Jetson : 
 - Taper "webcam" dans la recherche d'application Ubuntu (appuyer sur le bouton Windows pour l'ouvrir)
 - Ouvrir "Cheese Webcam Booth"
 - l'affichage devrait afficher la vue en live d'une des deux caméras "USB HDR Camera".
 - Passer la main devant pour vérifier laquelle
 - Ouvrir les préférences (Cheese => Preferences).
 - Dans l'onglet Webcam => Device, sélectionner l'autre caméra (les deux ont le même nom)
 - Vérifier en passant la main devant que c'est bien l'autre caméra qui est connectée.
 - Ok, fermer l'application


Test de l'envoi de commandes avec ROS : 
 - ...


Fin du test : 
 - Reprendre le dongle de la souris
 - Déconnecter l'écran, remettre 


English Translation 🇬🇧🇬🇧🇬🇧🇬🇧
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
 - ...


End of the Test:
- Retrieve the mouse dongle
- Disconnect the screen, reassemble
