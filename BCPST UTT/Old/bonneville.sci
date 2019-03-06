function [nville]=bonneville()
  mess=["Entrez le nom de la ville"];ville=x_mdialog('Nom de la ville ',mess,['']); nville=cleaner(ville);rang=finder(nville);
  while rang==0 do messagebox("La ville n''est pas référencée dans notre base de données. Vérifiez l''orthographe, on ne sait jamais!", "Oups! Il y a un problème!", "warning", "Corriger le nom","modal");
mess=['Nouveau nom']; ville=x_mdialog('Correction ',mess,['']); nville=cleaner(ville);rang=finder(nville);end
endfunction

function [rang1]=bonneville1(rang1)
  while rang1==0 do messagebox("La première ville n''est pas référencée dans notre base de données. Vérifiez l''orthographe, on ne sait jamais!", "Oups! Il y a un problème!", "warning", "Corriger le nom","modal");
                    mess=['Nouveau nom']; ville1=x_mdialog('Correction ',mess,['']); nville1=cleaner(ville1);rang1=finder(nville1);end
endfunction

function [rang1]=bonneville2(rang1)
  while rang1==0 do messagebox("La deuxième ville n''est pas référencée dans notre base de données. Vérifiez l''orthographe, on ne sait jamais!", "Oups! Il y a un problème!", "warning", "Corriger le nom","modal");
                    mess=['Nouveau nom']; ville1=x_mdialog('Correction ',mess,['']); nville1=cleaner(ville1);rang1=finder(nville1);end
endfunction