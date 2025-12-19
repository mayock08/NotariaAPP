using Microsoft.EntityFrameworkCore;
using NotariaAPI.Data;
using NotariaAPI.DTOs;

namespace NotariaAPI.Services
{
    public class ExpedienteService : IExpedienteService
    {
        private readonly ApplicationDbContext _context;

        public ExpedienteService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<ExpedienteDto?> GetExpedienteAsync(int expedienteId, int personId)
        {
            var expediente = await _context.Expedientes
                .Include(e => e.ProcessStages)
                .Include(e => e.Documents)
                .FirstOrDefaultAsync(e => e.Id == expedienteId && e.PersonId == personId);

            if (expediente == null)
                return null;

            return MapToDto(expediente);
        }

        public async Task<List<ExpedienteDto>> GetExpedientesByPersonAsync(int personId)
        {
            var expedientes = await _context.Expedientes
                .Include(e => e.ProcessStages)
                .Include(e => e.Documents)
                .Where(e => e.PersonId == personId)
                .ToListAsync();

            return expedientes.Select(MapToDto).ToList();
        }

        private ExpedienteDto MapToDto(Models.Expediente expediente)
        {
            return new ExpedienteDto
            {
                Id = expediente.Id,
                ExpedienteNumber = expediente.ExpedienteNumber,
                StartDate = expediente.StartDate,
                CurrentStatus = expediente.CurrentStatus,
                TotalAmount = expediente.TotalAmount,
                PaidAmount = expediente.PaidAmount,
                ProcessStages = expediente.ProcessStages
                    .OrderBy(ps => ps.StageOrder)
                    .Select(ps => new ProcessStageDto
                    {
                        Id = ps.Id,
                        StageName = ps.StageName,
                        StageOrder = ps.StageOrder,
                        IsCompleted = ps.IsCompleted,
                        CompletedDate = ps.CompletedDate
                    }).ToList(),
                Documents = expediente.Documents
                    .Select(d => new DocumentDto
                    {
                        Id = d.Id,
                        DocumentName = d.DocumentName,
                        DocumentType = d.DocumentType,
                        IsCompleted = d.IsCompleted,
                        DownloadUrl = d.DownloadUrl,
                        UploadedDate = d.UploadedDate
                    }).ToList()
            };
        }
    }
}
