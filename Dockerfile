################
FROM google/dart:2.12

WORKDIR /pubcrawler
COPY . .

WORKDIR /pubcrawler/backend

RUN dart pub get
RUN dart pub run build_runner build --delete-conflicting-outputs
RUN dart compile exe bin/server.dart -o bin/server

########################
FROM subfuzion/dart:slim
COPY --from=0 /pubcrawler/backend/bin/server /app/bin/server
EXPOSE 8080
ENV FUNCTION_TARGET=random
ENTRYPOINT ["/app/bin/server"]
