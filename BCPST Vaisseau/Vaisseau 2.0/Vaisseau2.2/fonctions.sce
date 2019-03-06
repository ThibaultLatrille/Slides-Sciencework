function [A,Mat,G,VG]=deplacement(M,Mat,G,VG)
  fact=10;  // constante de la force exercee 
  vfact=2; // constante de la force exercee sur le vaisseau
  dt=0.05855; // pas de temps 
  frein=2; /// pour eviter que l'entropie augmente il faut une force proportionnelle a la vitesse
  nbplanete=length(M)/5;
  ax=0;
  ay=0;
  A=M;
  for j=1:nbplanete do // pour chaque planete on doit calculer son acceleration
    for k=1:nbplanete do      // pour chaque planete son acceleration est la resultante de l'attraction des autres planetes
      if M(k,5)==M(j,5) then a=-fact; // coeff negatif si les planetes ont meme nature (attraction)
      else a=fact; // sinon repulsion des planetes
      end
      if k<>j then // attention a pas calculer l'action de la plante sur elle mÃªme
      ax(k)=a*(M(k,1)-M(j,1))/((M(k,1)-M(j,1))**2+(M(k,2)-M(j,2))**2)**(1/20); //cf geometrie
      ay(k)=a*(M(k,2)-M(j,2))/((M(k,1)-M(j,1))**2+(M(k,2)-M(j,2))**2)**(1/20); // puissance (n+1)/2 dans le cas d'une force en r**n
             else ax(k)=0;
                  ay(k)=0;
      end
    end
    A(j,1)=M(j,1)+M(j,3)*dt; //x(t+dt)=x(t)+v(t)dt cf mecanique et DL1(x)
    A(j,2)=M(j,2)+M(j,4)*dt;
    A(j,3)=M(j,3)+(sum(ax)-frein*M(j,3))*dt; // v(t+dt)=v(t)+a(t)dt cf mecanique
    A(j,4)=M(j,4)+(sum(ay)-frein*M(j,4))*dt;
    if (A(j,1)<0)|(A(j,1)>60) then // si jamais sa sort du cadre par la gauche ou droite la vitesse en x est inversÃ©
      A(j,3)=-A(j,3);
      A(j,4)=A(j,4);
      end
     if (A(j,2)<0)|(A(j,2)>60) then // et inversement
      A(j,3)=A(j,3);
      A(j,4)=-A(j,4);
    end
  end
  for k=1:nbplanete do      // son acceleration est la resultante de l'attraction de toutes les planetes
      if M(k,5)==5 then a=-vfact; // coef negatif si les nature vaisseau est 5
      else a=vfact; // sinon repulsion avec les planetes
      end
      ax(k)=a*(M(k,1)-G(1))/((M(k,1)-G(1))**2+(M(k,2)-G(2))**2)**(1/20); //cf geometrie
      ay(k)=a*(M(k,2)-G(2))/((M(k,1)-G(1))**2+(M(k,2)-G(2))**2)**(1/20); // puissance (n+1)/2 dans le cas d'une force en r**n
    end
  Mat(1,:)=Mat(1,:)+VG(1)*dt; //x(t+dt)=x(t)+v(t)dt cf mecanique et DL1(x)
  G(1)=G(1)+VG(1)*dt;
  Mat(2,:)=Mat(2,:)+VG(2)*dt; //x(t+dt)=x(t)+v(t)dt cf mecanique et DL1(x)
  G(2)=G(2)+VG(2)*dt;
  VG(1)=VG(1)+(sum(ax)-frein*VG(1))*dt; // v(t+dt)=v(t)+a(t)dt cf mecanique
  VG(2)=VG(2)+(sum(ay)-frein*VG(2))*dt;
endfunction

//-----------------------------------------------------------------------------------------------------------------------------------------------------

function colorier(M,N,k,i,couleur)
  for m=1:length(M)/5 do xset("color",M(m,5)*k+i) // i est le choix de la couleur k=0 si on ne veut pas la nature de la planete intervienne
    //xfpoly([M(m,1)-1,M(m,1)+1,M(m,1)+1,M(m,1)-1],[M(m,2)-1,M(m,2)-1,M(m,2)+1,M(m,2)+1])
    xfarc(M(m,1)-1,M(m,2)+1,2,2,0,23040);
    end
    if k=0 then
    xset("color",1);
    xfpoly(N(1,:),N(2,:)) 
    elseif k=1 then
     xset("color",couleur);
     xfpoly(N(1,:),N(2,:)) 
    end
endfunction


//-----------------------------------------------------------------------------------------------------------------------------------------------------

function []=jauge(fuel)
xset("color",8);xfpoly([60,57,57,60],[17,17,5,5]);
//rectangle : 12*3
//sÃ©paration en 12 fractions

u=[60,57,57,60];v=[17,17,5,5];
xpoly(u,v,"lines",1)
  
if fuel>92 then xset("color",13);xfpoly(u,v);
elseif fuel>84 & fuel<=92 then v(1)=v(1)-1;v(2)=v(1);xset("color",14);xfpoly(u,v);
elseif fuel>73 & fuel<=84 then v(1)=v(1)-2;v(2)=v(1);xset("color",15);xfpoly(u,v);
elseif fuel>65 & fuel<=73 then v(1)=v(1)-3;v(2)=v(1);xset("color",3);xfpoly(u,v);
elseif fuel>56 & fuel<=65 then v(1)=v(1)-4;v(2)=v(1);xset("color",7);xfpoly(u,v);
elseif fuel>48 & fuel<=56 then v(1)=v(1)-5;v(2)=v(1);xset("color",32);xfpoly(u,v);
elseif fuel>40 & fuel<=48 then v(1)=v(1)-6;v(2)=v(1);xset("color",26);xfpoly(u,v);
elseif fuel>31 & fuel<=40 then v(1)=v(1)-7;v(2)=v(1);xset("color",27);xfpoly(u,v);
elseif fuel>23 & fuel<=31 then v(1)=v(1)-8;v(2)=v(1);xset("color",19);xfpoly(u,v);
elseif fuel>15 & fuel<=23 then v(1)=v(1)-9;v(2)=v(1);xset("color",20);xfpoly(u,v);
elseif fuel>7 & fuel<=15 then v(1)=v(1)-10;v(2)=v(1);xset("color",21);xfpoly(u,v);
elseif fuel>0 & fuel<=7 then v(1)=v(1)-11;v(2)=v(1);xset("color",5);xfpoly(u,v,1); //faire clignoter !!
end
xset("color",0);
u=[60,57,57,60];v=[17,17,5,5];
xpoly(u,v,"lines",1)

endfunction

//-----------------------------------------------------------------------------------------------------------------------------------------------------


function [Mat]=rotation(Mat,couleur)  
   //On efface le triangle précédent
   xset("color",1);
   xfpoly(Mat(1,:),Mat(2,:))
   //On modifie les coordonnées                                       
   Mat(1,:)=Mat(1,:)-G(1);
   Mat(2,:)=Mat(2,:)-G(2);
   Mat=[cos(theta),-sin(theta);sin(theta),cos(theta)]*Mat;
   Mat(1,:)=Mat(1,:)+G(1);
   Mat(2,:)=Mat(2,:)+G(2); // on fait ici une rotation du triangle d'un angle theta de centre de rotation G
   //On trace le nouveau triangle
   xset("color",5,couleur);
   xfpoly(Mat(1,:),Mat(2,:));
endfunction
 
 
//-----------------------------------------------------------------------------------------------------------------------------------------------------
 
function [Mat,M,G]=avancer(Mat,M,G,k,couleur)
  
//On efface le triangle précédent
  xset("color",1);
  xfpoly(Mat(1,:),Mat(2,:),1)   
  
//Séparation de 2 cas : triangle vertical ou quelconque.                          
  if (M(1)-Mat(1,2)) <> 0 then   //Cas du triangle quelconque.
    k=k*(Mat(1,2)-M(1))/abs(M(1)-Mat(1,2));
    a=(M(2)-Mat(2,2))/(M(1)-Mat(1,2));  
    Mat(1,:)=[Mat(1,1)+k/sqrt(a**2+1),Mat(1,2)+k/sqrt(a**2+1),Mat(1,3)+k/sqrt(a**2+1)];
    G(1)=G(1)+k/sqrt(a**2+1);
    Mat(2,:)=[Mat(2,1)+k/sqrt(a**2+1)*a,Mat(2,2)+k/sqrt(a**2+1)*a,Mat(2,3)+k/sqrt(a**2+1)*a];
    G(2)=G(2)+k/sqrt(a**2+1)*a;
  else  // Cas du triangle vertical (on ne peut pas calculer a).
    Mat(2,:)=Mat(2,:)+k;
    G(2)=G(2)+k;
  end
  
//On trace le nouveau triangle.
xset("color",couleur);
xfpoly(Mat(1,:),Mat(2,:)); 

endfunction

//-------------------------------------------------------------------------------------------------------------------------------------------------

function [y]=calculdistance(G,M)
  s=size(M);l=s(1);  
  for i=1:l do
    d(i)=sqrt((G(1)-M(i,1))**2+(G(2)-M(i,2))**2);
  end
  y=min(d);
endfunction