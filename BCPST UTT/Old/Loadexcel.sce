
//Ouverture et lecture du fichier excel. Les cha�nes de caract�res sont dans SST, les valeurs num�riques dans Value.
[fd,SST,Sheetnames,Sheetpos] = xls_open('C:\Users\Thibault\Desktop\a.xls');
[tableau,TextInd] = xls_read(fd,Sheetpos(1));
mclose(fd);
