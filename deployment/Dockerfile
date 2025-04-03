# Build stage for backend
FROM dart:stable AS backend-builder

WORKDIR /app/backend
COPY backend/pubspec.* ./
RUN dart pub get

COPY backend ./
COPY shared ./shared
RUN dart compile exe bin/server.dart -o bin/server

# Build stage for frontend
FROM dart:stable AS frontend-builder

# Install Flutter
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:$PATH"
RUN flutter doctor
RUN flutter config --enable-web

WORKDIR /app/frontend
COPY frontend/pubspec.* ./
RUN flutter pub get

COPY frontend ./
COPY shared ./shared
RUN flutter build web

# Runtime stage
FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy backend executable
COPY --from=backend-builder /app/backend/bin/server /app/server

# Copy frontend build
COPY --from=frontend-builder /app/frontend/build/web /app/public

# Expose port
EXPOSE 8080

# Run the server
CMD ["/app/server"]
