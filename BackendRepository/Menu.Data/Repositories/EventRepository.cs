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
    public interface IEventRepository
    {

        Task<IEnumerable<Event>> GetAllEvents();
        Task<IEnumerable<Event>> GetEventsByCityName(String query);
        Task<Event> GetEventById(int id);
        Task<List<string>> DeleteEventById(int id);
        Task<List<string>> UpdateEvent(Event eventDetail, List<string> newImages, List<int> deletedImagesIds);
        Task CreateEvent(Event eventDetail, List<string> images);
    }
    public class EventRepository : IEventRepository
    {
        private readonly AppDbContext _appDbContext;
        private readonly IHttpContextAccessor _contextAccessor;
        private readonly IConnectionFactory _connectionFactory;


        public EventRepository(AppDbContext appDbContext, IHttpContextAccessor contextAccessor, IConnectionFactory connectionFactory)
        {
            _appDbContext = appDbContext;
            _contextAccessor = contextAccessor;
            _connectionFactory = connectionFactory;
        }

        public async Task CreateEvent(Event eventDetail, List<String> images)
        {
            eventDetail.Id = 0;
            eventDetail.CreatedDate = GeneralUtility.GetCurrentDateTime();
            eventDetail.ModifiedDate = null;
            using TransactionScope trans = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            {
                await _appDbContext.Events.AddAsync(eventDetail);
                await _appDbContext.SaveChangesAsync();
                if (images.Any())
                    await _appDbContext.EventImages.AddRangeAsync(images.Select(x => new EventImage()
                    {
                        CreatedDate = eventDetail.CreatedDate,
                        EventId = eventDetail.Id,
                        ImageName = x
                    }));
                await _appDbContext.SaveChangesAsync();
                trans.Complete();
            }
        }

        public async Task<List<string>> DeleteEventById(int id)
        {
            var eventDetail = await GetEventById(id);
            var eventImages = await GetEventImagesById(id);
            List<string> imagesToBeReturned = new List<string>();
            foreach (var item in eventImages)
            {
                imagesToBeReturned.Add(item.ImageName);
            }

            using TransactionScope trans = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            {
                eventDetail.EventImages.Clear();
                _appDbContext.EventImages.RemoveRange(eventImages);
                _appDbContext.Events.Remove(eventDetail);

                await _appDbContext.SaveChangesAsync();
                trans.Complete();
            }
            return imagesToBeReturned;
        }
        public async Task<IEnumerable<EventImage>> GetEventImagesById(int id)
        {
            return await _appDbContext.EventImages.OrderBy(x => x.Id).AsNoTracking().ToListAsync();
        }

        public async Task<IEnumerable<Event>> GetAllEvents()
        {
            return await _appDbContext.Events.Include(x => x.EventImages).Include(x => x.TicketType).OrderBy(x => x.Id).AsNoTracking().ToListAsync();
        }
        public async Task<Event> GetEventById(int id)
        {
            var eventDetail = await _appDbContext.Events.Include(x => x.EventImages).Include(x => x.TicketType).Include(x => x.TicketPayments).ThenInclude(x => x.TicketStatus).Where(x => x.Id == id).AsNoTracking().FirstOrDefaultAsync();
            if (eventDetail == null) throw new Exception("Event doesnt exists");
            return eventDetail;
        }

        public async Task<IEnumerable<Event>> GetEventsByCityName(string query)
        {
            return await _appDbContext.Events.Include(x => x.EventImages).Include(x => x.TicketType).Where(x => x.City.ToLower().Contains(query.ToLower())).OrderBy(x => x.Id).AsNoTracking().ToListAsync();
        }

        public async Task<List<string>> UpdateEvent(Event eventDetail, List<string> newImages, List<int> deletedImagesIds)
        {
            var eventRealDetail = await GetEventById(eventDetail.Id);
            eventDetail.CreatedDate = eventRealDetail.CreatedDate;
            eventDetail.ModifiedDate = GeneralUtility.GetCurrentDateTime();
            var eventImagesToBeDeleted = await _appDbContext.EventImages.Where(x => x.EventId == eventDetail.Id && deletedImagesIds.Contains(x.Id)).AsNoTracking().ToListAsync();
            using TransactionScope trans = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            {
                _appDbContext.EventImages.RemoveRange(eventImagesToBeDeleted);
                if (newImages.Any())
                    await _appDbContext.EventImages.AddRangeAsync(newImages.Select(x => new EventImage()
                    {
                        CreatedDate = eventDetail.CreatedDate,
                        EventId = eventDetail.Id,
                        ImageName = x
                    }));
                _appDbContext.Events.Update(eventDetail);
                await _appDbContext.SaveChangesAsync();
                trans.Complete();
            }
            return eventImagesToBeDeleted.Select(x => x.ImageName).ToList();
        }
    }
}
