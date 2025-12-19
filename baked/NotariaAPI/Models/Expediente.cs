namespace NotariaAPI.Models
{
    public class Expediente
    {
        public int Id { get; set; }
        public string ExpedienteNumber { get; set; } = string.Empty;
        public int PersonId { get; set; }
        public Person? Person { get; set; }
        public DateTime StartDate { get; set; }
        public string CurrentStatus { get; set; } = string.Empty;
        public decimal TotalAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        // Navigation properties
        public ICollection<ProcessStage> ProcessStages { get; set; } = new List<ProcessStage>();
        public ICollection<Document> Documents { get; set; } = new List<Document>();
    }
}
