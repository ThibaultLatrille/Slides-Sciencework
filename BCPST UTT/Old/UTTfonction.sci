function []=utt()
txt=['Première Ville';'Seconde Ville'];
Villes=x_mdialog('Entrez le nom des deux villes',txt,['';''])
 ville1=Villes(1);// Première ville
  //Remplacement de tous les symboles foireux
  nville1=cleaner(ville1);
  ville2=Villes(2); // Seconde ville
  //Remplacement de tous les symboles foireux
  nville2=cleaner(ville2);
  //On remplit les variables correspondant à chaque ville en utilisant la fonction finder()
  rang1=finder(nville1);
  rang2=finder(nville2);
  //Si les villes n'existent pas :
rang1=bonneville1(rang1);
rang2=bonneville2(rang2); 
//Creation de la matrice de coordonnées (différente si il existe des doublons)
     if Value(rang1+1,3)==1|Value(rang2+1,3)==1 then C=doublon(rang1,rang2,ville1,ville2); //On vérifie si il y a des doublons et on remplit la matrice.
     else C=coord(rang1,rang2); //Remplissage normal
     end
//Calcul de la distance
d=calculdistance(C,1,2);
//Affichage du résultat final.
affichage(C,ville1,ville2,d);
endfunction