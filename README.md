# Ymage

Pour un bon fonctionnement : 
=>filtrer les objets utilisables
=>désactiver les infobulles des objets
=>scrollbar de l'objet en haut, de manière à afficher le premier jet



# résistance au lag :

procédure /ping



# affinement du comportement :

statistiques de taux de réussite des runes

refaire la capture au lieu de recalibrate quand on a un historique incomplet
=>partiellemet intégré

afficher dans des widget la valeur des caracs masquées par l'interface

intégrer L'OCR dans le code (sous forme de dll?)

ne compte pas le trash over comme du reliquat (p-ex 2 chance et 43 reliquat => 45 reliquat)

remplacer tous les recalibrate par la strategie de buffer (dico temporaire pour stocker les changements (insert, remove, push...)

=> procedure enter dans le début de userune (lorsqu'on retire la rune possiblement présente dans l'atelier)

procedure /ping dans le cas d'une boucle infinie de capturelastattempthistory (fusion de rune pas passée)

cas ou enter reste jusqu'au placement de rune, possibilité que plusieurs runes soient placées, possibilité que 2 fusions aient lieu => erreur de calcul (saut d'une ilgne)
=> pas de gestion du enter dans le placement de rune
=> en cas de lag, peut etre que plusieurs runes peuvent être placées : à tester
=> procédure de retrait de rune pendant le placement
=> fusionner ne peut pas etre appliqué sur plusieurs runes? (tant qu'on ne fait pas d'enter sur le placement de runes)



# en test/PROBLEMES : 

analyse des couleurs de l'interface/inventaire résistante au lag
la fenêtre "recette impossible" fait perdre le fil du fm (apparait avec un gros délais, le programme met déjà la rune suivante)
=>partiellement contré

capture de l'historique
=> capture du clipboard partielle => problème contré dans l'ensemble, sauf si la capture partielle se fait avant une virgule
=> capture partielle (haut pas pris + bas pas pris => différent, mais meme modif que précédente => erreur de calcul)
=> tous ces cas se produisent quand la souris passe sur l'historique quand il est en train de bouger ?

FreeOcr erreur de capture clipboard (due à la haute priorité du script?)



# en test/VALIDATION :

remet la prospection apres avoir epuisé le reliquat pour mettre un over res, avant l'exo
=> à vérifier

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
