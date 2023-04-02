using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class MenuAccessLevel
    {
        public int Id { get; set; }
        public int AccessLevelId { get; set; }
        public int MenuId { get; set; }
        public string AdminName { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }

        public virtual Menu Menu { get; set; }
    }
}
