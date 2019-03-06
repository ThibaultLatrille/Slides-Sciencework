function dx=Gl(t,x)
    b=1; g=0.5;
    dx(1)=1-b*x(1)*x(2)-x(1)
    dx(2)=b*x(1)*x(2)-g*x(2)-x(2)
    dx(3)=g*x(2)-x(3)
endfunction


t=0:0.1:200;
for i=1:60 do 
    a=rand()
    b=rand()
    c=rand()
    A=a/(a+b+c)
    B=b/(a+b+c)
    C=c/(a+b+c)
    x=ode([A;B;C],0,t,Gl);
    xset("color",2)
    xfarc(x(1,1)-0.005,x(2,1)+0.005,.010,0.010,0,360*64)
    xset("color",5)
    xfarc(x(1,200)-0.005,x(2,200)+0.005,.010,0.010,0,360*64)
    xset("color",1)
    plot2d(x(1,:),x(2,:))
end
