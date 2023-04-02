using AutoMapper;
using Menu.Data.DTOS;
using Menu.Data.Repositories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using Menu.App.Model;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Menu.Data.Utilities;

namespace Menu.App.Controllers
{
    [Route("api/general")]
    [ApiController]
    [Authorize]
    public class GeneralController : ControllerBase
    {
        private readonly IGeneralRepository _generalRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<GeneralController> _logger;

        public GeneralController(IGeneralRepository generalRepository, IMapper mapper, ILogger<GeneralController> logger)
        {
            _generalRepository = generalRepository;
            _mapper = mapper;
            _logger = logger;
        }



        [HttpGet, Route("ticket-type")]
        public async Task<IActionResult> GetAllTicketType()
        {
            try
            {
                return Ok(await _generalRepository.GetAllTicketType());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
        [HttpGet, Route("ticket-status")]
        public async Task<IActionResult> GetAllTicketStatus()
        {
            try
            {
                return Ok(await _generalRepository.GetAllTicketStatus());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
        [HttpGet, Route("dashboard-data")]
        public async Task<IActionResult> GetDashboardData()
        {
            try
            {
                return Ok(await _generalRepository.GetDashboardData());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


    }

}
