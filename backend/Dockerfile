FROM dart:stable AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN dart pub get

# Copy the rest of the application
COPY . .

# Build the frontend if needed (uncomment if you want to build frontend here)
# RUN cd ../frontend && flutter build web
# RUN mkdir -p public
# RUN cp -r ../frontend/build/web/* public/

# Ensure the public directory exists
RUN mkdir -p public

# Build for production
RUN dart compile exe bin/server.dart -o bin/server

# Create a new image with just the compiled binary
FROM debian:bullseye-slim

# Install necessary SSL certificates
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the compiled binary from the build stage
COPY --from=build /app/bin/server /app/bin/server

# Copy the public directory
COPY --from=build /app/public /app/public

# Expose the port
EXPOSE 8080

# Start the server
CMD ["/app/bin/server"]
