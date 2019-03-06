'''
Created on Jul 19, 2013

@author: Thibault
'''
from Newmodule import *  # Import AbundanceTree 
import matplotlib.pyplot as plt  # plt is needed for ploting the output.

import os

os.chdir("C:\\Users\\Thibault\\workspace\\UniFrac")

tree=AbundanceTree("sampled_silva.nh")
N=10**8
tree.power_law(N, True)
tree.fill_tree()
hill_parameters , hill_diversity=tree.diversity()
plt.plot(hill_parameters,hill_diversity, color="black", linewidth=3.5,linestyle="--")

tree.sample(10*4)

goodturing=tree.dico_good_turing()

btree=tree.copy()
hill_parameters , miihill_diversity =btree.minestimate(goodturing)
plt.plot(hill_parameters,miihill_diversity, color="green", linewidth=2.5,linestyle="--")

btree=tree.copy()
hill_parameters , mihill_diversity =btree.lowerestimate(goodturing)
plt.plot(hill_parameters,mihill_diversity, color="red", linewidth=2.5,linestyle="--")

btree=tree.copy()
hill_parameters , mmhill_diversity =btree.upperestimate(N,goodturing)
plt.plot(hill_parameters,mmhill_diversity, color="red", linewidth=2.5,linestyle="--")

btree=tree.copy()
hill_parameters , mhill_diversity =btree.maxestimate(N,goodturing)


mhill_diversity+=hill_diversity[-1]-mhill_diversity[-1]
mmhill_diversity+=hill_diversity[-1]-mmhill_diversity[-1]

plt.plot(hill_parameters,mhill_diversity, color="green", linewidth=2.5,linestyle="--")

plt.yscale('log')
plt.show()