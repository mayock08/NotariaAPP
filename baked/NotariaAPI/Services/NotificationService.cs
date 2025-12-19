using Microsoft.EntityFrameworkCore;
using NotariaAPI.Data;
using NotariaAPI.DTOs;
using NotariaAPI.Models;
using System.Text.Json;

namespace NotariaAPI.Services
{
    public class NotificationService : INotificationService
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<NotificationService> _logger;
        private readonly IConfiguration _configuration;

        public NotificationService(
            ApplicationDbContext context,
            ILogger<NotificationService> logger,
            IConfiguration configuration)
        {
            _context = context;
            _logger = logger;
            _configuration = configuration;
        }

        public async Task<SendNotificationResponse> SendNotificationAsync(SendNotificationRequest request)
        {
            _logger.LogInformation("Sending notification: {Title} to device: {DeviceToken}", 
                request.Title, request.DeviceToken ?? "Unknown");

            try
            {
                // TODO: Implement actual Firebase Cloud Messaging integration
                // For now, this is a mock implementation that logs the notification
                
                var notificationLog = new NotificationLog
                {
                    UserId = request.UserId,
                    Title = request.Title,
                    Body = request.Body,
                    DeviceToken = request.DeviceToken,
                    Success = true,
                    MessageId = Guid.NewGuid().ToString(),
                    SentAt = DateTime.UtcNow,
                    AdditionalData = request.Data != null ? JsonSerializer.Serialize(request.Data) : null
                };

                // Simulate sending notification
                await Task.Delay(100); // Simulate network delay

                // Log to database
                _context.NotificationLogs.Add(notificationLog);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Notification sent successfully. MessageId: {MessageId}", notificationLog.MessageId);

                return new SendNotificationResponse
                {
                    Success = true,
                    Message = "Notification sent successfully (Mock)",
                    MessageId = notificationLog.MessageId
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending notification: {Title}", request.Title);

                // Log failed attempt
                var failedLog = new NotificationLog
                {
                    UserId = request.UserId,
                    Title = request.Title,
                    Body = request.Body,
                    DeviceToken = request.DeviceToken,
                    Success = false,
                    ErrorMessage = ex.Message,
                    SentAt = DateTime.UtcNow,
                    AdditionalData = request.Data != null ? JsonSerializer.Serialize(request.Data) : null
                };

                _context.NotificationLogs.Add(failedLog);
                await _context.SaveChangesAsync();

                return new SendNotificationResponse
                {
                    Success = false,
                    Message = $"Failed to send notification: {ex.Message}"
                };
            }
        }

        public async Task<SendNotificationResponse> SendToUserAsync(int userId, string title, string body, Dictionary<string, string>? data = null)
        {
            _logger.LogInformation("Sending notification to user {UserId}: {Title}", userId, title);

            // In a real implementation, you would:
            // 1. Look up the user's device token(s) from the database
            // 2. Send to all registered devices
            
            // For now, we'll just log it
            var request = new SendNotificationRequest
            {
                UserId = userId,
                Title = title,
                Body = body,
                Data = data,
                DeviceToken = "user_device_token_placeholder"
            };

            return await SendNotificationAsync(request);
        }

        public async Task<SendNotificationResponse> SendTestNotificationAsync(string deviceToken)
        {
            _logger.LogInformation("Sending test notification to device: {DeviceToken}", deviceToken);

            var request = new SendNotificationRequest
            {
                Title = "Notificación de Prueba",
                Body = "Esta es una notificación de prueba desde Notaría Pública 9",
                DeviceToken = deviceToken,
                Data = new Dictionary<string, string>
                {
                    { "type", "test" },
                    { "timestamp", DateTime.UtcNow.ToString("o") }
                }
            };

            return await SendNotificationAsync(request);
        }

        public async Task<List<NotificationLog>> GetNotificationLogsAsync(int? userId = null, int limit = 50)
        {
            var query = _context.NotificationLogs.AsQueryable();

            if (userId.HasValue)
            {
                query = query.Where(n => n.UserId == userId.Value);
            }

            return await query
                .OrderByDescending(n => n.SentAt)
                .Take(limit)
                .ToListAsync();
        }
    }
}
