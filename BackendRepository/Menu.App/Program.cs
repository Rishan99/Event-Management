using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;


namespace Menu.App
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();

        }

        public static IHostBuilder CreateHostBuilder(string[] args)
        {


            var host = Host.CreateDefaultBuilder(args)
                   .ConfigureWebHostDefaults(webBuilder =>
                   {

                       webBuilder.UseStartup<Startup>();
                   });

            host.UseSerilog((context, services, configuration) => configuration
                 .MinimumLevel.Debug()
         .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
         .MinimumLevel.Override("Microsoft.AspNetCore", LogEventLevel.Information)
         .MinimumLevel.Override("Microsoft.Hosting.Lifetime", LogEventLevel.Information)
         .MinimumLevel.Override("Microsoft.AspNetCore.HttpLogging.HttpLoggingMiddleware", LogEventLevel.Information)
         .ReadFrom.Services(services)
         .Filter.ByExcluding(c => c.Properties.Any(p => p.Value.ToString().Contains("swagger")))
         .Enrich.FromLogContext().WriteTo.File(
       System.IO.Path.Combine(Directory.GetCurrentDirectory(), "LogFiles", "logs-.txt"),
       rollingInterval: RollingInterval.Day,
       fileSizeLimitBytes: 10 * 1024 * 1024,
       rollOnFileSizeLimit: true,
       shared: true,
       flushToDiskInterval: TimeSpan.FromSeconds(1)));

            return host;
        }
    }
}
