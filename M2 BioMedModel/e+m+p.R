### Algorithme de simulation du modèle à 2 états : promoteur + ARN ###

# Paramètres du modèle
kon = 0.5 # Taux d'allumage du gène
koff = 50 # Taux d'extinction du gène
s = 100 # Taux de création d'ARN (état ON)
d = 1 # Taux de dégradation de l'ARN
sp=10 # Taux de traduction
dp=0.1 # Taux de dégradation des protéines

# Simulation d'une trajectoire jusqu'au temps Tf
SimuRT= function(Tf) {
  t = 0 # Initialisation du temps
  e = 0 # État du promoteur
  m = 0 # Nombre de molécules d'ARN
  p = 0 # Nombre de molécules de protéines
  Vt = t # Vecteur des instants de réaction
  Ve = e # Vecteur des états du promoteur
  Vm = m # Vecteur des nombres d'ARNs
  Vp = p # Vecteur des nombres de protéines
  
  while (t < Tf) {
    # On liste les réactions possibles et leurs taux
    Vtaux = cbind(kon*(1-e), koff*e,s*e, d*m,m*sp,p*dp) # Taux de chaque réaction
    Staux = sum(Vtaux) # Taux de la prochaine réaction
    
    # Partie stochastique
    t = t + rexp(1, rate = Staux) # Nouvel instant de réaction
    R = rmultinom(1, 1, Vtaux/Staux) # Choix de la nouvelle réaction
    
    # Astuce pour récupérer l'indice de la réaction
    l = 1:length(R)
    i = l[R==1]
    
    # Mise à jour de l'état du système
    if (i == 1) { e = 1 } # Passage en ON
    if (i == 2) { e = 0 } # Passage en OFF
    if (i == 3) { m = m + 1 } # Création d'un ARN
    if (i == 4) { m = m - 1 } # Dégradation d'un ARN
    if (i == 5) { p = p + 1 } # Création d'une protéine
    if (i == 6) { p = p - 1 } # Dégradation d'une protéine
    
    
    # On stocke les nouvelles valeurs
    Vt = rbind(Vt,t)
    Ve = rbind(Ve,e)
    Vm=rbind(Vm,m)
    Vp=rbind(Vp,p)
  }
  
  # On corrige les dernières valeurs à l'instant final
  n = length(Vt)
  Vt[n] = Tf # Instant jusqu'auquel on a observé la trajectoire
  Ve[n] = Ve[n-1] # État effectif du promoteur à cet instant
  Vm[n] = Vm[n-1] # Nombre effectif de molécules à cet instant
  Vp[n] = Vp[n-1] # Nombre effectif de molécules à cet instant
  
  return(list("Temps" = Vt, "Promoteur" = Ve, "ARN"=Vm, "Proteins"=Vp))
}

#simulation
simu = SimuRT(Tf = 100)

# Tracé d'une simulation
op=par(mfrow=c(3,1)) 
plot(simu$Temps, simu$Promoteur , type="s", col="blue")
plot(simu$Temps, simu$ARN , type="s", col="red")
plot(simu$Temps, simu$Proteins , type="s", col="green")
