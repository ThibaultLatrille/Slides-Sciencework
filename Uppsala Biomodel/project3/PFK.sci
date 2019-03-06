function dx=Gl(t,x,sigma)
    k=1; L=7.5*10^6; q=20;
    dx(1)=-q*x(1)*(1+x(1))*(1+x(2))^2/(L+(1+x(1))^2*(1+x(2))^2)+sigma
    dx(2)=q*x(1)*(1+x(1))*(1+x(2))^2/(L+(1+x(1))^2*(1+x(2))^2)-k*x(2)
endfunction
clf()
A=zeros(1000,1)
B=zeros(1000,1)
for i=100:1000 do
    sigma=i*15/1000
    k=1; L=7.5*10^6; q=20;
    A(i)=(k*sqrt((q^2*(k+sigma)^2)/k^2+4*L*q*sigma-4*L*sigma^2)+k*q-2*k*sigma-q*sigma+2*sigma^2)/(2*(k+sigma)*(q-sigma))
    B(i)=sigma/k 
end
plot(A(100:1000),B(100:1000),'blacko')

t=0:0.1:150;
X=zeros(10,1501)
Y=zeros(10,1501)
for i=1:10 do
    sigma=i*15/10
    k=1; L=7.5*10^6; q=20;
    a=(k*sqrt((q^2*(k+sigma)^2)/k^2+4*L*q*sigma-4*L*sigma^2)+k*q-2*k*sigma-q*sigma+2*sigma^2)/(2*(k+sigma)*(q-sigma))
    b=sigma/k 
    a=260
    b=0.4
    x=ode([a;b],0,t,list(Gl,sigma));
    X(i,:)=x(1,:)
    Y(i,:)=x(2,:)
end
plot(X',Y')

