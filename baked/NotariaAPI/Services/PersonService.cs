using Microsoft.EntityFrameworkCore;
using NotariaAPI.Data;
using NotariaAPI.DTOs;

namespace NotariaAPI.Services
{
    public class PersonService : IPersonService
    {
        private readonly ApplicationDbContext _context;

        public PersonService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<PersonProfileDto?> GetProfileAsync(int personId)
        {
            var person = await _context.Persons.FindAsync(personId);

            if (person == null)
                return null;

            return new PersonProfileDto
            {
                Id = person.Id,
                FullName = person.FullName,
                Email = person.Email,
                Phone = person.Phone,
                Address = new AddressDto
                {
                    Street = person.Street,
                    Neighborhood = person.Neighborhood,
                    City = person.City,
                    State = person.State,
                    PostalCode = person.PostalCode
                },
                PhotoUrl = person.PhotoUrl
            };
        }
    }
}
