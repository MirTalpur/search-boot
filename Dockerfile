# Build package
FROM maven:alpine AS build
WORKDIR /opt/app
COPY . /opt/app
WORKDIR /opt/app/search-boot
RUN mvn clean package

# Setup run container
FROM openjdk:8-jdk-alpine

# Add java user
RUN adduser --system javarole \
    && mkdir -p /opt/app \
    && chown -R javarole /opt/app

# Change the work directory
WORKDIR /opt/app/search-boot/

# Set Env Vars
ENV SERVER_PORT 8080
# TODO: use the default profile being set for now
# ENV SPRING_PROFILES_ACTIVE dev

# Copy app from build containter
COPY --from=build /opt/app/search-boot/target/search-boot.jar .
# TODO: add this back later doesn't work with javarole user
# USER javarole
EXPOSE $SERVER_PORT
# Run
CMD java -jar search-boot.jar