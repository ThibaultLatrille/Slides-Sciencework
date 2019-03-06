clear

function [miroir]=vecteurnormal(A,B,C)
//miroir est le vecteur normal du plan il contient a,b,c,d td ax+by+cz+d=0
// A,B,C 3 points du plan coordonnées x,y,z
M=[A';B';C'];
M(:,4)=[1;1;1];
miroir=kernel(M); //dans kernel on a un vecteur de quatre qui verifie ax+by+cz+d=0 pour les trois points, dim(kernel(M))=1 <=> les trois points ne sont pas alignés
miroir=1/miroir(1)*miroir // 1ere coordonée=1
endfunction


function [B]=sympoint(plan,A)
  // soit x tq AX=t*N avec N vecteur normal au plan
  // si x verifie l'equation du plan (ax+by+cz+d=0) on Y tq AY=2*t*N,y est le symetrique de A par la plan
  t=-(plan(1)*A(1)+plan(2)*A(2)+plan(3)*A(3)+plan(4))/(plan(1)**2+plan(2)**2+plan(3)**2)
  B(1)=A(1)+plan(1)*2*t;
  B(2)=A(2)+plan(2)*2*t;
  B(3)=A(3)+plan(3)*2*t;
endfunction


function [vd2]=symdroite(vd,cam,plan,cam2)
  pt=sympoint(plan,[vd(1)*100+cam(1),vd(2)*100+cam(2),vd(3)*100+cam(3)]);
  vd2=[pt(1)-cam2(1),pt(2)-cam2(2),pt(3)-cam2(3)]; 
  // pour avoir le vecteur directeur de la droite symetrique par un plan
  // on cherche le symetrique de deux points de la droite different  
endfunction


function [y]=distance(vd1,vc1,vd2,vc2)
  w=[vd1;vd2];
  n=kernel(w), // on obtient dans n le vecteur directeur de la droite orthogonale aux deux autres (produits scalaire nul) 
  V=[vc1(1)-vc2(1),vd1(1),-vd2(1),-n(1);vc1(2)-vc2(2),vd1(2),-vd2(2),-n(2);vc1(3)-vc2(3),vd1(3),-vd2(3),-n(3)];
  // [x1-x2  , xvd1  ,  -xvd2  ,  -xn  ]
  // [y1-y2  , yvd1  ,  -yvd2  ,  -yn  ]
  // [z1-z2  , zvd1  ,  -zvd2  ,  -zn  ]
  S=kernel(V), // on cherche les deux points appartenants aux deux droites qui forment un segment colinéaire à  n
  x=1/S(1); 
  S=S*x; // S=[1,a,b,c] et x1+a*vd1-(x2+b*vd2)=c*xn , y1+a*...
  p1(1)=vc1(1)+S(2)*vd1(1);
  p1(2)=vc1(2)+S(2)*vd1(2);
  p1(3)=vc1(3)+S(2)*vd1(3);
  p2(1)=vc2(1)+S(3)*vd2(1);
  p2(2)=vc2(2)+S(3)*vd2(2);
  p2(3)=vc2(3)+S(3)*vd2(3);
  y=[(p1(1)+p2(1))/2,(p1(2)+p2(2))/2,(p1(3)+p2(3))/2,(p1(1)-p2(1))**2+(p1(2)-p2(2))**2+(p1(3)-p2(3))**2];
  //les coordonnÃ©es du point assimilÃ© Ã  l'intersection des droites ainsi que la distance min entre les deux droites
endfunction 


function [T]=exploitation(tableau)
A=[10;0;0];
B=[100;0;10];
C=[50;0;40]; // A,B,C trois points du miroir
plan=vecteurnormal(A,B,C); // a,b,c,d tq ax+by+cz+d=0 est l'équation du plan du miroir
cam=[266.5;325;89]; // coordonnees de la cam
regle=[11;4.5;89];   // coordonnees de la regle sur la droite de la photo (origine)
centre=[84;69;89];  // coordonnees d'un point qui apparait au centre de la photo
vd1=centre-cam;
vd2=cam-regle;
t=-(vd1(1)*vd2(1)+vd1(2)*vd2(2))/(vd1(1)**2+vd1(2)**2) 
// on cherche xX tq AX=t*vd1 et AX.REGLEX=0 d'où t 
X=[cam(1)+t*vd1(1);cam(2)+t*vd1(2);89] // coordonnees du point qui apparait au centre de la photo et tel que le plan de projection contienne ce point et la regle
// on cherche à exprimer les vecteur dans une nouvelle base tq l'origine est au point X et le vecteur unitaire de la 1ere coordonnée soit dirigé vers la camera
theta=atan((cam(2)-X(2))/(cam(1)-X(1))) // angle diedre entre base orthonormée et la droite camera-X
A=A-X;
B=B-X;
C=C-X;
regle=regle-X;
cam=cam-X; // translation pour etre sur centrée sur X
theta=-theta
M=[cos(theta),-sin(theta),0;sin(theta),cos(theta),0;0,0,1]
A=M*A;
B=M*B;
C=M*C;
regle=M*regle;
cam=M*cam; // rotation qui donne les nouvelles coordonées dans la nouvelle base
plan=vecteurnormal(A,B,C);
cam2=sympoint(plan,cam) // coordonnées dans la nouvllle base
s=size(tableau);
T=zeros(s(1),4)
for i=1:s(1) do 
    vd1=[0-cam(1),tableau(i,1)-cam(2),tableau(i,2)-cam(3)];
     //Vecteur directeur de la droite 1 entre la cam et le projeté de la samare dans plan règle
vd2=[0-cam(1),tableau(i,3)-cam(2),tableau(i,4)-cam(3)];
    //Vecteur directeur de la droite 1 entre la cam et le projeté du reflet de la samare dans plan règle
[vd2]=symdroite(vd2,cam,plan,cam2); //vecteur directeur de la droite symetrique de la droite passant par la camera et le reflet
T(i,:)=distance(vd1,cam,vd2,cam2); // intersection entre ces deux droites qui donne les coordonnées de la samare reel
Vect=[T(i,1);T(i,2);T(i,3)]
Vect=[cos(-theta),-sin(-theta),0;sin(-theta),cos(-theta),0;0,0,1]*Vect;
Vect=Vect+X; // retour dans la base orthonormée d'origine
T(i,1)=Vect(1);
T(i,2)=Vect(2);
T(i,3)=Vect(3); 
T=real(T);
end
endfunction

function [Nx,Ny,Nmaille]=step(x,y,maille,T,accuracy)
    // x,y les coordonnées du point autour duquel on cherche s'il existe des
    // points qui minimise la difference entre distance du dit point a la samare la
    // plus eloigné est celle la plus proche
    // le point qui minimise cette valeur est le centre du cercle....
    // accuracy -->le nombre de points de chaque coté de l'origine 
    // maille --> distance entre deux points consecutif
    n=max(size(T))
    test=9999999; // bidon --> initialisation
    for i=-accuracy:accuracy do
        for j=-accuracy:accuracy do // nombre de points a gauche et à droite de l'origine
            X=x+maille*i; // x du point à tester
            Y=y+maille*j; // y du point à tester
            for l=1:n do
                vect(l)=sqrt((X-T(l,1))**2+(Y-T(l,2))**2) //distance samare-point
            end
            minim=min(vect) //distance à la samare la plus proche
            maxim=max(vect) //distance à la samare la plus proche
            if (maxim-minim)<test then test=maxim-minim
                                       Nx=X
                                       Ny=Y //si on minimise par rapport a la valeur precedente on remplace
            end
        end 
    end
    Nmaille=maille/(2*accuracy) // on creer un nouveau maillage
endfunction 

function [vect,utile]=surexploitation(T)
  n=max(size(T))
  x=mean(T(:,1)) //origine du point qui sert pour l'algo
  y=mean(T(:,2))
  accuracy=60;
  maille=2;
  for i=1:4 do // on repete l'operation 2 fois 
    [Nx,Ny,Nmaille]=step(x,y,maille,T,accuracy) // cf la fonction
    x=Nx;
    y=Ny;
    maille=Nmaille;
  end
  vect(3)=x;//X(Centre)
  vect(4)=y;//Y(centre)
  for i=1:n do
      d(i)=sqrt((T(i,1)-vect(3))**2+(T(i,2)-vect(4))**2);
  end
  vect(1)=mean(d); //Rayon du cercle
for i=1:n-1 do 
  X1=T(i,1)-vect(3);
  Y1=T(i,2)-vect(4);
  X2=T(i+1,1)-vect(3);
  Y2=T(i+1,2)-vect(4);
  d1=sqrt(X1**2+Y1**2);
  d2=sqrt(X2**2+Y2**2);
  X1=X1/d1;
  X2=X2/d2;
  Y1=Y1/d1;
  Y2=Y2/d2;
  theta(i)=asin(X1*Y2-X2*Y1); // angle entre deux images consecutive de la samare
  DZ(i)=abs(T(i+1,3)-T(i,3)) //difference d'altitude entre deux images consecutive de la samare
end
  vect(2)=mean(theta); //angle par image (moyenne)
  vect(5)=mean(DZ); // Delta Z par image (moyenne)
  utile(1)=vect(1)
  utile(2)=300*360*vect(2)/(2*%pi); //vitesse angulaire radian/seconde (moyenne)
  utile(3)=300*vect(5) // vitesse verticale (moyenne)
endfunction


function [T,vect,tableau,utile]=touche(excel)
[fd,SST,Sheetnames,Sheetpos] = xls_open('C:\Users\thibault\Desktop\TIPE2\excel\'+string(excel)+'.xls');
[tableau,TextInd] = xls_read(fd,Sheetpos(1)); // ouverture du fichier excel
mclose(fd)
n=max(size(tableau));
T=exploitation(tableau); //construction du tableau contenant x,y,z a partir du pointage donc de quatre coordonnées
[vect,utile]=surexploitation(T); // extraction des renseignement à partir de la courbe 
endfunction

//[T,vect,tableau,utile]=touche('poids61');
//
//param3d(T(:,1),T(:,2),T(:,3),35,45,"X@Y@Z",[2,4]);
//
//d=sqrt((T(1,1)-vect(3))**2+(T(1,2)-vect(4))**2);
//coor(1,1)=(T(1,1)-vect(3))/d;
//coor(2,1)=(T(1,2)-vect(4))/d;
//M=[cos(vect(2)),-sin(vect(2));sin(vect(2)),cos(vect(2))];
//N(1,1)=coor(1)*vect(1)+vect(3);
//N(1,2)=coor(2)*vect(1)+vect(4);
//N(1,3)=T(1,3)
//for i=2:max(size(T)) do
//  coor=M*coor;
//  N(i,1)=coor(1)*vect(1)+vect(3);
//  N(i,2)=coor(2)*vect(1)+vect(4);
//N(i,3)=N(i-1,3)-vect(5);
//end
//
//param3d(N(:,1),N(:,2),N(:,3),35,45,"X@Y@Z",[2,4]);
//disp(utile)


