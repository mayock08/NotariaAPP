using Microsoft.EntityFrameworkCore;
using NotariaAPI.Models;

namespace NotariaAPI.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Person> Persons { get; set; }
        public DbSet<Expediente> Expedientes { get; set; }
        public DbSet<ProcessStage> ProcessStages { get; set; }
        public DbSet<Document> Documents { get; set; }
        public DbSet<NotificationLog> NotificationLogs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure User
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasOne(u => u.Person)
                .WithMany()
                .HasForeignKey(u => u.PersonId)
                .OnDelete(DeleteBehavior.Restrict);

            // Configure Person
            modelBuilder.Entity<Person>()
                .HasIndex(p => p.Email)
                .IsUnique();

            // Configure Expediente
            modelBuilder.Entity<Expediente>()
                .HasIndex(e => e.ExpedienteNumber)
                .IsUnique();

            modelBuilder.Entity<Expediente>()
                .Property(e => e.TotalAmount)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Expediente>()
                .Property(e => e.PaidAmount)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Expediente>()
                .HasOne(e => e.Person)
                .WithMany(p => p.Expedientes)
                .HasForeignKey(e => e.PersonId)
                .OnDelete(DeleteBehavior.Restrict);

            // Configure ProcessStage
            modelBuilder.Entity<ProcessStage>()
                .HasOne(ps => ps.Expediente)
                .WithMany(e => e.ProcessStages)
                .HasForeignKey(ps => ps.ExpedienteId)
                .OnDelete(DeleteBehavior.Cascade);

            // Configure Document
            modelBuilder.Entity<Document>()
                .HasOne(d => d.Expediente)
                .WithMany(e => e.Documents)
                .HasForeignKey(d => d.ExpedienteId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
