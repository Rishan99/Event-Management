using Menu.Data.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Menu.Data.Model
{
    public class MenuVm
    {
        public int Id { get; set; }
        public int ParentId { get; set; }
        public string Name { get; set; }
        public string Url { get; set; }
        public bool IsActive { get; set; }
        public IEnumerable<MenuVm> Children { get; set; }
        public string Icon { get; set; }
        public int OrderId { get; set; }
        public bool IsSelected { get; set; }
        public bool IsLink { get; set; }
    }

    public class UpdateMenusForAccessLevel
    {
        public int Id { get; set; }
        public int[] MenuIds { get; set; }
    }

    public class UpdateMenusForUser
    {
        public string UserId { get; set; }
        public int[] MenuIds { get; set; }
    }


}
