using System;
using System.Collections.Generic;

#nullable disable

namespace Menu.Data.Entities
{
    public partial class Token
    {
        public int Id { get; set; }
        public string TokenUrl { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool IsTokenBlackListed { get; set; }
        public string Type { get; set; }
        public string UserId { get; set; }

        public virtual AspNetUser User { get; set; }
    }
}
