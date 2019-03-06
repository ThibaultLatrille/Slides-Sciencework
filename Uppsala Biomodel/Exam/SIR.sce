function dx=Gl1(t,x,R1,R2,R3)
    dx(1)=-x(1)*(R1*x(2)+R2*x(3))
    dx(2)=x(2)*(R1*x(1)-1)
    dx(3)=x(3)*(R2*x(1)+R3*x(4)-1)
    dx(4)=x(2)-R3*x(4)*x(3)
    dx(5)=x(3)
endfunction

function dx=Gl2(t,x,R1,R2,R3,B,C,D)
    dx(1)=-x(1)*(R1*x(2)+R2*x(3))+B*(x(1)+x(2)+x(3)+x(4)+x(5))-D*x(1)
    dx(2)=x(2)*(R1*x(1)-1)-D*x(2)
    dx(3)=x(3)*(R2*x(1)+R3*x(4)-1)-(D+C)*x(3)
    dx(4)=x(2)-R3*x(4)*x(3)-D*x(4)
    dx(5)=x(3)-D*x(5)
endfunction

function dx=Gl3(t,x,R1,R2,R3,B,C,D)
    dx(1)=-x(1)*(R1*x(2)+R2*x(3))+B*(x(1)+x(3)+x(4)+x(5))-D*x(1)
    dx(2)=x(2)*(R1*x(1)-1)+(B-D)*x(2)
    dx(3)=x(3)*(R2*x(1)+R3*x(4)-1)-(D+C)*x(3)
    dx(4)=x(2)-R3*x(4)*x(3)-D*x(4)
    dx(5)=x(3)-D*x(5)
endfunction

R1=1.4;R2=1.4;R3=2;B=0.5;C=0.2;D=0.5;
t=0:0.02:12;
x1=1;x2=0.05;x3=0.05;x4=0;x5=0;
for i=1:1 do 
    x=ode([x1;x2;x3;x4;x5],0,t,Gl3);
    plot(t,x(1,:),"black")
    plot(t,x(2,:),"red")
    plot(t,x(3,:),"blue")
    plot(t,x(4,:),"yellow")
    plot(t,x(5,:),"cyan")
end
