# Stage 1: Build the Flutter web app
FROM subosito/flutter-node:v3.22.0-ubuntu AS build
WORKDIR /app

# Copy dependencies first for better caching
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the project
COPY . .

# Build the web application
RUN flutter build web --release

# Stage 2: Serve the app using Nginx
FROM nginx:alpine
# Copy the build output from the previous stage to nginx's public folder
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
