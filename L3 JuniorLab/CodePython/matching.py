'''
Created on 10 juil. 2012

@author: thibault
'''
import numpy as np
import math
import pickle
from scipy import spatial
from classes import *

def match(A, B):
    out = 0
    for i in range(1, 7):
        if A[i].color != B[i].color:
            out += 10000
    return out

def cout(L1, L2):
    f = 0
    n = 0
    for i in L2:
        result = tree.query(i(1))
        if result[0] < 0.1:
            n += 1
            f += result[0] * 100 + match(i, L1[result[1]])
    if n > 2:
        return f / (n ** 4)
    else:
        return float('inf')
    
def recursiv(f, L1, L2, dphi, phitot):
    T2 = L2.transform(phitot + dphi, vec3(0, 0, 1))
    f1 = cout(L1, T2)
    if f1 < f:
        phitot = phitot + dphi
        return recursiv(f1, L1, L2, dphi, phitot)
    T2 = L2.transform(phitot - dphi, vec3(0, 0, 1))
    f1 = cout(L1, T2)
    if f1 < f:
        phitot = phitot - dphi
        return recursiv(f1, L1, L2, -dphi, phitot)
    return phitot

L1 = Grille("1composite1.txt")
L2 = Grille("1composite0.txt")
dico = L2.split()
fa = float('inf')
for i in range(len(L1)):
    S = L1[i].mean.ThreeDtoSC()
    theta1 = math.pi - S.th
    psi = S.phi + math.pi / 2
    if psi < 0:
        psi = 2 * math.pi + psi
    vec1 = SC(math.pi / 2, psi).SCtoThreeD()
    vec1 /= abs(vec1)
    baitGrille = L1.transform(theta1, vec1)
    phi1 = baitGrille[i].Orientation()
    tree = spatial.KDTree([j(1) for j in baitGrille])
    for j, target in enumerate(dico[baitGrille[i].color]):
        S = target.mean.ThreeDtoSC()
        theta2 = math.pi - S.th
        psi = S.phi + math.pi / 2
        if psi < 0:
            psi = 2 * math.pi + psi
        vec2 = SC(math.pi / 2, psi).SCtoThreeD()
        vec2 /= abs(vec2)
        targetGrille = dico[baitGrille[i].color].transform(theta2, vec2)
        phi2 = targetGrille[j].Orientation()
        targetGrille = targetGrille.transform(phi1 - phi2, vec3(0, 0, 1))
        fb = cout(baitGrille, targetGrille)
        if fb < fa:
            theta1f = theta1
            vec1f = vec1
            vec2f = vec2
            dphif = phi1 - phi2
            theta2f = theta2
            fa = fb

L1 = L1.transform(theta1f, vec1f)
L2 = L2.transform(theta2f, vec2f)
L2 = L2.transform(dphif, vec3(0, 0, 1))
dphitot = recursiv(fa, L1, L2, 0.01, 0)
L2 = L2.transform(dphitot, vec3(0, 0, 1))

f = open("position.txt", 'wb')
T = ((theta1f, theta2f), (vec1f, vec2f), dphif + dphitot)
pickle.dump(T, f)
f.close()
i = ThreeD(0, 0, -1)
cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.blue, material=materials.emissive)
i = ThreeD(1, 0, 0)
cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.white, material=materials.emissive)
i = ThreeD(0, 1, 0)
cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.red, material=materials.emissive)
L1.plot('magenta')
L2.plot('blue')
tree = spatial.KDTree([j(1) for j in L1])
for i in L2:
    print tree.query(i(1))
union = unionGrille(L1, L2)
scene2 = display(title='Union', width=600, height=600)
scene2.select()
union.plot()
