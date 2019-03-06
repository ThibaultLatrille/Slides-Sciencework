for name in ["ita","eng_fiction","eng_us","eng_gb","fre"]:
    L=[]
    with open(name+".txt", 'r') as f:
        for line in f:
            L.append(line)
    date=[0]*2010
    for i in L:
        j=i.split("\t")
        date[int(j[1])]+=float(j[2])

    T=[]
    with open(name+"_total.txt", 'r') as f:
        for line in f:
            T=line.split("\t")

    for i in T:
        j=i.split(",")
        date[int(j[0])]=date[int(j[0])]/int(j[1])

    date=date[1800:]

    output=[]
    for i in date:
        output.append(str(i)+"\n")
    with open("R"+name+".txt", 'w') as w:
        w.writelines(output)




