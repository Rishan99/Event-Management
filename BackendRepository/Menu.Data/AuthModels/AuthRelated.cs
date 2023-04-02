using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Menu.Data.AuthModels
{
    public class AuthRelated
    {

    }

    public class LoginVm
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }

    public class RegisterVm
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string Name { get; set; }
        public string Role { get; set; }
        public string Id { get; set; }
    }

    public class PasswordResetVm
    {
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string Username { get; set; }
        public string UserId { get; set; }
    }

    public class ChangePasswordVm
    {
        public string Username { get; set; }
        public string OldPassword { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }

    }

    public class UnRegisterVm
    {
        public string UserName { get; set; }
    }

    public class AspnetUserVm
    {
        public string Id { get; set; }
        public string UserName { get; set; }
        public string Role { get; set; }
        public bool EmailConfirmed { get; set; }
    }

    public class UrlProtection
    {
        public readonly string UrlProtector = "ConfirmEmailLink";
    }

}
