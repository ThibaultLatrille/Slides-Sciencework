function [vect]=test(fg)
    for i=1:800 do
        A(i)=sum(fg(:,i)/255);
    end
    compt=1;
    B=0;
    for k=20:781 do
        su=0
        for i=k-19:k+19 do
            su=su+A(i)
        end
        if su>100 then B(compt)=k
                       B(compt)=k
                      compt=compt+1
        end
    end
    minim=min(B);
    maxim=max(B);
    if (maxim-minim)<80 then vect=0
        else k=0;
             l=0;
             n=length(B);
         for i=1:n do 
             if abs(minim-B(i))<80 then
                         k=k+1
                         S1C(k)=B(i)
                       else 
                         l=l+1
                         S2C(l)=B(i)
                 end
         end
         vect=ones(1,7);
         vect(3)=floor(mean(S1C));
         vect(5)=floor(mean(S2C));
         if vect(3)<16|vect(5)<16 then vect(1)=0
                                       vect(3)=400
                                       vect(4)=400
         end
         compt=1;
         su=0;
         C=fg(:,[vect(3)-5,vect(3)-4,vect(3)-3,vect(3)-2,vect(3)-1,vect(3),vect(3)+1,vect(3)+2,vect(3)+3,vect(3)+4,vect(3)+5]);
         C1=0;
         D=fg(:,[vect(5)-5,vect(5)-4,vect(5)-3,vect(5)-2,vect(5)-1,vect(5),vect(5)+1,vect(5)+2,vect(5)+3,vect(5)+4,vect(5)+5]);
         D1=0;
         k=1;
         l=1;
         for i=4:597 do
             su=sum(C([i-3;i-2;i-1;i;i+1;i+2;i+3],:)/255)
             if su>9 then C1(l)=i;l=l+1;
             end
             su=sum(D([i-3;i-2;i-1;i;i+1;i+2;i+3],:)/255)
             if su>9 then D1(k)=i;k=k+1;
             end
         end
         vect(2)=floor(mean(C1))
         vect(4)=floor(mean(D1))
         if vect(2)<26|vect(4)<26|vect(2)>575|vect(4)>575 then vect(1)=0
                                                               vect(2)=400
                                                               vect(4)=400
         end
         for i=vect(2)-25:vect(2)+25 do
             for j=vect(3)-15:vect(3)+15 do
                 if fg(i,j)==255 then vect(6)=vect(6)+1
                 end
             end
         end
         for i=vect(4)-25:vect(4)+25 do
             for j=vect(5)-15:vect(5)+15 do
                 if fg(i,j)==255 then vect(7)=vect(7)+1
                 end
             end
         end
    end
endfunction

function su=comptage(A)
su=0;
i=1;
for i=3:length(A)-3 do
    if A(i+1)<A(i)&A(i+2)<A(i)&A(i-1)<A(i)&A(i-2)<A(i) then su=su+1;
    end
end
endfunction

function [samare1,samare2]=pointage(path)
n = aviopen(string(path));
im = avireadframe(n);
fg = detectforeground(im, 'GMM');//or:fg = detectforeground(im). create background model
info = aviinfo(string(path));
fin=getfield(7,info);
on=1;
test1=0;
A=0;B=0;C=0;D=0;E=0;F=0;
for p=1:fin-1 do 
  img = detectforeground(im);//get the foreground mask
  //imshow(img);   
  im = avireadframe(n);
  if on==1 then
    [test1]=test(img);
    if test1(1)==1 then centreli1=floor(test1(2));
                        A(p)=((test1(2)-300)*10/(273-159))
                       centreco1=floor(test1(3));
                        B(p)=((test1(3)-400)*10/(273-159))
                        C(p)=test1(6)
                       centreli2=floor(test1(4));
                        D(p)=((test1(4)-300)*10/(273-159))
                       centreco2=floor(test1(5));
                        E(p)=((test1(5)-400)*10/(273-159))
                        F(p)=test1(7)
                       on=0;
    end
  elseif on==0 then 
    ////////////////////////////////////////////
    su=0;
    p,
    if (centreli1-20)>1 then minli1=centreli1-20;
                     else minli1=1;
    end
    if (centreli1+20)<600 then maxli1=centreli1+20;
                       else maxli1=600;
    end
    if (centreco1-35)>1 then minco1=centreco1-35;
                     else minco1=1;
    end
    if (centreco1+35)<800 then maxco1=centreco1+35;
                       else maxco1=800;
    end
    a=1,
    ligne=0,
    colonne=0,
    for i=minli1:maxli1 do
        for j=minco1:maxco1 do if img(i,j)==255 then 
                                          su=su+1;
                                          ligne(a)=i;
                                          colonne(a)=j;
                                          a=a+1;
            end
        end
    end
    centreli1=floor(mean(ligne));
    centreco1=floor(mean(colonne));
    A(p)=((mean(ligne)-300)*10/(273-159));
    B(p)=((mean(colonne)-400)*10/(273-159));
    C(p)=su;
    samare1=[A,B,C];
    /////////////////////////////////////////////
    su=0;
    if (centreli2-20)>1 then minli2=centreli2-20;
                     else minli2=1;
    end
    if (centreli2+20)<600 then maxli2=centreli2+20;
                       else maxli=600;
    end
    if (centreco2-35)>1 then minco2=centreco2-35;
                     else minco2=1;
    end
    if (centreco2+35)<800 then maxco2=centreco2+35;
                       else maxco2=800;
    end
    a=1;
    ligne=0;
    colonne=0;
    for i=minli2:maxli2 do
        for j=minco2:maxco2 do if img(i,j)==255 then 
                                          su=su+1;
                                          ligne(a)=i;
                                          colonne(a)=j;
                                          a=a+1;
            end
        end
    end
    d1=sqrt
    centreli2=floor(mean(ligne));
    centreco2=floor(mean(colonne));
    D(p)=((mean(ligne)-300)*10/(273-159));
    E(p)=((mean(colonne)-400)*10/(273-159));
    F(p)=su;
    if 600-centreli1<15|600-centreli2<10|centreco1<10|800-centreli2<15 then 
        on=2;
    end
  end
end
samare1=[A,B,C];
samare2=[D,E,F];
avicloseall();
endfunction

function [T,nb,vect]=touche(path)
[samare1,samare2]=pointage(string(path))
tableau=0;
compt=1;
for i=1:max(size(samare1)) do
    if samare1(i,3)<>0&samare2(i,3)<>0 then 
       tableau(compt,1)=samare2(i,2);
       tableau(compt,2)=-samare2(i,1);
       tableau(compt,3)=samare1(i,2);
       tableau(compt,4)=-samare1(i,1);
       compt=compt+1;
  end
end
n=max(size(tableau))
T=exploitation(tableau);
vect=surexploitation(T);
nb=(comptage(samare1(:,3))+comptage(samare2(:,3)))/2
//plot2d(samare1(:,3));
samaradraw(T);
endfunction







