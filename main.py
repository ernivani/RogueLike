import numpy as np
import matplotlib.pyplot as plt
from matplotlib import style

# Style
style.use('fivethirtyeight')

# Figure
fig = plt.figure()
ax1 = fig.add_subplot(1, 1, 1)

# Fonction pour convertir degrés en radians
def f(x):
    return 0.1 * expo(x) 
def expo(x):
    return np.exp(x) * 0.2 * x
    

# Données : angles de 0 à 360 degrés
x = np.arange(0, 360, 1)  # Vous pouvez ajuster l'intervalle et le pas selon vos besoins
y = f(x)

# Tracé du graphique
ax1.plot(x, y)

# Titres des axes
plt.xlabel('Degrees')
plt.ylabel('Radians')

# Afficher le graphique
plt.show()
