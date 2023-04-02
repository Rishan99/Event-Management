using Menu.Data.Entities;
using System;
using System.Collections.Generic;

namespace Menu.Data.DTOS
{
    public class GeneralDto
    {



    }
    public class EventSelectDto : Event
    {
        public bool allowBooking { get; set; }

        public string coverImage { get; set; }
        public string ticketStatus { get; set; }
        public int? ticketStatusId { get; set; }
    }
    public class DashboardInformationDto
    {
        public int noOfUser { get; set; }
        public int noOfEvents { get; set; }
        public int noOfTicketsSold { get; set; }
    }

    public class EventInsertDto
    {
        public String name { get; set; }
        public String city { get; set; }
        public String description { get; set; }
        public String address { get; set; }
        public DateTime startDate { get; set; }
        public DateTime? endDate { get; set; }
        public int ticketTypeId { get; set; }
        public decimal ticketPrice { get; set; }
    }

    public class EventUpdateDto : EventInsertDto
    {
        public int id { get; set; }
        
    }
    public class EventDeleteDto
    {
        public int id { get; set; }
    }
    public class TicketPurchaseDeleteDto
    {
        public int id { get; set; }
    }

    public class TicketPaymentDeleteDto
    {
        public int id { get; set; }
    }

}

