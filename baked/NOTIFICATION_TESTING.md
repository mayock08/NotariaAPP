# Testing Notification System

## API Endpoints

The notification system has been added to the backend with the following endpoints:

### 1. Send Test Notification

**POST** `/api/notification/test`

Sends a test notification to verify the system is working.

**Headers:**
```
Authorization: Bearer {your_jwt_token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "deviceToken": "test_device_token_123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Notification sent successfully (Mock)",
  "messageId": "550e8400-e29b-41d4-a716-446655440000"
}
```

### 2. Send Custom Notification

**POST** `/api/notification/send`

Send a custom notification with title, body, and optional data.

**Request Body:**
```json
{
  "title": "Actualización de Expediente",
  "body": "Su expediente EXP-2025-001 ha sido actualizado",
  "deviceToken": "user_device_token",
  "userId": 1,
  "data": {
    "expedienteId": "1",
    "type": "update"
  }
}
```

### 3. Send to User

**POST** `/api/notification/send-to-user/{userId}`

Send notification to a specific user by their ID.

**Request Body:**
```json
{
  "title": "Notificación Importante",
  "body": "Tiene un nuevo documento disponible",
  "data": {
    "documentId": "5"
  }
}
```

### 4. Get Notification Logs

**GET** `/api/notification/logs?userId={userId}&limit={limit}`

Retrieve notification logs. Optional filters by userId and limit.

**Response:**
```json
[
  {
    "id": 1,
    "userId": 1,
    "title": "Notificación de Prueba",
    "body": "Esta es una notificación de prueba...",
    "deviceToken": "test_device_token_123",
    "success": true,
    "errorMessage": null,
    "messageId": "550e8400-e29b-41d4-a716-446655440000",
    "sentAt": "2025-12-09T22:35:00Z",
    "additionalData": "{\"type\":\"test\",\"timestamp\":\"2025-12-09T22:35:00Z\"}"
  }
]
```

### 5. Get My Logs

**GET** `/api/notification/my-logs?limit={limit}`

Get notification logs for the authenticated user.

## Testing with Swagger

1. **Start the API:**
   ```bash
   cd baked/NotariaAPI
   dotnet run
   ```

2. **Open Swagger UI:**
   - Navigate to `https://localhost:5001/swagger`

3. **Login first:**
   - POST `/api/auth/login`
   - Email: `juan.perez@example.com`
   - Password: `password123`
   - Copy the token

4. **Authorize:**
   - Click "Authorize" button
   - Enter: `Bearer {your_token}`

5. **Test Notification:**
   - POST `/api/notification/test`
   - Body:
     ```json
     {
       "deviceToken": "my_test_device_token"
     }
     ```

6. **View Logs:**
   - GET `/api/notification/logs`
   - You should see your test notification logged

## Testing with cURL

```bash
# 1. Login
curl -X POST https://localhost:5001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan.perez@example.com",
    "password": "password123"
  }'

# 2. Send test notification (replace TOKEN with your JWT)
curl -X POST https://localhost:5001/api/notification/test \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "deviceToken": "test_device_123"
  }'

# 3. View logs
curl -X GET https://localhost:5001/api/notification/logs \
  -H "Authorization: Bearer TOKEN"
```

## Logging Features

All notifications are logged to the database with:
- ✅ Title and body
- ✅ Device token
- ✅ Success/failure status
- ✅ Error messages (if failed)
- ✅ Message ID
- ✅ Timestamp
- ✅ Additional data (JSON)

## Mock Implementation

Currently, the notification service uses a **mock implementation**. It:
- Simulates sending notifications
- Logs all attempts to the database
- Returns success responses
- Does NOT actually send to Firebase

### To Integrate Real Firebase:

1. Install Firebase Admin SDK:
   ```bash
   dotnet add package FirebaseAdmin
   ```

2. Update `NotificationService.cs`:
   ```csharp
   using FirebaseAdmin;
   using FirebaseAdmin.Messaging;
   
   // In SendNotificationAsync method:
   var message = new Message()
   {
       Token = request.DeviceToken,
       Notification = new Notification
       {
           Title = request.Title,
           Body = request.Body
       },
       Data = request.Data
   };
   
   var response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
   ```

3. Add Firebase credentials to `appsettings.json`

## Next Steps

- [ ] Integrate real Firebase Cloud Messaging
- [ ] Store user device tokens in database
- [ ] Add push notification triggers (e.g., when expediente status changes)
- [ ] Add notification preferences per user
- [ ] Implement notification scheduling
