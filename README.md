# Ymage



# r�sistance au lag :

proc�dure /ping



# affinement du comportement :

en cas de stats (poids 1) dans la zone 61-101, comportement d'over puis remise � la dizaine

statistiques de taux de r�ussite des runes

capture multiple d'un jet avec ascenseur

refaire la capture au lieu de recalibrate quand on a un historique incomplet



# en test/PROBLEMES : 

Recalibrate() 
=> cas �trange de rune appartenant � l'objet qui deviennent inconnues apr�s recalibration (r�sistance pouss� sur anneau valet veinard)
=> levenshtein distance pour certains mots? � v�rifier. (plusieurs recalibrages permettent de r�cup�rer la rune donc probablement pas la cause)

analyse des couleurs de l'interface/inventaire r�sistante au lag
la fen�tre "recette impossible" fait perdre le fil du fm (parfois)
=>recalibrage dans applyattemptchanges (inutile?)
=>toujours un probl�me lorsque la rune n'est pas fusionn�e apr�s s�lection dans l'inventaire. comment passe-t-elle les conditions? pr�visu de la rune dans le chemin?

capture de l'historique
=> capture du clipboard partielle => probl�me contr� dans l'ensemble, sauf si la capture partielle se fait avant une virgule
=> cas �trange ou la capture semble bonne, mais le programme ajoute des runes r� pou � l'infini au dessus du max
=> capture partielle (haut pas pris + bas pas pris => diff�rent, mais meme modif que pr�c�dente => erreur de calcul)
=> tous ces cas se produisent quand la souris passe sur l'historique quand il est en train de bouger ?

FreeOcr erreur de capture clipboard (due � la haute priorit� du script?)

clipwait dans capturelasthistory empeche d'arriver dans la gestion de la fenetre erreur de applyattemptchanges



# en test/VALIDATION :

possibilit� de mauvaise capture de la couleur de l'emplacement rune de l'atelier (pas r�sistant au lag lors de la calibration)

encodage ISO 8859-1 pour tous les fichiers
