
function su=comptage(A)
su=0;
i=1;
for i=3:length(A)-3 do
    if A(i+1)<A(i)&A(i+2)<A(i)&A(i-1)<A(i)&A(i-2)<A(i) then su=su+1;
    end
end
endfunction

function [vect]=test(ligne,colonne)
    minim=min(colonne);
    maxim=max(colonne);
    n=max(size(ligne));
if maxim-minim<50 then vect=0
else 
    k=0;
    l=0;
    for i=1:n do if abs(minim-colonne(i))<50 then
                         k=k+1
                         S1L(k)=ligne(i)
                         S1C(k)=colonne(i)
                       else 
                         l=l+1
                         S2L(l)=ligne(i)
                         S2C(l)=colonne(i)
                 end
     end
     //d1=sqrt((max(S1L)-min(S1L))**2+(min(S1C)-max(S1C))**2)
     //d2=sqrt((max(S2L)-min(S2L))**2+(min(S2C)-max(S2C))**2)
     d1=length(S1L);
     d2=length(S2L);
     if d1<50|d2<50 then vect=0
     else vect=1
          vect(2)=mean(S1L)
          vect(3)=mean(S1C)
          vect(4)=mean(S2L)
          vect(5)=mean(S2C)
          vect(6)=length(S1L)
          vect(7)=length(S1L)
     end
end
endfunction

function [samare1,samare2]=pointage(video)
n = aviopen('C:\Users\thibault\Desktop\TIPE2\video\'+string(video)+'.avi');
im = avireadframe(n);
fg = detectforeground(im, 'GMM');//or:fg = detectforeground(im). create background model
info = aviinfo('C:\Users\thibault\Desktop\TIPE2\video\'+string(video)+'.avi');
fin=getfield(7,info);
on=1;
test1=0;
A=0;B=0;C=0;D=0;E=0;F=0;
for p=1:fin-1 do 
  img = detectforeground(im);//get the foreground mask
  imshow(img);   
  im = avireadframe(n);
  if on==1 then
    a=1;
    ligne=0;
    colonne=0;
    for i=1:100 do
        for j=1:800 do
            if img(i,j)==255 then  ligne(a)=i;
                                   colonne(a)=j;
                                   a=a+1;
            end
        end
    end
    [test1]=test(ligne,colonne);
    if test1(1)==1 then centreli1=floor(test1(2));
                        A(p)=((test1(2)-300)*10/(494-378))
                       centreco1=floor(test1(3));
                        B(p)=((test1(3)-400)*10/(494-378))
                        C(p)=test1(6)
                       centreli2=floor(test1(4));
                        D(p)=((test1(4)-300)*10/(494-378))
                       centreco2=floor(test1(5));
                        E(p)=((test1(5)-400)*10/(494-378))
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
    A(p)=((mean(ligne)-300)*10/(494-378));
    B(p)=((mean(colonne)-400)*10/(494-378));
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
    D(p)=((mean(ligne)-300)*10/(494-378));
    E(p)=((mean(colonne)-400)*10/(494-378));
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

function [T,vect,tableau,A,B]=touche(video)
[samare1,samare2]=pointage(string(video))
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
n=max(size(tableau));
T=exploitation(tableau);
vect=surexploitation(T);
A=samare1(:,3);
B=samare2(:,3);
endfunction

[T,vect,tableau,A,B]=touche('poids121')
samaradraw(T)