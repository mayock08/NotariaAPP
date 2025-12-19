namespace NotariaAPI.Models
{
    public class NotificationLog
    {
        public int Id { get; set; }
        public int? UserId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Body { get; set; } = string.Empty;
        public string? DeviceToken { get; set; }
        public bool Success { get; set; }
        public string? ErrorMessage { get; set; }
        public string? MessageId { get; set; }
        public DateTime SentAt { get; set; } = DateTime.UtcNow;
        public string? AdditionalData { get; set; }
    }
}
