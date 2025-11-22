# Étape 1 : image Node légère
FROM node:14-alpine AS build
WORKDIR /app

# Copier package.json et installer dépendances
COPY package.json ./
RUN npm install

# Copier le reste du projet
COPY . .

# Pas de script build nécessaire pour un serveur simple

# Étape finale
FROM node:14-alpine
WORKDIR /app

# Copier tout depuis l'étape build
COPY --from=build /app .

# Lancer le serveur Node
CMD ["node", "src/index.js"]
