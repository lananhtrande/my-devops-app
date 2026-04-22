############################################
# Stage 1 — Build React Application
############################################
FROM node:20 AS build

# Set working directory
WORKDIR /app

# Copy dependency files first (Docker cache optimization)
COPY package*.json ./

# Install ALL dependencies (needed to build React)
RUN npm install --no-audit --no-fund

# Copy the rest of the app source code
COPY . .

# Create production build
RUN npm run build


############################################
# Stage 2 — Nginx to Serve Static Files
############################################
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy React build output from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy SSL certs
COPY ssl/nginx.crt /etc/nginx/ssl/nginx.crt
COPY ssl/nginx.key /etc/nginx/ssl/nginx.key

# Healthcheck (optional)
RUN apk add --no-cache curl

HEALTHCHECK CMD curl -k $LOCALHOST || exit 1

# Expose port 80
EXPOSE $HTTP_PORT $HTTPS_PORT

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]