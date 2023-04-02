using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Menu.Data.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace Menu.Data.Repositories
{
    public interface IGeneralRepository
    {

        Task<IEnumerable<TicketStatus>> GetAllTicketStatus();
        Task<IEnumerable<TicketType>> GetAllTicketType();
        Task<DashboardInformationDto> GetDashboardData();
    }
    public class GeneralRepository : IGeneralRepository
    {
        private readonly AppDbContext _appDbContext;
        private readonly IHttpContextAccessor _contextAccessor;
        private readonly IConnectionFactory _connectionFactory;

        public GeneralRepository(AppDbContext appDbContext, IHttpContextAccessor contextAccessor, IConnectionFactory connectionFactory)
        {
            _appDbContext = appDbContext;
            _contextAccessor = contextAccessor;
            _connectionFactory = connectionFactory;
        }

        public async Task<IEnumerable<TicketStatus>> GetAllTicketStatus()
        {
            return await _appDbContext.TicketStatuses.OrderBy(x => x.Id).AsNoTracking().ToListAsync();
        }

        public async Task<IEnumerable<TicketType>> GetAllTicketType()
        {
            return await _appDbContext.TicketTypes.OrderBy(x => x.Id).AsNoTracking().ToListAsync();
        }

        public async Task<DashboardInformationDto> GetDashboardData()
        {

            var connection = _connectionFactory.GetSqlConnection(_appDbContext);
            string query = @"DECLARE @noOfUser int, @noOfEvents  int, @noOfTicketsSold int;  
                           SET @noOfUser = (SELECT COUNT(u.Id) FROM [AspNetUsers] u WHERE u.IsSuperAdmin = 0);
                           SET @noOfEvents = (SELECT COUNT(e.Id) FROM EVENT e); 
                           SET @noOfTicketsSold = (SELECT COUNT(tp.Id) FROM TicketPayment tp WHERE tp.TicketStatusId = 2);
                           SELECT @noOfUser noOfUser,@noOfTicketsSold noOfTicketsSold,@noOfEvents noOfEvents";
            return await connection.QueryFirstAsync<DashboardInformationDto>(query, commandType: CommandType.Text);

        }
    }
}
