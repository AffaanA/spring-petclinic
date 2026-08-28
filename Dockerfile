# Base image with Java 21
FROM eclipse-temurin:21-jdk

# Create a non-root application user
RUN useradd --create-home --uid 10001 appuser

# Working directory inside the container
WORKDIR /app

# Copy the JAR into the image
COPY target/*.jar app.jar

# Give the application user ownership of the application
RUN chown appuser:appuser /app/app.jar

# Run the application as non-root
USER appuser

# Spring Boot listens on port 8080
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]
