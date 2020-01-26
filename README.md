# Ymage

Pour un bon fonctionnement : 
=>filtrer les objets utilisables
=>désactiver les infobulles des objets
=>scrollbar de l'objet en haut, de manière à afficher le premier jet



# résistance au lag :

procédure /ping



# affinement du comportement :

problème : cas d'un corps a corps à 2 lignes identiques + echec de lecture du jet maximal : faire en sorte d'ignorer totalement les lignes de degats

REMARQUE : DANS LE CAS OU IL N'Y A PLUS DE RELIQUAT SUR L'OBJET, ECHEC CRITIQUE ET SUCCES NEUTRE SONT CONFONDUS

problème : si l'historique est réellement constitué uniquement d'échecs, le programme bug.

problème : si l'objectif est un over, dans certaines phases il détruit l'over avant d'arriver dans la phase objectif (stupide)

problème : considère le jet fini en cas de gros over sous reliquat exception et ne remet pas le pa (présent de base sur le jet) (voir si bon usage de reliquat exception... :p)

problème : tente over puissance

faille lag => perte du jet courant

methode de verification si un objectif est rempli

attention : avec l'objectif de res a 10 si y'a 10 8 et 8 7, il va tenter la rune pour 9 7 et pas 8 8 d'abord

ajouter l'effet de rune "pdv rendus" pour les armes qui soignent

tente un over % res air si il n'y a pas assez de reliquat pour over vita a 327/350?

probleme si le jet n'est pas remonté avec le poids du reliquat et que la rune choisie pour continuer a le remonter est superieure à
la valeur du reliquat + probleme arrete avant de faire la tenta over % alors qu'il a bien assez pour la faire => cas d'un over de 1 considéré comme un exo (contradiction)
=> regle, peut etre encore un probleme quand il n'arrive pas a remonter l'item jusqu'au bout (reliquat insuffisant pour faire un over ra vi) a verifier

gérer les potions d'élémentaire pour les armes, gérer les orbes reconstituants (pour fm)

statistiques de taux de réussite des runes

afficher dans des widget la valeur des caracs masquées par l'interface

intégrer L'OCR dans le code (sous forme de dll?)
=> attention toute particulière aux position ou il devrait/pourrait y avoir un nombre

procedure /ping dans le cas d'une boucle infinie de capturelastattempthistory (fusion de rune pas passée)
=>pas nécessaire? Le programme attend le changement de couleur de pixel, à vérifier si c'est le cas partout (peut etre raison de la faille))

# en test/PROBLEMES : 

FreeOcr erreur de capture clipboard (due à la haute priorité du script?)

cas de choix d'action faux sans que le jet enregistré le soit, à tenir à l'oeil
=> possibilité que le script mette le modif_max_index à 0 pour le pa quand il tombe, à vérifier !!!! (plus d'actualité?)



# en test/VALIDATION :

capturer sur plusieurs pixels min et max 
=> capturer la ligne des effets avec pour un meilleur resultat
=> ne capture pas uniquement les lignes erronées mais toutes les lignes à partir de la ligne erronée
=> probleme si la colonne min n'est pas capturée du tout...
=> ajout d'un procédé manuel au cas ou l'ocr ne capture jamais la bonne valeur
=> solution finale : passer à l'OCR dans le code

créer une méthode de forçage du dernier objectif dans le cas ou aucun objectif n'est rempli et qu'aucune rune n'est mettable
=> probablement à ajuster selon certains autres problèmes

attention exo négatif vers 0 =/= 1
=> conditions changées

ne compte pas le trash over comme du reliquat (p-ex 2 chance et 43 reliquat => 45 reliquat)
=> check chooserune et mainroutine

si un jet est au dessus du max lors de la calibration, enclencher la procédure de vide trash

gérer le cliquer glisser possible (à cause de capture pixel?)

cas ou enter reste jusqu'au placement de rune, possibilité que plusieurs runes soient placées, possibilité que 2 fusions aient lieu => erreur de calcul (saut d'une ilgne)
=> pas de gestion du enter dans le placement de rune
=> en cas de lag, peut etre que plusieurs runes peuvent être placées : à tester
=> procédure de retrait de rune pendant le placement
=> fusionner ne peut pas etre appliqué sur plusieurs runes? (tant qu'on ne fait pas d'enter sur le placement de runes)

analyse des couleurs de l'interface/inventaire résistante au lag
la fenêtre "recette impossible" fait perdre le fil du fm (apparait avec un gros délais, le programme met déjà la rune suivante)

capture de l'historique
=> capture du clipboard partielle => problème contré dans l'ensemble, sauf si la capture partielle se fait avant une virgule
=> capture partielle (haut pas pris + bas pas pris => différent, mais meme modif que précédente => erreur de calcul)
=> tous ces cas se produisent quand la souris passe sur l'historique quand il est en train de bouger ?

=> procedure pour gérer la fenetre d'erreur (si useRune foire, on recalibre, (seul recalibrage présent)
=> erreur jamais constatée (test si n'apparait pas trop souvent (calibrate))

refaire la capture au lieu de recalibrate quand on a un historique incomplet
=> erreur jamais constatée

remet la prospection apres avoir epuisé le reliquat pour mettre un over res, avant l'exo
=> erreur jamais constatée

possibilité de mauvaise capture de la couleur de l'emplacement rune de l'atelier (pas résistant au lag lors de la calibration)
=> erreur jamais constatée

encodage ISO 8859-1 pour tous les fichiers
=> erreur jamais constatée

capture multiple d'un jet avec ascenseur
=> erreur jamais constatée

désactiver l'infobulle
=> erreur jamais constatée
<= infobulle objet vient masquer le bouton fusionner
<= faire bouger la souris avant le test couleur cause un glissement de la rune et une nouvelle erreur

correction dans le cas ou une ligne est mal lue modifie mal les objectifs
réduire la bande vide de recherche à droite (pour un monoline avec chiffre faux)
=> vérifier l'état de l'objet juste après une capture monoligne

gère la notion d'exo dans les instructions (valeur unitaire qu'on ajoute à la toute fin d'un jet)
=> erreur jamais constatée
<= sur une instruction over + exo po d'un item possédant un pa, tentait le po avant les % res

généraliser la procédure d'exclusion des runes exclue dans les instructions
=> erreur jamais constatée

en cas de stats (poids 1) dans la zone 61-101, comportement d'over puis remise à la dizaine
=> erreur jamais constatée

nouvelle version de LevenshteinDistance
=> erreur jamais constatée
<= cas étrange de rune appartenant à l'objet qui deviennent inconnues après recalibration (résistance poussée sur anneau valet veinard)
<= cas étrange ou la capture semble bonne, mais le programme ajoute des runes ré pou à l'infini au dessus du max (idem precedent)
<= levenshtein distance pour certains mots? à vérifier. (plusieurs recalibrages permettent de récupérer la rune donc probablement pas la cause)
<= trouve résistance neutre plus facilement que résistance poussée avec "resistanoe Pousée" distance neutre : 5, distance poussée : 2 (pas normal)

probleme : desynchronisation :
=> mauvaise capture du clipboard ?

-> validation du clipboard plus serieuse
=> valider une selection clipboard seulement si la tentative precedente dans la liste est la derniere tentative dans la version precedente

-> pouvoir editer le msgbox de confirmation

-> faire la verification du dernier reliquat ajoute

-> probleme d'over 2 force -> 1 pa blocage