using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Menu.Data.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using AutoMapper;
using System.Linq;
using Menu.Data.Utilities;
using Microsoft.AspNetCore.Identity;
using Menu.Data.AuthModels;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using Microsoft.AspNetCore.Authorization;

namespace Menu.App.Controllers
{
    [Route("api/event")]
    [ApiController]
    [Authorize]
    public class EventController : ControllerBase
    {
        private readonly IMapper _mapper;
        private readonly IEventRepository _eventRepository;
        private readonly ITicketPaymentRepository _paymentRepository;
        private readonly IHttpContextAccessor _contextAccessor;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public EventController(IEventRepository eventRepository, IWebHostEnvironment webHostEnvironment, UserManager<ApplicationUser> userManager, IHttpContextAccessor contextAccessor, ITicketPaymentRepository paymentRepository, IMapper mapper)
        {
            _eventRepository = eventRepository;
            _contextAccessor = contextAccessor;
            _mapper = mapper;
            _userManager = userManager;
            _webHostEnvironment = webHostEnvironment;
            _paymentRepository = paymentRepository;
        }

        [HttpPost, Route("insert")]
        public async Task<IActionResult> CreateEvent()
        {
            List<string> images = new List<string>();
            string imagePath = _webHostEnvironment.ContentRootPath + "\\Images\\Event";
            try
            {
                var eventDetailInString = Request.Form["data"];
                var eventData = JsonConvert.DeserializeObject<EventInsertDto>(eventDetailInString);
                Event eventDetail = _mapper.Map<Event>(eventData);
                var filesFromServer = HttpContext.Request.Form.Files.Where(x => x.Name == "files");

                foreach (var currentFile in filesFromServer)
                {
                    var image = await GeneralUtility.GetFileName(currentFile, imagePath);
                    images.Add(image);
                }

                await _eventRepository.CreateEvent(eventDetail, images);
                return Ok("Event has been created");
            }
            catch (Exception ex)
            {
                GeneralUtility.DeleteImageFromServer(imagePath, fileNames: images);
                return BadRequest(ex.Message);
            }
        }
        [HttpPost, Route("{id}/update")]
        public async Task<IActionResult> UpdateEvent(int id)
        {
            List<string> images = new List<string>();
            string imagePath = _webHostEnvironment.ContentRootPath + "\\Images\\Event";
            try
            {
                var eventDetailInString = Request.Form["data"];
                var eventData = JsonConvert.DeserializeObject<EventInsertDto>(eventDetailInString);
                Event eventDetail = _mapper.Map<Event>(eventData);
                List<int> deletedImagesIds = new List<int>();
                var deletedImagesInString = Request.Form["deletedImages"].ToString();
                //delete images
                if (!string.IsNullOrEmpty(deletedImagesInString))

                {
                    deletedImagesIds = JsonConvert.DeserializeObject<List<int>>(Request.Form["deletedImages"]);
                }
                //new files
                var filesFromServer = HttpContext.Request.Form.Files.Where(x => x.Name == "files");
                foreach (var currentFile in filesFromServer)
                {
                    var image = await GeneralUtility.GetFileName(currentFile, imagePath);
                    images.Add(image);
                }
                eventDetail.Id = id;
                var toBeDeletdImages = await _eventRepository.UpdateEvent(eventDetail, images, deletedImagesIds);
                try
                {
                    GeneralUtility.DeleteImageFromServer(imagePath, fileNames: toBeDeletdImages);
                }
                catch (Exception ex) { }
                return Ok("Event has been updated");
            }
            catch (Exception ex)
            {
                try
                {
                    GeneralUtility.DeleteImageFromServer(imagePath, fileNames: images);
                }
                catch (Exception)
                {
                    //do nth
                }
                return BadRequest(ex.Message);
            }
        }
        [HttpGet, Route("list")]
        public async Task<IActionResult> GetAllEventList()
        {
            try
            {
                IEnumerable<Event> eventList = await _eventRepository.GetAllEvents();

                foreach (var item in eventList)
                {
                    List<EventImage> eventImages = item.EventImages.ToList();
                    eventImages.ForEach(x =>
                    {
                        x.ImageName = $"{Request.Scheme}://{Request.Host}/Images/Event/{x.ImageName}";
                    });
                }
                return Ok(eventList);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpGet, Route("query")]
        public async Task<IActionResult> GetAllEventByCity(String city)
        {
            try
            {
                IEnumerable<Event> eventList = new List<Event>();
                if (string.IsNullOrEmpty(city.Trim()))
                {
                    eventList = await _eventRepository.GetAllEvents();
                }
                else
                {
                    eventList = await _eventRepository.GetEventsByCityName(city);
                }
                IEnumerable<EventSelectDto> eventSelectDto = _mapper.Map<IEnumerable<EventSelectDto>>(eventList);
                foreach (var item in eventSelectDto)
                {

                    List<EventImage> eventImages = item.EventImages.ToList();
                    var firstImage = eventImages.FirstOrDefault()?.ImageName;
                    if (!string.IsNullOrEmpty(firstImage))
                    {
                        item.coverImage = $"{Request.Scheme}://{Request.Host}/Images/Event/{firstImage}";
                    }
                    eventImages.ForEach(x =>
                    {
                        x.ImageName = $"{Request.Scheme}://{Request.Host}/Images/Event/{x.ImageName}";
                    });
                }

                return Ok(eventSelectDto);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost, Route("delete")]
        public async Task<IActionResult> DeleteEvent(EventDeleteDto eventDeleteDto)
        {
            try
            {
                var hasTicketBeenSoldToEvent = await _paymentRepository.ExistsTicketForEventByEventId(eventDeleteDto.id);
                if (hasTicketBeenSoldToEvent)
                {
                    throw new Exception("Cannot delete event, Ticket Booking for event has already been performed");
                }
                List<string> imageToBeDeleted = await _eventRepository.DeleteEventById(eventDeleteDto.id);
                try
                {
                    GeneralUtility.DeleteImageFromServer(_webHostEnvironment.ContentRootPath + "\\Images\\Event", fileNames: imageToBeDeleted);
                }
                catch (Exception e)
                {
                    //do nothing
                }
                return Ok("Event has been deleted");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpGet, Route("{id}")]
        public async Task<IActionResult> GetEventById(int id)
        {
            try
            {
                var eventDetail = await _eventRepository.GetEventById(id);
                EventSelectDto eventSelectDto = _mapper.Map<EventSelectDto>(eventDetail);
                var userName = GeneralUtility.GetUsernameFromClaim(_contextAccessor);
                var user = await _userManager.FindByNameAsync(userName);
                bool hasAlreadyBought = await _paymentRepository.HasUserAlreadyBoughtTicket(id, user.Id);
                var currentDateTime = GeneralUtility.GetCurrentDateTime();
                var userTicketPayment = eventDetail.TicketPayments.FirstOrDefault(x => x.AspNetUserId == user.Id);
                if (userTicketPayment != null)
                {
                    eventSelectDto.ticketStatus = userTicketPayment.TicketStatus?.Name?.ToString();
                    eventSelectDto.ticketStatusId = userTicketPayment.TicketStatusId;
                }
                bool hasDateForBookingPassed = (currentDateTime.CompareTo(eventDetail.StartDate) >= 0);
                eventSelectDto.allowBooking = !(hasAlreadyBought || hasDateForBookingPassed);
                var firstImage = eventSelectDto.EventImages.FirstOrDefault()?.ImageName;
                if (!string.IsNullOrEmpty(firstImage))
                {
                    eventSelectDto.coverImage = $"{Request.Scheme}://{Request.Host}/Images/Event/{firstImage}";
                }
                eventSelectDto.EventImages.ToList().ForEach(x =>
                {
                    x.ImageName = $"{Request.Scheme}://{Request.Host}/Images/Event/{x.ImageName}";
                });

                return Ok(eventSelectDto);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}