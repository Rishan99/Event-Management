@ECHO OFF
TYPE name.txt   
cd ..
cd Menu.App
dotnet ef dbcontext scaffold name=DefaultConnection Microsoft.EntityFrameworkCore.SqlServer -o Entities --context AppDbContext --project ../Menu.Data --force --no-build                                               
ECHO DATABASE SCAFFOLDING DONE...
PAUSE