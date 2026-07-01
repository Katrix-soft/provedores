# Stage 1: Build the Flutter web app
FROM debian:bookworm-slim AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b 3.22.0 --depth 1 /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Enable Web build and download platform binaries
RUN flutter config --enable-web
RUN flutter doctor

WORKDIR /app

# Copy dependencies first for better caching
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the project
COPY . .

# Build the web application
RUN flutter build web --release --web-renderer html
RUN echo "self.addEventListener('install', (e) => { self.skipWaiting(); }); self.addEventListener('activate', (e) => { self.clients.claim(); });" >> build/web/flutter_service_worker.js

# Stage 2: Serve the app using Nginx
FROM nginx:alpine
# Copy the build output from the previous stage to nginx's public folder
COPY --from=build /app/build/web /usr/share/nginx/html
# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
