
//Ouverture et lecture du fichier excel. Les chaînes de caractères sont dans SST, les valeurs numériques dans Value.
[fd,SST,Sheetnames,Sheetpos] = xls_open('C:\Users\Thibault\Desktop\a.xls');
[tableau,TextInd] = xls_read(fd,Sheetpos(1));
mclose(fd);
