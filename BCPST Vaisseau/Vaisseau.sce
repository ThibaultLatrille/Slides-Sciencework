exec('C:\Users\Thibault\Desktop\Vaisseau\triangle.sci')
exec('C:\Users\Thibault\Desktop\Vaisseau\choixpseudo.sci')
pseudo="Jack";
couleur=5;
f=figure();
time=uicontrol("BackgroundColor",[0.20,0.56,0.12],"String", "Nouveau jeu", "Position", [10 10 110, 25], "Callback", "newgame(pseudo,couleur)");
pseudo=uicontrol("BackgroundColor",[0.80,0.45,0.05],"String", "Choix du pseudo", "Position", [130 10 100, 25],"Callback", "choixpseudo()");
couleur=uicontrol("BackgroundColor",[0.12,0.45,0.77],"String", "Couleur du vaisseau", "Position", [240 10 125, 25], "Callback", "choixcouleur()");
uicontrol("BackgroundColor",[0.85,0.05,0.05],"String", "Quitter", "Position", [375 10 100, 25], "Callback", "delete(gcf())");






