# -*- coding: utf-8 -*-

#" Read help may provide clues to match picture and how the program works.
## This script isn't commented, the author is really sorry for this inconveniance. 
## If you want to improve the code and made some analysis in final data the best way to do it is to write an independent code.
## Data are written in a .txt file in your workbench directory. To extract the data use the command below
#import pickle
#liste=[]
#with open("***********.txt",'r') as fr
#    while 1:
#        try:
#            liste.append(pickle.load(fr))
#        except
#            break
## This way the variable liste is a list of ommatidia
## Each ommatidia is a dict object with key varying from 1 to 6 (photoreceptor) and associated values are tuple of coordinate and color
## The tuple is of length 4.  the first value if the x coordinate of photoreceptor, the second one is the y coordinate and the third one is the z coordinate
## The forth value is the color i str format, "yellow" or "green" 
## Each Photoreceptor map onto the unit sphere.
## File named "*****matchFile.txt" or "*****matchlist.txt" don't contain this sort of date, they are used before matching picture.

import pickle
import time
import os
from classes import *
from Tkinter import *
import tkMessageBox
from tkFileDialog import askopenfilename, askdirectory
import ImageTk
import Image
from copy import deepcopy
    
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

class PRimage(TwoD):
    # 2 dimensional photoreceptor, class inherited from 2 dimensional vector and with a color associated
    def __init__(self, x=0, y=0, color=None):
        TwoD.__init__(self, x, y)
        self.color = color    
    def __str__(self):
        return 'x:' + str(self.x) + ', y:' + str(self.y) + ', color:' + self.color + '\n'
    def __repr__(self):
        return str(self)

class Ommatidiaimage(dict):
    # 2 dimensional ommatidia 
    def __init__(self, dico={}):
            if len(list(dico.iterkeys())) == 0:
                dict.__init__(self)
                self.head = None
                self.mean = None
                self.color = 0
            else:
                dict.__init__(self)
                for i in range(1, 7):
                    self[i] = PRimage(dico[i][0], dico[i][1], dico[i][2])

    def pickle(self):
        dico = {}
        for key, Pr in self.iteritems():
            dico[key] = (Pr.x, Pr.y, Pr.color)
        dico["From2D"] = True
        return dico
    def __repr__(self):
        try:
            return "1: {0}2: {1}3: {2}4: {3}5: {4}6: {5}\n".format(self[1], self[2], self[3], self[4], self[5], self[6])
        except:
            return "this ommatidia is not complete"    
    def Orientation(self):
            d1 = TwoD(self[1].x - self[2].x, self[1].y - self[2].y) + TwoD(self[1].x - self[3].x, self[1].y - self[3].y) + TwoD(self[2].x - self[3].x, self[2].y - self[3].y) + TwoD(self[6].x - self[5].x, self[6].y - self[5].y)
            d1 = d1.Norm()
            self.head = d1
            return d1    
    def Mean(self):
        (x, y) = (0, 0)
        for i in self.itervalues():
            x += i.x
            y += i.y
        self.mean = TwoD(x / 6, y / 6)
        return self.mean

class Myapp(dict):
    #The main class container of the Tkinter root. Contains all the Gui methods
    def __init__(self, parent):
        dict.__init__(self)
        self.max = 0
        self.dico = {}
        self.threshold = 0.01
        self.scale = 0.51
        self.tc = 55
        self.isactive = False
        self.liste = list()
        self.union = Grille(empty=True)
        self.root = parent
        self.root.geometry("{0}x{1}+0+0".format(self.root.winfo_screenwidth(), self.root.winfo_screenheight()))
        self.folder = "C:/Users/thibault/workspace/LabJunior/NIKEL3"
        self.root.title("Flymatch toolbox 1.0.alpha")
        self.mainmenu = Menu(self.root)
        self.menu1 = Menu(self.mainmenu, tearoff=0)
        self.mainmenu.add_cascade(label="File", menu=self.menu1)
        self.menu1.add_command(label="Open picture", command=self.Open)
        self.menu1.add_command(label="Open folder", command=self.Folder)
        self.menu1.add_separator()
        self.menu1.add_command(label="Merge folder", command=self.Merger)
        self.menu2 = Menu(self.mainmenu, tearoff=0)
        self.mainmenu.add_cascade(label="View", menu=self.menu2)
        self.fullscreen = Menu(self.menu2, tearoff=0)
        self.menu2.add_cascade(label="Display picture", menu=self.fullscreen)
        self.menu2.add_separator()
        self.menu2.add_command(label="Match pictures", command=self.Split)
        self.menu2.add_separator()
        self.menu2.add_command(label="Image color intensity", command=self.Colorbutton)
        self.menu2.add_command(label="Image linear transformation", command=self.Movebutton)
        self.menu2.add_separator()
        self.menu2.add_command(label="Set color threshold", command=self.Threshold)
        self.menu3 = Menu(self.mainmenu, tearoff=0)
        self.mainmenu.add_cascade(label="3D tools", menu=self.menu3)
        self.view = Menu(self.menu3, tearoff=0)
        self.menu3.add_cascade(label="Display picture", menu=self.view)
        self.menu3.add_separator()
        self.menu3.add_command(label="Build match", command=self.Builder)
        self.menu4 = Menu(self.mainmenu, tearoff=0)
        self.mainmenu.add_cascade(label="Tune factor", menu=self.menu4)
        self.menu4.add_command(label="Set scale", command=self.Scale)
        self.menu5 = Menu(self.mainmenu, tearoff=0)
        self.mainmenu.add_cascade(label="Help", menu=self.menu5)
        self.menu5.add_command(label="Display help", command=self.Help)
        self.frame = Frame(parent, bd=2, relief=SUNKEN)
        self.frame.grid_rowconfigure(0, weight=1)
        self.frame.grid_columnconfigure(0, weight=1)
        self.frame.pack(fill=BOTH, expand=1)
        self.root.config(menu=self.mainmenu)
        self.color = 0
        self.ommatidia = Ommatidiaimage()

    def Threshold(self):
        # Method bounds with the "Set color threshold" button, change the value of threshold (auto detect color)
        self.Top = Toplevel()
        saisie = StringVar()
        saisie.set(str(self.tc))
        self.saisie = StringVar()
        self.saisie.set("Enter a number between 0 and 255")
        lb1 = Label(self.Top, text="This number is used to auto-detect photoreceptor's color", foreground="blue")
        ent = Entry(self.Top, textvariable=saisie, width=30)
        lb2 = Label(self.Top, textvariable=self.saisie, foreground="blue")
        ok = Button(self.Top, text="Ok", command=lambda: self.Int(saisie.get()))
        lb1.pack()
        ent.pack()
        lb2.pack()
        ok.pack()
    
    def Int(self, string):
        # method associated with self.Threshold
        try:
            t = int(string)
        except:
            t = string
        if t != string:
            if -1 < t < 256:
                self.tc = t
                self.Top.destroy()
            else:
                self.saisie.set("Integer not include in the interval. \n Return to middle school")
        else:
            self.saisie.set("Not an integer. \n Return to elementary school")
    
    def Help(self):
        pass
    
    def Scale(self):
        #Method bounds with the "Set scale" button, change the value of scale (parameter to map 2 dimensional point onto the sphere with stereographic projection)
        self.Top = Toplevel()
        saisie = StringVar()
        saisie.set(str(self.scale))
        self.saisie = StringVar()
        self.saisie.set("Enter a positive float number")
        lb1 = Label(self.Top, text="This number is used to map ommatidia onto the unite sphere \n read help before doing something stupid", foreground="blue")
        ent = Entry(self.Top, textvariable=saisie, width=30)
        lb2 = Label(self.Top, textvariable=self.saisie, foreground="blue")
        ok = Button(self.Top, text="ok", command=lambda: self.Float(saisie.get()))
        lb1.pack()
        ent.pack()
        lb2.pack()
        ok.pack()
    def Float(self, string):
        # method associated with self.Threshold
        try:
            t = float(string)
        except:
            t = string
        if t != string:
            self.scale = t
            self.Top.destroy()
        else:
            self.saisie.set("Not a positive float. \n Do you really know what a float is ?")
    
    def Folder(self, flag=True):
        # Method bounds with the "open folder" button, load directory : .jpg and .txt files.
        self.root.title("Loading workbench")
        if flag:
            self.folder = askdirectory(initialdir=self.folder, title='workspace')
        os.chdir(self.folder)
        List = os.listdir(self.folder)
        List1 = [i for i in List if i[-4:] == ".jpg"]
        self.Im = Image.open("{0}/{1}".format(self.folder, List1[0]))
        List1.extend(i for i in List if i[-5:] == "#.txt")
        for i in List1:
            j = i[:-4] + ".txt"
            if j not in self.dico:
                self.Open("{0}/{1}".format(self.folder, i), FS=False)
        self.Fullscreen(1)
        self.root.title("Workbench loaded")
    
    def View(self, n):
        #Method bounds with by the "3d tools -> Display picture" button.
        try:
            print n
            x = self.Im.getbbox()[2]
            y = self.Im.getbbox()[3]
            L = Grille(self[n]["objet"], sizex=x, sizey=y, scale=self.scale)
            print self[n]["objet"]
            print "length", len(L)
            self.scene = display(title='3D view', width=600, height=600, exit=False, forward=(.1, .1, 1), range=(1, 1, 1))
            self.scene.select()
            i = ThreeD(0, 0, -1)
            cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.blue, material=materials.emissive)
            i = ThreeD(1, 0, 0)
            cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.white, material=materials.emissive)
            i = ThreeD(0, 1, 0)
            cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.red, material=materials.emissive)
            L.plot("black")
        except:
            print self[n]["objet"] + " n'existe pas gros con"
    
    def Builder(self):
        #Method bounds with by the "3d tools -> build match" button. Open first web of ommatidia.
        self.frame.destroy()
        self.isactive = False
        self.top = Toplevel()
        self.top.title("Choose the first one")
        self.scrollbar = Scrollbar(self.top)
        self.scrollbar.pack(side=RIGHT, fill=Y)
        self.listbox = Listbox(self.top)
        self.listbox.pack(side="left", fill="both", expand=True)
        for i in self.iterkeys():
            if self[i]["mean"] != [] or self[i]["union"]:
                self.listbox.insert(END, self[i]["objet"][:-4])
        self.listbox.config(yscrollcommand=self.scrollbar.set)
        self.scrollbar.config(command=self.listbox.yview)
        self.listbox.bind('<Double-1>', self.Firstselect)
           
    def Firstselect(self, event):
        #Method associated with self.Builder method. Open second web of ommatidia.
        select1 = self.listbox.get(self.listbox.curselection()) + ".txt"
        self.top.destroy()
        self.top = Toplevel()
        self.top.title("Choose the second one")
        self.scrollbar = Scrollbar(self.top)
        self.scrollbar.pack(side=RIGHT, fill=Y)
        self.listbox = Listbox(self.top)
        self.listbox.pack(side="left", fill="both", expand=True)
        self.n1 = self.dico[select1]
        for i in self.iterkeys():
            if self[i]["mean"] != [] or self[i]["union"]:
                if i != self.n1:
                    self.listbox.insert(END, self[i]["objet"][:-4])
        self.listbox.config(yscrollcommand=self.scrollbar.set)
        self.scrollbar.config(command=self.listbox.yview)
        self.listbox.bind('<Double-1>', self.Secondselect)
    
    def Secondselect(self, event):
        #Method associated with self.Builder method. Load matching information.
        select2 = self.listbox.get(self.listbox.curselection()) + ".txt"
        self.top.destroy()
        self.n2 = self.dico[select2]
        if self[self.n2]["objet"] == min(self[self.n1]["objet"], self[self.n2]["objet"]):
            self.n1, self.n2 = self.n2, self.n1
        name = self[self.n1]["objet"][:-4] + "#" + self[self.n2]["objet"][:-4] + "#.txt"
        T = name in self.dico
        if T:
            f = tkMessageBox.askokcancel(title="Already match", message="You already build this match, do it again ?")
            if f:
                try:
                    os.remove(name[:-4] + "matchlist.txt")
                except:
                    pass
                try:
                    with open(name[:-4] + "matchFile.txt", 'r') as fr:
                        L = list(pickle.load(fr))
                    for i in L:
                        O = []
                        with open(i[:-4] + "matchlist.txt", 'r') as ffr:
                            while 1:
                                try:
                                    O.append(pickle.load(ffr))
                                except:
                                    break
                        O = [mo for mo in O if mo[0] != name]
                        with open(i[:-4] + "matchlist.txt", 'w') as ffw:
                            for j in O:
                                pickle.dump(j, ffw)
                except:
                    pass
                T = False
        if not T:
            self.top = Toplevel()
            self.top.title(name)
            self.root.title(name)
            self.frame = Frame(self.top)
            self.frame.grid_rowconfigure(0, weight=1)
            self.frame.grid_columnconfigure(0, weight=1)
            self.frame.pack(fill=BOTH, expand=1)
            b1 = Button(self.frame, text="match", command=self.Matchgrille)
            b1.grid(row=0, column=0, columnspan=3, sticky=N + S + E + W)
            self.first = True
        
    def Matchgrille(self):
        #Method associated with self.Builder method, match raw data
        x = self.Im.getbbox()[2]
        y = self.Im.getbbox()[3]
        self.L1 = Grille(self[self.n1]["objet"], sizex=x, sizey=y, scale=self.scale)
        self.L2 = Grille(self[self.n2]["objet"], sizex=x, sizey=y, scale=self.scale)
        bait = []
        targets = []
        try:
            with open(self[self.n1]["objet"][:-4] + "matchlist.txt", 'r') as fr:
                while 1:
                    try:
                        tupl = pickle.load(fr)
                        if tupl[0] == self[self.n2]["objet"]:
                            bait.append(tupl[1])
                            targets.append((tupl[2]))
                            F = True
                    except:
                        break
        except:
            pass
        if bait == []:
            bait = range(len(self.L1))
            targets = range(len(self.L2))
            F = False
        v = self.L1.match(self.L2, bait, targets, F)
        self.L1 = self.L1.transform(*v[:2])
        self.L2 = self.L2.transform(*v[2:4])
        print v[4], "phif"
        self.L2 = self.L2.transform(v[4], vec3(0, 0, 1))
        self.scene = display(title='3D view', width=600, height=600, exit=False, forward=(.1, .1, 1), range=(1, 1, 1))
        self.scene.select()
        i = ThreeD(0, 0, -1)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.blue, material=materials.emissive)
        i = ThreeD(1, 0, 0)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.white, material=materials.emissive)
        i = ThreeD(0, 1, 0)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.red, material=materials.emissive)
        self.plot = self.L1.plot("white")
        self.plot = self.L2.plot("black")
        if self.first:
            b2 = Label(self.frame, text="θ", width=5)
            b2.grid(row=1, column=0, sticky=N + S + E + W)
            b2 = Button(self.frame, text="+", command=lambda : self.Rotate(0.005, 0))
            b2.grid(row=1, column=1, sticky=N + S + E + W)
            b2 = Button(self.frame, text="-", command=lambda : self.Rotate(-0.005, 0))
            b2.grid(row=1, column=2, sticky=N + S + E + W)
            b2 = Label(self.frame, text="φ", width=5)
            b2.grid(row=2, column=0, sticky=N + S + E + W)
            b2 = Button(self.frame, text="+", command=lambda : self.Rotate(0, 0.03))
            b2.grid(row=2, column=1, sticky=N + S + E + W)
            b2 = Button(self.frame, text="-", command=lambda : self.Rotate(0, -0.03))
            b2.grid(row=2, column=2, sticky=N + S + E + W)
            b2 = Button(self.frame, text="Compute union", command=lambda : self.Computeunion(0))
            b2.grid(row=3, column=0, columnspan=3, sticky=N + S + E + W)
            self.scene2 = display(title='Union', width=600, height=600, exit=False, forward=(.1, .1, 1), range=(1, 1, 1))
        self.first = False
        self.second = True
    
    def Rotate(self, theta, phi):
        #Method associated with self.MatchGrille method, Rotate the second web of ommatidia
        self.scene.select()
        self.scene.visible = True
        for i in self.plot:
            i.visible = False
        self.L2 = self.L2.transform(theta, vec3(1, 0, 0))
        self.L2 = self.L2.transform(phi, vec3(0, 0, 1))
        i = ThreeD(0, 0, -1)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.blue, material=materials.emissive)
        i = ThreeD(1, 0, 0)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.white, material=materials.emissive)
        i = ThreeD(0, 1, 0)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.red, material=materials.emissive)
        self.plot = self.L2.plot("black")
        
    def Computeunion(self, incre):
        #Method associated with self.MatchGrille method, compute union of data
        self.threshold += incre
        print self.threshold
        L1 = self.L1.Copy()
        L2 = self.L2.Copy()
        self.union.convert, self.union = Compute(L1, L2, self.threshold)
        self.scene2.select()
        self.scene2.visible = True
        for i in self.scene2.objects:
            i.visible = False
        self.union.plot("white")
        print len(self.union)
        i = ThreeD(0, 0, -1)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.blue, material=materials.emissive)
        i = ThreeD(1, 0, 0)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.white, material=materials.emissive)
        i = ThreeD(0, 1, 0)
        cylinder(pos=i(0.95), axis=i(3), radius=0.005, color=color.red, material=materials.emissive)
        if self.second:
                b2 = Label(self.frame, text="union")
                b2.grid(row=4, column=0, sticky=N + S + E + W)
                b2 = Button(self.frame, text="+", command=lambda : self.Computeunion(0.002))
                b2.grid(row=4, column=1, sticky=N + S + E + W)
                b2 = Button(self.frame, text="-", command=lambda : self.Computeunion(-0.002))
                b2.grid(row=4, column=2, sticky=N + S + E + W)
                b3 = Button(self.frame, text="Save data", command=self.Save)
                b3.grid(row=5, column=0, columnspan=3, sticky=N + S + E + W)
        self.second = True

    def Save(self):
        #Method associated with self.MatchGrille method, save data in raw format (.txt)
        self.top.destroy()
        name = self[self.n1]["objet"][:-4] + "#" + self[self.n2]["objet"][:-4] + "#.txt"
        self.union.pickle(name)
        self.pickle()
        self.max += 1
        self.n, n = self.max, self.max
        self[n] = {}
        self[n]["File"] = self.folder + "/" + name
        self[n]["path"] = self[n]["File"].split("/")   
        del self[n]["path"][len(self[n]["path"]) - 1]
        self[n]["path"] = '/'.join(self[n]["path"])
        os.chdir(self[n]["path"])
        self[n]["objet"] = self[n]["File"].split("/")[len(self[n]["File"].split("/")) - 1]
        self[n]["objet"] = self[n]["objet"][:-4] + ".txt"
        self[n]["mean"] = []
        self[n]["union"] = True
        self.view.add_command(label=self[n]["objet"][:-4], command=lambda : self.View(n))
        self.root.config(menu=self.mainmenu)
        self.dico[self[n]["objet"]] = n
    
    def pickle(self):
        print "n1", self[self.n1]["objet"]
        print "n2", self[self.n2]["objet"]
        #Method associated with self.Save method, save matching information
        L1 = []
        try:
            with open(self[self.n1]["objet"][:-4] + "matchlist.txt", 'r') as fr:
                while 1:
                    try:
                        tupl = pickle.load(fr)
                        L1.append((tupl[0], self.union.convert[tupl[1]], tupl[2]))
                    except:
                        break
            L1 = [i for i in L1 if i[0] != self[self.n2]["objet"]]
        except:
            pass
        L2 = []
        try:
            with open(self[self.n2]["objet"][:-4] + "matchlist.txt", 'r') as fr:
                while 1:
                    try:
                        L2.append(pickle.load(fr))  
                    except:
                        break
            L1.extend(L2)
        except:
            pass
        F2 = []
        try:
            with open(self[self.n2]["objet"][:-4] + "matchFile.txt", 'r') as fr:
                F2.extend(pickle.load(fr))
            F2 = [i for i in F2 if i != self[self.n1]["objet"]]
        except:
            pass
        print "F2", F2
        L2 = []
        for matchlist in F2:
            try:
                with open(matchlist[:-4] + "matchlist.txt", 'r') as fr:
                    while 1:
                        tupl = pickle.load(fr)
                        L2.append((matchlist, tupl[2], tupl[1]))
            except:
                pass
        L1.extend(L2)
        F1 = []
        try:
            with open(self[self.n1]["objet"][:-4] + "matchFile.txt", 'r') as fr:
                F1.extend(pickle.load(fr))
        except:
            pass
        L2 = []
        print "F1", F1
        for matchlist in F1:
            try:
                with open(matchlist[:-4] + "matchlist.txt", 'r') as fr:
                    while 1:
                        try:
                            tupl = pickle.load(fr)
                            L2.append((matchlist, self.union.convert[tupl[2]], tupl[1]))
                        except:
                            break
            except:
                pass
        print "L2", L2
        L1.extend(L2)
        build = self[self.n1]["objet"][:-4] + "#" + self[self.n2]["objet"][:-4] + "#.txt"
        print "L1", L1
        for objet in L1:
            if build == min(objet[0], build):
                with open(build[:-4] + "matchlist.txt", 'a') as fa:
                    pickle.dump((objet[0], objet[1] , objet[2]), fa)
                L = []
                try:
                    with open(objet[0][:-4] + "matchFile.txt", 'r') as fr:
                        L = list(pickle.load(fr))
                except:
                    print objet[0][:-4] + "matchFile.txt" + " n'existe pas, impossible de l'ouvrir"
                if not build in L:
                    L.append(build)
                with open(objet[0][:-4] + "matchFile.txt", 'w') as fa:
                    pickle.dump(L, fa)
            else:
                with open(objet[0][:-4] + "matchlist.txt", 'a') as fa:
                    pickle.dump((build, objet[2] , objet[1]), fa)
                L = []
                try:
                    with open(build[:-4] + "matchFile.txt", 'r') as fr:
                        L = list(pickle.load(fr))
                except:
                    print build[:-4] + "matchFile.txt" + " n'existe pas, impossible de l'ouvrir"
                if not objet[0] in L:
                    L.append(objet[0])
                with open(build[:-4] + "matchFile.txt", 'w') as fa:
                    pickle.dump(L, fa)
       
    def Merger(self):
        # Method bounds with the "merge folder" button, open directory.
        self.folder = askdirectory(initialdir=self.folder, title='Workbench')
        os.chdir(self.folder)
        f = tkMessageBox.askokcancel(title="Merge directory", message="You really wanna merge image")
        if f:
            self.Merge()
    
    def Merge(self):
        # Method associated with self.Merger method, merge directory.
        tkMessageBox.showinfo(title="Don't forget", message="A 'merge' folder will be created in the current directory")
        self.root.title("Merge in progress")
        try:
            os.mkdir(str(self.folder + "/merge"))
        except:
            print "dossier merge existe deja"
        List = os.listdir(self.folder)
        List = [i for i in List if (i[-4:] == ".jpg") or (i[-4:] == ".tif")]
        List.sort()
        List.append("")
        for i in range(1, len(List)):
            if List[i][:-5] == List[i - 1][:-5]:
                os.chdir(self.folder)
                Imv = Image.open(str(List[i]))
                r, G, b = Imv.split()
                Imr = Image.open(str(List[i - 1]))
                R, g, b = Imr.split()
                im = Image.merge("RGB", (R, G, b))
                path = List[i][:-6] + '.jpg'
                os.chdir(self.folder + "/merge")
                try:
                    os.remove(path)
                except:
                    print path + " n'existe pas"
                im.save(fp=str(path), quality=100)
        self.folder += "/merge"
        self.root.title("Merge finished")
        self.Folder(False)
        
    def Open(self, File=False, FS=True, TH=False):
        # Method bounds with the "open picture" button, open picture and display it.
        if not File:
            File = askopenfilename(initialdir=self.folder, title='Allez, encore une de plus')
        if File:
            if File[-5:] == "#.txt":
                TH = True
            T = False
            for i in self.iterkeys():
                if self[i]["File"] == File:
                    T = i
            if T and FS:
                self.Fullscreen(T)
            if not T:
                self.max += 1
                self.n, n = self.max, self.max
                self[n] = {}
                self[n]["head"] = []
                self[n]["File"] = File
                self[n]["path"] = self[n]["File"].split("/")
                del self[n]["path"][len(self[n]["path"]) - 1]
                self[n]["path"] = '/'.join(self[n]["path"])
                os.chdir(self[n]["path"])
                self[n]["union"] = True
                self[n]["objet"] = self[n]["File"].split("/")[len(self[n]["File"].split("/")) - 1]
                self[n]["objet"] = self[n]["objet"][:-4] + ".txt"
                if not TH:
                    self.fullscreen.add_command(label=self[n]["objet"][:-4], command=lambda : self.Fullscreen(n))
                    self[n]["union"] = False
                    print File
                self.view.add_command(label=self[n]["objet"][:-4], command=lambda : self.View(n))
                self.root.config(menu=self.mainmenu)
                self.dico[self[n]["objet"]] = n
                self[n]["numbom"] = 0
                self[n]["mean"] = []
                if FS:
                    self.Fullscreen(n)
                elif not TH:
                    try:
                        with open(self[self.n]["objet"], 'r') as fr:
                            while 1:
                                try:
                                    dico = pickle.load(fr)
                                    O = Ommatidiaimage(dico)
                                    mean = O.Mean()
                                    O.Orientation()
                                    self[n]["head"].append(O.Orientation())
                                    self[n]["mean"].append((mean.x, self.Im.getbbox()[3] - mean.y))
                                    self[n]["numbom"] += 1
                                except:
                                    break
                    except:
                        print self[self.n]["objet"] + " n'existe pas, impossible de l'ouvrir"
        
    def Split(self):
        #Method bounds with by the "View -> match picture" button. Open first web of ommatidia.
        self.isactive = False
        self.top = Toplevel()
        self.top.title("Choose the first one")
        self.scrollbar = Scrollbar(self.top)
        self.scrollbar.pack(side=RIGHT, fill=Y)
        self.listbox = Listbox(self.top)
        self.listbox.pack()
        for i in self.iterkeys():
            if self[i]["mean"] != []:
                self.listbox.insert(END, self[i]["objet"][:-4])
        self.listbox.config(yscrollcommand=self.scrollbar.set)
        self.scrollbar.config(command=self.listbox.yview)
        self.listbox.bind('<Double-1>', self.Onselect)
           
    def Onselect(self, event):
        #Method associated with self.Split method. Open second web of ommatidia.
        select1 = self.listbox.get(self.listbox.curselection()) + ".txt"
        self.top.destroy()
        self.top = Toplevel()
        self.top.title("Choose the second one")
        self.scrollbar = Scrollbar(self.top)
        self.scrollbar.pack(side=RIGHT, fill=Y)
        self.listbox = Listbox(self.top)
        self.listbox.pack()
        self.n1 = self.dico[select1]
        for i in self.iterkeys():
            if self[i]["mean"] != []:
                if i != self.n1:
                    self.listbox.insert(END, self[i]["objet"][:-4])
        self.listbox.config(yscrollcommand=self.scrollbar.set)
        self.scrollbar.config(command=self.listbox.yview)
        self.listbox.bind('<Double-1>', self.Twoselect)
    
    def Twoselect(self, event):
        #Method associated with self.Onselect method. Display the two images side to side.
        select2 = self.listbox.get(self.listbox.curselection()) + ".txt"
        self.top.destroy()
        self.frame.destroy()
        self.n2 = self.dico[select2]
        if self[self.n2]["objet"] == min(self[self.n1]["objet"], self[self.n2]["objet"]):
            self.n1, self.n2 = self.n2, self.n1
        self.root.title(self[self.n1]["objet"] + " and " + self[self.n2]["objet"])
        self[self.n1]["tree"] = spatial.KDTree(self[self.n1]["mean"])
        self[self.n2]["tree"] = spatial.KDTree(self[self.n2]["mean"])
        self[self.n1]["match"] = []
        self[self.n2]["match"] = []
        self[self.n1]["listeoutline"] = []
        self[self.n2]["listeoutline"] = []
        self[self.n1]["listefill"] = []
        self[self.n2]["listefill"] = []
        L = []
        try:
            with open(self[self.n2]["objet"][:-4] + "matchFile.txt", 'r') as fr:
                L = list(pickle.load(fr))
        except:
            print self[self.n2]["objet"][:-4] + "matchFile.txt" + " n'existe pas, impossible de l'ouvrir"
        if not self[self.n1]["objet"] in L:
            L.append(self[self.n1]["objet"])
        with open(self[self.n2]["objet"][:-4] + "matchFile.txt", 'w') as fa:
            pickle.dump(L, fa)
        self.frame = Frame(self.root, relief=SUNKEN)
        self.frame.grid_rowconfigure(0, weight=1)
        self.frame.grid_columnconfigure(0, weight=1)
        self.frame.grid_columnconfigure(2, weight=1)
        self.frame.pack(fill=BOTH, expand=1)
        self.xscroll1 = Scrollbar(self.frame, orient=HORIZONTAL)
        self.xscroll2 = Scrollbar(self.frame, orient=HORIZONTAL)
        self.xscroll1.grid(row=1, column=0, sticky=E + W)
        self.xscroll2.grid(row=1, column=2, sticky=E + W)
        self.yscroll1 = Scrollbar(self.frame)
        self.yscroll2 = Scrollbar(self.frame)
        self.yscroll1.grid(row=0, column=1, sticky=N + S)
        self.yscroll2.grid(row=0, column=3, sticky=N + S)
        self.canvas1 = Canvas(self.frame, bd=0, xscrollcommand=self.xscroll1.set, yscrollcommand=self.yscroll1.set)
        self.canvas2 = Canvas(self.frame, bd=0, xscrollcommand=self.xscroll2.set, yscrollcommand=self.yscroll2.set)
        self.canvas1.grid(row=0, column=0, sticky=N + S + E + W)
        self.canvas2.grid(row=0, column=2, sticky=N + S + E + W)
        self.Im1 = Image.open(self[self.n1]["File"])
        self.Im2 = Image.open(self[self.n2]["File"])
        self.img1 = ImageTk.PhotoImage(self.Im1)
        self.img2 = ImageTk.PhotoImage(self.Im2)
        self.canvas1.create_image(0, 0, image=self.img1, anchor="nw")
        self.canvas2.create_image(0, 0, image=self.img2, anchor="nw")
        self.canvas1.config(scrollregion=self.canvas1.bbox(ALL))
        self.canvas2.config(scrollregion=self.canvas2.bbox(ALL))
        self.xscroll1.config(command=self.canvas1.xview)
        self.xscroll2.config(command=self.canvas2.xview)
        self.yscroll1.config(command=self.canvas1.yview)
        self.yscroll2.config(command=self.canvas2.yview)
        for mean, head in zip(self[self.n1]["mean"], self[self.n1]["head"]):
            x, y = mean[0], mean[1]
            self.canvas1.create_oval((x - 5, y - 5, x + 5, y + 5), fill="red")
            self.canvas1.create_line(x + 20 * head.x, y - 20 * head.y, x - 20 * head.x, y + 20 * head.y, arrow=FIRST)
        for mean, head in zip(self[self.n2]["mean"], self[self.n2]["head"]):
            x, y = mean[0], mean[1]
            self.canvas2.create_oval((x - 5, y - 5, x + 5, y + 5), fill="red")
            self.canvas2.create_line(x + 20 * head.x, y - 20 * head.y, x - 20 * head.x, y + 20 * head.y, arrow=FIRST)
        self.Show()
        #function to be called when mouse is clicked
        self.canvas1.bind('<BackSpace>', lambda event : self.Erase(event, self.n1, self.n2))
        self.canvas1.bind("<Button 1>", lambda event : self.Nearest(event, self.n1, self.n2))
        #function to be called when mouse is clicked
        self.canvas2.bind('<BackSpace>', lambda event : self.Erase(event, self.n2, self.n1))
        self.canvas2.bind("<Button 1>", lambda event : self.Nearest(event, self.n2, self.n1))
    
    def Nearest(self, event, n, other):
        #Method bounds with left mouse click event when matching picture. Search for nearest ommatidia.
        event.widget.focus_force()
        query = self[n]["tree"].query((event.widget.canvasx(event.x), event.widget.canvasy(event.y)))
        point = self[n]["mean"][query[1]]
        x = point[0]
        y = point[1]
        if not query[1] in self[n]["match"]:
            self[n]["listeoutline"].append(event.widget.create_oval((x - 20, y - 20, x + 20, y + 20), outline="cyan"))
            self[n]["match"].append(query[1])
            if len(self[n]["match"]) <= len(self[other]["match"]):
                index = len(self[n]["match"]) - 1
                indice1 = self[self.n1]["match"][index]
                x = self[self.n1]["mean"][indice1][0]
                y = self[self.n1]["mean"][indice1][1]
                self[self.n1]["listefill"].append(self.canvas1.create_oval((x - 5, y - 5, x + 5, y + 5), fill="cyan"))
                indice2 = self[self.n2]["match"][index]
                x = self[self.n2]["mean"][indice2][0]
                y = self[self.n2]["mean"][indice2][1]
                self[self.n2]["listefill"].append(self.canvas2.create_oval((x - 5, y - 5, x + 5, y + 5), fill="cyan"))
                with open(self[self.n1]["objet"][:-4] + "matchlist.txt", 'a') as fa:
                    pickle.dump((self[self.n2]["objet"], int(self[self.n1]["match"][index]), int(self[self.n2]["match"][index])), fa)
    
    def Show(self):
        #Display blue oval on screen when matching picture
        try:
            with open(self[self.n1]["objet"][:-4] + "matchlist.txt", 'r') as fr:
                while 1:
                    try:
                        T = pickle.load(fr)
                        if T[0] == self[self.n2]["objet"]:
                            self[self.n1]["match"].append(T[1])
                            self[self.n2]["match"].append(T[2])
                            x = self[self.n1]["mean"][T[1]][0]
                            y = self[self.n1]["mean"][T[1]][1]
                            self[self.n1]["listeoutline"].append(self.canvas1.create_oval((x - 20, y - 20, x + 20, y + 20), outline="cyan"))
                            self[self.n1]["listefill"].append(self.canvas1.create_oval((x - 5, y - 5, x + 5, y + 5), fill="cyan"))
                            x = self[self.n2]["mean"][T[2]][0]
                            y = self[self.n2]["mean"][T[2]][1]
                            self[self.n2]["listeoutline"].append(self.canvas2.create_oval((x - 20, y - 20, x + 20, y + 20), outline="cyan"))
                            self[self.n2]["listefill"].append(self.canvas2.create_oval((x - 5, y - 5, x + 5, y + 5), fill="cyan"))
                    except:
                        break
        except:
            print self[self.n1]["objet"][:-4] + "matchlist.txt" + " n'existe pas, impossible de l'ouvrir"
    
    def Erase(self, event, n, other):
        #Method bounds with backspace event when matching picture.  
        if len(self[n]["match"]) != 0:
            if len(self[n]["match"]) <= len(self[other]["match"]):
                self.Delete(self[self.n1]["objet"][:-4] + "matchlist.txt")
                self.canvas1.delete(self[self.n1]["listefill"][-1])
                del self[self.n1]["listefill"][-1]
                self.canvas2.delete(self[self.n2]["listefill"][-1])
                del self[self.n2]["listefill"][-1]
            event.widget.delete(self[n]["listeoutline"][-1])
            del self[n]["listeoutline"][-1]
            del self[n]["match"][-1]
        
    def Colorbutton(self):
        #Method bounds with "Image color intensity" button. Open the widget. 
        if self.isactive:
            try:
                self.alpha.destroy()
            except:
                print "self.alpha n'existe pas"
            self.alpha = Toplevel(self.root)
            self.frama = Frame(self.alpha, relief=SUNKEN)
            self.red = 1.
            self.green = 1.
            Label(self.frama, text="Red layer").grid(row=0, column=0, columnspan=2, sticky=N + S + E + W)
            Button(self.frama, text="+", command=lambda : self.Color(1.125, 1)).grid(row=1, column=0, sticky=N + S + E + W)
            Button(self.frama, text="-", command=lambda : self.Color(0.88, 1)).grid(row=1, column=1, sticky=N + S + E + W)
            Label(self.frama, text="Green layer").grid(row=2, column=0, columnspan=2, sticky=N + S + E + W)
            Button(self.frama, text="+", command=lambda : self.Color(1, 1.125)).grid(row=3, column=0, sticky=N + S + E + W)
            Button(self.frama, text="-", command=lambda : self.Color(1, 0.88)).grid(row=3, column=1, sticky=N + S + E + W)
            Button(self.frama, text="OK", command=self.OK).grid(row=4, column=0, columnspan=2, sticky=N + S + E + W)
            Button(self.frama, text="Annuler", command=self.Annuler).grid(row=5, column=0, columnspan=2, sticky=N + S + E + W)
            self.frama.pack()
        else:
            try: 
                self.Fullscreen(self.n)
            except:
                self.Open()
            self.Colorbutton()
    
    def Annuler(self):
        #probably usefull ;-)
        self.alpha.destroy()
        self.Fullscreen(self.n)
    
    def Color(self, r, g):
        #Method associated with self.Colorbutton. Change layer intensity.
        self.red *= r
        self.green *= g
        Imv = Image.open(self[self.n]["File"])
        R, G, b = Imv.split()
        G = G.point(lambda i: i * self.green)
        R = R.point(lambda i: i * self.red)
        im = Image.merge("RGB", (R, G, b))
        self.img = ImageTk.PhotoImage(im)
        self.canvas.delete(self.createimage)
        self.createimage = self.canvas.create_image(0, 0, image=self.img, anchor="nw")
    
    def OK(self):
        #Method associated with self.Colorbutton. Save picture.
        self.alpha.destroy()
        Imv = Image.open(self[self.n]["File"])
        R, G, b = Imv.split()
        G = G.point(lambda i: i * self.green)
        R = R.point(lambda i: i * self.red)
        im = Image.merge("RGB", (R, G, b))
        os.remove(self[self.n]["File"])
        im.save(fp=str(self[self.n]["File"]), quality=100)
        self.Fullscreen(self.n)
    
    def Movebutton(self):
        #Method bounds with "Image linear transformation" button. Open the widget.
        if self.isactive:
            try:
                self.alpha.destroy()
            except:
                print "self.alpha n'existe pas"
            self.alpha = Toplevel(self.root)
            self.frama = Frame(self.alpha, relief=SUNKEN)
            self.x = 0
            self.y = 0
            Button(self.frama, text="▲", command=lambda : self.Move(0, 5)).grid(row=0, column=1, sticky=N + S + E + W)
            Button(self.frama, text="◀", command=lambda : self.Move(5, 0)).grid(row=1, column=0, sticky=N + S + E + W)
            Button(self.frama, text="▶", command=lambda : self.Move(-5, 0)).grid(row=1, column=2, sticky=N + S + E + W)
            Button(self.frama, text="▼", command=lambda : self.Move(0, -5)).grid(row=2, column=1, sticky=N + S + E + W)
            Button(self.frama, text="OK", command=self.OKmove).grid(row=1, column=1, sticky=N + S + E + W)
            Button(self.frama, text="Annuler", command=self.Annuler).grid(row=3, column=0, columnspan=3, sticky=N + S + E + W)
            self.frama.pack()
        else:
            try: 
                self.Fullscreen(self.n)
            except:
                self.Open()
            self.Movebutton()
    
    def Move(self, x, y):
        #Method associtaed with self.Movebutton. Move the red layer.
        self.x += x
        self.y += y
        Imv = Image.open(self[self.n]["File"])
        R, G, b = Imv.split()
        Size = (Imv.getbbox()[2], Imv.getbbox()[3])
        R = R.transform(size=Size, method=Image.AFFINE, data=(1, 0, self.x, 0, 1, self.y))
        im = Image.merge("RGB", (R, G, b))
        self.img = ImageTk.PhotoImage(im)
        self.canvas.delete(self.createimage)
        self.createimage = self.canvas.create_image(0, 0, image=self.img, anchor="nw")
    
    def OKmove(self):
        #Method associated with self.Colorbutton. Save picture.
        self.alpha.destroy()
        Imv = Image.open(self[self.n]["File"])
        R, G, b = Imv.split()
        Size = (Imv.getbbox()[2], Imv.getbbox()[3])
        R = R.transform(size=Size, method=Image.AFFINE, data=(1, 0, self.x, 0, 1, self.y))
        im = Image.merge("RGB", (R, G, b))
        os.remove(self[self.n]["File"])
        im.save(fp=str(self[self.n]["File"]), quality=100)
        self.Fullscreen(self.n)
    
    def Fullscreen(self, n):
        # Display picture 
        self.isactive = True
        self.frame.destroy()
        self.frame = Frame(self.root, relief=SUNKEN)
        self.frame.grid_rowconfigure(0, weight=1)
        self.frame.grid_columnconfigure(0, weight=1)
        self.frame.pack(fill=BOTH, expand=1)
        self.n = n
        self[n]["mean"] = []
        self[n]["liste"] = []
        self[n]["numbom"] = 0
        self[n]["numbpr"] = 1
        self.xscroll = Scrollbar(self.frame, orient=HORIZONTAL)
        self.xscroll.grid(row=1, column=0, sticky=E + W)
        self.yscroll = Scrollbar(self.frame)
        self.yscroll.grid(row=0, column=1, sticky=N + S)
        self.canvas = Canvas(self.frame, bd=0, xscrollcommand=self.xscroll.set, yscrollcommand=self.yscroll.set)
        self.canvas.grid(row=0, column=0, sticky=N + S + E + W)
        self.Im = Image.open(self[n]["File"])
        self.img = ImageTk.PhotoImage(self.Im)
        self.createimage = self.canvas.create_image(0, 0, image=self.img, anchor="nw")
        self.canvas.config(scrollregion=self.canvas.bbox(ALL))
        self.xscroll.config(command=self.canvas.xview)
        self.yscroll.config(command=self.canvas.yview)
        #function to be called when mouse is clicked
        self.canvas.focus_force()
        self.canvas.bind('<BackSpace>', self.Backspace)
        self.canvas.bind("<Button 1>", self.Clickleft)
        self.canvas.bind("<Button 3>", self.Backspace)
        self.canvas.bind("y", self.Keyy)
        self.canvas.bind("g", self.Keyg)
        try:
            with open(self[self.n]["objet"], 'r') as fr:
                while 1:
                    try:
                        dico = pickle.load(fr)
                        self.ommatidia = Ommatidiaimage(dico)
                        for j in range(1, 7):
                            self[n]["numbpr"] += 1
                            self.Draw(dico[j][0], self.Im.getbbox()[3] - dico[j][1], dico[j][2])
                    except:
                        break
        except:
            print self[self.n]["objet"] + " n'existe pas, impossible de l'ouvrir"
        
    def Delete(self, name):
        #Method associated with self.Backspace. Load and save raw data.
        with open(name, 'r') as fr:
            L = list()
            while 1:
                try:
                    L.append(pickle.load(fr))
                except:
                    break
        os.remove(name)
        with open(name, 'a') as fw:
            for i in range(len(L) - 1):
                pickle.dump(L[i], fw)

    def Keyg(self, event):
        #Method bounds with g key event when annotating picture. Force green color
        self.color = "green"
        self.root.title(self[self.n]["objet"][:-4] + "| Ommatidia : " + str(self[self.n]["numbom"]) + " Photoreceptor : " + str(self[self.n]["numbpr"]) + " Hey, I wanna be GREEN")

    def Keyy(self, event):
        #Method bounds with y key event when annotating picture. Force green color
        self.color = "yellow"
        self.root.title(self[self.n]["objet"][:-4] + "| Ommatidia : " + str(self[self.n]["numbom"]) + " Photoreceptor : " + str(self[self.n]["numbpr"]) + " Dude, I wanna be YELLOW")
    
    def Backspace(self, event):
        #Method bounds with backspace event when annotating picture. Delete last clicked photoreceptor.
        n = self.n
        if self[n]["numbpr"] + self[n]["numbom"] - 1:
            if self[n]["numbpr"] == 1:
                self.Delete(self[self.n]["objet"])
                try:
                    os.remove(self[self.n]["objet"][:-4] + "matchlist.txt")
                except:
                    print self[self.n]["objet"][:-4] + "matchlist.txt" + " n'existe pas, impossible de le supprimer"
                try:
                    with open(self[self.n]["objet"][:-4] + "matchFile.txt", 'r') as fr:
                        L = list(pickle.load(fr))
                        for i in L:
                            os.remove(i[:-4] + "matchlist.txt")
                        os.remove(self[self.n]["objet"][:-4] + "matchFile.txt")
                except:
                    print self[self.n]["objet"][:-4] + "matchFile.txt" + " n'existe pas, impossible de le supprimer"
                self.canvas.delete(self[n]["liste"][-1])
                del self[n]["liste"][-1]
                self.canvas.delete(self[n]["liste"][-1])
                del self[n]["liste"][-1]
                self.canvas.delete(self[n]["liste"][-1])
                del self[n]["liste"][-1]
                del self[n]["mean"][-1]
                del self[n]["head"][-1]
                self[n]["numbpr"] = 6
                self[n]["numbom"] -= 1
                self.root.title(self[n]["objet"][:-4] + "| Ommatidia : " + str(self[n]["numbom"]) + " Photoreceptor : " + str(self[n]["numbpr"]))
            else:
                self[n]["numbpr"] -= 1
                self.canvas.delete(self[n]["liste"][-1])
                del self[n]["liste"][-1]
                self.root.title(self[n]["objet"][:-4] + "| Ommatidia : " + str(self[n]["numbom"]) + " Photoreceptor : " + str(self[n]["numbpr"]))
    
    def Draw(self, x, y, currentcolor):
        #Method with self.Fullscreen. Draw widget
        n = self.n
        self[n]["liste"].append(self.canvas.create_oval(x - 5, y - 5, x + 5, y + 5, fill=currentcolor))
        if self[n]["numbpr"] == 7:
            self[n]["numbpr"] = 1
            self[n]["numbom"] += 1
            head = self.ommatidia.Orientation()
            mean = self.ommatidia.Mean()
            self[n]["head"].append(head)
            self[n]["mean"].append((mean.x, self.Im.getbbox()[3] - mean.y))
            asym = head.Findortho()
            asym = asym.Norm()
            if asym * (self.ommatidia[3] - mean) < 0:
                asym = TwoD(-asym.x, -asym.y)
            self[n]["liste"].append(self.canvas.create_line(mean.x + 20 * head.x, self.Im.getbbox()[3] - mean.y - 20 * head.y, mean.x - 20 * head.x, self.Im.getbbox()[3] - mean.y + 20 * head.y, arrow=FIRST))
            self[n]["liste"].append(self.canvas.create_line(mean.x - 20 * head.x, self.Im.getbbox()[3] - mean.y + 20 * head.y, mean.x - 20 * head.x + 20 * asym.x, self.Im.getbbox()[3] - mean.y + 20 * head.y - 20 * asym.y))
        self.root.title(self[n]["objet"][:-4] + "| Ommatidia : " + str(self[n]["numbom"]) + " Photoreceptor : " + str(self[n]["numbpr"]))
        
    def Clickleft(self, event):
        #Method bounds with left mouse click event annotating picture. Add photoreceptor.
        n = self.n
        x = self.canvas.canvasx(event.x)
        y = self.canvas.canvasy(event.y)
        pixel = self.Im.getpixel((x, y))
        currentcolor = str(self.color)
        if not isinstance(self.color, str):
            if  pixel[0] > self.tc:
                currentcolor = "yellow"
            else:
                currentcolor = "green"
        self.color = 0
        self.ommatidia[self[n]["numbpr"]] = PRimage(x, self.Im.getbbox()[3] - y, currentcolor)
        self[n]["numbpr"] += 1
        if self[n]["numbpr"] == 7:
                with open(self[n]["objet"], 'a') as fw:
                    pickle.dump(self.ommatidia.pickle(), fw)
        self.Draw(x, y, currentcolor)

Root = Tk()
myapp = Myapp(Root)
Root.mainloop()
#lunch the tk mainloop
