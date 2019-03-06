'''
Created on Jul 15, 2013

@author: Thibault
'''

import os

os.chdir("C:\\Users\\Thibault\\workspace\\LBEPy")
final=[]

count_table={}
with open("CreativErucount_table.txt", 'r') as f:
    for line in f:
        count_table[line[0:14]]=line

prequel=count_table["Representative"]

mpick=[]
with open("cluster_Mpick.txt", 'r') as f:
    for line in f:
        mpick.append(line)

del mpick[0]
final.append(prequel)
    
for otu_str in mpick:
    otu=[]
    otu_list=otu_str.split(';')
    otu_list[0]=otu_list[0].strip('"')
    otu=[0 for i in range(32)]
    otu_list[1]=otu_list[1].strip("\n")
    otu_list[1]=otu_list[1].strip('"')
    otu_list[1]=otu_list[1].split(',')
    for name in otu_list[1]:
        name_list=count_table[name].strip("\n").split("\t")
        for i in range(32):
            otu[i]+=int(name_list[i+1])
    
    otu_line="Mpick"
    otu_line+=otu_list[0]
    for number in otu:
        otu_line+="\t"
        otu_line+=str(number)
    
    final.append(otu_line+"\n")


with open("OTU_abundance.txt", 'w') as w:
    w.writelines(final)



