# Ymage



# r�sistance au lag :

proc�dure /ping



# affinement du comportement :

en cas de stats (poids 1) dans la zone 61-101, comportement d'over puis remise � la dizaine

statistiques de taux de r�ussite des runes

capture sp�cifique d'une ligne qui a pos� probl�me � l'OCR (la zone de capture doit toucher le caract�re)
=>OCR detecte parfois mal les chiffres :=> si 4 caract�res devant % ou espace, et que ce n'est pas un chiffre, la capture est fausse

capture multiple d'un jet avec ascenseur

refaire la capture au lieu de recalibrate quand on a un historique incomplet



# en test : 

Recalibrate() 
=>cas �trange de rune appartenant � l'objet qui deviennent inconnues apr�s recalibration (r�sistance pouss� sur anneau valet veinard)
=>modif_max_index est mal (re)configur� quelque part?

syst�me de detection immediate pour selectionner une rune dans l'inventaire
=>cas ou le fusionner ne passe pas (r�gl�, � v�rifier)

analyse des couleurs de l'interface en nombreuses phases (de v�rification d'�tat)
=>manque gestion de fen�tre "cette recette ne donne rien"



# PROBLEMES

possibilit� d'erreur de lecture de l'historique encore pr�sente
=> capture du clipboard partielle => probl�me contr� dans l'ensemble, sauf si la capture partielle se fait avant une virgule

possibilit� de mauvaise capture de la couleur de l'emplacement rune de l'atelier (pas r�sistant au lag lors de la calibration)

fichiers se r�encodent en UTF-8, raison inconnue (ex�cution autohotkey, push git, fermeture notepad++, ?)
