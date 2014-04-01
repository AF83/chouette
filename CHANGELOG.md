# V2.3.0 (en cours)

* Migration technique de chouette (Java)

# V2.2.0 (06/03/14)

* Refonte des fonctions d'import et validation

# V2.1.1 (20/12/13)

* Ajout de Google Analytics
* Clonage de courses
  * les calendiers de la course initiale sont reportés dans les copies

# V2.1.0 (15/07/13)

* suppression des coordonnées projetées en base
  * les données sont produites à la volée pour l'export et l'affichage à partir de la projection fixée dans le référentiel
* consolidation de l'import GTFS
* ajout d'un export KML :
  * lignes
  * séquences d'arrêt
  * arrêts (une chouche par type)
  * missions
  * correspondances
  * accès et liaisons accès-arrêt
* Intégration des cartes du géoportail (IGN)
  * ajout des fonds niveau cadastre et orthophoto
  * affichage de l'orthophoto IGN par défaut lorsque la clé IGN est présente

# V2.0.3 (27/05/13)

* Ajout des imports/export NeTex
* Fonctionnement sous windows
* Prise en compte de grandes quantités de calendriers.
* Reprise des logs d'import Neptune
* Intégration des cartes du géoportail (IGN)

# V2.0.2 (28/01/13)

* Ajout de l'import GTFS (expérimental, ne traite pas les stations)
* Ajout d'API Rest pour accéder aux données depuis une autre application

# V2.0.1 (17/12/12)

* Ajout de la gestion des groupes de lignes
* Ajout de la gestion des accès et des relations arrêts-accès
* Ajout d'une vue calendaire des calendriers d'application
* Améliorations ergonomiques et cartographiques
* L'import Neptune accepte les principaux formats d'encodage : ISO-8859-1, UTF-8, ...

# V2.0.0 (10/09/12)

* refonte de l'interface graphique
* ajout d'une gestion simplifiée d'utilisateurs :
  * ajout d'une notion d'organisation
  * ajout d'une notion d'espace de données
