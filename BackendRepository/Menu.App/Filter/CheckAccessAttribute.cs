using System.Linq;
using System.Threading.Tasks;
using Menu.Data.Repositories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Menu.App.Filter
{
    public class CheckAccessAttribute : ActionFilterAttribute
    {
        public int MenuCode { get; set; }

        public override async Task OnActionExecutionAsync(ActionExecutingContext context,
            ActionExecutionDelegate next)
        {

            var menuCode = MenuCode;
            var username = context.HttpContext.User.Claims.FirstOrDefault(x => x.Type == "username")?.Value;
            var menuRepository = (IMenuRepository)context.HttpContext.RequestServices.GetService(typeof(IMenuRepository));
            var hasAccess = await menuRepository.HasAccessForMenu(menuCode, username);

            if (!hasAccess)
            {
                context.Result = new ContentResult()
                {
                    StatusCode = 401,
                    Content = "You are not authorized to access this resource."
                };
            }
            else
            {
                await next();
            }
        }
    }
}
