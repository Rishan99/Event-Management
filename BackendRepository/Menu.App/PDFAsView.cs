using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace Laligurans.App
{
    public class PDFAsView : IActionResult
    {
        private readonly string _url;

        public PDFAsView(string url)
        {
            _url = url;
        }

        public async Task ExecuteResultAsync(ActionContext context)
        {
            string fileName = DateTime.UtcNow.AddMinutes(345).ToString("yyyyMMddHHmmssfff");

            var exited = false;

            using (var process = new Process())
            {
                process.StartInfo.FileName = @"wkhtmltopdf.exe"; // relative path. absolute path works too.
                process.StartInfo.Arguments = $"-O Portrait --dpi 600 -L 5mm -R 5mm -T 5mm -B 5mm --page-size A4 {_url} pdfs/{fileName}.pdf";
                //process.StartInfo.FileName = @"cmd.exe";
                //process.StartInfo.Arguments = @"/c dir";      // print the current working directory information
                process.StartInfo.CreateNoWindow = true;
                process.StartInfo.UseShellExecute = false;
                process.StartInfo.RedirectStandardOutput = true;
                process.StartInfo.RedirectStandardError = true;

                process.OutputDataReceived += (sender, data) => Console.WriteLine(data.Data);
                process.ErrorDataReceived += (sender, data) => Console.WriteLine(data.Data);
                Console.WriteLine("starting");
                process.Start();
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();
                exited = process.WaitForExit(1000 * 15);     // (optional) wait up to 10 seconds
                Console.WriteLine($"exit {exited}");
                string filePath = $"pdfs/{fileName}.pdf";

                if (exited)
                {
                    using (var fileStream = new FileStream(filePath, FileMode.Open))
                    {
                        await fileStream.CopyToAsync(context.HttpContext.Response.Body);
                        var fileStreamResult = new FileStreamResult(fileStream, "application/pdf");
                        await fileStreamResult.ExecuteResultAsync(context);
                    }
                }
            }

            
        }
    }
}
