P=linspace(0.67,1,30)
lowerbound=zeros(30)
higherbound=zeros(30)
estimate=zeros(30)
for i=1:30 do 
    p=P(i)
    bootstrap=zeros(1,1000)
    for j=1:1000 do
        n=5000
        M=zeros(1,n)
        for k=1:n do
            if rand()<p then
                loop=%F
                M(k)=1
            else
                x=2
                T=1
                loop=%T
            end
            while loop do
                T=T+1
                if rand()<p then
                    x=x-1
                    if x==0 then
                        M(k)=T
                        loop=%F
                    end
                else x=x+2
                end
            end
        end
        bootstrap(j)=1/mean(M)
    end
    bootstrap=gsort(bootstrap)
    lowerbound(i)=bootstrap(975)
    higherbound(i)=bootstrap(25)
    estimate(i)=mean(bootstrap)
end
plot(P,higherbound,"red")
plot(P,lowerbound,"green")
plot(P,estimate)
