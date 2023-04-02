using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class TicketStatus
    {
        public TicketStatus()
        {
            TicketPayments = new HashSet<TicketPayment>();
        }

        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<TicketPayment> TicketPayments { get; set; }
    }
}
