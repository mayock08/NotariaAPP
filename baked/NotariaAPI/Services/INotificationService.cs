using NotariaAPI.DTOs;

namespace NotariaAPI.Services
{
    public interface INotificationService
    {
        Task<SendNotificationResponse> SendNotificationAsync(SendNotificationRequest request);
        Task<SendNotificationResponse> SendToUserAsync(int userId, string title, string body, Dictionary<string, string>? data = null);
        Task<SendNotificationResponse> SendTestNotificationAsync(string deviceToken);
        Task<List<Models.NotificationLog>> GetNotificationLogsAsync(int? userId = null, int limit = 50);
    }
}
