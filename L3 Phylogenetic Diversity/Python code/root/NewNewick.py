'''
Created on Jul 22, 2013

@author: Thibault
'''
import os
from module import *
import matplotlib.pyplot as plt  # plt is needed for ploting the output.

os.chdir("C:\\Users\\Thibault\\workspace\\LBEPy")

N=10**9
tree=AbundanceTree("silva.nh")
s=len(tree)
community_abundance=power_law_distribution(s,N)
tree.fill_leaves(community_abundance)
tree.fill_tree()

hill_parameters , diversity=tree.diversity()

effort_list = np.array([500,1000,10000,100000,1000000,10000000])
colormap = plt.get_cmap('jet')

plt.figure(1)
plt.title("The hill diversity of the community (black plain), \n the Good-Turing estimates (dashed) \n for the sivla tree and log normal distribution \n for N=%1.1E, S=%d " % (N, s))
label = "Silva tree"
plt.plot(hill_parameters,diversity, color="black", linewidth=4.0)
for plot_id, effort in enumerate(effort_list):
    print plot_id
    color = colormap(1.*(plot_id) / (len(effort_list)))
    M=effort
    community_sample=sample(community_abundance,M)
    tree.fill_leaves(community_sample)
    goodturing=tree.dico_good_turing()
    for i in goodturing:
        print i, goodturing[i]
    _ , lowerdiversity=tree.lowerestimate(goodturing)
    print "lower"
    _ , upperdiversity=tree.upperestimate(N,goodturing)
    label="Sample size : %1.1E"%(M)
    plt.plot(hill_parameters,lowerdiversity, color=color, label=label, linewidth=2.0, linestyle="--")
    plt.plot(hill_parameters,upperdiversity, color=color, linewidth=2.0, linestyle="--")

plt.legend(loc="best")
plt.yscale('log')
plt.show()