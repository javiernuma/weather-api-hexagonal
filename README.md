# ☁️ Weather API - Hexagonal Architecture Showcase

> Production-ready weather aggregation service demonstrating Hexagonal Architecture 
> (Ports & Adapters), Clean Architecture principles, and modern Java 17+ features.

[![Java](https://img.shields.io/badge/Java-17-red?logo=openjdk&logoColor=white)]
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.x-green?logo=spring&logoColor=white)]
[![Hexagonal](https://img.shields.io/badge/Architecture-Hexagonal-blue)]
[![License](https://img.shields.io/badge/License-MIT-yellow)]

## 🎯 Overview

Enterprise-grade weather API service that aggregates data from multiple weather 
providers through a clean, unified interface. Built to demonstrate architectural 
patterns and best practices in modern Java development.

### Key Features

- ✅ **Hexagonal Architecture** - Complete separation of business logic from technical concerns
- ✅ **Provider Abstraction** - Easily add new weather data sources
- ✅ **Normalized API** - Consistent response format regardless of provider
- ✅ **Modern Java 17+** - Records, Pattern Matching, Text Blocks
- ✅ **Spring Boot 3.x** - Jakarta EE, native compilation ready
- ✅ **API Documentation** - Swagger/OpenAPI integration
- ✅ **Request Logging** - Complete audit trail of API calls

---

## 🏗️ Architecture

### Hexagonal Architecture Layers

```
weather-api/
│
├── domain/                   # Core business logic (zero external dependencies)
│   ├── model/                # Entities & Value Objects
│   ├── ports/                # Interface contracts
│   │   ├── in/               # Primary ports (use cases)
│   │   └── out/              # Secondary ports (persistence, external APIs)
│   └── services/             # Business logic implementation
│
├── shared/                   # Cross-cutting concerns
│   ├── dto/                  # Data Transfer Objects
│   └── exception/            # Domain exceptions
│
├── application/              # Application orchestration
│   ├── service/              # Application services
│   └── config/               # Application configuration
│
├── adapters/                 # Technical implementations
│   ├── in/                   # Inbound adapters
│   │   └── rest/             # REST controllers
│   └── out/                  # Outbound adapters
│       ├── persistence/      # Database implementations
│       └── api/              # External API integrations
│
└── bootstrap/                # Application initialization
    └── config/               # Global configuration
```

### Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│               REST API Layer                        │
│              (Adapters - In)                        │
└───────────────────┬─────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────┐
│           Application Services                      │
│          (Orchestration Layer)                      │
└───────────────────┬─────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────┐
│         Domain Layer (Business Logic)               │
│   - Weather Entity        - Ports (Interfaces)      │
│   - Temperature VO        - Use Cases               │
│   - Wind Speed VO         - Domain Services         │
└───────────────────┬─────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────┐
│            Adapters - Out                           │
│  ┌──────────────┐  ┌──────────────┐                 │
│  │ OpenWeather  │  │  H2 Database │                 │
│  │   Adapter    │  │   Adapter    │                 │
│  └──────────────┘  └──────────────┘                 │
└─────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

### Core Technologies
- **Java 17** - Modern Java features (Records, Pattern Matching, Text Blocks)
- **Spring Boot 3.x** - Jakarta EE framework
- **Spring Data JPA** - Data persistence
- **H2 Database** - Embedded database
- **Maven** - Build tool

### API & Documentation
- **Spring Web** - REST API
- **Swagger/OpenAPI** - API documentation
- **Jakarta Validation** - Input validation

### Modern Java 17 Features Used
```java
// Records for immutable DTOs
public record WeatherResponse(
    String city,
    Temperature temperature,
    String condition,
    Wind wind
) {}

// Pattern Matching
if (provider instanceof OpenWeatherAdapter adapter) {
    return adapter.fetchWeather(city);
}

// Text Blocks
String query = """
    SELECT * FROM weather_log
    WHERE city = ?
    AND timestamp > ?
    """;
```

---

## 🚀 Quick Start

### Prerequisites

- Java 17 or higher
- Maven 3.8+

### Installation & Run

```bash
# Clone repository
git clone https://github.com/javiernuma/weather-api-hexagonal.git
cd weather-api-hexagonal

# Build
mvn clean install

# Run
mvn -pl bootstrap spring-boot:run
```

### Access Points

- **API Base:** http://localhost:8080
- **Swagger UI:** http://localhost:8080/swagger-ui.html
- **H2 Console:** http://localhost:8080/h2-console

---

## 📡 API Usage

### Get Weather Data

```http
GET /api/weather/{city}?source={provider}&config={json}
```

#### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| city | path | Yes | City name |
| source | query | No | Weather provider (default: mock) |
| config | query | No | Provider-specific configuration (JSON) |

### Examples

**Basic Request (Mock Provider):**
```bash
curl http://localhost:8080/api/weather/Madrid?source=mock
```

**OpenWeather Provider:**
```bash
curl "http://localhost:8080/api/weather/Madrid?source=openweather&config={\"apiKey\":\"YOUR_API_KEY\"}"
```

### Normalized Response

```json
{
  "city": "Madrid",
  "temperature": {
    "value": 25.5,
    "unit": "°C"
  },
  "condition": "Sunny",
  "wind": {
    "speed": 12.3,
    "unit": "km/h"
  }
}
```

---

## 🔌 Weather Providers

### Implemented Providers

| Provider | Status | Description |
|----------|--------|-------------|
| **Mock** | ✅ Active | Simulated data for testing |
| **OpenWeather** | ✅ Active | OpenWeatherMap API integration |
| **WeatherStack** | 🔄 Planned | WeatherStack API |
| **AccuWeather** | 🔄 Planned | AccuWeather API |

### Adding New Providers

Implement the `WeatherProvider` port:

```java
public interface WeatherProvider {
    Weather fetchWeather(String city, ProviderConfig config);
}
```

Example implementation:

```java
@Component("customProvider")
public class CustomWeatherAdapter implements WeatherProvider {
    @Override
    public Weather fetchWeather(String city, ProviderConfig config) {
        // Your implementation
    }
}
```

---

## 🏛️ Architecture Patterns

### Design Patterns Used

- **Hexagonal Architecture** - Ports & Adapters separation
- **Dependency Inversion** - Core depends on abstractions
- **Strategy Pattern** - Interchangeable weather providers
- **Factory Pattern** - Provider instantiation
- **Repository Pattern** - Data access abstraction
- **DTO Pattern** - API boundary objects

### SOLID Principles

✅ **Single Responsibility** - Each class has one reason to change
✅ **Open/Closed** - Open for extension (new providers), closed for modification
✅ **Liskov Substitution** - Providers are interchangeable
✅ **Interface Segregation** - Focused port interfaces
✅ **Dependency Inversion** - High-level modules independent of low-level details

---

## 🧪 Testing

### Run Tests

```bash
# Unit Tests
mvn test

# Integration Tests
mvn verify

# Coverage Report
mvn jacoco:report
```

### Test Coverage

- ✅ Unit tests for domain logic
- ✅ Integration tests for adapters
- ✅ Contract tests for API
- Target: 80%+ code coverage

---

## 📦 Project Structure

```
weather-api/
├── domain/
│   ├── model/
│   │   ├── Weather.java
│   │   ├── Temperature.java (Value Object)
│   │   └── Wind.java (Value Object)
│   ├── ports/
│   │   ├── in/
│   │   │   └── WeatherUseCase.java
│   │   └── out/
│   │       ├── WeatherProvider.java
│   │       └── WeatherLogRepository.java
│   └── services/
│       └── WeatherService.java
│
├── shared/
│   ├── dto/
│   │   ├── WeatherResponse.java (Record)
│   │   └── ProviderConfig.java (Record)
│   └── exception/
│       └── WeatherNotFoundException.java
│
├── application/
│   └── service/
│       └── WeatherApplicationService.java
│
├── adapters/
│   ├── in/
│   │   └── rest/
│   │       └── WeatherController.java
│   └── out/
│       ├── persistence/
│       │   └── JpaWeatherLogAdapter.java
│       └── api/
│           ├── MockWeatherAdapter.java
│           └── OpenWeatherAdapter.java
│
└── bootstrap/
    └── WeatherApplication.java
```

---

## 🔒 Security Considerations

- ✅ Input validation with Jakarta Validation
- ✅ SQL injection prevention (JPA)
- ✅ API key management (externalized config)
- ✅ Error handling without data leakage

---

## 📈 Future Enhancements

### Planned Features

- [ ] **Caching Layer** - Redis integration for performance
- [ ] **Rate Limiting** - API request throttling
- [ ] **Authentication** - JWT-based security
- [ ] **Docker Support** - Containerization
- [ ] **Circuit Breaker** - Resilience4j integration
- [ ] **Monitoring** - Prometheus metrics
- [ ] **More Providers** - WeatherStack, AccuWeather

---

## 🐳 Docker Support

### Build & Run with Docker

```bash
# Build image
docker build -t weather-api:latest .

# Run container
docker run -p 8080:8080 weather-api:latest
```

### Docker Compose

```yaml
version: '3.8'
services:
  weather-api:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
```

---

## 📚 Additional Resources

- [Hexagonal Architecture Guide](https://alistair.cockburn.us/hexagonal-architecture/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Java 17 Features](https://openjdk.org/projects/jdk/17/)

---

## 👨‍💻 Author

**Javier Vidal Numa Mendoza**

Software Architect specializing in:
- Clean Architecture
- Hexagonal Architecture
- Domain-Driven Design
- Modern Java Development

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin&logoColor=white)](https://linkedin.com/in/ing-javier-vidal-numa-mendoza)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github&logoColor=white)](https://github.com/javiernuma)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🌟 Highlights

- ⚡ **Hexagonal Architecture** - Ports & Adapters pattern
- 🎯 **Clean Code** - SOLID principles
- 🚀 **Modern Java** - Java 17+ features
- 📦 **Provider Abstraction** - Extensible design
- 📚 **Well-Documented** - Clear structure & examples

---

**Built with ❤️ demonstrating architectural excellence and modern Java practices**
