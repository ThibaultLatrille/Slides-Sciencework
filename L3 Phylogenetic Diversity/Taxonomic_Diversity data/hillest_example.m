%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ILLUSTRATION OF HILL DIVERSITY ESTIMATORS
% (A) IN SILICO GENERATED SAMPLE DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1/ generate power-law community and take sample
% 2/ compute Hill diversity estimates from sample data
% 3/ generate plot of Hill diversity estimates

% we generate a community with power-law abundance distribution
z=2; % z = exponent of the power-law distribution
s=1e6; % ss = species richness of the community
ii=1:s;
pp=exp(-z*log(ii));
pp=pp/sum(pp);
aa=union(0:.1:2,.2:.02:1.2);
hilltrue=zeros(1,length(aa));
for cnt=1:length(aa),
    a=aa(cnt);
    if a==0,
        hilltrue(cnt)=log(length(pp));
    elseif a==1,
        hilltrue(cnt)=sum(-pp.*log(pp));
    else
        hilltrue(cnt)=log(sum(pp.^a))/(1-a);
    end
end

% we take a sample from the power-law community
% we compute the Hill diversity estimates
sss=[1e4 1e5 1e6];
for cnts=1:3,
    mm=sss(cnts); % mm = sample size
    aux=randsample(s,mm,true,pp);
    abun=hist(aux,1:s);
    abun=sort(abun(abun>0),'descend');
    css=[1e10 1e15 1e20];
    for cntc=1:3,
        nn=css(cntc); % nn = community size
        hillests{cnts,cntc}=zeros(length(aa),2);
        for cnt=1:length(aa),
            hillests{cnts,cntc}(cnt,:)=hillest(abun,aa(cnt),nn);
        end
    end
end

% we plot Hill diversity estimates vs Hill parameter
figure
cols1=[1 .8 .8;.8 .8 1;.8 1 .8];
cols2='rbg';
for cnts=1:3,
    mm=sss(cnts); % mm = sample size
    for cntc=1:3,
        nn=css(cntc); % nn = community size
        subplot(3,3,cnts+3*(cntc-1))
        patch([aa aa(end:-1:1)], ...
            [exp(hillests{cnts,cntc}(:,1))' ...
             exp(hillests{cnts,cntc}(end:-1:1,2))'], ...
            cols1(cnts,:))
        hold on
        plot(aa,exp(hilltrue),'k','linewidth',1)
        plot(aa,exp(hillests{cnts,cntc}),cols2(cnts),'linewidth',1)
        plot([0 2],1e8*[1 1],'k')
        axis([0 2 1 1e8])
        set(gca,'yscale','log')
        set(gca,'box','on')
        set(gca,'xtick',0:.5:2)
        set(gca,'ytick',10.^(0:2:8))
        set(gca,'fontsize',6)
        text(1,1e7,['$N = 10^{' num2str(round(log10(nn))) '}$'], ...
            'interpreter','latex','fontsize',10)
        text(1,7e5,['$M = 10^{' num2str(round(log10(mm))) '}$'], ...
            'interpreter','latex','fontsize',10,'color',cols2(cnts))
        if cnts==1,
            ylabel('Hill diversity','interpreter','latex','fontsize',10)
        end
        if cntc==3,
            xlabel('Hill parameter','interpreter','latex','fontsize',10)
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ILLUSTRATION OF HILL DIVERSITY ESTIMATORS
% (B) EMPIRICALLY SAMPLED DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1/ load file with sample abundance distribution
% 2/ compute Hill diversity estimates for sample data
% 3/ generate plot of Hill diversity estimates

% we load the data file
fid=fopen('data.rtf');
for c=1:9,
    aux=textscan(fid,'%[^,]');
    data(c).name=aux{1}{1};
    aux=textscan(fid,',%f');
    data(c).abun=aux{1};
end
fclose(fid);

% we compute the Hill diversity estimates
commsize=10^15;
aa=union(0:.1:2,.2:.02:1.2);
for idxsmp=1:9,
    abun=data(idxsmp).abun;
    estims{idxsmp}=zeros(length(aa),2);
    for cnt=1:length(aa),
        estims{idxsmp}(cnt,:)=hillest(abun,aa(cnt),commsize);
    end
end

% we plot Hill diversity estimates vs Hill parameter
figure
titles = {'upper ocean', 'soil, Brazil', 'soil, Florida', ...
    'soil, Illinois', 'soil, Canada', 'FS312, bacteria', ...
    'FS312, archaea', 'FS396, bacteria', 'FS396, archaea'};
for c=1:9,
    subplot(3,3,c)
    semilogy(aa,exp(estims{c}),'k','linewidth',1)
    hold on
    aux1=exp(estims{c}(:,1))';
    aux2=exp(estims{c}(:,2))';
    patch([aa aa(end:-1:1)],[aux1 aux2(end:-1:1)],[.8 .8 .8])
    axis([0 2 1 1e8])
    plot([0 2],[1e8 1e8],'k','linewidth',1)
    set(gca,'xtick',0:.5:2)
    set(gca,'ytick',10.^(0:2:8))
    set(gca,'fontsize',6)
    if sum(c==[1 4 7]),
        ylabel('Hill diversity','interpreter','latex','fontsize',10)
    end
    if c>6,
        xlabel('Hill parameter','interpreter','latex','fontsize',10)
    end
    title(titles{c},'interpreter','latex','fontsize',10)
end
