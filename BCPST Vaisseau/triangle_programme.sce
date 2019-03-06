
exec('C:\Users\Thibault\Desktop\Vaisseau\jauge.sci') //appel fonction jauge
exec('C:\Users\Thibault\Desktop\Vaisseau\avancer.sci') //appel fonction jauge  
exec('C:\Users\Thibault\Desktop\Vaisseau\rotation.sci') //appel fonction rotation
// Ecrire un background
//Penser à un menu pour choisir pseudo
//Definition des variables et de l'environnement ( ie traï¿½age du triangle )

f=scf(0);
a=[0,0];b=[60,60];
plot2d(a,b,axesflag=0), plot2d(b,a,axesflag=0)
xset("color",1);
xfpoly([0,0,56,56],[0,56,56,0],1)
//zone de manoeuvre : [2,2,54,54],[2,54,54,2]
rep=[0,0,0];
Mat(1,:)=[3.5,4,4.5]; // 1ere ligne : abscisses
Mat(2,:)=[3,5,3]; // 2eme ligne : ordonnees
G=[4;3.66];
xset("color",5);
xfpoly(Mat(1,:),Mat(2,:));
fuel=100;
c=0.3;
jauge(fuel)
xpoly([60,57,57,60],[17,17,5,5],"lines",1) 

//-----------------------------------------------

while rep(3)<>-1000 do    //triangle BAC, M est le milieu de BC (A en haut)
  rep=xgetmouse();
  
  
  if rep(3)==122|rep(3)==115 then   // code ascii : "z"->122 , "s"->115
    M=[(Mat(1,1)+Mat(1,3))/2;(Mat(2,1)+Mat(2,3))/2];  // M est le milieu de BC (A en haut)
    
    if rep(3)==115 & Mat(1,3)>2 & Mat(1,3)<54 & Mat(2,3)>2 & Mat(2,3)<54 & Mat(1,1)>2 & Mat(1,1)<54 & Mat(2,1)>2 & Mat(2,1)<54 then k=-1; 
    elseif rep(3)==122 & Mat(1,2)>2 & Mat(1,2)<54 & Mat(2,2)>2 & Mat(2,2)<54 then k=1;
    else k=0; RIP=messagebox("Vous avez atteint la limite de l''univers, Jack !!", "Oups!","warning",["Bien reçu, je reprends la mission","J''irai voir au-delà !"],"modal")
      if RIP==1&rep(3)==122 then 
         for i=1:14 do theta=0.2;
         Mat=rotation(Mat);
         end
      elseif RIP==1&rep(3)==115 then k=1;
         for i=1:3 do [Mat,M,G]=avancer(Mat,M,G,k); 
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
  if rep(3)==100|rep(3)==113 then // code ascii: "d"->100 , "q"=113 
    if rep(3)==100 then 
      theta=-0.3;
    else theta=0.3;
    end   
   Mat=rotation(Mat);  
  end
 xpause(5)
 if fuel<=0 then messagebox(["Vous n''avez plus de carburant, Jack... Vous avez échoué!"," Vous et votre vaisseau allez dériver jusqu''à la fin des temps dans le froid et la solitude de l''univers..."]), rep(3)=-1000;
 end
end

close()






