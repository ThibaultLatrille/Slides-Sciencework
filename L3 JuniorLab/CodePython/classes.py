'''
Created on 10 juil. 2012

@author: thibault
'''
from shapely.geometry import Point
import numpy as np
import math
import pickle
from scipy import spatial
from visual import *
from cgkit.cgtypes import vec3, quat

def Mean(*args):
    phi = 0
    th = 0
    for p in args:
        sc = p.ThreeDtoSC()
        phi += sc.phi
        th += sc.th
    phi /= len(args)
    th /= len(args)
    return SC(th, phi).SCtoThreeD()

class TwoD(Point):
    # 2 dimensional vector
    def __init__(self, x, y):
        Point.__init__(self, (x, y))
    def Norm(self):
        N = (self.x ** 2 + self.y ** 2) ** (0.5)
        return TwoD(self.x / N, self.y / N)
    def __repr__(self):
        return '(' + str(self.x) + ',' + str(self.y) + ')'    
    def __add__(self, V):
        return TwoD(self.x + V.x, self.y + V.y)
    def __div__(self, d):
        return TwoD(self.x / d, self.y / d)
    def __sub__(self, V):
        return TwoD(self.x - V.x, self.y - V.y)
    def __mul__(self, V):
        return self.x * V.x + self.y * V.y
    def Cross(self, V):
        return self.x * V.y - self.y * V.x
    def Findortho(self):
        return TwoD(self.y, -self.x)
    def TwoDtoThreeD(self):
        d = 1 + self.y ** 2 + self.x ** 2
        return ThreeD(2 * self.x / d, 2 * self.y / d, (d - 2) / d)
    def TwoDtoSC(self):
        phi = math.atan2(self.y, self.x)
        if phi < 0:
            phi = 2 * math.pi + phi
        return SC(2 * math.atan((self.x ** 2 + self.y ** 2) ** (-0.5)), phi)
        
class ThreeD(vec3):
    # 3 dimensional vector
    def __init__(self, *args):
        vec3.__init__(self, *args)
    def ThreeDtoTwoD(self):
        return TwoD(self.x / (1 - self.z), self.y / (1 - self.z))
    def ThreeDtoSC(self):
        phi = math.atan2(self.y, self.x)
        if phi < 0:
            phi = 2 * math.pi + phi
        return SC(math.acos(self.z), phi)
    def distance(self, threed):
        return (self.x - threed.x) ** 2 + (self.y - threed.y) ** 2 + (self.z - threed.z) ** 2
    def transform(self, psi, vec):
        Q = quat(psi, vec3(vec))
        return ThreeD(Q.rotateVec(self))
    def projection(self, vect):
        L = (vect.x) ** 2 + (vect.y) ** 2 + (vect.z) ** 2
        k = (vect.x * self.x + vect.y * self.y + vect.z * self.z) / L
        return ThreeD(k * vect.x, k * vect.y, k * vect.z)
    def __repr__(self):
        return '(' + str(self.x) + ',' + str(self.y) + ',' + str(self.z) + ')'
    def __call__(self, s):
        return (s * self.x, s * self.y, s * self.z)

class SC(object):
    # # 3 dimensional point in the unit sphere in spherical coordinate
    def __init__(self, th, phi):
        self.th = th
        self.phi = phi
    def SCtoThreeD(self):
        s = math.sin(self.th)
        return ThreeD(s * math.cos(self.phi), s * math.sin(self.phi), math.cos(self.th))
    def SCtoTwoD(self):
        r = math.sin(self.th) / (1 - math.cos(self.th))
        return TwoD(r * math.cos(self.phi), r * math.sin(self.phi))
    def distance(self, sc):
        return 2 * math.asin((self.SCto3D().distance(sc.SCto3D())) ** 0.5)
    def __repr__(self):
        return '(Phi : ' + str(self.phi) + ',Theta : ' + str(self.th) + ')'    
    def __add__(self, sc):
        th = self.th + sc.th
        if th > math.pi:
            th = 2 * math.pi - th
        phi = self.phi + sc.phi
        if phi > 2 * math.pi:
            phi = phi - 2 * math.pi
        return SC(th, phi)
    def __div__(self, d):
        return SC(self.th / d, self.phi / d)
    def __sub__(self, sc):
        return self +SC(-sc.th, -sc.phi)

class PR(ThreeD):
    # 3 dimensional photoreceptor, class inherited from 3 dimensional vector and with a color associated
    def __init__(self, *args):
        ThreeD.__init__(self, args[:len(args) - 1])
        self.color = args[len(args) - 1]
    def Copy(self):
        copy = PR(self.x, self.y, self.z, self.color)
        return copy
    def __repr__(self):
        return 'X:' + str(self.x) + ', Y:' + str(self.y) + ', Z:' + str(self.z) + ', color:' + self.color + '\n'
    def transform(self, psi, vec):
        Q = quat(psi, vec3(vec))
        return PR(Q.rotateVec(self), self.color)
        

class Ommatidia(dict):
    # 3 dimensional ommatidia 
    def __init__(self, common=True, dico={}, sizex=0, sizey=0, scale=0):
        if common:
            dict.__init__(self)
            self.mean = None
            self.color = 0
        else:
            dict.__init__(self)
            if dico["From2D"]:
                n = 0
                for i in range(1, 7):
                    n += (dico[i][2] == "yellow") + (dico[i][2] == "black")
                    X = (dico[i][0] - sizex / 2) * scale / sizex
                    Y = (dico[i][1] - sizey / 2) * scale / sizex
                    p = TwoD(X, Y).TwoDtoThreeD()
                    self[i] = PR(p.x, p.y, p.z, dico[i][2])
                self.color = n
                self.Mean()
            else:
                n = 0
                for i in range(1, 7):
                    n += (dico[i][3] == "yellow") + (dico[i][3] == "black")
                    self[i] = PR(dico[i][0], dico[i][1], dico[i][2], dico[i][3])
                self.color = n
                self.Mean()
    def Copy(self):
        copy = Ommatidia()
        for i in self:
            copy[i] = self[i].Copy()
        copy.mean = self.mean
        copy.color = self.color
        return copy
    
    def pickle(self):
        dico = {}
        for key, Pr in self.iteritems():
            dico[key] = (Pr.x, Pr.y, Pr.z, Pr.color)
        dico["From2D"] = False
        return dico
    def __repr__(self):
        try:
            return "1: {0}2: {1}3: {2}4: {3}5: {4}6: {5}\n".format(self[1], self[2], self[3], self[4], self[5], self[6])
        except:
            return "this ommatidia is not complete"    
    def Orientation(self):
        p1 = self[1]
        phi1 = math.atan2(p1.y, p1.x)
        if phi1 < 0:
            phi1 = 2 * math.pi + phi1
        p6 = self[6]
        phi6 = math.atan2(p6.y, p6.x)
        if phi6 < 0:
            phi6 = 2 * math.pi + phi6
        return (phi1 + phi6) / 2
    def Mean(self):
        self.mean = Mean(self[1], self[2], self[4], self[5], self[6])
        return self.mean
    def transform(self, psi, vec):
        out = Ommatidia()
        for indice, valeur in self.iteritems():
            out[indice] = valeur.transform(psi, vec)
        out.mean = self.mean.transform(psi, vec)
        out.color = self.color
        return out
    def avg(self, other):
        for i in self.iterkeys():
            p = self[i] + other[i]
            p /= abs(p)
            self[i] = PR(p.x, p.y, p.z, self[i].color)
        self.mean = (self.mean + other.mean) / 2
    def plot(self, dico, c):
        L = []
        L.append(curve(pos=[i(1) for i in self.itervalues()], radius=0.0015, color=dico[c]))
        for i in self.itervalues():
            L.append(cylinder(pos=i(0.95), axis=i(0.0515), radius=0.005, color=dico[i.color], material=materials.emissive))
        return L
    def __call__(self, s):
        return (self.mean.x * s, self.mean.y * s, self.mean.z * s)

class Grille(list):
    # A web (list) of ommatidia
    def __init__(self, File="", empty=False, sizex=0, sizey=0, scale=0):
        if empty:
            list.__init__(self)
        else:
            list.__init__(self)
            with open(File, 'r') as fa:
                while 1:
                    try:
                        self.append(Ommatidia(False, pickle.load(fa), sizex, sizey, scale=scale))
                    except:
                        break
    def Copy(self):
        copy = Grille(empty=True)
        for omma in self:
            copy.append(omma.Copy())
        return copy
    def plot(self, c):
        L = []
        dico = {}
        dico['yellow'] = color.yellow
        dico['green'] = color.green
        dico['black'] = color.black
        dico['blue'] = color.blue
        dico['magenta'] = color.magenta
        dico['white'] = color.white
        ball = sphere(pos=(0, 0, 0), radius=1, material=materials.emissive, color=color.orange)
        for i in self:
            L.extend(i.plot(dico, c))
        return L
    def pickle(self, File):
        fr = open(File, "a")
        for i in self:
            pickle.dump(i.pickle(), fr)
        fr.close()
    def __repr__(self):
        return "\n".join([str(i(1)) for i in self])
    def transform(self, psi, vec):
        out = Grille("", empty=True)
        for i in self:
            out.append(i.transform(psi, vec))
        return out
    def split(self):
        dico = {}
        for i in range(0, 7):
            dico[i] = Grille("", True)
        for i in self:
            dico[i.color].append(i)
        return dico
    
    @staticmethod
    def Colorcost(A, B):
        out = 0
        for i in range(1, 7):
            if A[i].color != B[i].color:
                out += 10000
        return out
    
    def cout(self, L2, tree):
        f = 0
        n = 0
        for i in L2:
            result = tree.query(i(1))
            if result[0] < 0.1:
                n += 1
                f += result[0] * 100 + Grille.Colorcost(i, self[result[1]])
        if n > 2:
            return f / (n ** 2)
        else:
            return float('inf')
        
    def recursiv(self, L2 , f , dphi, phitot, tree):
        T2 = L2.transform(phitot + dphi, vec3(0, 0, 1))
        f1 = self.cout(T2, tree)
        if f1 < f:
            phitot = phitot + dphi
            return self.recursiv(L2, f1, dphi, phitot, tree)
        T2 = L2.transform(phitot - dphi, vec3(0, 0, 1))
        f1 = self.cout(T2, tree)
        if f1 < f:
            phitot = phitot - dphi
            return self.recursiv(L2, f1, -dphi, phitot, tree)
        return phitot

    def match(self, L2, bait , targets, flag=True):
        fa = float('inf')
        for indice, i in enumerate(bait):
            S = self[i].mean.ThreeDtoSC()
            theta1 = math.pi - S.th
            psi = S.phi + math.pi / 2
            if psi < 0:
                psi = 2 * math.pi + psi
            vec1 = SC(math.pi / 2, psi).SCtoThreeD()
            vec1 /= abs(vec1)
            baitGrille = self.transform(theta1, vec1)
            phi1 = baitGrille[i].Orientation()
            baitGrille = baitGrille.transform(phi1, vec3(0, 0, 1))
            print "phi1", phi1
            tree = spatial.KDTree([j(1) for j in baitGrille])
            for k in targets:
                if flag:
                    target = L2[targets[indice]]
                    print self[i], target
                else:
                    target = L2[k]
                    print indice, k
                S = target.mean.ThreeDtoSC()
                theta2 = math.pi - S.th
                psi = S.phi + math.pi / 2
                if psi < 0:
                    psi = 2 * math.pi + psi
                vec2 = SC(math.pi / 2, psi).SCtoThreeD()
                vec2 /= abs(vec2)
                targetGrille = L2.transform(theta2, vec2)
                if flag:
                    phi2 = targetGrille[targets[indice]].Orientation()
                    print "phi2", phi2
                else:
                    phi2 = targetGrille[k].Orientation()
                targetGrille = targetGrille.transform(phi1 - phi2, vec3(0, 0, 1))
                print "phi2tran", targetGrille[targets[indice]].Orientation()
                fb = baitGrille.cout(targetGrille, tree)
                if fb < fa:
                    theta1f = theta1
                    vec1f = vec1
                    vec2f = vec2
                    dphif = phi1 - phi2
                    print "dphif", dphif
                    theta2f = theta2
                    fa = fb
                if flag:
                    break
        return theta1f , vec1f, theta2f, vec2f, dphif, fa

def Compute(L11, L22, hold):
    #compute the union of two Grille
    convert = {}
    tree = spatial.KDTree([i(1) for i in L11])
    n = len(L22)
    for indice, i in enumerate(L22):
        k = 1
        result = tree.query(i(1))
        while 1:
            if L11[result[1]] != False:
                break
            else:
                k += 1
                result = tree.query(i(1), k)
                result = (result[0][k - 1], result[1][k - 1])
        if result[0] < hold:
            L22[indice].avg(L11[result[1]])
            L11[result[1]] = False
            convert[result[1]] = indice
    j = 0
    for i in range(len(L11)):
        if L11[i] != False:
            convert[i] = j + n
            j += 1
    while 1:
        try:
            L11.remove(False)
        except:
            break
    L22.extend(L11)
    return convert, L22
        
