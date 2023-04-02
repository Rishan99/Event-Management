using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.AspNetCore.Http;
using System.Net;
using System.Reflection.Metadata.Ecma335;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Menu.Data.AuthModels;
using Microsoft.AspNetCore.Identity;
using System.Security.Cryptography;
using System.Xml.Serialization;
using Microsoft.Extensions.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.Net.Http;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Menu.Data.Repositories;
using Menu.Data.Utilities;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using System.Data;
namespace Menu.Data.Utilities
{
    public class GeneralUtility
    {

        public static string GetUsernameFromClaim(IHttpContextAccessor httpContextAccessor)
        {
            var user = httpContextAccessor.HttpContext.User;

            if (user == null)
                throw new Exception("No data found in claim.");

            if (user.Claims.All(x => x.Type != "username"))
                throw new Exception("No username in claim.");

            return user.Claims.FirstOrDefault(x => x.Type == "username")?.Value;
        }

        public static DateTime GetCurrentDateTime()
        {
            return DateTime.UtcNow.AddMinutes(345);
        }

        public static string GetRoleFromClaim(IHttpContextAccessor httpContextAccessor)
        {
            var user = httpContextAccessor.HttpContext.User;

            if (user == null)
                throw new Exception("No data found in claim.");

            if (user.Claims.All(x => x.Type != ClaimTypes.Role))
                throw new Exception("No role in claim.");

            return user.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Role)?.Value;
        }

        public static bool CheckIfModelExist<T>(T obj)
        {
            if (obj is null)
            {
                throw new Exception("Invalid");
            }

            return true;
        }

        public static async Task<string> GetFileName(IFormFile file, string imageUploadPath)
        {

            string savedFileName = FileNameOfNewFile(file.FileName);
            string filePath = Path.Combine(imageUploadPath, savedFileName);
            await using var stream = System.IO.File.Create(filePath);
            await file.CopyToAsync(stream);
            return savedFileName.Trim();

        }
        public static string FileNameOfNewFile(String sourceFileName)
        {
            string ext = Path.GetExtension(sourceFileName)?.ToLowerInvariant();
            string fileName = Path.GetFileNameWithoutExtension(sourceFileName);
            string savedFileName = DateTime.UtcNow.AddMinutes(345).ToString("yyyyMMddHHmmssffff") + ext;
            return savedFileName.Trim();

        }

        public static void DeleteImageFromServer(string path, string fileName = null, IList<string> fileNames = null)
        {
            {
                try
                {
                    if (fileNames.Any())
                    {
                        foreach (var image in fileNames)
                        {
                            if (System.IO.File.Exists($"{path}\\{image}"))
                            {
                                System.IO.File.Delete($"{path}\\{image}");
                            }
                        }
                    }
                    else if (string.IsNullOrEmpty(fileName))
                    {
                        if (System.IO.File.Exists($"{path}\\{fileName}"))
                        {
                            System.IO.File.Delete($"{path}\\{fileName}");
                        }
                    }
                }
                catch (Exception)
                {
                    //  ?   throw ex;
                }
            }
        }

        public static async Task DownloadImageAsync(string directoryPath, string fileName, Uri uri, string extension = "")
        {
            using var httpClient = new HttpClient();

            // Get the file extension
            var uriWithoutQuery = uri.GetLeftPart(UriPartial.Path);
            var fileExtension = string.IsNullOrEmpty(extension) ? Path.GetExtension(uriWithoutQuery) : extension;

            // Create file path and ensure directory exists
            var path = Path.Combine(directoryPath, $"{fileName}{fileExtension}");
            Directory.CreateDirectory(directoryPath);

            // Download the image and write to the file
            var imageBytes = await httpClient.GetByteArrayAsync(uri);
            await File.WriteAllBytesAsync(path, imageBytes);
        }
        public static void DeleteFileFromServer(string fileUploadPath, string fileName)
        {
            if (File.Exists($"{fileUploadPath}\\{fileName}"))
            {
                File.Delete($"{fileUploadPath}\\{fileName}");
            }
        }


        public static string GetCurrentTime()
        {
            return DateTime.Now.AddMinutes(345).ToString("HH:mm:ss tt");
        }
    }



}
