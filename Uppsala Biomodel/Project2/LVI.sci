function dx=Gl(t,x)
    k=4.2; m=3; v=1;
    dx(1)=x(1)*(1-x(1)/k)-m*x(2)*x(1)/(1+x(1))
    dx(2)=m*x(2)*x(1)/(1+x(1))-v*x(2)
endfunction

function dx=Gl(t,x)
     v=0.4;  m=.2505;  k=0.1770068;
    dx(1)=x(1)*(1-x(1)/k)-m*x(2)*x(1)/(1+x(1))
    dx(2)=m*x(2)*x(1)/(1+x(1))-v*x(2)
endfunction
clf()
v=0.2;  m=0.705;  k=0.958678; //complex-stable
v=0.2;  m=.4505;  k=2.958678; //cycle
 v=0.4;  m=.2505;  k=0.1770068; //musmall
v=1.325;  m=4.975;  k=0.1770068; //mubig
disp(v/(m-v))
disp((v+m)/(m-v))
S=0.8
t=0:0.1:500;
xi=v/(m-v)
yi=xi*(k-xi)/(k*v)
disp(xi)
disp(yi)
P=[v*(k*v+v-k*m+m)/(k*m*(v-m)),-v;(k*m-(k+1)*v)/(k*m),0]
disp(spec(P))
//for i=linspace(0,0.1,2) do 
//    for j=linspace(0,0.1,2) do 
//        x=ode([xi+i;yi+j],0,t,Gl);
//        xset("color",4)
//        xfarc(x(1,1)-S*0.005,x(2,1)+S*0.005,S*.010,S*0.010,0,360*64)
//        xset("color",5)
//        xfarc(x(1,$)-S*0.005,x(2,$)+S*0.005,S*.010,S*0.010,0,360*64)
//        xset("color",1)
//        plot(x(1,:),x(2,:))  
//    end
//end
for i=1:20 do 
    x=ode([2*k*rand();2*k*rand()],0,t,Gl);
    xset("color",2)
    xfarc(x(1,1)-S*0.005,x(2,1)+S*0.005,S*.010,S*0.010,0,360*64)
    xset("color",5)
//    xfarc(x(1,$)-S*0.005,x(2,$)+S*0.005,S*.010,S*0.010,0,360*64)
    xset("color",1)
    plot(x(1,:),x(2,:))  
end
xset("color",5)
xfarc(xi-S*0.005,yi+S*0.005,S*.010,S*0.010,0,360*64)
xfarc(k-S*0.005,0+S*0.005,S*.010,S*0.010,0,360*64)
xset("color",1)

