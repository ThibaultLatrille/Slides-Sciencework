function []=utt()
txt=['Premi�re Ville';'Seconde Ville'];
Villes=x_mdialog('Entrez le nom des deux villes',txt,['';''])
 ville1=Villes(1);// Premi�re ville
  //Remplacement de tous les symboles foireux
  nville1=cleaner(ville1);
  ville2=Villes(2); // Seconde ville
  //Remplacement de tous les symboles foireux
  nville2=cleaner(ville2);
  //On remplit les variables correspondant � chaque ville en utilisant la fonction finder()
  rang1=finder(nville1);
  rang2=finder(nville2);
  //Si les villes n'existent pas :
rang1=bonneville1(rang1);
rang2=bonneville2(rang2); 
//Creation de la matrice de coordonn�es (diff�rente si il existe des doublons)
     if Value(rang1+1,3)==1|Value(rang2+1,3)==1 then C=doublon(rang1,rang2,ville1,ville2); //On v�rifie si il y a des doublons et on remplit la matrice.
     else C=coord(rang1,rang2); //Remplissage normal
     end
//Calcul de la distance
d=calculdistance(C,1,2);
//Affichage du r�sultat final.
affichage(C,ville1,ville2,d);
endfunction