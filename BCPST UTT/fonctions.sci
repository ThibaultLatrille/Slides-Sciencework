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
RGB = ReadImage('C:\Users\Thibault\Documents\Scilab\UTT\france1.jpg');
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

function []=affichage(C,ville1,ville2,d)//Affiche la carte de france avec le nom des villes et la distance qui les sépare.
RGB = ReadImage('C:\Users\Thibault\Documents\Scilab\UTT\france1.jpg');
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
  if yhaut==coordIm(1,1) then xhaut=coordIm(1,2);yhaut=yhaut+5;ybas=coordIm(2,1)-5;xbas=coordIm(2,2);                                 villehaut=ville1;villebas=ville2;
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

//-------------------------------------------------------------------------------------------------------------------------------

function [nville]=bonneville()
  mess=["Entrez le nom de la ville"];ville=x_mdialog('Nom de la ville ',mess,['']); nville=cleaner(ville);rang=finder(nville);
  while rang==0 do messagebox("La ville n''est pas référencée dans notre base de données. Vérifiez l''orthographe, on ne sait jamais!", "Oups! Il y a un problème!", "warning", "Corriger le nom","modal");
mess=['Nouveau nom']; ville=x_mdialog('Correction ',mess,['']); nville=cleaner(ville);rang=finder(nville);end
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [rang1]=bonneville1(rang1)
  while rang1==0 do messagebox("La première ville n''est pas référencée dans notre base de données. Vérifiez l''orthographe, on ne sait jamais!", "Oups! Il y a un problème!", "warning", "Corriger le nom","modal");
                    mess=['Nouveau nom']; ville1=x_mdialog('Correction ',mess,['']); nville1=cleaner(ville1);rang1=finder(nville1);end
endfunction

//-------------------------------------------------------------------------------------------------------------------------------

function [rang1]=bonneville2(rang1)
  while rang1==0 do messagebox("La deuxième ville n''est pas référencée dans notre base de données. Vérifiez l''orthographe, on ne sait jamais!", "Oups! Il y a un problème!", "warning", "Corriger le nom","modal");
                    mess=['Nouveau nom']; ville1=x_mdialog('Correction ',mess,['']); nville1=cleaner(ville1);rang1=finder(nville1);end
endfunction
 
//-------------------------------------------------------------------------------------------------------------------------------
                 
function [F1]=crossover(Pa1,Pa2,a,b) //crossing over de deux individus
n=length(Pa1);
F1=zeros(1,n);M=zeros(1,n);
for i=a:b do t=Pa1(1,i); M(1,t)=t; end; //matrice M d'arret pour la boucle while
for k=a:b do F1(1,k)=Pa1(k); end;       // liste F1 contenant la sequence de Pa1 entre a et b
cont=1;
f=findeur(Pa2,Pa1(b));                   // f est l'indice dans Pa2 de Pa1(b)
while cont==1 do if (f<n)&(M(Pa2(f+1))==0)&(b<n) then F1(1,b+1)=Pa2(f+1);M(1,Pa2(f+1))=Pa2(f+1);f=f+1;b=b+1;
                 elseif (f<n)&(M(Pa2(f+1))==0)&(b==n) then F1(1,1)=Pa2(f+1); M(1,Pa2(f+1))=Pa2(f+1);f=f+1;b=1;
                 elseif (f==n)&(M(Pa2(1))==0)&(b<n) then F1(1,b+1)=Pa2(1,1); M(1,Pa2(1))=Pa2(1);f=1;b=b+1;
                 elseif (f==n)&(M(Pa2(1))==0)&(b==n) then F1(1,1)=Pa2(1,1); M(1,Pa2(1))=Pa2(1);f=1;b=1;
                 elseif (f==n)&(M(Pa2(1))<>0) then f=1;
                 else f=f+1; 
                 end;
                 zero=1;  
                 for s=1:n do if M(1,s)==0 then zero=0; end;end;
                 if zero==1 then cont=0; end;
end;
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [L]=init(n,nb);  //population avec nb d'individus
for i=1:nb do L(i,:)=permalea(n);end; 
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [y]=alea(d);   // nbr aleatoire entre 1 et n
y=floor(d*rand())+1;
if y==d+1 then y=d;end;
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [T]=coordist(C); //matrice de distance entre les villes
n=length(C(:,1));
for j=1:n do 
  for i=1:n do T(i,j)=calculdistance(C,i,j)
end;
end;  
endfunction;

//-------------------------------------------------------------------------------------------------------------------------------

function [L]=echange(L,i,j); //echange deux villes dans un individus
tran=L(i);
L(i)=L(j);
L(j)=tran;
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
  for i=1:n do T=echange(T,i,alea(n))
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
  n=x_mdialog('Nombre de villes',["Nombre de villes"],['']);
  n=evstr(n);
  for i=1:n do ville=bonneville();
               nom(i)=ville;
               rang=finder(ville);
               if Value(rang+1,3)==1 then coord=Matdoublon(rang);
                                       Carte(i,:)=choix(coord,ville);
               else Carte(i,1)=Value(rang,1);
                    Carte(i,2)=Value(rang,2);
         end                
end
C=transform(Carte);
RGB = ReadImage('C:\Users\Thibault\Documents\Scilab\UTT\france1.jpg');
[image, ColorMap] = RGB2Ind(RGB);
FigureHandle = ShowImage(image, 'Example', ColorMap);                 
minim=999999999;  //carte des villes avec les X ds la colonne 1 et Y ds la colonne 2
Tab=coordist(Carte);     //matrice des distances entre les villes
for k=1:ceil(n/2) do           //nbr de rush
 Pop=init(n,40);    //40=nbr d'individus ds la population                  
 for i=1:floor(n^2) do     //nbr de reproduction dans un rush
  Sele=selection(Tab,Pop);  //individu de la pop classé ds l'ordre croissant
  Pa1=Pop(Sele(1),:);Pa2=Pop(Sele(2),:);Pa3=Pop(Sele(3),:);Pa4=Pop(Sele(4),:); //4 meilleur individus
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; if a>b then biz=a;a=b;b=biz; end;
  Pop(1,:)=crossover(Pa1,Pa2,a,b);
  Pop(2,:)=crossover(Pa4,Pa3,a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(3,:)=echange(Pop(2,:),a,b);
  Pop(4,:)=echange(Pop(3,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(5,:)=echange(Pop(2,:),a,b);
  Pop(6,:)=echange(Pop(3,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; if a>b then biz=a;a=b;b=biz; end;
  Pop(7,:)=crossover(Pa2,Pa3,a,b);
  Pop(8,:)=crossover(Pa1,Pa4,a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(9,:)=echange(Pop(7,:),a,b);
  Pop(10,:)=echange(Pop(8,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(11,:)=echange(Pop(7,:),a,b);
  Pop(12,:)=echange(Pop(8,:),a,b);
  Pop(13,:)=Pa3;
  Pop(14,:)=Pa2;
  Pop(15,:)=Pa1;
  Pop(16,:)=Pa4;
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; if a>b then biz=a;a=b;b=biz; end;
  Pop(17,:)=crossover(Pa2,Pa1,a,b);
  Pop(18,:)=crossover(Pa3,Pa4,a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end;
  Pop(19,:)=echange(Pop(17,:),a,b);
  Pop(20,:)=echange(Pop(18,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(21,:)=echange(Pop(17,:),a,b);
  Pop(22,:)=echange(Pop(18,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; if a>b then biz=a;a=b;b=biz; end;
  Pop(23,:)=crossover(Pa1,Pa2,a,b);
  Pop(24,:)=crossover(Pa1,Pa3,a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(25,:)=echange(Pop(23,:),a,b);
  Pop(26,:)=echange(Pop(24,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(27,:)=echange(Pop(23,:),a,b);
  Pop(28,:)=echange(Pop(24,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; if a>b then biz=a;a=b;b=biz; end;
  Pop(29,:)=crossover(Pa1,Pa2,a,b);
  Pop(30,:)=crossover(Pa4,Pa3,a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(31,:)=echange(Pop(29,:),a,b);
  Pop(32,:)=echange(Pop(30,:),a,b);
  Pop(33,:)=echange(Pop(3,:),a,b);
  Pop(34,:)=echange(Pop(6,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(35,:)=echange(Pop(29,:),a,b);
  Pop(36,:)=echange(Pop(30,:),a,b);
  a=alea(n);b=alea(n);while b==a do a=alea(n);b=alea(n); end; 
  Pop(37,:)=echange(Pop(2,:),a,b);
  Pop(38,:)=echange(Pop(3,:),a,b);
  Pop(39,:)=echange(Pop(23,:),a,b);
  Pop(40,:)=echange(Pop(24,:),a,b);
  end;
 if longueur(Tab,Pa1)<minim then minim=longueur(Tab,Pa1); Pa=Pa1; end  
end;
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

//-------------------------------------------------------------------------------------------------------------------------------
function [rang]=finder(V)//Trouve le rang de la ville dans la liste
  test=%F;n=max(size(SST));
  rang=1;
  while test==%F&rang<=n do test=SST(rang)==V; rang=rang+1;
  end
endfunction