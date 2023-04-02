using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Menu.Data.Entities;

using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace Menu.Data.Infrastructure
{
    public interface IConnectionFactory
    {
        public SqlConnection GetSqlConnection(AppDbContext dbContext);
    }

    class ConnectionFactory : IConnectionFactory
    {
        public SqlConnection GetSqlConnection(AppDbContext dbContext)
        {
            var connectionString = dbContext.Database.GetDbConnection().ConnectionString;
            return new SqlConnection(connectionString);
        }
    }
    
}
