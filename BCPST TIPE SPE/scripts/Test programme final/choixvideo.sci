

function [Path]=choixvideo()
Path=uigetfile([""],'C:\Users\thibault\Desktop\TIPE\video')
endfunction

function [T,samare2,samare1]=pointer(path)
[samare1,samare2]=pointage(string(path))
tableau=0;
compt=1;
for i=1:max(size(samare1)) do
    if samare1(i,3)<>0 & samare2(i,3)<>0 then 
       tableau(compt,1)=samare2(i,2);
       tableau(compt,2)=-samare2(i,1);
       tableau(compt,3)=samare1(i,2);
       tableau(compt,4)=-samare1(i,1);
       compt=compt+1;
  end
end
n=max(size(tableau))
T=exploitation(tableau);
samaradraw(T)
endfunction

function [vect,nb]=analyser(T,samare1,samare2)
    vect=surexploitation(T);
    nb=(comptage(samare1(:,3))+comptage(samare2(:,3)))/2   
endfunction


function []=sauvegarde(T,nb,vect)
    Name=x_mdialog('Entrez le nom du fichier','Nom :','Samare')
    path=uigetdir('C:\Users\thibault\Desktop\TIPE\Programme final\Database')
    fprintfMat(string(path)+string(Name)+'_coordonnees',T);    
    fprintfMat(string(path)+string(Name)+'_parametres',vect);
    fprintfMat(string(path)+string(Name)+'_nbretour',nb);
endfunction
