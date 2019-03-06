from ete2 import TreeNode  # ete2 is a package needed for the class TreeNode.
import numpy as np  # numpy makes computation on vector faster and easier.
from math import exp, log, pow  # exponential and logarithm function.
import random  # Package for generating pseudo-random numbers.

def power_law_distribution(z=2, s=10**5, N=0):
    '''
    Return a vector of size s were the elements are distributed
    according to a power-law distribution with parameter z.
    All elements are integers and the sum of all elements equal approximatively s**2. 
    The sum can be different of s**2 due to numerical approximations.
    In terms of biology, s is the number of species and the elements are
    the number of individuals belonging to each species.
    '''
    ii = np.array(range(1, s + 1))
    ii = np.exp(-z * np.log(ii))
    ii = ii / sum(ii)
    if not N:
        N = s**2
    ii = np.array([int(round(i)) for i in ii * N])
    return(ii)

class AbundanceTree(TreeNode):
    '''
    AbundanceTree is class inherited from TreeNode, the class defined in the package ete2.
    Contains all the methods and attributes of TreeNode and add an attribute .abundance. 
    abundance is the weight of this node. The sum of the abundance of the leaves must equal one 
    and the abundance of a node is total abundance descended from from this node. 
    '''
    def __init__(self, newick=None, formating=0):
        TreeNode.__init__(self, newick, formating)
        self.abundance = None
    
    def fill_leaves(self, abundance_list):
        '''
        Fill the attributes abundance of the leaves of the tree using the the vector abundance_list. 
        '''
        if len(self) == len(abundance_list):
            for leaf , leaf_abundance in zip(self, abundance_list):
                leaf.abundance = leaf_abundance
            
        else:
            print("I will add abundances to the leaves only if the length of \n")
            print("your list matches the number of leaves, simple isn't it ! ")
    
    def fill_tree(self):
        '''
        Fill the attributes abundance of all internal nodes by climbing up 
        the tree from the leaves and summing over the children for each node.
        This methods shall be used after fill_leaves.
        '''
        for node in self.traverse("postorder"):
            if not node.is_leaf():
                node.nabundance = sum([child.nabundance for child in node.children])
        
        self.dist = 0
    
    def diversity(self, q=2):
        '''
        Return the Hill diversity of order q of the tree.
        The hill diversity is defined as in Chao & Al (2010).
        '''       
        D = 0.0
        T = 0.0
        if q == 1:  # for the special case q=1
            for node in self.traverse():
                if node.nabundance != 0.:
                    T += node.dist * node.nabundance
                    D += node.dist * node.nabundance * log(node.nabundance)
            
            D = exp(-D / T)
        else:
            for node in self.traverse():
                if node.nabundance != 0:
                    T += node.dist * node.nabundance
                    D += node.dist * ((node.nabundance)**q)
            D = (D / T)**(1 / (1 - q))
        return D

class Simulate(object):
    def __init__(self,s=10**3,samplesize=10**2, N=0, tree=None, random_tree=True, replace=True, sample_all_community=False, abundance_distribution=None):
        '''
        Initiate an object Simulate and compute the simulation.
        The object contains six attributes :
        1) Simulate.hill_parameters : 
        Vector of Hill parameters (order of the diversity) for which the diversity 
        is computed
        2) Simulate.diversity
        Vector of Hill phylogenic diversity for the whole community
        3) Simulate.diversity_of_the_samples
        2-dimensional array, each columns is a vector of Hill phylogenic diversity 
        computed for the jth sample.
        4) Simulate.N : 
        The number of individuals in the community
        5) Simulate.s :  
        The  species richness (number of species) of the community
        6) Simulate.samplesize :
        The number of individuals in the sample extracted from the community
        Must be lower than N
        
        INPUTS:
        ===================== s (by default 10**3) ===============================
         The number of species (the species richness) in the community, also the
         number of leaves in the tree
        
        
        ========== N (will be approximatively s**2 if not provided) ===============
         The number of individuals in the whole community. Must be greater than s.
        
        
        =================== samplesize (by default 10**2) =========================
         The number of individuals in the sample extracted from the community.
         Must be lower than N
        
        
        ====================== tree (by default None) =============================
         Use a tree of class AbundanceTree, 
        
        
        =================== random_tree (by default True) =========================
         random_tree must be True if we want to generate a random tree.
         random_tree must be set to False if we want a star-shaped tree. 
         The star-shaped tree is equivalent to compute the diversity without 
         taking into account the underlying phylogeny.
        
        
        =================== replace (by default True)  ============================
         replace must be True if we want to sample with replacement.
         replace must be set to False if we want to sample without replacement
        
        
        =============== sample_all_community (by default False) ===================
         If  sample_all_community is true, the sample will contains as many 
         individuals as the whole community. In the case of sampling without 
         replacement, the sample will exactly be the community.
        '''
        if tree:
            s=len(tree) 
        if not abundance_distribution:
            abundance_distribution = power_law_distribution(z=2, s=s, N=N)  
        # We generate a community of N individuals distributed in s species,
        # The community is distributed according to a power law distribution, 
        # where N is approximatively equal species_richness squared.
        # It is worth noticing that there is no randomness in this process.
        # Two calls of this function with the same parameters will produce the same distribution.
        abundance_cumulative = np.cumsum(abundance_distribution)
        #  We compute the cumulative distribution of , used later on for sampling.
        N = abundance_cumulative[-1]  # N is the number of individuals in the community.
        
        permutation = np.random.permutation(s)  # a vector used to shuffle the species.
        abundance_distribution_shuffled = np.array([abundance_distribution[i] for i in permutation ]) 
        #  shuffling the vector abundance_distribution using the vector permutation.
        
        if not tree:
            tree = AbundanceTree()  # Initiate the object tree.
            if random_tree:
                tree.populate(s, random_branches=True)  # Generating a random tree with s leaves.
            else:
                # Generating a star-shaped tree with s leaves.
                for i in range(s): 
                    tree.add_child()
        
        tree.dist = 0  # The root has a branch length of 0.
        tree.fill_leaves(abundance_distribution_shuffled / float(N)) 
        # Fill-in the leaf abundances with the shuffled abundance distribution (normalized to 1)
        tree.fill_tree()  # Fill-in the internal nodes using the abundances of the leaves.
        
        qmin = 0.0  # The minimum hill parameter
        qmax = 2.0  # The maximum hill parameter
        nb_of_q = 100  # The number of hill diversity we set to compute 
        diversity = np.array([0.]*nb_of_q)  # Initiate the vector of hill diversity
        hill_parameters = np.linspace(qmin, qmax, nb_of_q)  
        # All values of q equally distant between qmin and qmax (vectors of size points).
        for i in range(nb_of_q):
            diversity[i] = tree.diversity(hill_parameters[i])
            # Compute the hill diversity of tree for all value of q
        
        nb_of_samples = 30
        # The number time we extract a sample from the community
        diversity_of_the_samples = np.zeros((nb_of_q, nb_of_samples))
        # An array of nb_of_q row and nb_of_samples columns 
        
        
        if sample_all_community:
            samplesize=N
        
        if samplesize<=N+1 & samplesize>0:
            for j in range(nb_of_samples):
                sample = np.array([0] * s)  
                # The sample has the same distribution as abundance_distribution
                # but the sum will equal samplesize instead of N.
                if replace:
                    for i in range(samplesize):
                        random_int = random.randint(0, N)
                        index = (i for i, v in enumerate(abundance_cumulative) if v >= random_int).next()
                        sample[index] += 1
                else:
                    for i in range(samplesize):
                        random_int = random.randint(0, N)
                        index = (i for i, v in enumerate(abundance_cumulative) if v >= random_int).next()
                        sample[index] += 1
                        abundance_cumulative[index] -= 1
                    abundance_cumulative = np.cumsum(abundance_distribution)
                sample_shuffled = np.array([sample[i] for i in permutation ])
                tree.fill_leaves(sample_shuffled / float(samplesize))
                tree.fill_tree()
                for i, q in enumerate(hill_parameters):
                    diversity_of_the_samples[i, j] = tree.diversity(q)
        else:
            print("sample size must be lower than the size of the community")
        self.hill_parameters=hill_parameters
        self.diversity=diversity
        self.diversity_of_the_samples=diversity_of_the_samples
        self.N=N
        self.s=s
        self.samplesize=samplesize
    
    def __repr__(self):
        string="N="+str(self.N)+", S="+str(self.s)+", Sample size : "+str(self.samplesize)+"\n\n"
        string+="Diversity : \n"+str(self.diversity)+"\n\n"
        string+="for q in : \n"+str(self.hill_parameters)+"\n\n"
        string+="Diversity of the samples : \n"+str(self.diversity_of_the_samples)
        return string

import matplotlib.pyplot as plt  # plt is needed for ploting the output.

def plot(*plot_list):
    '''
    The input is a set of object of the class Simulate separated by commas
    example : 
    simu1=Simulate(s=10**3,samplesize=2000,random_tree=False)
    simu2=Simulate(s=10**3,samplesize=500,random_tree=False)
    plot(simu1,simu2)
    
    A window is produced, this window contains
    six panel with different output. The x axis is the always
    the value of the order of the diversity (q).
    1) (First row, First column)
    The hill diversity of the community (darker line) along with
    the hill diversity of the samples (lighter lines)
    
    2) (First row, Second column)
    The diversity variance of the samples
    3) (First row, Third column)
    
    The coefficient of variation (CV) of the samples,
    also known as relative standard deviation.
    The CV is defined as the ratio of the standard deviation to the mean.
    
    4) (Second row, First column)
    The diversity standard deviation of the samples divided by 
    the diversity of the whole community.
    
    5) (Second row, Second column)
    The diversity of the whole community minus the mean of the sample.
    
    6) (Second row, Third column)
    The diversity of the whole community divided by the mean of the sample.
    '''
    colormap = plt.get_cmap('Set1')
    plt.figure(1)
    nb_of_plots = len(plot_list)
    ymax = max([max(simul.diversity_of_the_samples[0, :]) for simul in plot_list]) * 2
    
    for simul_id, simul in enumerate(plot_list):
        hill_parameters = simul.hill_parameters
        diversity = simul.diversity
        diversity_of_the_samples = simul.diversity_of_the_samples
        color = colormap(1.*simul_id / nb_of_plots)
        plt.rcParams.update({'font.size': 12})
        
        plt.subplot(231)
        plt.ylim(0, ymax)
        nb_of_samples = len(diversity_of_the_samples[0, :])
        color_light = (color[0], color[1], color[2], 0.8)
        for j in range(nb_of_samples):
            plt.plot(hill_parameters, diversity_of_the_samples[:, j], color=color_light)
        
        plt.title("The hill diversity of the community (wide) \n and of the samples (thin)")
        
        plt.subplot(232)
        plt.plot(hill_parameters, np.var(diversity_of_the_samples, axis=1),
        color=color, linewidth=3.0)
        plt.title("The diversity variance of the samples")
        
        plt.subplot(233)
        plt.plot(hill_parameters, np.sqrt(np.var(diversity_of_the_samples, axis=1)) / np.mean(diversity_of_the_samples, axis=1), color=color, linewidth=3.0)
        plt.title("The coefficient of variation of the samples")
                
        plt.subplot(234)
        plt.plot(hill_parameters, np.var(diversity_of_the_samples, axis=1) / diversity, color=color, linewidth=3.0)
        plt.title("The diversity standard deviation of the samples divided \n by the diversity of the whole community")
        
        plt.subplot(235)
        plt.plot(hill_parameters, diversity - np.mean(diversity_of_the_samples, axis=1), color=color, linewidth=3.0)
        plt.title("The diversity of the whole community \n minus the mean of the sample")
        
        plt.subplot(236)
        plt.plot(hill_parameters, np.mean(diversity_of_the_samples, axis=1) / diversity, color=color, linewidth=3.0)
        plt.title("The diversity of the whole community \n divided by the mean of the sample")
    
    plt.subplot(231)
    for simul_id, simul in enumerate(plot_list):
        hill_parameters = simul.hill_parameters
        diversity = simul.diversity
        diversity_of_the_samples = simul.diversity_of_the_samples
        color = colormap(1.*simul_id / nb_of_plots)
        label = "N=%1.1E, S=%d, Sample size=%d" % (simul.N, simul.s, simul.samplesize)
        nb_of_samples = len(diversity_of_the_samples[0, :])
        plt.plot(hill_parameters, diversity, color=color, label=label, linewidth=3.0)
    
    plt.legend(loc='best')
    plt.show()

if __name__ == '__main__':
    simu = Simulate(s=10 ** 3, samplesize=500)
    simu1 = Simulate(s=10 ** 3, samplesize=500)
    simu2 = Simulate(s=10 ** 3, samplesize=500)
    simu3 = Simulate(s=10 ** 3, samplesize=500, random_tree=False)
    simu4 = Simulate(s=10 ** 3, samplesize=500, random_tree=False)
    simu5 = Simulate(s=10 ** 3, samplesize=500, random_tree=False)
    plot(simu, simu1, simu2, simu3, simu4, simu5)

