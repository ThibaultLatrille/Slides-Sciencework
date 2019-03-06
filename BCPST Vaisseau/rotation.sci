function [Mat]=rotation(Mat)  
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
   xset("color",5);
   xfpoly(Mat(1,:),Mat(2,:));
endfunction