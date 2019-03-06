// Permet de créer des fichier .dat à partir du fichier excel ouvert dans Scilab

fd=mopen('C:\Users\thibault\Desktop\UTT\Mat2.Dat','wb');
save(fd,SST);
mclose(fd);
Value(:,1)=[];
fd=mopen('C:\Users\thibault\Desktop\UTT\lat.Dat','wb');
save(fd,X);
mclose(fd);
fd=mopen('C:\Users\thibault\Desktop\UTT\long.Dat','wb');
save(fd,Y);
mclose(fd);
fd=mopen('C:\Users\thibault\Desktop\UTT\doublon.Dat','wb');
save(fd,Z);
mclose(fd);
fprintfMat('C:\Users\thibault\Desktop\UTT\lat',X);