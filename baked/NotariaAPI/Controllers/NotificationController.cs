using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NotariaAPI.DTOs;
using NotariaAPI.Services;

namespace NotariaAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class NotificationController : ControllerBase
    {
        private readonly INotificationService _notificationService;
        private readonly ILogger<NotificationController> _logger;

        public NotificationController(
            INotificationService notificationService,
            ILogger<NotificationController> logger)
        {
            _notificationService = notificationService;
            _logger = logger;
        }

        /// <summary>
        /// Send a test notification to a specific device token
        /// </summary>
        [HttpPost("test")]
        public async Task<ActionResult<SendNotificationResponse>> SendTestNotification([FromBody] TestNotificationRequest request)
        {
            if (string.IsNullOrEmpty(request.DeviceToken))
            {
                return BadRequest(new { message = "Device token is required" });
            }

            _logger.LogInformation("Test notification requested for device: {DeviceToken}", request.DeviceToken);

            var response = await _notificationService.SendTestNotificationAsync(request.DeviceToken);

            if (!response.Success)
            {
                return StatusCode(500, response);
            }

            return Ok(response);
        }

        /// <summary>
        /// Send a custom notification
        /// </summary>
        [HttpPost("send")]
        public async Task<ActionResult<SendNotificationResponse>> SendNotification([FromBody] SendNotificationRequest request)
        {
            if (string.IsNullOrEmpty(request.Title) || string.IsNullOrEmpty(request.Body))
            {
                return BadRequest(new { message = "Title and body are required" });
            }

            _logger.LogInformation("Custom notification requested: {Title}", request.Title);

            var response = await _notificationService.SendNotificationAsync(request);

            if (!response.Success)
            {
                return StatusCode(500, response);
            }

            return Ok(response);
        }

        /// <summary>
        /// Send notification to a specific user
        /// </summary>
        [HttpPost("send-to-user/{userId}")]
        public async Task<ActionResult<SendNotificationResponse>> SendToUser(
            int userId,
            [FromBody] UserNotificationRequest request)
        {
            if (string.IsNullOrEmpty(request.Title) || string.IsNullOrEmpty(request.Body))
            {
                return BadRequest(new { message = "Title and body are required" });
            }

            _logger.LogInformation("Notification to user {UserId} requested: {Title}", userId, request.Title);

            var response = await _notificationService.SendToUserAsync(
                userId,
                request.Title,
                request.Body,
                request.Data
            );

            if (!response.Success)
            {
                return StatusCode(500, response);
            }

            return Ok(response);
        }

        /// <summary>
        /// Get notification logs
        /// </summary>
        [HttpGet("logs")]
        public async Task<ActionResult<List<Models.NotificationLog>>> GetLogs([FromQuery] int? userId = null, [FromQuery] int limit = 50)
        {
            var logs = await _notificationService.GetNotificationLogsAsync(userId, limit);
            return Ok(logs);
        }

        /// <summary>
        /// Get notification logs for the authenticated user
        /// </summary>
        [HttpGet("my-logs")]
        public async Task<ActionResult<List<Models.NotificationLog>>> GetMyLogs([FromQuery] int limit = 50)
        {
            var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return Unauthorized(new { message = "Invalid token" });
            }

            var logs = await _notificationService.GetNotificationLogsAsync(userId, limit);
            return Ok(logs);
        }
    }

    public class TestNotificationRequest
    {
        public string DeviceToken { get; set; } = string.Empty;
    }

    public class UserNotificationRequest
    {
        public string Title { get; set; } = string.Empty;
        public string Body { get; set; } = string.Empty;
        public Dictionary<string, string>? Data { get; set; }
    }
}
