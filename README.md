# Ymage



# résistance au lag :

procédure /ping



# affinement du comportement :

en cas de stats (poids 1) dans la zone 61-101, comportement d'over puis remise à la dizaine

statistiques de taux de réussite des runes

capture multiple d'un jet avec ascenseur

refaire la capture au lieu de recalibrate quand on a un historique incomplet



# en test/PROBLEMES : 

Recalibrate() 
=> cas étrange de rune appartenant à l'objet qui deviennent inconnues après recalibration (résistance poussé sur anneau valet veinard)
=> levenshtein distance pour certains mots? à vérifier. (plusieurs recalibrages permettent de récupérer la rune donc probablement pas la cause)

analyse des couleurs de l'interface/inventaire résistante au lag
la fenêtre "recette impossible" fait perdre le fil du fm (parfois)
=>recalibrage dans applyattemptchanges (inutile?)
=>toujours un problème lorsque la rune n'est pas fusionnée après sélection dans l'inventaire. comment passe-t-elle les conditions? prévisu de la rune dans le chemin?

capture de l'historique
=> capture du clipboard partielle => problème contré dans l'ensemble, sauf si la capture partielle se fait avant une virgule
=> cas étrange ou la capture semble bonne, mais le programme ajoute des runes ré pou à l'infini au dessus du max
=> capture partielle (haut pas pris + bas pas pris => différent, mais meme modif que précédente => erreur de calcul)
=> tous ces cas se produisent quand la souris passe sur l'historique quand il est en train de bouger ?

FreeOcr erreur de capture clipboard (due à la haute priorité du script?)

clipwait dans capturelasthistory empeche d'arriver dans la gestion de la fenetre erreur de applyattemptchanges



# en test/VALIDATION :

possibilité de mauvaise capture de la couleur de l'emplacement rune de l'atelier (pas résistant au lag lors de la calibration)

encodage ISO 8859-1 pour tous les fichiers
