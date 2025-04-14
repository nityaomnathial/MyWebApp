# Stage 1: Build the app using Maven and JDK 17
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Stage 2: Run the app using OpenJDK 17
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/mywebapp-1.0-SNAPSHOT.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
