using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class Menu
    {
        public Menu()
        {
            MenuAccessLevels = new HashSet<MenuAccessLevel>();
        }

        public int Id { get; set; }
        public int ParentId { get; set; }
        public string Name { get; set; }
        public string Url { get; set; }
        public bool IsActive { get; set; }
        public string Icon { get; set; }
        public decimal? OrderId { get; set; }
        public bool? IsLink { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? DeletedDate { get; set; }

        public virtual ICollection<MenuAccessLevel> MenuAccessLevels { get; set; }
    }
}
