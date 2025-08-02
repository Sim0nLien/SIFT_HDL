Note pour la réalisation de la conv_Sobel

à modifier : Je n'ai besoin que de 3 données dans ma mémoire

Counter Objectif : 

Coup 0 : Demander Data_0
Coup 1 : Data_0
Coup 2 : Demande de Data_1
Coup 3 : Data_1
Coup 4 : Demande de Data_2
Coup 5 : Data_2
Ici on voit qu'il y a un gros problème de latence, il faudrait avoir toutes les données en même temps. Augmenter le débit....



Coup 6 : Multiplication <- Si on a le temps on peut rendre générique le nombre de DSPs
Coup 7 : Addition
Coup 8 : Addition

Coup 9 : Changement de valeur dans le buffer













