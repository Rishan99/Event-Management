using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Dapper;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Menu.Data.Infrastructure;
using Menu.Data.Utilities;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace Menu.Data.Repositories
{
    public interface ITicketPaymentRepository
    {

        Task<IEnumerable<TicketPayment>> GetAllTicketPayment();
        Task<IEnumerable<TicketPayment>> GetTicketPaymentsByEventId(int eventId);
        Task<bool> HasUserAlreadyBoughtTicket(int eventId, String aspNetUserId);
        Task DeleteTicketById(int id);
        Task UpdateTicketStatus(int id, int statusId);
        Task CreateTicket(int eventId, String aspNetUserId);
        Task<bool> ExistsTicketForEventByEventId(int eventId);

    }
    public class TicketPaymentRepository : ITicketPaymentRepository
    {
        private readonly AppDbContext _appDbContext;
        private readonly IHttpContextAccessor _contextAccessor;
        private readonly IConnectionFactory _connectionFactory;
        private readonly IEventRepository _eventRepository;

        public TicketPaymentRepository(AppDbContext appDbContext, IHttpContextAccessor contextAccessor, IConnectionFactory connectionFactory, IEventRepository eventRepository)
        {
            _appDbContext = appDbContext;
            _contextAccessor = contextAccessor; _eventRepository = eventRepository;
            _connectionFactory = connectionFactory;
        }

        public async Task<IEnumerable<TicketPayment>> GetAllTicketPayment()
        {
            return await _appDbContext.TicketPayments.Include(x => x.Event).Include(x => x.TicketStatus).Include(x => x.AspNetUser).AsNoTracking().ToListAsync();
        }

        public async Task<IEnumerable<TicketPayment>> GetTicketPaymentsByEventId(int eventId)
        {
            return await _appDbContext.TicketPayments.Include(x => x.Event).Include(x => x.TicketStatus).Where(x => x.EventId == eventId).AsNoTracking().ToListAsync();
        }

        public async Task DeleteTicketById(int id)
        {
            var ticketDetail = await GetTicketById(id);
            if (ticketDetail.TicketStatusId != 1)
            {
                throw new Exception("Cannot Delete Ticket, Ticket Status has already been resolved to " + ticketDetail.TicketStatus.Name);
            }
            _appDbContext.TicketPayments.Remove(ticketDetail);
            await _appDbContext.SaveChangesAsync();
        }
        private async Task<TicketPayment> GetTicketById(int id)
        {
            var ticketDetail = await _appDbContext.TicketPayments.Include(x => x.TicketStatus).Where(x => x.Id == id).FirstOrDefaultAsync();
            if (ticketDetail == null) throw new Exception("Ticket Payment not found");
            return ticketDetail;
        }

        public async Task UpdateTicketStatus(int id, int statusId)
        {
            var ticketDetail = await GetTicketById(id);
            ticketDetail.TicketStatusId = statusId;
            ticketDetail.ModifiedBy = GeneralUtility.GetUsernameFromClaim(_contextAccessor);
            ticketDetail.ModifiedDate = GeneralUtility.GetCurrentDateTime();
            _appDbContext.TicketPayments.Update(ticketDetail);
            await _appDbContext.SaveChangesAsync();
        }

        public async Task CreateTicket(int eventId, String aspNetUserId)
        {
            var hasAlreadyBought = await HasUserAlreadyBoughtTicket(eventId, aspNetUserId);
            if (hasAlreadyBought) throw new Exception("User has already bought ticket for this event, Cannot buy more than once ticket");
            var eventDetail = await _eventRepository.GetEventById(eventId);
            TicketPayment ticketPayment = new TicketPayment()
            {
                AspNetUserId = aspNetUserId,
                EventId = eventId,
                CreatedDate = GeneralUtility.GetCurrentDateTime(),
                TicketStatusId = 1,
                Amount = eventDetail.TicketPrice,
            };
            await _appDbContext.TicketPayments.AddAsync(ticketPayment);
            await _appDbContext.SaveChangesAsync();
        }
        public async Task<bool> HasUserAlreadyBoughtTicket(int eventId, String aspNetUserId)
        {

            var ticketInformation = await _appDbContext.TicketPayments.Where(x => x.EventId == eventId && x.AspNetUserId == aspNetUserId).FirstOrDefaultAsync();
            return ticketInformation != null;

        }

        public async Task<bool> ExistsTicketForEventByEventId(int eventId)
        {

            return await _appDbContext.TicketPayments.AnyAsync(x => x.EventId == eventId);


        }


    }
}
