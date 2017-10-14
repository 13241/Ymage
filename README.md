# Ymage



# résistance au lag :

procédure /ping



# affinement du comportement :

en cas de stats (poids 1) dans la zone 61-101, comportement d'over puis remise à la dizaine

statistiques de taux de réussite des runes

capture spécifique d'une ligne qui a posé problème à l'OCR (la zone de capture doit toucher le caractère)
=>OCR detecte parfois mal les chiffres :=> si 4 caractères devant % ou espace, et que ce n'est pas un chiffre, la capture est fausse

capture multiple d'un jet avec ascenseur

refaire la capture au lieu de recalibrate quand on a un historique incomplet



# en test : 

Recalibrate() 
=>cas étrange de rune appartenant à l'objet qui deviennent inconnues après recalibration (résistance poussé sur anneau valet veinard)
=>modif_max_index est mal (re)configuré quelque part?

système de detection immediate pour selectionner une rune dans l'inventaire
=>cas ou le fusionner ne passe pas (réglé, à vérifier)

analyse des couleurs de l'interface en nombreuses phases (de vérification d'état)
=>manque gestion de fenêtre "cette recette ne donne rien"



# PROBLEMES

possibilité d'erreur de lecture de l'historique encore présente
=> capture du clipboard partielle => problème contré dans l'ensemble, sauf si la capture partielle se fait avant une virgule

possibilité de mauvaise capture de la couleur de l'emplacement rune de l'atelier (pas résistant au lag lors de la calibration)

fichiers se réencodent en UTF-8, raison inconnue (exécution autohotkey, push git, fermeture notepad++, ?)
