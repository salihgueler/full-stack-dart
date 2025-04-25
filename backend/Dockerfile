FROM dart:stable AS build

WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe bin/server.dart -o bin/server

FROM debian:stable-slim
COPY --from=build /app/bin/server /app/bin/server
COPY --from=build /app/public /app/public

EXPOSE 8080
CMD ["/app/bin/server"]
