namespace NotariaAPI.Models
{
    public class ProcessStage
    {
        public int Id { get; set; }
        public int ExpedienteId { get; set; }
        public Expediente? Expediente { get; set; }
        public string StageName { get; set; } = string.Empty;
        public int StageOrder { get; set; }
        public bool IsCompleted { get; set; }
        public DateTime? CompletedDate { get; set; }
    }
}
