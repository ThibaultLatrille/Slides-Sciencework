import ete2
from ete2 import Tree
from ete2 import TreeNode
import copy

# this is a function for use elsewhere, not stand-alone
def mast(intree1,intree2):
  # copy the trees--this function DESTROYS its working copy!
  tree1 = copy.deepcopy(intree1)
  tree2 = copy.deepcopy(intree2)
  # count the tips
  numtips = len(tree1.get_leaves())
  assert numtips == len(tree2.get_leaves())  # trees must be same size!!

  ### label nodes

  # first, relabel tips as 0..numtips-1.  This has to be done all at
  # once as there might already have been tips with those names

  tipnames = tree1.get_leaf_names()
  tipdict = {}
  tipno = 0
  for tip in tipnames:
    tipdict[tip] = tipno
    tipno += 1
  for leaf in tree1.get_leaves():
    leaf.name = tipdict[leaf.name]
  for leaf in tree2.get_leaves():
    leaf.name = tipdict[leaf.name]
  
  # then, label internal nodes, starting with tips+1
  nodeno = numtips
  for node in tree1.traverse("postorder"):
    if not node.is_leaf():  
      node.name = nodeno
      nodeno += 1
  nodeno = numtips
  for node in tree2.traverse("postorder"):
    if not node.is_leaf():
      node.name = nodeno
      nodeno += 1

  # create the 2D array
  numnodes = 2 * numtips - 1
  vals = []
  inner = []
  for i in range(0,numnodes):
    inner.append(None)
  for i in range(0,numnodes):
    vals.append(inner[:])     # make a copy!

  # the mast score is the number of tips in the MAST of the given subtrees
  def rmast(a,w):   # recusively calculate mast score
    if vals[a.name][w.name] != None:
      return vals[a.name][w.name]    # already calculated
    else:
      # leaf branch
      if a.is_leaf():
        if a.name in w.get_leaf_names():
          vals[a.name][w.name] = 1
          return 1
        else:
          vals[a.name][w.name] = 0
          return 0
      if w.is_leaf():
        if w.name in a.get_leaf_names():
          vals[a.name][w.name] = 1
          return 1
        else:
          vals[a.name][w.name] = 0
          return 0
      # non-leaf branch
      b = a.get_children()[0]
      c = a.get_children()[1]
      x = w.get_children()[0]
      y = w.get_children()[1]
      results = []
      results.append(rmast(b,x)+rmast(c,y))
      results.append(rmast(b,y)+rmast(c,x))
      results.append(rmast(a,x))
      results.append(rmast(a,y))
      results.append(rmast(b,w))
      results.append(rmast(c,w))
      vals[a.name][w.name] = max(results)
      return vals[a.name][w.name]
       
  biggest = 0
  for node1 in tree1.traverse("postorder"):
    for node2 in tree2.traverse("postorder"):
      rmast(node1,node2)
  
  biggest = 0
  for i in range(0,numnodes):
    for j in range(0,numnodes):
      if vals[i][j] > biggest:
        biggest = vals[i][j]
  return biggest

def allbinarytrees(s):
    if len(s) == 1:
        yield s
    else:
        for i in range(1, len(s), 2):
            for l in allbinarytrees(s[:i]):
                for r in allbinarytrees(s[i+1:]):
                    yield '({}{}{})'.format(l, s[i], r)

for n in range(5, 11):
  print("n=%s " % n)
  r = ','.join([str(i) for i in range(n)])
  s = allbinarytrees(r)
  t1 = Tree(s.next()+";")
  tree_list = [Tree(s2+";") for s2 in s]
  print("T1:")
  print(t1)
  print("\n")

  mast_list = [mast(t1, t2) for t2 in tree_list]
  min_mast = min(mast_list)
  print("The most MAST distant tree T2 with distance %s :" % (n-min_mast))
  print(tree_list[mast_list.index(min_mast)])
  print("\n")

  rf_list = [t1.robinson_foulds(t2, unrooted_trees=True)[0] for t2 in tree_list]
  max_rf = max(rf_list)
  print("The most RF distant tree T3 with distance %s :" % max_rf)
  print(tree_list[rf_list.index(max_rf)])
  print("\n")
  print("-------------------------------------\n")
