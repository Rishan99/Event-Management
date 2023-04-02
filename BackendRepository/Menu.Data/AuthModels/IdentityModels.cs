using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;

namespace Menu.Data.AuthModels
{
   public class IdentityModels
    {

    }
   public class ApplicationUserRole : IdentityRole
   {

   }
   public class ApplicationUser : IdentityUser
   {
       public string Name { get; set; }
       public bool IsSuperAdmin { get; set; }
   }

   

}
