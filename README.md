# Ymage

Pour un bon fonctionnement : 
=>filtrer les objets utilisables
=>d�sactiver les infobulles des objets
=>scrollbar de l'objet en haut, de mani�re � afficher le premier jet



# r�sistance au lag :

proc�dure /ping



# affinement du comportement :

statistiques de taux de r�ussite des runes

refaire la capture au lieu de recalibrate quand on a un historique incomplet

afficher dans des widget la valeur des caracs masqu�es par l'interface

int�grer L'OCR dans le code (sous forme de dll?)



# en test/PROBLEMES : 

analyse des couleurs de l'interface/inventaire r�sistante au lag
la fen�tre "recette impossible" fait perdre le fil du fm (apparait avec un gros d�lais, le programme met d�j� la rune suivante)

capture de l'historique
=> capture du clipboard partielle => probl�me contr� dans l'ensemble, sauf si la capture partielle se fait avant une virgule
=> capture partielle (haut pas pris + bas pas pris => diff�rent, mais meme modif que pr�c�dente => erreur de calcul)
=> tous ces cas se produisent quand la souris passe sur l'historique quand il est en train de bouger ?

FreeOcr erreur de capture clipboard (due � la haute priorit� du script?)

remet la prospection apres avoir epuis� le reliquat pour mettre un over res, avant l'exo => � corriger



# en test/VALIDATION :

possibilit� de mauvaise capture de la couleur de l'emplacement rune de l'atelier (pas r�sistant au lag lors de la calibration)
=> erreur jamais constat�e

encodage ISO 8859-1 pour tous les fichiers
=> erreur jamais constat�e

capture multiple d'un jet avec ascenseur
=> erreur jamais constat�e

d�sactiver l'infobulle
=> erreur jamais constat�e
<= infobulle objet vient masquer le bouton fusionner
<= faire bouger la souris avant le test couleur cause un glissement de la rune et une nouvelle erreur

correction dans le cas ou une ligne est mal lue modifie mal les objectifs (� v�rifier dans le cas ou �a se pr�sente)
r�duire la bande vide de recherche � droite (pour un monoline avec chiffre faux)
=> erreur jamais constat�e

g�re la notion d'exo dans les instructions (valeur unitaire qu'on ajoute � la toute fin d'un jet)
=> erreur jamais constat�e
<= sur une instruction over + exo po d'un item poss�dant un pa, tentait le po avant les % res

g�n�raliser la proc�dure d'exclusion des runes exclue dans les instructions
=> erreur jamais constat�e

en cas de stats (poids 1) dans la zone 61-101, comportement d'over puis remise � la dizaine
=> erreur jamais constat�e

nouvelle version de LevenshteinDistance
=> erreur jamais constat�e
<= cas �trange de rune appartenant � l'objet qui deviennent inconnues apr�s recalibration (r�sistance pouss�e sur anneau valet veinard)
<= cas �trange ou la capture semble bonne, mais le programme ajoute des runes r� pou � l'infini au dessus du max (idem precedent)
<= levenshtein distance pour certains mots? � v�rifier. (plusieurs recalibrages permettent de r�cup�rer la rune donc probablement pas la cause)
<= trouve r�sistance neutre plus facilement que r�sistance pouss�e avec "resistanoe Pous�e" distance neutre : 5, distance pouss�e : 2 (pas normal)
