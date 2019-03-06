from ete2 import TreeNode
import numpy as np

from decimal import *
getcontext().prec=28

class AbundanceTree(TreeNode):    
    def upperestimate(self,N,nb_of_q=31):
        qmin = 0.0  # The minimum hill parameter
        qmax = 2  # The maximum hill parameter
        # The number of hill diversity we set to compute 
        sample=[leaf.abundance for leaf in self]
        hill_parameters = np.linspace(qmin, qmax, nb_of_q)
        hill_diversity = np.linspace(qmin, qmax, nb_of_q)
        F1=sum(1 for i in sample if i==1 )
        if (F1==0):
            print("impossible to compute upper GT")
        else:
            M=sum(leaf.abundance for leaf in self)
            for leaf in self:
                leaf.nabundance=(Decimal(leaf.abundance)/M)*(1-Decimal(F1)/M)
            
            self.fill_tree()
            self.nabundance=Decimal(1)
            _,branch=self.get_farthest_leaf()
            for i , q in enumerate(hill_parameters):
                D = Decimal(0)
                T = Decimal(0)
                if q == 1:  # for the special case q=1
                    for node in self.traverse():
                        if node.nabundance != 0.0:
                            T += Decimal(node.dist) * node.nabundance
                            D += Decimal(node.dist) * node.nabundance * (node.nabundance.ln())
                    
                    T+= Decimal(branch*F1/M)
                    D+= (Decimal(N)*F1/M)*Decimal(branch) * (Decimal(1)/N)*((Decimal(1)/N).ln())
                    D = (-D / T).exp()
                else:
                    for node in self.traverse():
                        if node.nabundance != 0.0:
                            T += node.nabundance * Decimal(node.dist)
                            D += Decimal(node.dist) * (node.nabundance.ln()*Decimal(q)).exp()
                    
                    T+= Decimal(branch)*(Decimal(F1)/M)
                    D+= (Decimal(N)*F1/M)*Decimal(branch)*(((Decimal(1)/N).ln()*Decimal(q)).exp())
                    D = ((D/T).ln()*Decimal(1 / (1 - q))).exp()
                hill_diversity[i]=D
        self.fill_leaves(sample)
        return (hill_parameters,hill_diversity)