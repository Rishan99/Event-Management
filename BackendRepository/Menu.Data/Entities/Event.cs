using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class Event
    {
        public Event()
        {
            EventImages = new HashSet<EventImage>();
            TicketPayments = new HashSet<TicketPayment>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? TicketTypeId { get; set; }
        public decimal TicketPrice { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }

        public virtual TicketType TicketType { get; set; }
        public virtual ICollection<EventImage> EventImages { get; set; }
        public virtual ICollection<TicketPayment> TicketPayments { get; set; }
    }
}
