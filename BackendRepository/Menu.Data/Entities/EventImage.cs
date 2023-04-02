using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class EventImage
    {
        public int Id { get; set; }
        public int EventId { get; set; }
        public string ImageName { get; set; }
        public DateTime CreatedDate { get; set; }

        public virtual Event Event { get; set; }
    }
}
