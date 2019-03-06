L=[]
with open("eng_fiction.txt", 'r') as f:
    for line in f:
        L.append(line)
date=[0]*2013
for i in L:
    j=i.split("\t")
    date[int(j[1])]+=int(j[2])
date=date[1800:]
output=[]
for i in date:
    output.append(str(i)+"\n")
with open("Reng_fiction.txt", 'w') as w:
    w.writelines(output)

