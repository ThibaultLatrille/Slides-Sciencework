//Marqueur de l'activité du programme
on=1;

//Blabla d'intro
disp("                  Ultimate Traveler''s toolbox ");     
disp("                                V 1.0             ");
disp(" ");
disp(" ");
disp("  Ultimate traveller''s toolbox est l''outil idéal pour tous les grands voyageurs soucieux de préparer leur voyage.");
disp("  Grâce à sa fabuleuse base de donnée, il vous permettra de connaître la distance entre deux étapes de votre voyage !");
disp("  Pour cela, il vous suffit de suivre les instructions données.");
disp(" ");  
disp(" ");

//Boucle permettant la fermeture du programme par un menu
while on==1 do
  
//Menu classique, on va pas s'étendre sur le concept
RMenu=0;
while RMenu <> 1 & RMenu <> 2 do
RMenu=x_choose(["Calculer une distance","Quitter Ultimate Traveler''s toolbox"],'Que voulez-vous faire ?');
end

//Réponse au menu
if RMenu==2 then on=0;
else
  ville1=x_dialog("Entrez le nom de la 1ere ville : ","");// Première ville
  //Remplacement de tous les symboles foireux
  nville1=cleaner(ville1);
  disp(" ");
  ville2=x_dialog("Entrez le nom de la 2eme ville : ",""); // Seconde ville
  //Remplacement de tous les symboles foireux
  nville2=cleaner(ville2);
  
  //On remplit les variables correspondant à chaque ville en utilisant la fonction finder()
  rang1=finder(nville1);
  rang2=finder(nville2);
  //Si les villes n'existent pas :
  if rang1==0 then disp("La première ville n''est pas référencée dans notre base de données"); 
    disp("Vérifiez l''orthographe, on ne sait jamais.");
  elseif rang2==0 then disp("La seconde ville n''est pas référencée dans notre base de données");
    disp("Vérifiez l''orthographe, on ne sait jamais.");
  else    //Creation de la matrice de coordonnées (différente si il existe des doublons)
     if Value(rang1+1,3)==1|Value(rang2+1,3)==1 then C=doublon(rang1,rang2,ville1,ville2); //On vérifie si il y a des doublons et on remplit la matrice.
     else C=coord(rang1,rang2); //Remplissage normal
     end
  //Calcul de la distance
  d=calculdistance(C);
  
  //Affichage du résultat final.
  disp(" ");
  disp(" ");
  affichage(C,ville1,ville2,d);
  
  end
end
end