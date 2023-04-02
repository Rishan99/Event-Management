using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Menu.App.Model
{
    public class TheToken
    {
        public string AccessToken { get; set; }
        public int ExpiresIn { get; set; }
        public string UserName { get; set; }
        public string RefreshToken { get; set; }
    }
    public class Sticker
    {
        public int Id { get; set; }
        public string StickerPath { get; set; }
    }
}
