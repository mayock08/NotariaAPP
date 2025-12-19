namespace NotariaAPI.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Email { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public int PersonId { get; set; }
        public Person? Person { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsActive { get; set; } = true;
    }
}
