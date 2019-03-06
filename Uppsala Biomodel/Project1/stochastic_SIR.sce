N=100
s=floor(rand()*100)
i=N-s
r=0
mu=0.01
b=0.05
g=0.09
steps=5000
S=zeros(1,steps)
I=zeros(1,steps)
R=zeros(1,steps)
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
    S(j)=s;
    I(j)=i;
    R(j)=r;
end
clf()
plot(1:steps,S,"blue")
plot(1:steps,I,"green")
plot(1:steps,R,"red")
