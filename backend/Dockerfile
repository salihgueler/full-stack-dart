FROM --platform=linux/amd64 dart:stable AS build

# Resolve app dependencies
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and compile it
COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image
FROM --platform=linux/amd64 debian:bullseye-slim
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/public/ /app/public/

EXPOSE 8080
CMD ["/app/bin/server"]