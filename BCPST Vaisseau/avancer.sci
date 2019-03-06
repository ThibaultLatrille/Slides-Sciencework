function [Mat,M,G]=avancer(Mat,M,G,k)
  
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
xset("color",5);
xfpoly(Mat(1,:),Mat(2,:)); 

endfunction