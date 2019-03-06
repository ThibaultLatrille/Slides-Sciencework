//A faire : 
//Quand le vaisseau s'approche des planètes, faire quelquechose.
//Ecrire un background.
//Definition des variables et de l'environnement ( ie tracage du triangle )

f=scf(0);
a=[0,0];b=[60,60];
plot2d(a,b,axesflag=0), plot2d(b,a,axesflag=0)
xset("color",1);
xfpoly([0,0,56,56],[0,56,56,0],1)
//zone de manoeuvre : [2,2,54,54],[2,54,54,2]
rep=[0,0,0];
Mat(1,:)=[3.5,4,4.5]; // 1ere ligne : abscisses
Mat(2,:)=[3,5,3]; // 2eme ligne : ordonnÃ©es
G=[4;3.66];
xset("color",5);
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
  if rep(3)==122|rep(3)==115 then   // code ascii : "z"->122 , "s"->115
    temps=toc();
    M=[(Mat(1,1)+Mat(1,3))/2;(Mat(2,1)+Mat(2,3))/2];  // M est le milieu de BC (A en haut)
    
    if rep(3)==115 & Mat(1,3)>2 & Mat(1,3)<54 & Mat(2,3)>2 & Mat(2,3)<54 & Mat(1,1)>2 & Mat(1,1)<54 & Mat(2,1)>2 & Mat(2,1)<54 then k=-1; 
    elseif rep(3)==122 & Mat(1,2)>2 & Mat(1,2)<54 & Mat(2,2)>2 & Mat(2,2)<54 then k=1;
    else k=0; RIP=messagebox("Vous avez atteint la limite de l''univers, Jack !!", "Oups!","warning",["Bien reçu, je reprends la mission","J''irai voir au-delà !"],"modal")
      if RIP==1&rep(3)==122 then 
         for i=1:28 do theta=0.1;
         Mat=rotation(Mat);
         end
      elseif RIP==1&rep(3)==115 then k=1;
         for i=1:5 do [Mat,M,G]=avancer(Mat,M,G,k); 
                      jauge(fuel)
         end
       elseif RIP==2 then messagebox("You''re dead Jack... RIP"), rep(3)=-1000;
      end
     end
   [Mat,M,G]=avancer(Mat,M,G,k);
   fuel=fuel-c;
   jauge(fuel) 
  end
  //Rotation
  if rep(3)==100|rep(3)==113 then  // code ascii: "d"->100 , "q"=113 
    temps=toc(); 
    if rep(3)==100 then 
      theta=-0.3;
    else theta=0.3;
    end 
    Mat=rotation(Mat); 
  end
 xpause(5)
 if fuel<=0 then messagebox(["Vous n''avez plus de carburant, Jack... Vous avez echoue!"," Vous et votre vaisseau allez dï¿½river jusqu''ï¿½ la fin des temps dans le froid et la solitude de l''univers..."]), rep(3)=-1000;
 end
if temps<>0 then 
 colorier(PLANETE,Mat,0,1);
 for i=1:floor(temps)+1 do 
   [PLANETE,Mat,G,VG]=deplacement(PLANETE,Mat,G,VG);
 end    
 colorier(PLANETE,Mat,1,0)
end
end
close()
time=timer()
messagebox("Vous avez tenu "+string(time)+" secondes")





