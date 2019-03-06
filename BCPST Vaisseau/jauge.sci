function []=jauge(fuel)
xset("color",8);xfpoly([60,57,57,60],[17,17,5,5]);
//rectangle : 12*3
//séparation en 12 fractions

u=[60,57,57,60];v=[17,17,5,5];
xpoly(u,v,"lines",1)
  
if fuel>92 then xset("color",13);xfpoly(u,v);
elseif fuel>84 & fuel<=92 then v(1)=v(1)-1;v(2)=v(1);xset("color",14);xfpoly(u,v);
elseif fuel>73 & fuel<=84 then v(1)=v(1)-2;v(2)=v(1);xset("color",15);xfpoly(u,v);
elseif fuel>65 & fuel<=73 then v(1)=v(1)-3;v(2)=v(1);xset("color",3);xfpoly(u,v);
elseif fuel>56 & fuel<=65 then v(1)=v(1)-4;v(2)=v(1);xset("color",7);xfpoly(u,v);
elseif fuel>48 & fuel<=56 then v(1)=v(1)-5;v(2)=v(1);xset("color",32);xfpoly(u,v);
elseif fuel>40 & fuel<=48 then v(1)=v(1)-6;v(2)=v(1);xset("color",26);xfpoly(u,v);
elseif fuel>31 & fuel<=40 then v(1)=v(1)-7;v(2)=v(1);xset("color",27);xfpoly(u,v);
elseif fuel>23 & fuel<=31 then v(1)=v(1)-8;v(2)=v(1);xset("color",19);xfpoly(u,v);
elseif fuel>15 & fuel<=23 then v(1)=v(1)-9;v(2)=v(1);xset("color",20);xfpoly(u,v);
elseif fuel>7 & fuel<=15 then v(1)=v(1)-10;v(2)=v(1);xset("color",21);xfpoly(u,v);
elseif fuel>0 & fuel<=7 then v(1)=v(1)-11;v(2)=v(1);xset("color",5);xfpoly(u,v,1); //faire clignoter !!
end
xset("color",0);
u=[60,57,57,60];v=[17,17,5,5];
xpoly(u,v,"lines",1)

endfunction
