//n est le nombre de villes
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