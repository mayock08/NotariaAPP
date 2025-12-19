using NotariaAPI.DTOs;

namespace NotariaAPI.Services
{
    public interface IExpedienteService
    {
        Task<ExpedienteDto?> GetExpedienteAsync(int expedienteId, int personId);
        Task<List<ExpedienteDto>> GetExpedientesByPersonAsync(int personId);
    }
}
