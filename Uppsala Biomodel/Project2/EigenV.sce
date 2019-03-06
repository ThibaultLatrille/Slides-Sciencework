function plotPoints(varargin)
// 
// plotPoints(XYZ [, style [, size [, color]]])
// --------------------------------------------
// * Action: Draw points onto a 2D or 3D plot, according to the number of 
//    given cartesian coordinates of points. These ones are specified into 
//    a Nx2 or Nx3 XYZ real matrix, one line per point.
// * Optional input arguments:
//    style: integer 0-14: type of marks. Scalar: Same style for all points
//           See help polyline_properties or getmark() for illustration
//    size:  Size of marks, in point unit (scalar: same size for all points)
//    color: Index (# in the current colormap) or name of color to be used.
//    DEFAULTS: shape dot=0, size=5 points, color=red
// * plotPoints() displays this help

// License: GPL
// Authors & History: 
//   2009-05-20 : S. Gougeon (Le Mans, France)
//		Creation

	N=argn(2);	// number of input arguments
	if N==0, head_comments('plotPoints'); return; end
	xyz=varargin(1);
	if size(xyz,2)<2 | size(xyz,2)>3
		tmp="%s: Coordinates XYZ in 1st argument must be a Nx2 or Nx3 matrix";
		error(msprintf(gettext(tmp)+"\n","plotPoints"));
	end
	ca=gca();
	Aview=ca.rotation_angles;
	if size(xyz,2)==3 & Aview==[0 270], Aview=[45 315]; end
	
	drawlater()
	plot2d(xyz(:,1),xyz(:,2));
	cc=ca.children(1).children(1);
	if size(xyz,2)==3, cc.data(:,3)=xyz(:,3); end
	cc.line_mode='off';
	cc.mark_mode='on';
	if N>1, tmp=varargin(2); else tmp=0;	end
	cc.mark_style=tmp;
	cc.mark_size_unit='point';
	if N>2, tmp=varargin(3); else tmp=5;	end
	cc.mark_size=tmp;
	if N>3, 
		tmp=varargin(4); 
		if typeof(tmp)=="string", tmp=color(tmp); end
	else tmp=color('red');
	end
	cc.mark_foreground=tmp;
	ca.rotation_angles=Aview;
	drawnow()
	
endfunction
Np=20
//Z=zeros(Np,Np)
//Mm=zeros(Np,Np)
//Mp=zeros(Np,Np)
//V=linspace(0.05,1,Np)
//K=linspace(0.05,3,Np)
//for i=1:Np do
//    v=V(i)
//    for j=1:Np do
//        k=K(j)
//        mu=(k*v+v)/k
//        Z(j,i)=(k*v+v)/k
//        minim=%inf
//        maxim=%inf
//        while mu<25 do 
//            P=[v*(k*v+v-k*mu+mu)/(k*mu*(v-mu)),-v;(k*mu-(k+1)*v)/(k*mu),0]
//            evals=spec(P)
//            if real(evals(1))<0 & real(evals(2))<0 then
//                if mu<minim then
//                    Mm(j,i)=mu
//                    minim=0
//                else
//                    maxim=mu
//                    Mp(j,i)=mu
//                end
//            end 
//            if mu>maxim then
//                    break
//            end
//            mu=mu+0.01
//        end
//    end
//end
//clf()
////surf(V,K,Mm,'facecol','red','edgecol','red")
//surf(V,K,Mp,'facecol','blu','edgecol','blu")
//surf(V,K,Z,'facecol','black','edgecol','red")


//M=[0,0,0,0,0]
//for v=linspace(0.1,1,Np) do
//    for k=linspace(0.1,5,Np) do
//        for mu=linspace((k*v+v)/k,2*(k*v+v)/k,Np) do
//            P=[v*(k*v+v-k*mu+mu)/(k*mu*(v-mu)),-v;(k*mu-(k+1)*v)/(k*mu),0]
//            evals=spec(P)
//            if real(evals(1))<0 & real(evals(2))<0 then
//                M=[M;v,k,mu,evals(1),evals(2)]
//            end
//        end
//    end
//end
//plotPoints(M(:,:))

//Np=20
//k=2.1947368; v=0.1;
//R=1:200
//T=1:200
//MU=linspace(0.01,1,200)'
//for i=1:200 do
//    mu=MU(i)
//    P=[v*(k*v+v-k*mu+mu)/(k*mu*(v-mu)),-v;(k*mu-(k+1)*v)/(k*mu),0]
//    evals=spec(P)
//    R(i)=evals(1)
//    T(i)=evals(2)
//end
//plot2d(MU,[real(R)' imag(R)' real(T)' imag(T)'],rect=[0,-2,1,2])

Np=5
M=zeros(Np*Np*Np,5)
i=1
for v=linspace(0.01,5,Np) do
    for mu=linspace(v+0.01,3*v+1,Np) do
        for k=linspace(v/(mu-v),(v+mu)/(mu-v),Np) do
            P=[v*(k*v+v-k*mu+mu)/(k*mu*(v-mu)),-v;(k*mu-(k+1)*v)/(k*mu),0]
            evals=spec(P)
            M(i,:)=[v,mu,k,evals(1),evals(2)]
            i=i+1
        end
    end
end
disp("/////////////////////")
disp("///////STABLE//////////")
disp("/////////////////////")
disp(M)
M=zeros(Np*Np*Np,5)
i=1
for v=linspace(0.1,5,Np) do
    for mu=linspace(v+0.01,3*v+1,Np) do
        for k=linspace(0.001,v/(mu-v)-0.01,Np) do
            P=[v*(k*v+v-k*mu+mu)/(k*mu*(v-mu)),-v;(k*mu-(k+1)*v)/(k*mu),0]
            evals=spec(P)
            M(i,:)=[v,mu,k,evals(1),evals(2)]
            i=i+1
        end
    end
end
disp("/////////////////////")
disp("///////BELOW-K/0 UNSTABLE//////////")
disp("/////////////////////")
disp(M)
M=zeros(Np*Np*Np,5)
i=1
for v=linspace(0.1,5,Np) do
    for mu=linspace(v+0.01,3*v+1,Np) do
        for k=linspace((v+mu)/(mu-v),3*(v+mu)/(mu-v),Np) do
            P=[v*(k*v+v-k*mu+mu)/(k*mu*(v-mu)),-v;(k*mu-(k+1)*v)/(k*mu),0]
            evals=spec(P)
            M(i,:)=[v,mu,k,evals(1),evals(2)]
            i=i+1
        end
    end
end
disp("/////////////////////")
disp("////////OVER-CYCLE STABLE/////////")
disp("/////////////////////")
disp(M)
M=zeros(Np*Np*Np,5)
i=1
for v=linspace(0.1,5,Np) do
    for mu=linspace(.001,v-0.01,Np) do
        for k=linspace(0.001,20,Np) do
            P=[v*(k*v+v-k*mu+mu)/(k*mu*(v-mu)),-v;(k*mu-(k+1)*v)/(k*mu),0]
            evals=spec(P)
            M(i,:)=[v,mu,k,evals(1),evals(2)]
            i=i+1
        end
    end
end
disp("/////////////////////")
disp("////////mu < v/////////")
disp("/////////////////////")
disp(M)
