# ☁️ Weather API - Hexagonal Architecture

> Production-ready weather aggregation service demonstrating Hexagonal Architecture (Ports & Adapters), Clean Architecture principles, and modern Java 17+ features.

[![Java](https://img.shields.io/badge/Java-17-red?logo=openjdk&logoColor=white)](https://openjdk.org/projects/jdk/17/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.x-green?logo=spring&logoColor=white)](https://spring.io/projects/spring-boot)
[![Hexagonal](https://img.shields.io/badge/Architecture-Hexagonal-blue)](https://alistair.cockburn.us/hexagonal-architecture/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)

## 🎯 Overview

Enterprise-grade weather API service that aggregates data from multiple weather providers through a clean, unified interface. Built to demonstrate architectural patterns and best practices in modern Java development.

### Key Features

- ✅ **Hexagonal Architecture** - Complete separation of business logic from technical concerns
- ✅ **Provider Abstraction** - Easily add new weather data sources
- ✅ **Normalized API** - Consistent response format regardless of provider
- ✅ **Modern Java 17+** - Records, Pattern Matching, Text Blocks
- ✅ **Spring Boot 3.x** - Jakarta EE, native compilation ready
- ✅ **Docker Support** - Multi-stage optimized containers
- ✅ **API Documentation** - Swagger/OpenAPI integration
- ✅ **Request Logging** - Complete audit trail of API calls

---

## 🏗️ Architecture

### Hexagonal Architecture Layers

```
weather-api/
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
│   ├── in/rest/              # REST controllers
│   └── out/                  # External integrations
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

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Makefile** - Build automation

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
- Docker & Docker Compose (optional)

### Installation & Run

#### Option 1: Using Docker (Recommended)

```bash
# Clone repository
git clone https://github.com/javiernuma/weater-proxy.git
cd weater-proxy

# Build and run with Docker
docker-compose up --build

# Or use Makefile
make docker-build
make docker-run
```

#### Option 2: Using Maven

```bash
# Build
mvn clean package

# Run
mvn -pl bootstrap spring-boot:run
```

### Access Points

- **API Base:** http://localhost:8080
- **Swagger UI:** http://localhost:8080/swagger-ui.html
- **H2 Console:** http://localhost:8080/h2-console
- **Health Check:** http://localhost:8080/actuator/health

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

**Using Makefile:**
```bash
make api-test
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

## 🐳 Docker Usage

### Using Makefile

```bash
make docker-build    # Build Docker image
make docker-run      # Start containers
make docker-logs     # View logs
make docker-stop     # Stop containers
make docker-clean    # Remove everything
```

### Using Docker Compose

```bash
# Build and start
docker-compose up --build

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Environment Variables

Create `.env` file:

```env
SPRING_PROFILES_ACTIVE=docker
OPENWEATHER_API_KEY=your_api_key_here
OPENWEATHER_ENABLED=true
LOGGING_LEVEL_ROOT=INFO
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

✅ **Single Responsibility** - Each class has one job  
✅ **Open/Closed** - Open for extension (new providers), closed for modification  
✅ **Liskov Substitution** - Providers are interchangeable  
✅ **Interface Segregation** - Focused port interfaces  
✅ **Dependency Inversion** - High-level modules independent of low-level details

---

## 📦 Build Commands

### Using Makefile

```bash
make help           # Show all commands
make build          # Build project
make test           # Run tests
make coverage       # Generate coverage report
make run            # Run locally
make verify         # Full verification
make swagger        # Open Swagger UI
make h2-console     # Open H2 Console
```

### Using Maven

```bash
mvn clean package   # Build
mvn test           # Run tests
mvn verify         # Integration tests
mvn jacoco:report  # Coverage report
```

---

## 🔒 Security Features

- ✅ Input validation with Jakarta Validation
- ✅ SQL injection prevention (JPA)
- ✅ API key management (externalized config)
- ✅ Docker non-root user
- ✅ Error handling without data leakage

---

## 📈 Roadmap

### Planned Features

- [ ] **Comprehensive Testing** - Unit, integration, and contract tests
- [ ] **Caching Layer** - Redis integration for performance
- [ ] **Rate Limiting** - API request throttling
- [ ] **Authentication** - JWT-based security
- [ ] **Circuit Breaker** - Resilience4j integration
- [ ] **Monitoring** - Prometheus metrics
- [ ] **More Providers** - WeatherStack, AccuWeather

---

## 📚 Additional Resources

- [Hexagonal Architecture Guide](https://alistair.cockburn.us/hexagonal-architecture/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Java 17 Features](https://openjdk.org/projects/jdk/17/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

## 👨‍💻 Author

**Javier Vidal Numa Mendoza**

Software Architect specializing in:
- Clean Architecture & Hexagonal Architecture
- Domain-Driven Design
- Event-Driven Systems
- Modern Java Development
- Cloud-Native Applications

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin&logoColor=white)](https://linkedin.com/in/ing-javier-vidal-numa-mendoza)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github&logoColor=white)](https://github.com/javiernuma)
[![Email](https://img.shields.io/badge/Email-Contact-red?logo=gmail&logoColor=white)](mailto:ing.javiernuma@gmail.com)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🌟 Highlights

- ⚡ **Hexagonal Architecture** - Ports & Adapters pattern
- 🎯 **Clean Code** - SOLID principles
- 🚀 **Modern Java** - Java 17+ features
- 📦 **Provider Abstraction** - Extensible design
- 🐳 **Docker Ready** - Production deployment
- 📚 **Well-Documented** - Clear structure & examples

---

**Built with ❤️ demonstrating architectural excellence and modern Java practices**
