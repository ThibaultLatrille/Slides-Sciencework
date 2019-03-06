k=10; m=1.1; v=0.45; r=1; steps=35000
X=zeros(1,steps)
Y=zeros(1,steps)
eps=.005
x=0.5
y=0.5
for j=1:steps do
       if rand() < r*x then 
           x=x+eps
       end,
       if rand()<x^2/k then
           x=x-eps
       end
       if rand() <m*y*x/(1+x) then 
           x=x-eps
           y=y+eps
       end
       if rand() < y*v then 
           y=y-eps 
       end
       X(1,j)=x;
       Y(1,j)=y;
end
plot(1:steps,X,"blue")
plot(1:steps,Y,"green")
plot(X,Y)
