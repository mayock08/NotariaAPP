namespace NotariaAPI.Models
{
    public class Document
    {
        public int Id { get; set; }
        public int ExpedienteId { get; set; }
        public Expediente? Expediente { get; set; }
        public string DocumentName { get; set; } = string.Empty;
        public string DocumentType { get; set; } = string.Empty;
        public bool IsCompleted { get; set; }
        public string? DownloadUrl { get; set; }
        public DateTime? UploadedDate { get; set; }
    }
}
