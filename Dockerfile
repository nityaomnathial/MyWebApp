# Stage 1: Build the app using Maven
FROM maven:3.8.1-jdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Stage 2: Run the app using OpenJDK
FROM openjdk:11-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
