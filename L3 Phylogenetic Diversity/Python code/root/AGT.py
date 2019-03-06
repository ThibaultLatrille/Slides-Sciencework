from Newmodule import *  # Import AbundanceTree 
import matplotlib.pyplot as plt  # plt is needed for ploting the output.

import os

os.chdir("D:\Desktop\LBE_Stage\Taxonomic_Diversity")
plt.figure(1)
folder=((2,10,1),(2,15,2),(2,20,3),(4,10,4),(4,15,5),(4,20,6),(6,10,7),(6,15,8),(6,20,9))

startree=startree(s=10**6)
ii = np.array(range(1, 10**6 + 1))
ii = np.exp(-2 * np.log(ii))
ii = ii / sum(ii)
startree.fill_tree(ii)
hill_parameters , stardiversity=startree.diversity()

for xx,yy,plot_nb in folder:
    N=10**yy
    M=10**xx
    upper_estimate_fig=[]
    lower_estimate_fig=[]
    hill_parameter_fig=[]
    hill_diversity_fig=[]
    
    with open("fig4_"+str(xx)+"_"+str(yy)+".dat", 'r') as f:
        for line in f:
            list_line=line.split(",")
            hill_parameter_fig.append(float(list_line[0]))
            lower_estimate_fig.append(exp(float(list_line[1])))
            upper_estimate_fig.append(exp(float(list_line[2])))
    
    with open("fig4_true.dat", 'r') as f:
        for line in f:
            list_line=line.split(",")
            hill_diversity_fig.append(exp(float(list_line[1])))
    
    
    plt.subplot(3, 3, plot_nb)
    plt.title("The hill diversity of the community (plain) \n, the Good-Turing estimates (dashed) \n for N=%1.1E, S=%d, and M=%d " % (10**yy, 10**6, 10**xx))
    label = "Very old implementation"
    plt.plot(hill_parameter_fig,hill_diversity_fig, label=label, color="red", linewidth=4.0, linestyle="-")
    plt.plot(hill_parameter_fig,lower_estimate_fig, color="red", linewidth=2.0, linestyle="--")
    plt.plot(hill_parameter_fig,upper_estimate_fig, color="red", linewidth=2.0, linestyle="--")
    
    #startree.sample(M=10**xx)
    abundance_cumulative = np.cumsum(ii)
    abundance_cumulative[-1]=1.0
    sample=np.array([0]*len(abundance_cumulative))
    rand_list = np.linspace(0, 1, M)
    index=0
    i=0
    while index<M:
        threshold=abundance_cumulative[i]
        number=0
        while 1:
            try:
                if threshold<rand_list[index]:
                    i+=1
                    break
            except:
                i+=1
                break
            else:
                index+=1
                number+=1
        sample[i-1] += number
    startree.fill_leaves(sample)
    #startree.power_law(N=10**xx)
    goodturing=startree.dico_good_turing()
    _ , starlowerdiversity=startree.lowerestimate(goodturing=goodturing)
    _ , starupperdiversity=startree.upperestimate(N=10**yy,goodturing=goodturing)
    
    label = "New implementation"
    plt.plot(hill_parameters,stardiversity, label=label, linewidth=2.0)
    plt.plot(hill_parameters,starlowerdiversity, color="blue", linewidth=2.0, linestyle="--")
    plt.plot(hill_parameters,starupperdiversity, color="blue", linewidth=2.0, linestyle="--")
    
    _ , starlowerdiversity=startree.oldlowerestimate()
    _ , starupperdiversity=startree.oldupperestimate(N=N)
    
    label = "Old implementation"
    plt.plot(hill_parameters,starlowerdiversity, label=label, color="green", linewidth=2.0, linestyle="--")
    plt.plot(hill_parameters,starupperdiversity, color="green", linewidth=2.0, linestyle="--")
    
    plt.legend(loc="best")
    
    plt.yscale('log')

plt.show()