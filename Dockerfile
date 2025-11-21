# Build stage
FROM node:14-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Final stage
FROM node:14-alpine
WORKDIR /app
COPY --from=build /app .
CMD ["node", "app.js"]

