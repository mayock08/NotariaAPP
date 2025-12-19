using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NotariaAPI.DTOs;
using NotariaAPI.Services;

namespace NotariaAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ExpedienteController : ControllerBase
    {
        private readonly IExpedienteService _expedienteService;

        public ExpedienteController(IExpedienteService expedienteService)
        {
            _expedienteService = expedienteService;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ExpedienteDto>> GetExpediente(int id)
        {
            var personIdClaim = User.FindFirst("PersonId")?.Value;

            if (string.IsNullOrEmpty(personIdClaim) || !int.TryParse(personIdClaim, out int personId))
            {
                return Unauthorized(new { message = "Invalid token" });
            }

            var expediente = await _expedienteService.GetExpedienteAsync(id, personId);

            if (expediente == null)
            {
                return NotFound(new { message = "Expediente not found" });
            }

            return Ok(expediente);
        }

        [HttpGet("my-expedientes")]
        public async Task<ActionResult<List<ExpedienteDto>>> GetMyExpedientes()
        {
            var personIdClaim = User.FindFirst("PersonId")?.Value;

            if (string.IsNullOrEmpty(personIdClaim) || !int.TryParse(personIdClaim, out int personId))
            {
                return Unauthorized(new { message = "Invalid token" });
            }

            var expedientes = await _expedienteService.GetExpedientesByPersonAsync(personId);

            return Ok(expedientes);
        }
    }
}
