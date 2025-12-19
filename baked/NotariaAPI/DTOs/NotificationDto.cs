namespace NotariaAPI.DTOs
{
    public class SendNotificationRequest
    {
        public string Title { get; set; } = string.Empty;
        public string Body { get; set; } = string.Empty;
        public string? DeviceToken { get; set; }
        public int? UserId { get; set; }
        public Dictionary<string, string>? Data { get; set; }
    }

    public class SendNotificationResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? MessageId { get; set; }
    }
}
