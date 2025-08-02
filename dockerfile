# ------------------------------------------
# Stage 1: Build the React + Vite App
# ------------------------------------------

# Use an official Node.js image (Alpine = lightweight version)
FROM node:20-alpine AS build

# Set the working directory inside the container to /app
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# install the development dependencies (Vite inside docker container)
RUN npm install --include=dev


# Copy all remaining project files (src, public, etc.)
COPY . .

# Build the React app using Vite (outputs static files to /app/dist)
RUN npm run build


# ------------------------------------------
# Stage 2: Serve the App using Nginx
# ------------------------------------------

# Use an official Nginx image to serve the static build
FROM nginx:stable-alpine  

# Copy the built files from the previous stage (Stage - 1) to Nginx's default public folder
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 (default HTTP port) so the app can be accessed externally
EXPOSE 80

# Start Nginx in the foreground (required for Docker containers)
CMD ["nginx", "-g", "daemon off;"]
