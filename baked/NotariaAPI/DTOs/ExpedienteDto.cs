namespace NotariaAPI.DTOs
{
    public class ExpedienteDto
    {
        public int Id { get; set; }
        public string ExpedienteNumber { get; set; } = string.Empty;
        public DateTime StartDate { get; set; }
        public string CurrentStatus { get; set; } = string.Empty;
        public decimal TotalAmount { get; set; }
        public decimal PaidAmount { get; set; }
        public List<ProcessStageDto> ProcessStages { get; set; } = new List<ProcessStageDto>();
        public List<DocumentDto> Documents { get; set; } = new List<DocumentDto>();
    }

    public class ProcessStageDto
    {
        public int Id { get; set; }
        public string StageName { get; set; } = string.Empty;
        public int StageOrder { get; set; }
        public bool IsCompleted { get; set; }
        public DateTime? CompletedDate { get; set; }
    }

    public class DocumentDto
    {
        public int Id { get; set; }
        public string DocumentName { get; set; } = string.Empty;
        public string DocumentType { get; set; } = string.Empty;
        public bool IsCompleted { get; set; }
        public string? DownloadUrl { get; set; }
        public DateTime? UploadedDate { get; set; }
    }
}
