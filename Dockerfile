# Multi-stage build for optimized image size

# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /app

# Copy pom.xml and download dependencies (cached layer)
COPY pom.xml .
COPY bootstrap/pom.xml bootstrap/
COPY domain/pom.xml domain/
COPY application/pom.xml application/
COPY adapters/pom.xml adapters/
COPY shared/pom.xml shared/

RUN mvn dependency:go-offline -B

# Copy source code
COPY . .

# Build application (skip tests for faster build, tests run in CI)
RUN mvn clean package -DskipTests -pl bootstrap -am

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine

# Create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /app

# Copy jar from builder stage
COPY --from=builder /app/bootstrap/target/*.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# JVM optimization flags
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# Run application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]