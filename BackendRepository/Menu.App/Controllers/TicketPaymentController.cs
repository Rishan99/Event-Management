using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Menu.Data.AuthModels;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Menu.Data.Repositories;
using Menu.Data.Utilities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
namespace Menu.App.Controllers
{
    [Route("api/ticket")]
    [ApiController]
    [Authorize]
    public class TicketPaymentController : ControllerBase
    {
        private readonly ITicketPaymentRepository _ticketPaymentRepository;
        private readonly IEventRepository _eventRepository;

        private readonly UserManager<ApplicationUser> _userManager;


        private readonly IHttpContextAccessor _contextAccessor;

        public TicketPaymentController(ITicketPaymentRepository ticketPaymentRepository, UserManager<ApplicationUser> userManager, IEventRepository eventRepository, IHttpContextAccessor contextAccessor)

        {
            _eventRepository = eventRepository;
            _userManager = userManager;
            _contextAccessor = contextAccessor;
            _ticketPaymentRepository = ticketPaymentRepository;
        }

        [HttpPost, Route("/api/event/{eventId}/purchase-ticket")]
        public async Task<IActionResult> PurchaseEventTicket(int eventId)
        {
            try
            {
                var userName = GeneralUtility.GetUsernameFromClaim(_contextAccessor);
                var user = await _userManager.FindByNameAsync(userName);
                await _ticketPaymentRepository.CreateTicket(eventId, user.Id);
                return Ok("Ticket has been booked with status Pending from Admin");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpPost, Route("approve")]
        public async Task<IActionResult> ApproveTicket(TicketPurchaseDeleteDto ticketPurchaseDeleteDto)
        {
            try
            {
                await _ticketPaymentRepository.UpdateTicketStatus(ticketPurchaseDeleteDto.id, 2);
                return Ok("Ticket Payment has been approved");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpPost, Route("reject")]
        public async Task<IActionResult> RejectTicket(TicketPurchaseDeleteDto ticketPurchaseDeleteDto)
        {
            try
            {
                await _ticketPaymentRepository.UpdateTicketStatus(ticketPurchaseDeleteDto.id, 3);
                return Ok("Ticket Payment has been rejected");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
        [HttpPost, Route("delete")]
        public async Task<IActionResult> DeleteTicket(TicketPaymentDeleteDto ticketPaymentDeleteDto)
        {
            try
            {

                await _ticketPaymentRepository.DeleteTicketById(ticketPaymentDeleteDto.id);
                return Ok("Ticket Payment has been deleted");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet, Route("list")]
        public async Task<IActionResult> GetAllTicketPurchaseInformation()
        {
            try
            {
                var listData = await _ticketPaymentRepository.GetAllTicketPayment();
                return Ok(listData);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}