using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using NotariaAPI.Data;
using NotariaAPI.DTOs;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace NotariaAPI.Services
{
    public class AuthService : IAuthService
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        public AuthService(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        public async Task<LoginResponse?> LoginAsync(LoginRequest request)
        {
            var user = await _context.Users
                .Include(u => u.Person)
                .FirstOrDefaultAsync(u => u.Email == request.Email && u.IsActive);

            if (user == null)
                return null;

            // Verify password
            if (!BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
                return null;

            // Generate JWT token
            var token = GenerateJwtToken(user.Id, user.Email, user.PersonId);
            var expiresAt = DateTime.UtcNow.AddHours(24);

            return new LoginResponse
            {
                Token = token,
                Email = user.Email,
                FullName = user.Person?.FullName ?? "",
                ExpiresAt = expiresAt
            };
        }

        public string GenerateJwtToken(int userId, string email, int personId)
        {
            var jwtSettings = _configuration.GetSection("JwtSettings");
            var secretKey = jwtSettings["SecretKey"] ?? throw new InvalidOperationException("JWT SecretKey not configured");
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, userId.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, email),
                new Claim("PersonId", personId.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            var token = new JwtSecurityToken(
                issuer: jwtSettings["Issuer"],
                audience: jwtSettings["Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(24),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
