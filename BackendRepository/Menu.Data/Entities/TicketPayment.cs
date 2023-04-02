using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class TicketPayment
    {
        public int Id { get; set; }
        public int TicketStatusId { get; set; }
        public int EventId { get; set; }
        public string AspNetUserId { get; set; }
        public decimal Amount { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        public virtual AspNetUser AspNetUser { get; set; }
        public virtual Event Event { get; set; }
        public virtual TicketStatus TicketStatus { get; set; }
    }
}
