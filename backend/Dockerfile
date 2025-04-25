FROM dart:stable AS build

WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe bin/hello.dart -o bin/hello

FROM debian:stable-slim
COPY --from=build /app/bin/hello /app/bin/hello
COPY --from=build /app/public /app/public

EXPOSE 8080
CMD ["/app/bin/hello"]