# Ymage

Pour un bon fonctionnement : 
=>filtrer les objets utilisables
=>d�sactiver les infobulles des objets
=>scrollbar de l'objet en haut, de mani�re � afficher le premier jet


# r�sistance au lag :

proc�dure /ping

faille lag => perte du jet courant (rare)

FreeOcr erreur de capture clipboard (due � la haute priorit� du script?) (rare)

probleme de recalibrage si la rune n'est pas placee (jet est perdu et il ne recalibre pas -> probleme de logique)

# problemes :

cas d'un corps a corps � 2 lignes identiques + echec de lecture du jet maximal : faire en sorte d'ignorer totalement les lignes de degats

REMARQUE : DANS LE CAS OU IL N'Y A PLUS DE RELIQUAT SUR L'OBJET, ECHEC CRITIQUE ET SUCCES NEUTRE SONT CONFONDUS

si l'historique est r�ellement constitu� uniquement d'�checs, le programme bug.

si l'objectif est un over, dans certaines phases il d�truit l'over avant d'arriver dans la phase objectif (stupide)

consid�re le jet fini en cas de gros over sous reliquat exception et ne remet pas le pa (pr�sent de base sur le jet) (voir si bon usage de reliquat exception... :p)

si l'objectif de res est 10 s'il y a 10 8 et 8 7, il va tenter la rune pour 9 7 et pas 8 8 d'abord

determiner le cout du passage exo n�gatif vers 0 =/= 1

ne compte pas le trash over comme du reliquat (p-ex 2 chance et 43 reliquat => 45 reliquat)
=> check chooserune et mainroutine

si un jet est au dessus du max lors de la calibration, enclencher la proc�dure de vide trash

dans le cas d'un perfect avec reliquat_exception, ne finit pas l'item

# problemes disparus (?)

probl�me : tente over puissance

tente un over % res air si il n'y a pas assez de reliquat pour over vita a 327/350?

probleme si le jet n'est pas remont� avec le poids du reliquat et que la rune choisie pour continuer a le remonter est superieure � la valeur du reliquat + probleme arrete avant de faire la tenta over % alors qu'il a bien assez pour la faire => cas d'un over de 1 consid�r� comme un exo (contradiction)
=> regle, peut etre encore un probleme quand il n'arrive pas a remonter l'item jusqu'au bout (reliquat insuffisant pour faire un over ra vi) a verifier

cas de choix d'action faux sans que le jet enregistr� le soit, � tenir � l'oeil
=> possibilit� que le script mette le modif_max_index � 0 pour le pa quand il tombe, � v�rifier !!!! (plus d'actualit�?)

nouvelle version de LevenshteinDistance
=> erreur jamais constat�e
<= cas �trange de rune appartenant � l'objet qui deviennent inconnues apr�s recalibration (r�sistance pouss�e sur anneau valet veinard)
<= cas �trange ou la capture semble bonne, mais le programme ajoute des runes r� pou � l'infini au dessus du max (idem precedent)
<= levenshtein distance pour certains mots? � v�rifier. (plusieurs recalibrages permettent de r�cup�rer la rune donc probablement pas la cause)
<= trouve r�sistance neutre plus facilement que r�sistance pouss�e avec "resistanoe Pous�e" distance neutre : 5, distance pouss�e : 2 (pas normal)

# fonctionnalites

methode de verification si un objectif est rempli (ou meilleur algo)

g�rer les potions d'�l�mentaire pour les armes, g�rer les orbes reconstituants (pour fm)

statistiques de taux de r�ussite des runes

afficher dans des widget la valeur des caracs masqu�es par l'interface

int�grer L'OCR dans le code (sous forme de dll?)
=> attention toute particuli�re aux position ou il devrait/pourrait y avoir un nombre

-> validation du clipboard plus serieuse
=> valider une selection clipboard seulement si la tentative precedente dans la liste est la derniere tentative dans la version precedente (parait inutile)

-> pouvoir editer le msgbox de confirmation

-> tenter de supprimer un over trash avec une rune du jet si possible

-> si reliquat et consignes inferieures au max, tenter de parfaire l'item avant d'exo

-> si un over trash bloque une tenta exo, utiliser un 2eme over trash (systeme de balance)
