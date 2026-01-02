# Plantoune

Plantoune est une application mobile Flutter Android permettant de réaliser un herbier numérique à partir de photos de plantes. Chaque entrée dans l’herbier est associée à des coordonnées géographiques, qu’il est possible de visualiser sur une carte.

L'objectif en développant cette application était de m'exercer et me re-familiariser avec l'environnement Flutter, que je n'avais pas pratiqué depuis un moment.

## Installation : 

Téléchargez l'apk et installé le sur votre téléphone : https://drive.google.com/file/d/1GsQ8INr0HBnsGD7OBBXB6u3l-Jvv55C8/view?usp=drive_link

Ou récupérer le dépôt pour compiler vous même :

- Clonez le dépôt :
```
git clone https://github.com/lohan5555/Plantoune
```
- Ouvrez le projet dans Android Studio

- Compilez et lancez sur un émulateur ou un appareil Android


## Fonctionnalités : 

- Créer une entrée dans l’herbier : prendre une photo (avec l'appareil photo ou depuis la galerie), renseigner des informations (un nom et une description) et y associer les coordonnées de l’appareil 

- Afficher la liste de toutes les plantes renseignées

- Visualiser sur une carte toutes les entrées de l’herbier 

- Modifier ou supprimer les informations des plantes de l'herbier

- Modifier les coordonnées associées au plantes de l'herbier

- Recentrer la carte sur le coordonnées de l'appareil

## Images :

Page d'acceuil:

<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/fc8e2c8d-f67b-4869-967b-0bf7f89213c7" />

Formulaire d'ajout (et Image picker):

<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/8407534f-e9ff-48ae-90fe-f4480bfba931" />
<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/d77a5fa2-0400-4075-ae21-ea1b737ca7e5" />

Liste des plantes dans la page herbier:

<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/a5e65d51-2367-4df7-944b-9ff6fd4272c5" />

Carte des plantes:

<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/8b803823-7740-4a91-9ee1-55b69288c0e8" />

Page de détails d'une plante:

<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/ad0171ae-9ef8-4526-9dd4-50fb433104ce" />

Formultaire de modification:

<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/8f6766cb-c740-4408-8b16-bd384da5b4af" />
<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/be61cbf2-a4be-409f-b6fa-65776690b517" />

## Technologie utilisées :

- Flutter_map pour la carte interactif (https://pub.dev/packages/flutter_map)
- Sqflite pour la persistance des données (https://pub.dev/packages/sqflite)
- Image_picker pour prendre/récupérer les photos (https://pub.dev/packages/image_picker)
- Geolocator pour les coordonnées géographiques (https://pub.dev/packages/geolocator)


## Potentiels améliorations :

- Ajouter plusieurs photos à une seule plante
- Ajouter des filtres et une barre de recherche dans l'herbier
- Choisir les coordonnées au moment de la création de la plante (plutôt que les coordonnées de l'appareil)


