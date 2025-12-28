# Plantoune

Plantoune est une application mobile Flutter permettant de réaliser un herbier numérique à partir de photos de plantes. Chaque entrée dans l’herbier est associée à des coordonnées géographiques, qu’il est possible de visualiser sur une carte.
L'objectif en développant cette application était de m'exercer et me re-familiariser avec l'environnement Flutter, que je n'avais pas pratiqué depuis un moment.

## Installation : 

- Clonez le dépôt :

git clone https://github.com/lohan5555/Plantoune

- Ouvrez le projet dans Android Studio

- Compilez et lancez sur un émulateur ou un appareil Android


## Fonctionnalités : 

- Créer une entrée dans l’herbier : prendre une photo (avec l'appareil photo ou depuis la galerie), renseigner des informations (un nom et une description) et y associer les coordonnées de l’appareil 

- Afficher toutes les plantes renseignées

- Modifier ou supprimer les plantes de l'herbier

- Visualiser sur une carte toutes les entrées de l’herbier 

- Recentrer la map sur le coordonnées de l'appareil


## Technologie utilisées :

- Flutter_map pour la carte interactif (https://pub.dev/packages/flutter_map)
- Sqflite pour la persistance des données (https://pub.dev/packages/sqflite)
- Image_picker pour prendre/récupérer les photos (https://pub.dev/packages/image_picker)
- Geolocator pour les coordonnées géographiques (https://pub.dev/packages/geolocator)


## Potentiels améliorations :

- Ajouter plusieurs photos à une seule plante
- Ajouter des filtres et une barre de recherche dans l'herbier


## Images :
