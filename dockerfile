# Etap 1: Budowanie aplikacji
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY vite.config.* ./
COPY tsconfig.* ./
COPY . .

RUN npm install
RUN npm run build

# Etap 2: Serwowanie przez nginx
FROM nginx:stable-alpine

# Usuwamy domyślną zawartość
RUN rm -rf /usr/share/nginx/html/*

# Kopiujemy zbudowaną aplikację
COPY --from=builder /app/dist /usr/share/nginx/html

# Własna konfiguracja nginx (ważna dla React Routera)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Port NGINX
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
