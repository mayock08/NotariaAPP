using NotariaAPI.DTOs;

namespace NotariaAPI.Services
{
    public interface IAuthService
    {
        Task<LoginResponse?> LoginAsync(LoginRequest request);
        string GenerateJwtToken(int userId, string email, int personId);
    }
}
