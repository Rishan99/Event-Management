using Menu.Data.Entities;
using Menu.Data.AuthModels;
using Menu.Data.Infrastructure;
using Menu.Data.Repositories;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using NETCore.MailKit.Extensions;
using NETCore.MailKit.Infrastructure.Internal;

namespace Menu.Data
{
    public static class DataServiceConfiguration
    {

        public static void AddServicesFromData(this IServiceCollection service, IConfiguration configuration)
        {
            var connectionString = configuration.GetConnectionString("DefaultConnection").ToString();

            service.AddDbContext<AuthDbContext>(options =>
                options.UseSqlServer(connectionString)
            );

            service.AddDbContext<AppDbContext>(options =>
                options.UseSqlServer(connectionString)
            );

            service.Configure<IdentityOptions>(options =>
            {
                options.Password.RequireDigit = false;
                options.Password.RequiredLength = 8;
                options.Password.RequireLowercase = true;
                options.Password.RequireNonAlphanumeric = true;
                options.Password.RequireUppercase = true;
                options.SignIn.RequireConfirmedEmail = false;
            });

            service.AddTransient<IConnectionFactory, ConnectionFactory>();
            service.AddTransient<IAuthRepository, AuthRepository>();
            service.AddTransient<IMenuRepository, MenuRepository>();
            service.AddTransient<IGeneralRepository, GeneralRepository>();
            service.AddTransient<IEventRepository, EventRepository>();
            service.AddTransient<ITicketPaymentRepository, TicketPaymentRepository>();
            service.AddSingleton<UrlProtection>();
        }



    }
}