function [y]=choixpseudo()
  y=x_mdialog(['Choix du pseudo'],['Quel est votre nom?'],['Jack'])
endfunction

function [y]=choixcouleur()
  y=getcolor();
endfunction
