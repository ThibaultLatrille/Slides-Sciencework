coor=[48.8,2.33;48.5,7.75;48.4,-4.48];
coord=[380,380;200,5;280,280];
//1ere colonne latitude
//2emme colonne longitude

function [coord]=transform(coord)
  n=length(coord(:,1))
  h=386
  w=393
  maxlat=51.1
  minlat=42.3
  maxlong=8.3
  minlong=-5.2
  for i=1:n do coord(i,1)=floor((coord(i,1)-minlat)*h/(maxlat-minlat))
               coord(i,2)=floor((coord(i,2)-minlong)*w/(maxlong-minlong))
  end
endfunction

function [y]=choix(coord,ville)
// "ville" est une chaine de caractère, le nom de la ville qui existe plusieurs fois en france. "coord" est une matrice de deux colonnes la premier correspondant au latitude la deuxième au longitude, chaque ligne correspond au coordonnées d'une ville
RGB = ReadImage('C:\Program Files\scilab-5.2.1\contrib\france1.jpg');
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
