# Notaria API Backend

Backend API for the Notarial Mobile Application built with .NET Core 9.0.

## 📋 Features

- **JWT Authentication** - Secure token-based authentication
- **RESTful API** - Three main endpoints for mobile app
- **Entity Framework Core** - In-memory database for development
- **Swagger UI** - API documentation and testing
- **CORS Enabled** - Ready for mobile app integration

## 🚀 Getting Started

### Prerequisites

- .NET 9.0 SDK or later
- Visual Studio 2022 / VS Code / Rider (optional)

### Installation

1. Navigate to the project directory:
```bash
cd baked/NotariaAPI
```

2. Restore NuGet packages:
```bash
dotnet restore
```

3. Build the project:
```bash
dotnet build
```

4. Run the API:
```bash
dotnet run
```

The API will start at `https://localhost:5001` (or the port shown in the console).

## 📡 API Endpoints

### Authentication

#### POST /api/auth/login
Login with email and password to receive JWT token.

**Request:**
```json
{
  "email": "juan.perez@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "email": "juan.perez@example.com",
  "fullName": "Juan Pérez García",
  "expiresAt": "2025-12-10T15:41:52Z"
}
```

### Person Profile

#### GET /api/person/profile
Get authenticated user's profile information.

**Headers:**
```
Authorization: Bearer {your_jwt_token}
```

**Response:**
```json
{
  "id": 1,
  "fullName": "Juan Pérez García",
  "email": "juan.perez@example.com",
  "phone": "+52 55 1234 5678",
  "address": {
    "street": "Av. Reforma 123",
    "neighborhood": "Juárez",
    "city": "Ciudad de México",
    "state": "CDMX",
    "postalCode": "06600"
  },
  "photoUrl": null
}
```

### Expediente (Case File)

#### GET /api/expediente/{id}
Get specific case file details with process stages and documents.

**Headers:**
```
Authorization: Bearer {your_jwt_token}
```

**Response:**
```json
{
  "id": 1,
  "expedienteNumber": "EXP-2025-001",
  "startDate": "2025-01-15T00:00:00Z",
  "currentStatus": "Carga de archivos iniciales",
  "totalAmount": 150000.00,
  "paidAmount": 60000.00,
  "processStages": [...],
  "documents": [...]
}
```

#### GET /api/expediente/my-expedientes
Get all case files for the authenticated user.

## 🧪 Testing

### Using Swagger UI

1. Run the application
2. Navigate to `https://localhost:5001/swagger`
3. Test the endpoints directly from the browser

### Test Credentials

The database is seeded with a test user:
- **Email:** `juan.perez@example.com`
- **Password:** `password123`

### Testing Flow

1. **Login** - POST to `/api/auth/login` with test credentials
2. **Copy Token** - From the login response
3. **Authorize** - Click "Authorize" in Swagger and paste the token as `Bearer {token}`
4. **Test Endpoints** - Try `/api/person/profile` and `/api/expediente/1`

## 🗄️ Database

The application uses an **in-memory database** for development. Data is seeded automatically on startup with:

- 1 test user (Juan Pérez)
- 1 expediente (EXP-2025-001)
- 6 process stages
- 4 documents

To use SQL Server or PostgreSQL in production, update `Program.cs`:

```csharp
// Replace UseInMemoryDatabase with:
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
```

## 🔐 Security

- Passwords are hashed using BCrypt
- JWT tokens expire after 24 hours
- CORS is configured to allow all origins (restrict in production)
- HTTPS is enforced

## 📁 Project Structure

```
NotariaAPI/
├── Controllers/          # API endpoints
│   ├── AuthController.cs
│   ├── PersonController.cs
│   └── ExpedienteController.cs
├── Models/              # Database entities
├── DTOs/                # Data transfer objects
├── Services/            # Business logic
├── Data/                # DbContext and seeding
├── Program.cs           # App configuration
└── appsettings.json     # Configuration
```

## 🛠️ Configuration

Edit `appsettings.json` to configure:

- **JwtSettings**: Secret key, issuer, audience
- **Logging**: Log levels
- **ConnectionStrings**: Database connection (when not using in-memory)

## 📱 Mobile App Integration

The Flutter mobile app should:

1. Call `/api/auth/login` to get JWT token
2. Store token securely (flutter_secure_storage)
3. Include token in Authorization header for all requests
4. Handle token expiration (401 responses)

Example Flutter HTTP request:
```dart
final response = await http.get(
  Uri.parse('https://your-api-url/api/person/profile'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
);
```

## 🐛 Troubleshooting

### NuGet Package Restore Issues

If you encounter authentication errors during package restore:

```bash
# Clear NuGet cache
dotnet nuget locals all --clear

# Restore with explicit source
dotnet restore --source https://api.nuget.org/v3/index.json
```

### Port Already in Use

If port 5001 is in use, edit `Properties/launchSettings.json` to change the port.

## 📝 License

This project is for educational/demonstration purposes.
