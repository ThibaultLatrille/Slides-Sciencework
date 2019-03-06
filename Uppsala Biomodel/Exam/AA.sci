function dx=Gl(t,x,a,b)
    dx(1)=a-(b+1)*x(1)+x(1)**2*x(2)
    dx(2)=b*x(1)-x(2)*x(1)**2
endfunction

a=0.5; b=1.5
t=0:0.05:20;
k=3
l=4
j=5
xi=k*rand()
yi=l*rand()
x=ode([xi;yi],0,t,list(Gl,a,b));
xset("color",2)
xfarc(x(1,1)-j*0.005,x(2,1)+j*0.005,j*.010,j*0.010,0,360*64)
xset("color",5)
//    xfarc(x(1,200)-j*0.005,x(2,200)+j*0.005,j*.010,j*0.010,0,360*64)
xset("color",1)
plot2d(x(1,:),x(2,:))
for i=1:15 do
    v=xclick()
    xi=v(2)
    yi=v(3)
    x=ode([xi;yi],0,t,list(Gl,a,b));
    xset("color",2)
    xfarc(x(1,1)-j*0.005,x(2,1)+j*0.005,j*.010,j*0.010,0,360*64)
    xset("color",5)
    //    xfarc(x(1,200)-j*0.005,x(2,200)+j*0.005,j*.010,j*0.010,0,360*64)
    xset("color",1)
    plot2d(x(1,:),x(2,:))
end

