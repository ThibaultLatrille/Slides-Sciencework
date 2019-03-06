function [nville1]=cleaner(ville1) //Remplace tous les caractères non supportés par scilab
  nville1=strsubst(ville1,"é","e");
  nville1=strsubst(nville1,"è","e");
  nville1=strsubst(nville1,"à","a");
  nville1=strsubst(nville1,"ç","c");
  nville1=strsubst(nville1,"-","");
  nville1=strsubst(nville1,"â","a");
  nville1=strsubst(nville1,"ê","e");
  nville1=strsubst(nville1,"î","i");
  nville1=strsubst(nville1,"ô","o");
  nville1=strsubst(nville1,"û","u");
  nville1=strsubst(nville1,"ù","u");
  nville1=strsubst(nville1,"ö","o");
  nville1=strsubst(nville1,"ü","u");
  nville1=strsubst(nville1,"ï","i");
  nville1=strsubst(nville1," ","");
  nville1=strsubst(nville1,"''","");
  nville1=convstr(nville1,'l');  
endfunction  

//-------------------------------------------------------------------------------------------------------------------------------

function [y]=finder(V)//Trouve le rang de la ville dans la liste
  n=max(size(SST));
  ville=str2code(V);//On convertit le nom de la ville
  L=length(ville);
  vect=0;
  l=0;
  y=0;
  test1=0;
  test2=0;
  compt=1;
  compt2=1;
  //Boucle 1 permettant la comparaison du nom de la ville à celui de chaque ville de la liste
  while (test1==0)&(compt<=n) do vect=str2code(SST(compt)); //On convertit le nom de la ville au rang "compt"          
                                 l=length(vect);
                                 compt2=1;
                                 test2=0;
                            if l==L then //Comparaison des longueurs des noms (évite une boucle inutile)
                                         while (test2==0)&(compt2<=l) do //Boucle 2 comparant chaque lettre une à une
                                                                       if vect(compt2)<>ville(compt2) then test2=1;//Arrêt boucle 2
                                                                       else compt2=compt2+1;                                                                                                end 
                                         end                             
                                         if test2==0 then y=compt;//Renvoi du rang correspondant
                                                          test1=1;//Arrêt de la boucle 1
                                         else compt=compt+1;
                                         end
                            else compt=compt+1;
                            end    
                          end                      
endfunction                        

//-------------------------------------------------------------------------------------------------------------------------------
                        
function [coords]=Matdoublon(rang)//Crée la matrice utilisée dans choix à partir des coordonnées des villes homonymes.
test=1;
j=2;
//Remplissage de la première ligne de la matrice avec les coordonnées de la première ville
coords(1,1)=Value(rang,1);
coords(1,2)=Value(rang,2);
while test==1 do //On regarde si la ville suivante est toujours un doublon, puis on remplit la ligne correspondante dans la matrice
coords(j,1)=Value(rang+1,1); coords(j,2)=Value(rang+1,2); rang=rang+1; j=j+1;
test=Value(rang+1,3);
end
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [coord]=transform(coord)//Convertit les cordonnées lat/long en pixels pour correspondre à la carte de France
  n=length(coord(:,1))
  h=386 //hauteur  
  w=393 //largeur
  maxlat=51.1
  minlat=42.3
  maxlong=8.3
  minlong=-5.2
  for i=1:n do coord(i,1)=floor((coord(i,1)-minlat)*h/(maxlat-minlat))
               coord(i,2)=floor((coord(i,2)-minlong)*w/(maxlong-minlong))
  end
endfunction  
                      //-------------------------------------------------------------------------------------------------------------------------------

function [y]=choix(coord,ville)// Permet le choix d'une ville parmi ses homonymes en les affichant sur une carte.
// "ville" est une chaine de caractères, le nom de la ville qui existe plusieurs fois en France. "coord" est une matrice de deux colonnes : la première correspondant aux latitudes et la deuxième aux longitudes. Chaque ligne contient les coordonnées d'une ville
RGB = ReadImage('C:\Program Files\scilab-5.2.1\contrib\france1.jpg');
[image, ColorMap] = RGB2Ind(RGB);
FigureHandle = ShowImage(image, 'Example', ColorMap); //affiche l'image en couleur !!! nécessite Image Processing Design !!!
coordIm=transform(coord) //coordIm est le transformé des coordonnées lat et long en des coordonnées adapté à l'image
n=length(coord(:,1)); //nombre de ville du même nom
for i=1:n do xstring(coordIm(i,2),coordIm(i,1),ville)
             xstring(coordIm(i,2),coordIm(i,1),"+")
end 
Click=xclick()
D=999999;d=0;y=0;compt=1
for i=1:n do d=(coordIm(i,2)-Click(2))^2+(coordIm(i,1)-Click(3))^2;
  if d<D then D=d;
    y=coord(i,1);
    y(1,2)=coord(i,2);
    compt=i;
  end
end 
// y les coordonné en lat et long de la ville la plus proche du clic 
xstring(coordIm(compt,2),coordIm(compt,1),ville,0,1)
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [D]=doublon(rang1,rang2,ville1,ville2)//Crée la matrice de coordonnées dans le cas où il y a des doublons
  if (Value(rang1+1,3)==1)&(Value(rang2+1,3)==0) then //La 1ère ville est un doublon
  D(1,:)=choix(Matdoublon(rang1),ville1);
  D(2,1)=Value(rang2,1);
  D(2,2)=Value(rang2,2);
  elseif (Value(rang1+1,3)==0)&(Value(rang2+1,3)==1) then //La seconde ville est un doublon
  D(2,:)=choix(Matdoublon(rang2),ville2);
  D(1,1)=Value(rang1,1);
  D(1,2)=Value(rang1,2);
  else D(1,:)=choix(Matdoublon(rang1),ville1); //Les deux villes sont des doublons
  D(2,:)=choix(Matdoublon(rang2),ville2);
 end
endfunction  

//-------------------------------------------------------------------------------------------------------------------------------

function [C]=coord(y1,y2)//Crée la matrice de coordonnées dans le cas normal
// 1ere colonne ---> latitudes
// 2eme colonne ---> longitudes
C(1,1)=Value(y1,1);
C(1,2)=Value(y1,2);    
C(2,1)=Value(y2,1);          
C(2,2)=Value(y2,2);
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [d]=calculdistance(C) //Calcule la distance entre les deux points en utilisant les coordonnées sphériques 
  //theta est la longitude
  //phi est la latitude
phi=C(1,1)*%pi/180
theta=C(1,2)*%pi/180
phi1=C(2,1)*%pi/180
theta1=C(2,2)*%pi/180
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

function []=affichage(C,ville1,ville2,d)//Affiche la carte de france avec le nom des villes et la distance qui les sépare.
RGB = ReadImage('C:\Program Files\scilab-5.2.1\contrib\france1.jpg');
[image, ColorMap] = RGB2Ind(RGB);
FigureHandle = ShowImage(image, 'Example', ColorMap);
coordIm=transform(C)
if d>=100 then
xstring(coordIm(1,2),coordIm(1,1),ville1)
xstring(coordIm(2,2),coordIm(2,1),ville2)
xpoly([coordIm(1,2),coordIm(2,2)],[coordIm(1,1),coordIm(2,1)],"lines",1);
d=round(d);
d=string(d)+" Km";
xstring((coordIm(1,2)+coordIm(2,2))/2,(coordIm(1,1)+coordIm(2,1))/2,d);
else 
  yhaut=max(coordIm(1,1),coordIm(2,1));
  if yhaut=coordIm(1,1) then xhaut=coordIm(1,2);yhaut=yhaut+5;ybas=coordIm(2,1)-5;xbas=coordIm(2,2);                                 villehaut=ville1;villebas=ville2;
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

