from ete2 import TreeNode  # ete2 is a package needed for the class TreeNode.
import numpy as np  # numpy makes computation on vector faster and easier.
from math import exp, log, pow, ceil   # exponential and logarithm function.
import random  # Package for generating pseudo-random numbers.
import itertools

def power_law_distribution(s, N):
    '''
    Return a vector of size s were the elements are distributed
    according to a power-law distribution with parameter z.
    All elements are integers and the sum of all elements equal approximatively s**2. 
    The sum can be different of s**2 due to numerical approximations.
    In terms of biology, s is the number of species and the elements are
    the number of individuals belonging to each species.
    '''
    ii = np.array(range(1, s + 1))
    ii = np.exp(-2 * np.log(ii))
    ii = ii / sum(ii)
    np.random.shuffle(ii)
    if N<10**9:
        abundance_cumulative = np.cumsum(ii)
        abundance_cumulative[-1]=1.0
        abundance=np.array([0]*len(abundance_cumulative))
        rand_list = np.linspace(0, 1, N)
        index=0
        i=0
        while index<N:
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
            abundance[i-1] += number
        return abundance
    else:
        return [int(i*N) for i in ii]

def sample(abundance,M):
    abundance_cumulative = np.cumsum(abundance)
    sample=[0]*len(abundance_cumulative)
    N=abundance_cumulative[-1]
    if N>10**9:
        rand_list = [random.randint(1,N) for i in xrange(M)]
    else:
        rand_list = np.random.randint(1, N, M)
    rand_list.sort()
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
    return sample

class AbundanceTree(TreeNode):
    '''
    AbundanceTree is class inherited from TreeNode, the class defined in the package ete2.
    Contains all the methods and attributes of TreeNode and add an attribute .abundance. 
    abundance is the weight of this node. The sum of the abundance of the leaves must equal one 
    and the abundance of a node is total abundance descended from this node. 
    '''
    def __init__(self, newick=None, formating=0):
        TreeNode.__init__(self, newick, formating)
        self.abundance = None
        self.nabundance = None
    
    def fill_leaves(self, abundance_list):
        '''
        Fill the attributes abundance of the leaves of the tree using the vector abundance_list. 
        '''
        if len(self) == len(abundance_list):
            for leaf , leaf_abundance in zip(self, abundance_list):
                leaf.abundance = leaf_abundance  
        else:
            print("I will add abundances to the leaves only if the length of \n")
            print("your list matches the number of leaves, simple isn't it ! ")
    
    def fill_tree(self,nabundance_list=0):
        '''
        Fill the attributes abundance of all internal nodes by climbing up 
        the tree from the leaves and summing over the children for each node.
        This methods shall be used after fill_leaves.
        '''
        try:
            flag=len(nabundance_list)
        except:
            flag=0
        
        if flag==0:
            abundance_list=[leaf.abundance for leaf in self]
            N=sum(abundance_list)
            for leaf , leaf_abundance in zip(self, abundance_list):
                leaf.nabundance = float(leaf_abundance)/N
        else:
            for leaf, leaf_nabundance  in zip(self, nabundance_list) :
                leaf.nabundance=leaf_nabundance
        for node in self.traverse("postorder"):
            if not node.is_leaf():
                node.nabundance = sum((child.nabundance for child in node.children))
        self.dist = 0
        
    def dico_good_turing(self):
        abundance=[leaf.abundance for leaf in self]
        n=sum(abundance)  # n is the number of individual in the community
        rset=set(abundance)-set([0])  # The list of items appearing at least once in abundance
        # in this case phi_list is [1, 2, 3, 4, 5, 9, 20]
        # a dict associate a key to a value, in this case proba associate r to the probability of observing a species appearing r times in the sample.
        m=ceil((n+1)**(1./3))  # m is needed to compute probabilities
        # The probabilities of observing new species 
        r_estimate={}
        r_estimate[0]=[1,float(max(m,abundance.count(1)+1))]
        for r in rset:
            count=abundance.count(r)
            r_estimate[r]=[count,float(r+1)*max(m,abundance.count(r+1)+1)/max(m,count)]
            # abundance.count(r) count the number of times the item r appears in abundance
        
        normfactor=sum((i[0]*i[1] for i in r_estimate.itervalues()))
        for values in r_estimate.itervalues():
            values[1]/=normfactor
        return(r_estimate)
    
    def diversity(self, nb_of_q=31):
        '''
        Return the Hill diversity of order q of the tree.
        The hill diversity is defined as in Chao & Al (2010).
        '''
        qmin = 0.0  # The minimum hill parameter
        qmax = 2  # The maximum hill parameter
        # The number of hill diversity we set to compute 
        hill_parameters = np.linspace(qmin, qmax, nb_of_q)
        hill_diversity = np.linspace(qmin, qmax, nb_of_q)
        for i , q in enumerate(hill_parameters):
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
                        D += node.dist * pow(node.nabundance,q)
                D = pow(D / T,1 / (1 - q))
            hill_diversity[i]=D
        return (hill_parameters,hill_diversity)
    
    def minestimate(self,goodturing,nb_of_q=31):
        goodturing[0][0]=goodturing[0][1]/goodturing[1][1]
        qmin = 0.0  # The minimum hill parameter
        qmax = 2  # The maximum hill parameter
        # The number of hill diversity we set to compute 
        hill_parameters = np.linspace(qmin, qmax, nb_of_q)
        hill_diversity = np.linspace(qmin, qmax, nb_of_q)
        for leaf in self:
            if leaf.abundance!=0:
                leaf.nabundance=goodturing[leaf.abundance][1]
            else:
                leaf.nabundance=0.
        for node in self.traverse("postorder"):
            if not node.is_leaf():
                node.nabundance = sum((child.nabundance for child in node.children))
        node_list=[node for node in self.traverse() if not (node.abundance==0 or node.is_leaf()) ]
        #leaf_dist=[node.get_farthest_leaf()[1] for node in node_list]
        leaf_dist=[leaf.dist for leaf in self]
        infered_dist=[]
        for i in xrange(int(goodturing[0][0])):
            node=random.choice(node_list)
            while node.up:
                node.nabundance=node.nabundance+goodturing[1][1]
                node = node.up
            infered_dist.append(random.choice(leaf_dist))
        
        rest=goodturing[1][1]*(goodturing[0][0]-int(goodturing[0][0]))
        leaf=max((leaf for leaf in self) ,key=lambda item:item.abundance)
        leaf.nabundance+=rest
        while node.up:
            node.nabundance=node.nabundance+rest
            node = node.up
        self.nabundance=1
        for i , q in enumerate(hill_parameters):
            D = 0.0
            T = 0.0
            if q == 1:  # for the special case q=1
                for node in self.traverse():
                    if node.nabundance != 0.:
                        T += node.dist * node.nabundance
                        D += node.dist * node.nabundance * log(node.nabundance)
                T+= sum((dist*goodturing[1][1] for dist in infered_dist))
                a=goodturing[1][1] * log(goodturing[1][1])
                D+=sum((dist*a for dist in infered_dist))
                D = exp(-D / T)
            else:
                for node in self.traverse():
                    if node.nabundance != 0:
                        T += node.dist * node.nabundance
                        D += node.dist * pow(node.nabundance,q)
                T+= sum((dist*goodturing[1][1] for dist in infered_dist))
                a=pow(goodturing[1][1],q)
                D+=sum((dist*a for dist in infered_dist))
                D = pow(D / T,1 / (1 - q))
            hill_diversity[i]=D
        return (hill_parameters,hill_diversity)
    
    def maxestimate(self,N,goodturing,nb_of_q=31):
        goodturing[0][0]=goodturing[0][1]*N
        qmin = 0.0  # The minimum hill parameter
        qmax = 2  # The maximum hill parameter
        # The number of hill diversity we set to compute 
        hill_parameters = np.linspace(qmin, qmax, nb_of_q)
        hill_diversity = np.linspace(qmin, qmax, nb_of_q)
        for leaf in self:
            if leaf.abundance!=0:
                leaf.nabundance=goodturing[leaf.abundance][1]
            else:
                leaf.nabundance=0.
        for node in self.traverse("postorder"):
            if not node.is_leaf():
                node.nabundance = sum((child.nabundance for child in node.children))
        node_list=[node for node in self.traverse() if not (node.abundance==0 or node.is_leaf()) ]
        #leaf_dist=[node.get_farthest_leaf()[1] for node in node_list]
        leaf_dist=[leaf.dist for leaf in self]
        infered_dist=[]
        for i in xrange(int(goodturing[0][0])):
            node=random.choice(node_list)
            while node.up:
                node.nabundance=node.nabundance+1./N
                node = node.up
            infered_dist.append(random.choice(leaf_dist))
        
        rest=1./N*(goodturing[0][0]-int(goodturing[0][0]))
        leaf=max((leaf for leaf in self) ,key=lambda item:item.abundance)
        leaf.nabundance+=rest
        while node.up:
            node.nabundance=node.nabundance+rest
            node = node.up
        self.nabundance=1
        print "diversity"
        for i , q in enumerate(hill_parameters):
            D = 0.0
            T = 0.0
            if q == 1:  # for the special case q=1
                for node in self.traverse():
                    if node.nabundance != 0.:
                        T += node.dist * node.nabundance
                        D += node.dist * node.nabundance * log(node.nabundance)
                T+= sum((dist/N for dist in infered_dist))
                a=1./N * log(1./N)
                D+=sum((dist*a for dist in infered_dist))
                D = exp(-D / T)
            else:
                for node in self.traverse():
                    if node.nabundance != 0:
                        T += node.dist * node.nabundance
                        D += node.dist * pow(node.nabundance,q)
                T+= sum((dist/N for dist in infered_dist))
                a=pow(1./N,q)
                D+=sum((dist*a for dist in infered_dist))
                D = pow(D / T,1 / (1 - q))
            hill_diversity[i]=D
        return (hill_parameters,hill_diversity)
    
    def sampled_diversity(self,samplesize,nb_of_samples,nb_of_q=61):
        abundance=[leaf.abundance for leaf in self]
        abundance_cumulative = np.cumsum(abundance)
        N=abundance_cumulative[-1]
        s=len(self)
        # The number time we extract a sample from the community
        diversity_of_the_samples = np.zeros((nb_of_q, nb_of_samples))
        # An array of nb_of_q row and nb_of_samples columns 
        if (samplesize <= N + 1) & (samplesize > 0):
            for j in xrange(nb_of_samples):
                sample=np.array([0]*s)
                abundance_cumulative = np.cumsum(abundance)
                N=abundance_cumulative[-1]
                rand_list = np.random.randint(1, N, samplesize)
                rand_list.sort()
                index=0
                i=0
                while index<samplesize:
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
                self.fill_leaves(sample)
                self.fill_tree()
                diversity_of_the_samples[: , j] = self.diversity(nb_of_q)[1]
        else:
            print("sample size must be lower than the size of the community")
        
        self.fill_leaves(abundance)
        self.fill_tree()
        return diversity_of_the_samples
    
    def __repr__(self):
        for node in self.traverse():
            node.name="%1.2f" % node.dist
        return self.get_ascii(show_internal=True)
    
    def show(self):
        for leaf in self:
            if leaf.abundance==0:
                leaf.name="Null"
            else:
                leaf.name="%d" % leaf.abundance
        print self.get_ascii(show_internal=True)

def k2tree(s, t):
    tree = AbundanceTree()
    for _ in itertools.repeat(None,s): 
        child = tree.add_child(dist=t)
        for _ in itertools.repeat(None,s):
            child.add_child(dist=(1 - t))
    tree.dist=0
    return tree

def startree(s):
    tree = AbundanceTree()
    for _ in itertools.repeat(None,s): 
        tree.add_child()
    tree.dist=0
    return tree

