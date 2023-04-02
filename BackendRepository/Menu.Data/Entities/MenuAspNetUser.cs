using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class MenuAspNetUser
    {
        public int Id { get; set; }
        public string AspNetUserId { get; set; }
        public int MenuId { get; set; }
    }
}
