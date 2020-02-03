# Ymage

Pour un bon fonctionnement : 
=>filtrer les objets utilisables
=>désactiver les infobulles des objets
=>scrollbar de l'objet en haut, de manière à afficher le premier jet


# résistance au lag :

procédure /ping

faille lag => perte du jet courant (rare)

FreeOcr erreur de capture clipboard (due à la haute priorité du script?) (rare)

probleme de recalibrage si la rune n'est pas placee (jet est perdu et il ne recalibre pas -> probleme de logique)

# problemes :

cas d'un corps a corps à 2 lignes identiques + echec de lecture du jet maximal : faire en sorte d'ignorer totalement les lignes de degats

REMARQUE : DANS LE CAS OU IL N'Y A PLUS DE RELIQUAT SUR L'OBJET, ECHEC CRITIQUE ET SUCCES NEUTRE SONT CONFONDUS

si l'historique est réellement constitué uniquement d'échecs, le programme bug.

si l'objectif est un over, dans certaines phases il détruit l'over avant d'arriver dans la phase objectif (stupide)

considère le jet fini en cas de gros over sous reliquat exception et ne remet pas le pa (présent de base sur le jet) (voir si bon usage de reliquat exception... :p)

si l'objectif de res est 10 s'il y a 10 8 et 8 7, il va tenter la rune pour 9 7 et pas 8 8 d'abord

determiner le cout du passage exo négatif vers 0 =/= 1

ne compte pas le trash over comme du reliquat (p-ex 2 chance et 43 reliquat => 45 reliquat)
=> check chooserune et mainroutine

si un jet est au dessus du max lors de la calibration, enclencher la procédure de vide trash

dans le cas d'un perfect avec reliquat_exception, ne finit pas l'item

# problemes disparus (?)

problème : tente over puissance

tente un over % res air si il n'y a pas assez de reliquat pour over vita a 327/350?

probleme si le jet n'est pas remonté avec le poids du reliquat et que la rune choisie pour continuer a le remonter est superieure à la valeur du reliquat + probleme arrete avant de faire la tenta over % alors qu'il a bien assez pour la faire => cas d'un over de 1 considéré comme un exo (contradiction)
=> regle, peut etre encore un probleme quand il n'arrive pas a remonter l'item jusqu'au bout (reliquat insuffisant pour faire un over ra vi) a verifier

cas de choix d'action faux sans que le jet enregistré le soit, à tenir à l'oeil
=> possibilité que le script mette le modif_max_index à 0 pour le pa quand il tombe, à vérifier !!!! (plus d'actualité?)

nouvelle version de LevenshteinDistance
=> erreur jamais constatée
<= cas étrange de rune appartenant à l'objet qui deviennent inconnues après recalibration (résistance poussée sur anneau valet veinard)
<= cas étrange ou la capture semble bonne, mais le programme ajoute des runes ré pou à l'infini au dessus du max (idem precedent)
<= levenshtein distance pour certains mots? à vérifier. (plusieurs recalibrages permettent de récupérer la rune donc probablement pas la cause)
<= trouve résistance neutre plus facilement que résistance poussée avec "resistanoe Pousée" distance neutre : 5, distance poussée : 2 (pas normal)

# fonctionnalites

methode de verification si un objectif est rempli (ou meilleur algo)

gérer les potions d'élémentaire pour les armes, gérer les orbes reconstituants (pour fm)

statistiques de taux de réussite des runes

afficher dans des widget la valeur des caracs masquées par l'interface

intégrer L'OCR dans le code (sous forme de dll?)
=> attention toute particulière aux position ou il devrait/pourrait y avoir un nombre

-> validation du clipboard plus serieuse
=> valider une selection clipboard seulement si la tentative precedente dans la liste est la derniere tentative dans la version precedente (parait inutile)

-> pouvoir editer le msgbox de confirmation

-> tenter de supprimer un over trash avec une rune du jet si possible

-> si reliquat et consignes inferieures au max, tenter de parfaire l'item avant d'exo

-> si un over trash bloque une tenta exo, utiliser un 2eme over trash (systeme de balance)
