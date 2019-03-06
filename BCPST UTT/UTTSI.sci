// La fonction utt permet de calculer la distance entre deux villes parmis les 35249 villes de la base de données, en assimillant la terre à une sphère.
// On posséde 2 vecteurs : SST contient le nom de villes dans l'ordre alphabétique. Value contient les coordonéees GPS des villes, dans le même ordre que SST.
// La 1ere colonne de Value contient les latitudes, la 2ème colonne les longitudes. La 3ème colonne indique si la ville est un doublon, c'est à dire si il existe
// plusieurs villes qui ont le même nom. Cette colonne ne contient que des zeros sauf pour les villes dont la suivante sur la liste posséde le même nom. 
// Dans ce cas la valeur de la 3ème colonne est 1.

//Chargement de la base de données.
//Ouverture de la liste des villes contenue dans Mat2.dat
fd=mopen('C:\Users\thibault\Desktop\UTT\Mat2.Dat','rb');
load(fd,"SST");
mclose(fd);
//Ouverture de la liste des latitudes contenue dans lat
X=fscanfMat('C:\Users\thibault\Desktop\UTT\lat');
//Ouverture de la liste des longitudes contenue dans long.dat
fd=mopen('C:\Users\thibault\Desktop\UTT\long.Dat','rb');
load(fd,"Y");
mclose(fd);
//Ouverture de la liste des doublons contenue dans doublon.
Z=fscanfMat('C:\Users\thibault\Desktop\UTT\doublon');
//Création de la matrice Value : [Latitude, Longitude, Doublon].
Value(:,1)=X;
Value(:,2)=Y;
Z(1)=[];Z(length(X))=0
Value(:,3)=Z;

function [nville1]=cleaner(ville1) //Remplace tous les caractères non supportés par scilab
 nville1=strsubst(ville1,"é","e"); nville1=strsubst(nville1,"è","e"); nville1=strsubst(nville1,"à","a");
 nville1=strsubst(nville1,"ç","c"); nville1=strsubst(nville1,"-","");
 nville1=strsubst(nville1,"â","a"); nville1=strsubst(nville1,"ê","e");
 nville1=strsubst(nville1,"î","i"); nville1=strsubst(nville1,"ô","o");
 nville1=strsubst(nville1,"û","u"); nville1=strsubst(nville1,"ù","u"); 
 nville1=strsubst(nville1,"ö","o"); nville1=strsubst(nville1,"ü","u");
 nville1=strsubst(nville1,"ï","i"); nville1=strsubst(nville1," ","");
 nville1=strsubst(nville1,"''",""); nville1=convstr(nville1,'l');  
endfunction  

//-------------------------------------------------------------------------------------------------------------------------------

function [rang]=finder(V)//Trouve le rang de la ville dans la liste (SST) à partir de son nom
  test=%F;n=max(size(SST));
  rang=1;//initialisation
  while test==%F&rang<=n do test=SST(rang)==V // on retourne dans la boucle si la ville n'est pas trouvé
                            rang=rang+1 //et on incremente le rang de +1
  end
  if test==%F&rang==n+1 then rang=0 // Pour ne pas oublier les 583 Habitants de Zuytpeene, dernière ville de france dans l'ordre alphabetiques...
      else rang=rang-1             // On est obligé de voir si l'arret de la boucle est due au test ou si rang==n
  end
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [coord]=transform(coord)
    //Convertit les cordonnées lat/long en pixels pour correspondre à la carte de France
    // la carte est volontairement deformé pour qu'il y'ait proportionnalité entre lat/long et pixels
  n=length(coord(:,1))
  h=386 //hauteur  
  w=393 //largeur
  maxlat=51.1
  minlat=42.3
  maxlong=8.3
  minlong=-5.2
  for i=1:n do coord(i,1)=floor((coord(i,1)-minlat)*h/(maxlat-minlat)) //il s'agit d'une régle de 3
               coord(i,2)=floor((coord(i,2)-minlong)*w/(maxlong-minlong))
  end
endfunction  

//-------------------------------------------------------------------------------------------------------------------------------

function [y,ville]=bonneville(i,texte)
  mess=["Entrez le nom de la '+string(i)+string(texte)+' ville"];ville=x_mdialog('Nom de la '+string(i)+string(texte)+' ville ',mess,['']); nville=cleaner(ville);rang=finder(nville); // on cherche l'indice de la ville dans SST
  while rang==0 do messagebox("La ville n''est pas référencée dans notre base de données. Vérifiez l''orthographe, on ne sait jamais!", "Oups! Il y a un problème!", "warning", "Corriger le nom","modal");
mess=['Nouveau nom']; ville=x_mdialog('Correction ',mess,['']); nville=cleaner(ville);rang=finder(nville);end 
// Tant que la ville n'est pas référencée on recommence
if Value(rang,3)==1 then // Si la ville est un doublon on affiche sur la carte de france tout les doublons et le choix se fait par un clic de souris.
    j=1
    coord(j,1)=Value(rang,1); coord(j,2)=Value(rang,2)
    while Value(rang,3)==1 do j=j+1;
                              rang=rang+1;
                              coord(j,1)=Value(rang,1); coord(j,2)=Value(rang,2) // On fabrique une matrice contenant toutes les coordonées des villes du même nom.
    end
    RGB = ReadImage('C:\Users\thibault\Desktop\UTT\france1.jpg');
    [image, ColorMap] = RGB2Ind(RGB);
    FigureHandle = ShowImage(image, 'Example', ColorMap); //affiche l'image de la france en couleur !!! nécessite Image Processing Design !!!
    coordIm=transform(coord) //coordIm est le transformé des coordonnées lat et long en des coordonnées adapté à l'image
    n=length(coord(:,1)); //nombre de ville du même nom (au moins 2)
    for i=1:n do xstring(coordIm(i,2),coordIm(i,1),ville)
             xstring(coordIm(i,2),coordIm(i,1),"+")
    end 
    Clic=xclick() // Clics contient les coordonnées en pixel du clic
D=999999;d=0;y=0;compt=1
for i=1:n do d=(coordIm(i,2)-Clic(2))^2+(coordIm(i,1)-Clic(3))^2;
  if d<D then D=d;
    y=coord(i,1);
    y(1,2)=coord(i,2);
    compt=i;
  end
end 
// y contient les coordonnées en lat et long de la ville la plus proche du clic 
xstring(coordIm(compt,2),coordIm(compt,1),ville,0,1)
else y=Value(rang,1);y(1,2)=Value(rang,2)
end
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [d]=calculdistance(C,i,j) //Calcule la distance entre les deux points en utilisant les coordonnées sphériques 
  //theta est la longitude
  //phi est la latitude
phi=C(i,1)*%pi/180
theta=C(i,2)*%pi/180
phi1=C(j,1)*%pi/180
theta1=C(j,2)*%pi/180
x=6378*cos(phi)*cos(theta)
y=6378*cos(phi)*sin(theta)
z=6378*sin(phi)
X=6378*cos(phi1)*cos(theta1)
Y=6378*cos(phi1)*sin(theta1)
Z=6378*sin(phi1)
d=sqrt((z-Z)^2+(x-X)^2+(y-Y)^2)
alpha=2*asin(d/(2*6378))
D=6378*alpha
endfunction   

//-------------------------------------------------------------------------------------------------------------------------------

function []=affichage(y1,y2,ville1,ville2,d)//Affiche la carte de france avec le nom des villes et la distance qui les sépare.
RGB = ReadImage('C:\Users\thibault\Desktop\UTT\france1.jpg');
[image, ColorMap] = RGB2Ind(RGB);
FigureHandle = ShowImage(image, 'Example', ColorMap);
coordIm=transform([y1;y2])
if d>=100 then
xstring(coordIm(1,2),coordIm(1,1),ville1)
xstring(coordIm(2,2),coordIm(2,1),ville2)
xpoly([coordIm(1,2),coordIm(2,2)],[coordIm(1,1),coordIm(2,1)],"lines",1);
d=round(d);
d=string(d)+" Km";
xstring((coordIm(1,2)+coordIm(2,2))/2,(coordIm(1,1)+coordIm(2,1))/2,d);
else 
  yhaut=max(coordIm(1,1),coordIm(2,1));
  if yhaut==coordIm(1,1) then xhaut=coordIm(1,2);yhaut=yhaut+5;ybas=coordIm(2,1)-5;xbas=coordIm(2,2); villehaut=ville1;villebas=ville2;
  else yhaut=yhaut+5; xhaut=coordIm(2,2); ybas=coordIm(1,1)-5;xbas=coordIm(1,2); villehaut=ville2;villebas=ville1;
  end  
xstring(xhaut,yhaut,villehaut);
xstring(xbas,ybas,villebas);
xpoly([coordIm(1,2),coordIm(2,2)],[coordIm(1,1),coordIm(2,1)],"lines",1);
d=round(d);
d=string(d)+" Km";
xstring((xhaut+xbas)/2,(yhaut+ybas)/2,d);
uicontrol("String", "Close the window", "Position", [10 10 100, 25], "Callback", "delete(gcf())");
end
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function []=utt()
[y1,ville1]=bonneville(1,'ère')
[y2,ville2]=bonneville(2,'ème')
//Calcul de la distance
d=calculdistance([y1;y2],1,2)
//Affichage du résultat final.
affichage(y1,y2,ville1,ville2,d);
endfunction

// l'objectif de itinéraire est de trouver le chemin le plus court qui passe une seule fois par ville.
// Soit n le nombre de ville
// A chaque ville on associe un nombre entre 1 et n
// On appelle itinéraire un vecteur de taille n qui contient tout les nombres de 1 à n 
// (il y n! itinéraires différents)
// L'algorithme présenté est un algorithme génétique. 
// On génère au départ k itinéraires aléatoires, puis on garde 4 les plus courts. 
// On regénère une 'population' de k itinéraires à partir de ces 4 itinéraires en leur faisant 
// subir des 'mutations' aléatoires (crossing over,echange) mais on garde ces 4 itinéraires.
// On selectionne à nouveau les 4 plus courts dans cette nouvelle population et on réhitere l'opération
// L'algorithme s'arrete lorsqu'il atteint la fin de la boucle-(1)
// On réalise plusieurs fois cette opération pour avoir un résultat plus sûr. (boucle-(2))

function [L]=init(n,nb);  //population avec nb d'individus
for i=1:nb do L(i,:)=permalea(n);end; 
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [T]=coordist(C); //matrice de distance entre les villes
n=length(C(:,1));
for j=1:n do 
  for i=1:n do T(i,j)=calculdistance(C,i,j)
  end
end  
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [L]=echange(L,i,j); //echange deux villes dans un individus
L(i)=L(i)+L(j);
L(j)=L(i)-L(j);
L(i)=L(i)-L(j);
endfunction; 

//-------------------------------------------------------------------------------------------------------------------------------

function [i]=findeur(C,a)   //donne le rang de a dans une matrice
n=length(C(1,:));i=0;
for j=1:n do if C(j)==a then i=j; end; end;  
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [s]=longueur(T,I); //longueur total d'un individus (un chemin)
s=0;tai=length(I);
for i=1:tai-1 do l=T(I(i),I(i+1));s=s+l; end;
l=T(I(tai),I(1));
s=s+l;                    
endfunction;  

//-------------------------------------------------------------------------------------------------------------------------------

function [T]=permalea(n); //chemins créés aléatoirement
  for i=1:n do T(1,i)=i;
  end
  for i=1:n do T=echange(T,i,ceil(n*rand()))
  end
endfunction   

//-------------------------------------------------------------------------------------------------------------------------------

function [TT]=selection(T,P) //indices des individus classé dans l'ordre croissant
Y=P(:,1)
nb=length(Y)
for i=1:nb do L(1,i)=longueur(T,P(i,:));
end;
TT=tri(L);
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [T]=tri(L); // la liste des indices de L triées dans l’ordre de L
n=length(L);maximum=max(L); 
for i=1:n do m=L(1);rang=1;
             for k=1:n do if L(k)<m then m=L(k); rang=k; end; end;
             T(1,i)=rang;
             L(rang)=maximum+1,
end;             
endfunction;  

//-------------------------------------------------------------------------------------------------------------------------------

function []=itineraire()
  n=x_mdialog('Nombre de villes',["Nombre de villes"],[''])
  n=evstr(n)// n le nombre de villes
  [Carte(1,:),nom(1)]=bonneville(1,'ère')
  for i=2:n do [Carte(i,:),nom(i)]=bonneville(i,'ème')
  end // Carte contient n lignes qui sont les coordonnées latitude longitude des villes 
C=transform(Carte)//conversion des coordonnées Lat/Long en pixel adapté à la carte
RGB = ReadImage('C:\Users\thibault\Desktop\UTT\france1.jpg');
[image, ColorMap] = RGB2Ind(RGB)
FigureHandle = ShowImage(image, 'Example', ColorMap) //on affiche la carte de france
minim=999999999  //carte des villes avec les X ds la colonne 1 et Y ds la colonne 2
Tab=coordist(Carte)     //matrice des distances entre les villes
for k=1:ceil(n/2) do           // boucle-(2)
 Pop=init(n,40);    //On génère 40 itinéraires aléatoirement
 for i=1:floor(n^2) do     // boucle-(1)
  Sele=selection(Tab,Pop);  //itinéraires classés ds l'ordre croissant
  Pa1=Pop(Sele(1),:);Pa2=Pop(Sele(2),:);Pa3=Pop(Sele(3),:);Pa4=Pop(Sele(4),:); 
  //4 itinéraires les plus courts
   for i=5:40 do // on génère le reste de la population à partir des 4 parents
    Na=rand()//nombre aléatoire entre 0 et 1
    // si il est plus petit que 0.5 alors crossover sinon echange
    if ceil(2*Na)==1 then Na=10*Na-floor(10*Na) // on génère un nouveau nombre pseudo aléatoire
                          [a,b]=rand2(4,Na) //on choisit 2 parents parmis les quatres
                          [c,d]=rand2(n,Na) //on choisit les deux extremités du crossover
                          Pop(i,:)=crossover1(evstr('Pa'+string(a)),evstr('Pa'+string(b)),min(c,d),max(c,d));
                          // on réalise le crossover grace au quatres nombres aléatoires a,b,c,d
                     else Na=10*Na-floor(10*Na)
                          a=ceil(n*Na) //on choisit le parent qui subira l'échange
                          [c,d]=rand2(n,Na) //on choisit les deux villes que l'on va echanger
                          Pop(i,:)=echange(evstr('Pa'+string(a)),c,d); // on réalise l'échange
                     end
   end
 end
 if longueur(Tab,Pa1)<minim then minim=longueur(Tab,Pa1); Pa=Pa1; end  
end
Min="La distance totale est de "+string(minim)+" km"
xstring(20,400,Min);
j=1;
Carte=transform(Carte)
for j=1:n do Car1(j,2)=Carte(Pa(j),1);            
             Car1(j,1)=Carte(Pa(j),2);
             xstring(C(j,2),C(j,1),nom(j));  
end;
Car1(n+1,2)=Carte(Pa(1),1);            
Car1(n+1,1)=Carte(Pa(1),2);                    
X=(Car1(:,1)); //X du chemin le plus court
Y=(Car1(:,2)); //Y du chemin le plus court
plot(X,Y);
endfunction

function [a,b]=rand2(n,Na)
    // rand2 est un fonction qui génère deux nombres entiers aléatoires distincts entre 1 et n
    // à partir de Na qui est un nombre aléatoire réelle entre 0 et 1.
    // L'astuce est qu'en faisant 10*Na-floor(10*Na), on obtient un nouveau 
    // nombre nombre aléatoire réelle entre 0 et 1 à partir de Na
    a=ceil(n*Na); b=a;
    while a==b do Na=10*Na-floor(10*Na)
                  b=ceil(n*Na)
    end
endfunction

function [Pa2]=crossover1(Pa1,Pa2,a,b) //crossing over de deux individus
    // Dans un crossing over on créer un nouvel itinéraire à partir de 2 (Pa1 et Pa1)
    // On regarde l'arrangement des ville de Pa1 entre les indices a et b.
    // Et on modifie Pa2 pour qu'il posséde cet arrangement sans modifier l'ordre des autres villes
n=length(Pa1);
x=findeur(Pa2,Pa1(a))
if x<>1 then C=Pa2(1,1:x-1)
             Pa2(1,1:x-1)=[]
             Pa2(1,n-x+2:n)=C //on coupe le vecteur avant x, on remet cette partie à la fin
end
for i=a+1:b do // pour chaque valeurs entre a+1 et b on réarange l'itinéraire Pa2 pour qu'il corresponde avec Pa1.
    x=findeur(Pa2,Pa1(i))
    Test=(i==n)&(a==1)
    if Pa2(i-a+1)<>Pa1(i)&Test==%F then
        C=Pa2(1,i-a+1:x-1)
        Pa2(i-a+1)=Pa1(i)
        Pa2(1,i-a+2:x)=C
    end
end
endfunction