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
=>partiellemet int�gr�

afficher dans des widget la valeur des caracs masqu�es par l'interface

int�grer L'OCR dans le code (sous forme de dll?)

ne compte pas le trash over comme du reliquat (p-ex 2 chance et 43 reliquat => 45 reliquat)

remplacer tous les recalibrate par la strategie de buffer (dico temporaire pour stocker les changements (insert, remove, push...)

=> procedure enter dans le d�but de userune (lorsqu'on retire la rune possiblement pr�sente dans l'atelier)

procedure /ping dans le cas d'une boucle infinie de capturelastattempthistory (fusion de rune pas pass�e)

cas ou enter reste jusqu'au placement de rune, possibilit� que plusieurs runes soient plac�es, possibilit� que 2 fusions aient lieu => erreur de calcul (saut d'une ilgne)
=> pas de gestion du enter dans le placement de rune
=> en cas de lag, peut etre que plusieurs runes peuvent �tre plac�es : � tester
=> proc�dure de retrait de rune pendant le placement
=> fusionner ne peut pas etre appliqu� sur plusieurs runes? (tant qu'on ne fait pas d'enter sur le placement de runes)



# en test/PROBLEMES : 

analyse des couleurs de l'interface/inventaire r�sistante au lag
la fen�tre "recette impossible" fait perdre le fil du fm (apparait avec un gros d�lais, le programme met d�j� la rune suivante)
=>partiellement contr�

capture de l'historique
=> capture du clipboard partielle => probl�me contr� dans l'ensemble, sauf si la capture partielle se fait avant une virgule
=> capture partielle (haut pas pris + bas pas pris => diff�rent, mais meme modif que pr�c�dente => erreur de calcul)
=> tous ces cas se produisent quand la souris passe sur l'historique quand il est en train de bouger ?

FreeOcr erreur de capture clipboard (due � la haute priorit� du script?)



# en test/VALIDATION :

remet la prospection apres avoir epuis� le reliquat pour mettre un over res, avant l'exo
=> � v�rifier

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

correction dans le cas ou une ligne est mal lue modifie mal les objectifs
r�duire la bande vide de recherche � droite (pour un monoline avec chiffre faux)
=> v�rifier l'�tat de l'objet juste apr�s une capture monoligne

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
