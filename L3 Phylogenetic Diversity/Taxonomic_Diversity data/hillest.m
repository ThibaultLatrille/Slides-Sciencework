function estims = hillest(abun,alpha,commsize)
% function estims = hillest(abun,alpha,commsize)
% estimates of Hill diversity based on rarefaction curve
% . abun: vector of absolute species abundances in sample
% . alpha: order of Hill diversity to be estimated
% . commsize: (estimated) community size
% . estims(1): natural logarithm of lower estimate of Hill diversity
% . estims(2): natural logarithm of upper estimate of Hill diversity

smplsize = sum(abun);

if alpha==2,
% case alpha=2: Simpson diversity
% compute unbiased estimator of Simpson concentration index
    aux = sum(abun.*(abun-1))/smplsize/(smplsize-1);
    estims = -log(aux)*[1 1];
    return
end

if alpha==0,
% case alpha=0: species richness
% compute Chao's estimator of species richness
f1 = sum(abun==1);
    f2 = sum(abun==2);
    sobs = sum(abun>=1);
    estims = log(sobs+[f1^2/2/f2 commsize*f1/smplsize]);
    return
end
    
% general case: alpha>0 and alpha<2
% we have to compute an infinite sum
% we split this infinite sum into two parts
% terms below cutoff are computed exactly
cutoff = 100;
if smplsize <= cutoff,
    disp('ERROR: sample size has to be larger than 100')
end
ss = zeros(1,cutoff);
for c = 1:cutoff,
    aux = gammaln(smplsize-abun+1) ...
        - gammaln(smplsize+1) ...
        + gammaln(smplsize-c+1) ...
        - gammaln(smplsize-c-abun+1);
    ss(c) = sum(1-exp(aux));
end
ii = 1:cutoff;
cc = alpha/gamma(2-alpha) * ...
    exp(gammaln(ii-alpha)-gammaln(ii+1));
aux = ss.*cc;
c1 = sum(aux(2:end-1))+aux(end)/2;
% terms above cutoff are approximated by integral
% computation for lower estimate
c2 = quad(@(x) integrand(x,abun,alpha,commsize,1),0,1);
% computation for upper estimate
c3 = quad(@(x) integrand(x,abun,alpha,commsize,2),0,1);

% lower and upper estimate for Tsallis entropy
estims = -1+c1+[c2 c3];
% lower and upper estimate for Renyi entropy
% recall: Renyi entropy = natural logarithm of Hill diversity
if alpha ~= 1,
    estims = log(1+(1-alpha)*estims)/(1-alpha);
end

end

%-------------------------------------------------------------------
function f = integrand(y,abun,alpha,commsize,flag)
% function f = integrand(y,abun,alpha,commsize,flag)
% computes integrand for Hill diversity estimates
% flag=1 for lower estimate
% flag=2 for upper estimate

cutoff = 100;
beta = alpha;
x = cutoff*y.^(-1/beta);

% compute rarefaction curve
c1 = zeros(size(x));
smplsize = sum(abun);

ii1 = find(x<=smplsize);
for c = 1:length(ii1),
    i1 = ii1(c);
    aux = gammaln(smplsize-abun+1) ...
        - gammaln(smplsize+1) ...
        + gammaln(smplsize-x(i1)+1) ...
        - gammaln(smplsize-x(i1)-abun+1);
    c1(i1) = sum(1-exp(aux));
end

ii2 = find(x>smplsize);
f1 = sum(abun==1);
f2 = sum(abun==2);
for c = 1:length(ii2),
    i2 = ii2(c);
    if flag==1,
        c1(i2) = length(abun) + f1^2/2/f2* ...
            (1-(1-2*f2/f1/smplsize).^(x(i2)-smplsize));
    elseif flag==2,
        c1(i2) = length(abun) + commsize*f1/smplsize* ...
            (1-exp(-(x(i2)-smplsize)/commsize));
    end
end

% compute weights
c2 = zeros(size(x));

ii1 = find(x<=1e6);
c2(ii1) = alpha/gamma(2-alpha) * ...
        exp(gammaln(x(ii1)-alpha)-gammaln(x(ii1)+1));
ii2 = find(x>1e6);
c2(ii2) = alpha/gamma(2-alpha) * x(ii2).^(-alpha-1);

% compute integrand
f = c1.*c2.*x./y/beta;

% separate computations for large x
ii3 = find(x>=1e20);
for c = 1:length(ii3),
    if flag==1,
        f(ii3) = (length(abun) + f1^2/2/f2* ...
            (1-(1-2*f2/f1/smplsize).^(x(ii3)-smplsize))) ...
            * alpha/gamma(2-alpha)/cutoff^beta/beta;
            % .* x(ii3).^(beta-alpha)   if alpha \neq beta
    elseif flag==2,
        f(ii3) = (length(abun) + commsize*f1/smplsize* ...
            (1-exp(-(x(ii3)-smplsize)/commsize))) ...
            * alpha/gamma(2-alpha)/cutoff^beta/beta;
            % .* x(ii3).^(beta-alpha)   if alpha \neq beta
    end
end

end
