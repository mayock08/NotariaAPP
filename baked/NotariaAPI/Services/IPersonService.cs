using NotariaAPI.DTOs;

namespace NotariaAPI.Services
{
    public interface IPersonService
    {
        Task<PersonProfileDto?> GetProfileAsync(int personId);
    }
}
