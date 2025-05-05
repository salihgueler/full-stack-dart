FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart pub get --offline

# Build a minimal serving image
FROM dart:stable-slim
COPY --from=build /app /app
WORKDIR /app

# Make sure the application listens on port 8080
ENV PORT=8080

# Start the application
CMD ["dart", "bin/hello.dart"]

# Expose the port
EXPOSE 8080
