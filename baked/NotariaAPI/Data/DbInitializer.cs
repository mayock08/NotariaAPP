using NotariaAPI.Models;
using BCrypt.Net;

namespace NotariaAPI.Data
{
    public class DbInitializer
    {
        public static void Initialize(ApplicationDbContext context)
        {
            context.Database.EnsureCreated();

            // Check if already seeded
            if (context.Users.Any())
            {
                return;
            }

            // Seed Persons
            var person1 = new Person
            {
                FullName = "Juan Pérez García",
                Email = "juan.perez@example.com",
                Phone = "+52 55 1234 5678",
                Street = "Av. Reforma 123",
                Neighborhood = "Juárez",
                City = "Ciudad de México",
                State = "CDMX",
                PostalCode = "06600"
            };

            context.Persons.Add(person1);
            context.SaveChanges();

            // Seed Users
            var user1 = new User
            {
                Email = "juan.perez@example.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("password123"),
                PersonId = person1.Id,
                CreatedAt = DateTime.UtcNow,
                IsActive = true
            };

            context.Users.Add(user1);
            context.SaveChanges();

            // Seed Expediente
            var expediente1 = new Expediente
            {
                ExpedienteNumber = "EXP-2025-001",
                PersonId = person1.Id,
                StartDate = new DateTime(2025, 1, 15),
                CurrentStatus = "Carga de archivos iniciales",
                TotalAmount = 150000.00m,
                PaidAmount = 60000.00m,
                CreatedAt = DateTime.UtcNow
            };

            context.Expedientes.Add(expediente1);
            context.SaveChanges();

            // Seed Process Stages
            var stages = new List<ProcessStage>
            {
                new ProcessStage
                {
                    ExpedienteId = expediente1.Id,
                    StageName = "Inicio",
                    StageOrder = 1,
                    IsCompleted = true,
                    CompletedDate = new DateTime(2025, 1, 15, 10, 30, 0)
                },
                new ProcessStage
                {
                    ExpedienteId = expediente1.Id,
                    StageName = "Carga de archivos iniciales",
                    StageOrder = 2,
                    IsCompleted = true,
                    CompletedDate = new DateTime(2025, 1, 20, 14, 15, 0)
                },
                new ProcessStage
                {
                    ExpedienteId = expediente1.Id,
                    StageName = "Trámites municipales",
                    StageOrder = 3,
                    IsCompleted = false,
                    CompletedDate = null
                },
                new ProcessStage
                {
                    ExpedienteId = expediente1.Id,
                    StageName = "Pago de derechos",
                    StageOrder = 4,
                    IsCompleted = false,
                    CompletedDate = null
                },
                new ProcessStage
                {
                    ExpedienteId = expediente1.Id,
                    StageName = "Inscripción al Registro Público",
                    StageOrder = 5,
                    IsCompleted = false,
                    CompletedDate = null
                },
                new ProcessStage
                {
                    ExpedienteId = expediente1.Id,
                    StageName = "Notificación a INFONAVIT/FOVISSSTE",
                    StageOrder = 6,
                    IsCompleted = false,
                    CompletedDate = null
                }
            };

            context.ProcessStages.AddRange(stages);
            context.SaveChanges();

            // Seed Documents
            var documents = new List<Document>
            {
                new Document
                {
                    ExpedienteId = expediente1.Id,
                    DocumentName = "Entrega de IFE",
                    DocumentType = "identification",
                    IsCompleted = true,
                    DownloadUrl = "https://example.com/docs/ife.pdf",
                    UploadedDate = new DateTime(2025, 1, 16, 9, 0, 0)
                },
                new Document
                {
                    ExpedienteId = expediente1.Id,
                    DocumentName = "Entrega Comprobante de domicilio",
                    DocumentType = "proof_of_address",
                    IsCompleted = true,
                    DownloadUrl = "https://example.com/docs/comprobante.pdf",
                    UploadedDate = new DateTime(2025, 1, 16, 9, 5, 0)
                },
                new Document
                {
                    ExpedienteId = expediente1.Id,
                    DocumentName = "Entrega pago de predial",
                    DocumentType = "payment_proof",
                    IsCompleted = false,
                    DownloadUrl = null,
                    UploadedDate = null
                },
                new Document
                {
                    ExpedienteId = expediente1.Id,
                    DocumentName = "Recibo de luz",
                    DocumentType = "utility_bill",
                    IsCompleted = false,
                    DownloadUrl = null,
                    UploadedDate = null
                }
            };

            context.Documents.AddRange(documents);
            context.SaveChanges();
        }
    }
}
