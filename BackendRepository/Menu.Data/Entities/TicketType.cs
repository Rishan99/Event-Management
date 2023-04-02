using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class TicketType
    {
        public TicketType()
        {
            Events = new HashSet<Event>();
        }

        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Event> Events { get; set; }
    }
}
