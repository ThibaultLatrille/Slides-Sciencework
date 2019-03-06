function []=affichage(C,ville1,ville2,d)
RGB = ReadImage('C:\Program Files\scilab-5.2.1\contrib\france1.jpg');
[image, ColorMap] = RGB2Ind(RGB);
FigureHandle = ShowImage(image, 'Example', ColorMap);
coordIm=transform(C)
if d>=100 then
xstring(coordIm(1,2),coordIm(1,1),ville1)
xstring(coordIm(2,2),coordIm(2,1),ville2)
xpoly([coordIm(1,2),coordIm(2,2)],[coordIm(1,1),coordIm(2,1)],"lines",1);
d=round(d);
d=string(d)+" Km";
xstring((coordIm(1,2)+coordIm(2,2))/2,(coordIm(1,1)+coordIm(2,1))/2,d);
else 
  yhaut=max(coordIm(1,1),coordIm(2,1));
  if yhaut=coordIm(1,1) then xhaut=coordIm(1,2);yhaut=yhaut+5;ybas=coordIm(2,1)-5;xbas=coordIm(2,2);                                 villehaut=ville1;villebas=ville2;
  else yhaut=yhaut+5; xhaut=coordIm(2,2); ybas=coordIm(1,1)-5;xbas=coordIm(1,2); villehaut=ville2;villebas=ville1;
  end  
xstring(xhaut,yhaut,villehaut);
xstring(xbas,ybas,villebas);
xpoly([coordIm(1,2),coordIm(2,2)],[coordIm(1,1),coordIm(2,1)],"lines",1);
d=round(d);
d=string(d)+" Km";
xstring((xhaut+xbas)/2,(yhaut+ybas)/2,d);
end
endfunction