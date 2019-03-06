rang=1;
GG=0;
maxim=0;
j=0;
n=max(size(Value));
while rang<=n do 
    if Value(rang,3)==1
                       while Value(rang+j,3)==1 do j=j+1,
                       end
                       if j>maxim then GG=rang;
                                       maxim=j;
                       end
                       rang=rang+j;j=0;
      end
      rang=rang+1;
end