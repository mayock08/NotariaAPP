using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NotariaAPI.DTOs;
using NotariaAPI.Services;
using System.Security.Claims;

namespace NotariaAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class PersonController : ControllerBase
    {
        private readonly IPersonService _personService;

        public PersonController(IPersonService personService)
        {
            _personService = personService;
        }

        [HttpGet("profile")]
        public async Task<ActionResult<PersonProfileDto>> GetProfile()
        {
            var personIdClaim = User.FindFirst("PersonId")?.Value;

            if (string.IsNullOrEmpty(personIdClaim) || !int.TryParse(personIdClaim, out int personId))
            {
                return Unauthorized(new { message = "Invalid token" });
            }

            var profile = await _personService.GetProfileAsync(personId);

            if (profile == null)
            {
                return NotFound(new { message = "Profile not found" });
            }

            return Ok(profile);
        }
    }
}
