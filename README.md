# Ymage

Pour un bon fonctionnement : 
=>filtrer les objets utilisables
=>d�sactiver les infobulles des objets
=>scrollbar de l'objet en haut, de mani�re � afficher le premier jet



# r�sistance au lag :

proc�dure /ping



# affinement du comportement :

probl�me : cas d'un corps a corps � 2 lignes identiques + echec de lecture du jet maximal : faire en sorte d'ignorer totalement les lignes de degats

REMARQUE : DANS LE CAS OU IL N'Y A PLUS DE RELIQUAT SUR L'OBJET, ECHEC CRITIQUE ET SUCCES NEUTRE SONT CONFONDUS

probl�me : si l'historique est r�ellement constitu� uniquement d'�checs, le programme bug.

probl�me : si l'objectif est un over, dans certaines phases il d�truit l'over avant d'arriver dans la phase objectif (stupide)

probl�me : consid�re le jet fini en cas de gros over sous reliquat exception et ne remet pas le pa (pr�sent de base sur le jet) (voir si bon usage de reliquat exception... :p)

probl�me : tente over puissance

faille lag => perte du jet courant

methode de verification si un objectif est rempli

attention : avec l'objectif de res a 10 si y'a 10 8 et 8 7, il va tenter la rune pour 9 7 et pas 8 8 d'abord

ajouter l'effet de rune "pdv rendus" pour les armes qui soignent

tente un over % res air si il n'y a pas assez de reliquat pour over vita a 327/350?

probleme si le jet n'est pas remont� avec le poids du reliquat et que la rune choisie pour continuer a le remonter est superieure �
la valeur du reliquat + probleme arrete avant de faire la tenta over % alors qu'il a bien assez pour la faire => cas d'un over de 1 consid�r� comme un exo (contradiction)
=> regle, peut etre encore un probleme quand il n'arrive pas a remonter l'item jusqu'au bout (reliquat insuffisant pour faire un over ra vi) a verifier

g�rer les potions d'�l�mentaire pour les armes, g�rer les orbes reconstituants (pour fm)

statistiques de taux de r�ussite des runes

afficher dans des widget la valeur des caracs masqu�es par l'interface

int�grer L'OCR dans le code (sous forme de dll?)
=> attention toute particuli�re aux position ou il devrait/pourrait y avoir un nombre

procedure /ping dans le cas d'une boucle infinie de capturelastattempthistory (fusion de rune pas pass�e)
=>pas n�cessaire? Le programme attend le changement de couleur de pixel, � v�rifier si c'est le cas partout (peut etre raison de la faille))

# en test/PROBLEMES : 

FreeOcr erreur de capture clipboard (due � la haute priorit� du script?)

cas de choix d'action faux sans que le jet enregistr� le soit, � tenir � l'oeil
=> possibilit� que le script mette le modif_max_index � 0 pour le pa quand il tombe, � v�rifier !!!! (plus d'actualit�?)



# en test/VALIDATION :

capturer sur plusieurs pixels min et max 
=> capturer la ligne des effets avec pour un meilleur resultat
=> ne capture pas uniquement les lignes erron�es mais toutes les lignes � partir de la ligne erron�e
=> probleme si la colonne min n'est pas captur�e du tout...
=> ajout d'un proc�d� manuel au cas ou l'ocr ne capture jamais la bonne valeur
=> solution finale : passer � l'OCR dans le code

cr�er une m�thode de for�age du dernier objectif dans le cas ou aucun objectif n'est rempli et qu'aucune rune n'est mettable
=> probablement � ajuster selon certains autres probl�mes

attention exo n�gatif vers 0 =/= 1
=> conditions chang�es

ne compte pas le trash over comme du reliquat (p-ex 2 chance et 43 reliquat => 45 reliquat)
=> check chooserune et mainroutine

si un jet est au dessus du max lors de la calibration, enclencher la proc�dure de vide trash

g�rer le cliquer glisser possible (� cause de capture pixel?)

cas ou enter reste jusqu'au placement de rune, possibilit� que plusieurs runes soient plac�es, possibilit� que 2 fusions aient lieu => erreur de calcul (saut d'une ilgne)
=> pas de gestion du enter dans le placement de rune
=> en cas de lag, peut etre que plusieurs runes peuvent �tre plac�es : � tester
=> proc�dure de retrait de rune pendant le placement
=> fusionner ne peut pas etre appliqu� sur plusieurs runes? (tant qu'on ne fait pas d'enter sur le placement de runes)

analyse des couleurs de l'interface/inventaire r�sistante au lag
la fen�tre "recette impossible" fait perdre le fil du fm (apparait avec un gros d�lais, le programme met d�j� la rune suivante)

capture de l'historique
=> capture du clipboard partielle => probl�me contr� dans l'ensemble, sauf si la capture partielle se fait avant une virgule
=> capture partielle (haut pas pris + bas pas pris => diff�rent, mais meme modif que pr�c�dente => erreur de calcul)
=> tous ces cas se produisent quand la souris passe sur l'historique quand il est en train de bouger ?

=> procedure pour g�rer la fenetre d'erreur (si useRune foire, on recalibre, (seul recalibrage pr�sent)
=> erreur jamais constat�e (test si n'apparait pas trop souvent (calibrate))

refaire la capture au lieu de recalibrate quand on a un historique incomplet
=> erreur jamais constat�e

remet la prospection apres avoir epuis� le reliquat pour mettre un over res, avant l'exo
=> erreur jamais constat�e

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

probleme : desynchronisation :
=> mauvaise capture du clipboard ?

-> validation du clipboard plus serieuse
=> valider une selection clipboard seulement si la tentative precedente dans la liste est la derniere tentative dans la version precedente

-> pouvoir editer le msgbox de confirmation

-> faire la verification du dernier reliquat ajoute

-> probleme d'over 2 force -> 1 pa blocage