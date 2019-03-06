//A faire : 
//Ecrire un background.
//Definition des variables et de l'environnement ( ie tracage du triangle )
function [time]=newgame(pseudo,couleur)
f2=figure()
a=[0,0];b=[60,60];
plot2d(a,b,axesflag=0), plot2d(b,a,axesflag=0)
xset("color",1);
xfpoly([0,0,56,56],[0,56,56,0],1)
//zone de manoeuvre : [2,2,54,54],[2,54,54,2]
explosion=3;
rep=[0,0,0];
Mat(1,:)=[3.5,4,4.5]; // 1ere ligne : abscisses
Mat(2,:)=[3,5,3]; // 2eme ligne : ordonnees
G=[4;3.66];
xset("color",couleur);
xfpoly(Mat(1,:),Mat(2,:));
fuel=100;
c=0.5;
jauge(fuel)
xpoly([60,57,57,60],[17,17,5,5],"lines",1) 
PLANETE=[20,20,0,0,2;30,50,0,0,5;50,10,0,0,5;30,30,0,0,2];
VG=[0,0];
timer()
//-----------------------------------------------

while rep(3)<>-1000 do    //triangle BAC, M est le milieu de BC (A en haut)
    tic()
  rep=xgetmouse();  
   temps=0;
  if Mat(1,3)<2|Mat(1,3)>54|Mat(2,3)<2|Mat(2,3)>54|Mat(1,1)<2|Mat(1,1)>54|Mat(2,1)<2|Mat(2,1)>54 then messagebox("You''re dead Jack... RIP"), rep(3)=-1000;
  end
  boom=calculdistance(G,PLANETE);
  if boom<explosion then messagebox(["La perturbation gravitationnelle provoquee par la planete vous a fait perdre le controle de votre vaisseau..." " Vous vous ecrasez sur cette terre hostile, peuplee par d''etranges creatures... Au revoir, Jack !"]), rep(3)=-1000;
  end
  if rep(3)==122|rep(3)==115 then   // code ascii : "z"->122 , "s"->115
    temps=toc();
    M=[(Mat(1,1)+Mat(1,3))/2;(Mat(2,1)+Mat(2,3))/2];  // M est le milieu de BC (A en haut)
    if rep(3)==115 then k=-2; 
    else k=2;
    end
   [Mat,M,G]=avancer(Mat,M,G,k,couleur);
   fuel=fuel-c;
   jauge(fuel) 
  end
  //Rotation
  if rep(3)==100|rep(3)==113 then
    temps=toc(); 
    if rep(3)==100 then 
      theta=-0.3;
    else theta=0.3;
    end  // code ascii: "d"->100 , "q"=113  
    Mat=rotation(Mat,couleur); 
   jauge(fuel) 
  end
 xpause(5)
 if fuel<=0 then messagebox(["Vous n''avez plus de carburant, Jack... Vous avez echoue!"," Vous et votre vaisseau allez d�river jusqu''� la fin des temps dans le froid et la solitude de l''univers..."]), rep(3)=-1000;
 end
if temps<>0 then 
 colorier(PLANETE,Mat,0,1,couleur);
 for i=1:floor(temps)+1 do 
   [PLANETE,Mat,G,VG]=deplacement(PLANETE,Mat,G,VG);
 end    
 colorier(PLANETE,Mat,1,0,couleur)
end
end
time=timer()
endfunction
//xpause(10000000)
//messagebox("Vous avez tenu "+string(time)+" secondes")





