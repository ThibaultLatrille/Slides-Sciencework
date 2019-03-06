//Chargement de la base de données.

//Ouverture de la liste des villes contenue dans Mat2.dat
fd=mopen('C:\Users\thibault\Desktop\UTT\Mat2.Dat','rb');
load(fd,"SST");
mclose(fd);
//Ouverture de la liste des latitudes contenue dans lat
X=fscanfMat('C:\Users\thibault\Desktop\UTT\lat');
//Ouverture de la liste des longitudes contenue dans long.dat
fd=mopen('C:\Users\thibault\Desktop\UTT\long.Dat','rb');
load(fd,"Y");
mclose(fd);
//Ouverture de la liste des doublons contenue dans doublon.
Z=fscanfMat('C:\Users\thibault\Desktop\UTT\doublon');
//Création de la matrice Value : [Latitude, Longitude, Doublon].
Value(:,1)=X;
Value(:,2)=Y;
Z(1)=[];Z(length(X))=0
Value(:,3)=Z;