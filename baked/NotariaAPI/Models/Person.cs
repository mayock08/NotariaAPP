namespace NotariaAPI.Models
{
    public class Person
    {
        public int Id { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string Street { get; set; } = string.Empty;
        public string Neighborhood { get; set; } = string.Empty;
        public string City { get; set; } = string.Empty;
        public string State { get; set; } = string.Empty;
        public string PostalCode { get; set; } = string.Empty;
        public string? PhotoUrl { get; set; }
        
        // Navigation properties
        public ICollection<Expediente> Expedientes { get; set; } = new List<Expediente>();
    }
}
