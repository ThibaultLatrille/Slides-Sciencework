figure()
uicontrol("BackgroundColor",[0.20,0.56,0.12],"String", "Calcul de Distance", "Position", [10 10 110, 25], "Callback", "utt()");
uicontrol("BackgroundColor",[0.80,0.45,0.05],"String", "Itinéraire", "Position", [130 10 100, 25],"Callback", "itineraire()");
uicontrol("BackgroundColor",[0.12,0.45,0.77],"String", "Coupes topographiques", "Position", [240 10 125, 25], "Callback", "topo()");
uicontrol("BackgroundColor",[0.85,0.05,0.05],"String", "Quitter", "Position", [375 10 100, 25], "Callback", "delete(gcf())");







