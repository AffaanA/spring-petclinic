# Base image with Java 21
FROM eclipse-temurin:21-jdk

# Working directory inside the container
WORKDIR /app

# Copy the JAR into the image
COPY target/*.jar app.jar

# Spring Boot listens on port 8080
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
