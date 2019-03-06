import numpy as np
import matplotlib.pyplot as plt
from operator import mul
from functools import reduce

# Paramètres du modèle
kon = 1.  # Taux d'allumage du gène
koff = 2.  # Taux d'extinction du gène
s = 100.  # Taux de création d'ARN (état ON)
d = 1.  # Taux de dégradation de l'ARN
sp = 10.  # Taux de traduction
dp = 0.1  # Taux de dégradation des protéines


def reaction_time(rate):
    return np.random.exponential(1. / rate)


def choose_reaction(vector, rate):
    return list(np.random.multinomial(1, np.array(vector) / rate)).index(1)


class MultipleSwitch(object):
    def __init__(self, nbr_gene=2, constitutive=True, interaction=False):
        self.genes = [Gene(constitutive=constitutive, interaction=interaction) for _ in range(nbr_gene)]
        self.t = 0
        for i in range(nbr_gene-1):
            self.genes[i].is_repressed_by(self.genes[i+1])
            self.genes[i+1].is_repressed_by(self.genes[i])

    def run(self, t_final):
        while 1:
            vector_rate = []
            for gene in self.genes:
                vector_rate.extend(gene.vector_rate())
            rate = sum(vector_rate)
            self.t += reaction_time(rate)
            if self.t > t_final:
                for gene in self.genes:
                    gene.t = t_final
                    gene.store_current_state()
                break
            else:
                reaction = choose_reaction(vector_rate, rate)
                index = int(reaction / 6)
                self.genes[index].update_state(int(reaction % 6))
                for gene in self.genes:
                    gene.t = self.t
                    gene.store_current_state()
        return self

    def plot(self):
        fig = plt.figure()
        for k, gene in enumerate(self.genes):
            gene.plot(fig, k+1, len(self.genes))


class Gene(object):
    def __init__(self, e=0, m=0, p=0, constitutive=True, interaction=False):
        self.t = 0  # Initialisation du temps
        self.e = e
        self.m = m
        self.p = p
        self.Vt = [self.t]  # Vecteur des instants de réaction
        self.Ve = [e]  # Vecteur des états du promoteur
        self.Vm = [m]  # Vecteur des nombres d'ARNs
        self.Vp = [p]  # Vecteur des nombres de protéines
        self.repressors = []
        self.constitutive = constitutive
        self.interaction = interaction

    def repression_rate(self):
        off = 0.
        if self.constitutive:
            off = 1.
        if self.interaction:
            return off + reduce(mul, [rep.p for rep in self.repressors])
        else:
            return off + sum([rep.p for rep in self.repressors])

    def vector_rate(self):
        off_rate = koff * self.e * self.repression_rate()
        return [kon * (1-self.e), off_rate, s * self.e, d * self.m, self.m * sp, self.p * dp]

    def update_state(self, reaction):
        # Mise à jour de l'état du système
        if reaction == 0:
            self.e = 1  # Passage en ON
        elif reaction == 1:
            self.e = 0  # Passage en OFF
        elif reaction == 2:
            self.m += 1 # Création d'un ARN
        elif reaction == 3:
            self.m -= 1 # Dégradation d'un ARN
        elif reaction == 4:
            self.p += 1  # Création d'une protéine
        elif reaction == 5:
            self.p -= 1 # Dégradation d'une protéine

    def store_current_state(self):
        self.Vt.append(self.t)
        self.Ve.append(self.e)
        self.Vm.append(self.m)
        self.Vp.append(self.p)

    def run(self, t_final):
        while 1:
            vector_rate = self.vector_rate()
            rate = sum(vector_rate)
            self.t += reaction_time(rate)
            if self.t > t_final:
                self.t = t_final
                self.store_current_state()
                break
            else:
                reaction = choose_reaction(vector_rate, rate)
                self.update_state(reaction)
                self.store_current_state()
        return self

    def is_repressed_by(self, gene):
        self.repressors.append(gene)

    def plot(self, fig=None, k=1, n=1):
        if not fig:
            fig = plt.figure()
        ax = fig.add_subplot(2 * n, 1, 2 * k - 1)
        ax.set_xlabel(r'$t$')
        ax.set_ylabel(r'Etat du promoteur')
        ax.plot(self.Vt, self.Ve, 'blue', linewidth=1.5)
        ax.fill_between(self.Vt, 0, self.Ve, facecolor='blue')
        for tl in ax.get_yticklabels():
            tl.set_color('b')
        ax.set_ylim((0, 1.5))

        ax1 = fig.add_subplot(2 * n, 1, 2 * k)
        ax1.set_xlabel(r'$t$')
        ax1.set_ylabel("ARNm")
        ax1.plot(self.Vt, self.Vm, 'r', linewidth=1.5)
        for tl in ax1.get_yticklabels():
            tl.set_color('r')

        ax2 = ax1.twinx()
        plt.plot(self.Vt, self.Vp, 'g', linewidth=1.5)
        ax2.set_ylabel("Proteines")
        for tl in ax2.get_yticklabels():
            tl.set_color('g')
        ax1.set_title("Gene %s" % k)

    @staticmethod
    def normalize(array):
        if np.max(array) > 0:
            return np.divide(array, np.max(array))
        else:
            return array

# simulation
# Gene().run(100).plot()

MultipleSwitch(2, interaction=False, constitutive=True).run(100).plot()
MultipleSwitch(2, interaction=True, constitutive=True).run(100).plot()
MultipleSwitch(2, interaction=False, constitutive=False).run(100).plot()
MultipleSwitch(2, interaction=True, constitutive=False).run(100).plot()

MultipleSwitch(3, interaction=False, constitutive=True).run(100).plot()
MultipleSwitch(3, interaction=True, constitutive=True).run(100).plot()
MultipleSwitch(3, interaction=False, constitutive=False).run(100).plot()
MultipleSwitch(3, interaction=True, constitutive=False).run(100).plot()
