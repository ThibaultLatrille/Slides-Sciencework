b=0.7; g=0.05; mu=0.01; steps=8000
S=zeros(20,steps)
I=zeros(20,steps)
R=zeros(20,steps)
sensibleinitial=floor(rand()*100)
sensibleinitial=80
for k=1:20 do
    N=100; s=sensibleinitial; i=N-sensibleinitial; r=0;
    for j=1:steps do
        if rand() < mu then 
            s=s+1, N=N+1; 
            end,
        if rand() <mu then 
            a=rand()
            if a<s/N then 
                s=s-1;
            elseif s/N<a & a<(s+i)/N then 
                i=i-1; 
            else r=r-1;
            end,
            N=N-1
             end
        if rand() < b*s*i/(N**2) then 
            s=s-1, i=i+1; 
            end
        if rand() < g*i/N then 
            i=i-1, r=r+1; 
        end
        S(k,j)=s;
        I(k,j)=i;
        R(k,j)=r;
    end
end
clf()
plot(1:steps,S,"blue")
plot(1:steps,I,"green")
plot(1:steps,R,"red")
plot(1:steps,mean(S,"r"),"black")
plot(1:steps,mean(I,"r"),"black")
plot(1:steps,mean(R,"r"),"black")
