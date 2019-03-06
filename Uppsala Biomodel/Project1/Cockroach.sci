function dx=Gly(t,x)
    a=0.06
    b=6
    dx(1)=a*(N-x(1))/(b+(N-x(1)**2)**2)-a*x(1)/(b+x(1)**2)
endfunction

function dx=Gl(t,x)
    a=0.06;
    b=6;
    dx(1)=a*x(2)/(b+x(2)**2)-a*x(1)/(b+x(1)**2)
    dx(2)=a*x(1)/(b+x(1)**2)-a*x(2)/(b+x(2)**2)
endfunction
//T=3000
//N=12
//t=0:0.1:T;
//for i=0:N do
//    x=ode([i;N-i],0,t,Gl);
//    plot(t,x(2,:)/N,"green")
//end
//N=24
//t=0:0.1:T;
//for i=0:N do
//    x=ode([i;N-i],0,t,Gl);
//    plot(t,x(2,:)/N,"red")
//end
//
//N=4
//t=0:0.1:T;
//for i=0:N do
//    x=ode([i;N-i],0,t,Gl);
//    plot(t,x(2,:)/N,"blue")
//end
//N1=0:0.1:20;
//N2=sqrt(24):0.1:20;
//plot(N1,1/2)
//plot(N1,1,"blue")
//plot(N2,1/2+sqrt(-24 +N2^2)./(2*N2),"green")
//plot(N2,1/2-sqrt(-24 +N2^2)./(2*N2),"green")
T=3000
N=12
t=0:0.1:T;
for i=0:N do
    x=ode([i;N-i],0,t,Gl);
    plot(x(1,:)/N,x(2,:)/N,"green")
end
N=24
t=0:0.1:T;
for i=0:N do
    x=ode([i;N-i],0,t,Gl);
    plot(x(1,:)/N,x(2,:)/N,"red")
end

N=4
t=0:0.1:T;
for i=0:N do
    x=ode([i;N-i],0,t,Gl);
    plot(x(1,:)/N,x(2,:)/N,"blue")
end

clf()
plot(x(1,:)/N,x(2,:)/N,"blue")
