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

function [L]=init(n,nb);  //population avec nb d'individus
for i=1:nb do L(i,:)=permalea(n);end; 
endfunction;

function [y]=alea(d);   // nbr aleatoire entre 1 et n
y=floor(d*rand())+1;
if y==d+1 then y=d;end;
endfunction;

function [T]=coordist(C); //matrice de distance entre les villes
n=length(C(:,1));
for j=1:n do 
  for i=1:n do T(i,j)=calculdistance(C,i,j)
end;
end;  
endfunction;

function [L]=echange(L,i,j); //echange deux villes dans un individus
tran=L(i);
L(i)=L(j);
L(j)=tran;
endfunction; 

function [i]=findeur(C,a)   //donne le rang de a dans une matrice
n=length(C(1,:));i=0;
for j=1:n do if C(j)==a then i=j; end; end;  
endfunction;

function [s]=longueur(T,I); //longueur total d'un individus (un chemin)
s=0;tai=length(I);
for i=1:tai-1 do l=T(I(i),I(i+1));s=s+l; end;
l=T(I(tai),I(1));
s=s+l;                    
endfunction;  

function [T]=permalea(n); //chemins créés aléatoirement
  for i=1:n do T(1,i)=i;
  end
  for i=1:n do T=echange(T,i,alea(n))
  end
endfunction   

function [TT]=selection(T,P) //indices des individus classé dans l'ordre croissant
Y=P(:,1)
nb=length(Y)
for i=1:nb do L(1,i)=longueur(T,P(i,:));
end;
TT=tri(L);
endfunction;

function [T]=tri(L); // la liste des indices de L triées dans l’ordre de L
n=length(L);maximum=max(L); 
for i=1:n do m=L(1);rang=1;
             for k=1:n do if L(k)<m then m=L(k); rang=k; end; end;
             T(1,i)=rang;
             L(rang)=maximum+1,
end;             
endfunction;  

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
RGB = ReadImage('C:\Program Files\scilab-5.2.1\contrib\france1.jpg');
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