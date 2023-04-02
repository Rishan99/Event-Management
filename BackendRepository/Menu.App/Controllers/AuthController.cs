using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.WebSockets;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Menu.App.Filter;
using Menu.App.Model;
using Menu.Data.AuthModels;
using Menu.Data.Model;
using Menu.Data.Repositories;
using Menu.Data.Utilities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;

using Menu.Data.constants;
using AutoMapper;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.WebUtilities;


namespace Menu.App.Controllers
{
    [Route("api")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthRepository _authRepository;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly IMapper _mapper;

        private readonly ILogger<AuthController> _logger;
        private readonly RoleManager<ApplicationUserRole> _roleManager;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMenuRepository _menuRepository;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public AuthController(IAuthRepository authRepository, IWebHostEnvironment webHostEnvironment, IMapper mapper, UrlProtection urlProtection, ILogger<AuthController> logger, RoleManager<ApplicationUserRole> roleManager,

            UserManager<ApplicationUser> userManager, IMenuRepository menuRepository, IHttpContextAccessor httpContextAccessor,
            IConfiguration configuration)
        {
            _authRepository = authRepository;

            _webHostEnvironment = webHostEnvironment;
            _mapper = mapper;

            _logger = logger;
            _roleManager = roleManager;
            _userManager = userManager;
            _menuRepository = menuRepository;
            _httpContextAccessor = httpContextAccessor;
            _configuration = configuration;
        }

        [HttpPost]
        [AllowAnonymous]
        [Route("auth/admin-login")]
        public async Task<IActionResult> Login(LoginVm model)
        {
            try
            {
                if (string.IsNullOrEmpty(model.Username))
                    throw new Exception("The Username cannot be empty.");

                if (string.IsNullOrEmpty(model.Password))
                    throw new Exception("The Password cannot be empty.");

                var result = await _authRepository.Login(model);
                if (!result)
                {
                    throw new Exception("Username or password is invalid");
                }

                ApplicationUser applicationUser = await _authRepository.GetUser(model.Username);

                var role = await _authRepository.GetUserRole(applicationUser.UserName);
                if (string.IsNullOrEmpty(role))
                    throw new Exception("User is not configured properly, Please contact administrator");
                if (string.CompareOrdinal(role, "Admin") != 0)
                {


                    throw new Exception("Invalid Login Credentials, Please verify you credentials");

                }
                var user = await _authRepository.GetUserName(model.Username);
                if (user == null)
                {
                    _logger.LogError($"Error! Failed to retrieve user with username {model.Username}.");
                    throw new Exception("The Username or Password is Wrong.");
                }
                var _tempToken = await GenerateJwtToken(user.UserName);

                var theToken = new TheToken()
                {
                    UserName = user.UserName,
                    AccessToken = _tempToken.ToString(),
                    ExpiresIn = Convert.ToInt32(_configuration["JwtExpireDays"]) * 24 * 10000,

                };
                return Ok(theToken);
            }
            catch (Exception ex)

            {
                return BadRequest(ex.Message);
            }
        }

        [Route("auth/logout")]
        [HttpPost, Authorize]
        public async Task<IActionResult> Logout()
        {
            await _authRepository.Logout();
            return Ok("Logout successful!");
        }
        [HttpPost]
        [AllowAnonymous]
        [Route("auth/login-user")]
        public async Task<IActionResult> UserLogin(LoginVm model)
        {
            try
            {
                if (string.IsNullOrEmpty(model.Username))
                    throw new Exception("The Username cannot be empty.");

                if (string.IsNullOrEmpty(model.Password))
                    throw new Exception("The Password cannot be empty.");

                var result = await _authRepository.Login(model);
                if (!result)
                {
                    throw new Exception("Username or password is invalid");
                }
                ApplicationUser applicationUser = await _authRepository.GetUser(model.Username);
                var role = await _authRepository.GetUserRole(applicationUser.UserName);
                if (string.IsNullOrEmpty(role))
                    throw new Exception("User is not configured properly, Please contact administrator");
                if (string.CompareOrdinal(role, "User") != 0)
                {


                    throw new Exception("Invalid Login Credentials, Please verify you credentials");

                }
                var user = await _authRepository.GetUserName(model.Username);
                if (user == null)
                {
                    throw new Exception("The Username or Password is Wrong.");
                }
                var _tempToken = await GenerateJwtToken(user.UserName);
                var theToken = new TheToken()
                {
                    UserName = user.UserName,
                    AccessToken = _tempToken.ToString(),
                    ExpiresIn = Convert.ToInt32(_configuration["JwtExpireDays"]) * 24 * 10000,

                };
                return Ok(theToken);
            }
            catch (Exception ex)

            {
                return BadRequest(ex.Message);
            }
        }
        [HttpPost]
        [AllowAnonymous]
        [Route("auth/register-user")]
        public async Task<IActionResult> RegisterUser(RegisterVm model)
        {
            try
            {
                if (string.IsNullOrEmpty(model.Username))
                    throw new Exception("The Username cannot be empty.");

                if (string.IsNullOrEmpty(model.Password))
                    throw new Exception("The Password cannot be empty.");

                if (model.Password != model.ConfirmPassword)
                    throw new Exception("Password and Confirm Password do not match.");
                model.Role = "User";
                var result = await _authRepository.Register(model);
                return Ok("User has been registed successfully, Please Login");
            }
            catch (Exception ex)

            {
                return BadRequest(ex.Message);
            }
        }
        private async Task<object> GenerateJwtToken(string username)
        {
            var user = await _authRepository.GetUserName(username: username);
            var theRole = await _authRepository.GetRoleByUser(user);

            var claims = new List<Claim>
            {
                new Claim("username", user.UserName),
                new Claim(ClaimTypes.Role, theRole )


            };
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JwtKey"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expires = DateTime.Now.AddDays(Convert.ToDouble(_configuration["JwtExpireDays"]));

            var token = new JwtSecurityToken(
                _configuration["JwtIssuer"],
                _configuration["JwtIssuer"],
                claims,
                expires: expires,
                signingCredentials: creds
            );
            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        [HttpGet, Route("roles")]
        public IActionResult GetAllRoles()
        {
            try
            {
                return Ok(_roleManager.Roles);
            }
            catch (Exception e)
            {
                _logger.LogError("Exception Occurred While getting all roles", e.Message);
                return BadRequest(e.Message);
            }
        }

        [HttpGet, Route("users")]
        public IActionResult GetAllUsers()
        {
            try
            {
                return Ok(_authRepository.GetAllUsers());
            }
            catch (Exception e)
            {
                _logger.LogError("Exception Occurred While getting all roles", e.Message);
                return BadRequest(e.Message); throw;
            }
        }



        [HttpPost, Route("create-role")]
        public async Task<IActionResult> CreateRole(string role)
        {
            try
            {
                string createdRole = await _authRepository.CreateRole(role);
                return Ok($"The role {createdRole} has been created");
            }
            catch (Exception e)
            {
                _logger.LogError("Exception Occurred while inserting new role", e.Message);
                return BadRequest(e.Message);
            }
        }


        [HttpPost, Route("change-password")]
        public async Task<IActionResult> ChangePassword(ChangePasswordVm changePasswordVm)
        {
            try
            {
                await _authRepository.ChangePassword(changePasswordVm);
                return Ok("Password has been changed");
            }
            catch (Exception e)
            {
                _logger.LogError("Exception Occurred while changing password", e.Message);
                return BadRequest(e.Message);
            }
        }

        [HttpGet, Route("users-with-role")]
        public async Task<IActionResult> GetAllUsersWithRole()
        {
            try
            {
                var userName = GeneralUtility.GetUsernameFromClaim(_httpContextAccessor);
                return Ok(await _authRepository.GetAllUsersWithRole(userName.CompareTo("fezerio") == 0));
            }
            catch (Exception e)
            {
                _logger.LogError("exception occurred while getting all users along with role", e.Message);
                return BadRequest(e.Message);
            }
        }

        [HttpGet]
        [Route("auth/me")]
        public async Task<IActionResult> GetUser()
        {
            try
            {
                var username = GeneralUtility.GetUsernameFromClaim(_httpContextAccessor);
                var menus = await _menuRepository.GetMenusByUser(username);
                var menuTree = GetMenuTree(menus);
                // string _tempIds = "";
                var menuList = await _menuRepository.GetAllMenus();
                var role = GeneralUtility.GetRoleFromClaim(_httpContextAccessor);
                var menuIds = menuList.Select(x => x.Id);
                // foreach (var menu in menuTree)
                // {
                //     _tempIds += menu.Id + ",";
                //     if (menu.Children.Any())
                //     {
                //         foreach (var child in menu.Children)
                //         {
                //             _tempIds += child.Id + ",";
                //         }
                //     }
                // }
                // _tempIds = _tempIds.TrimEnd(',');

                // string[] abc = _tempIds.Split(',');

                // int[] menuIds = new int[abc.Length];

                // for (int i = 0; i < abc.Length; i++)
                // {
                //     if (!string.IsNullOrEmpty(abc[i]))
                //     {
                //         menuIds[i] = int.Parse(abc[i]);
                //     }
                // }

                ApplicationUser applicationUser = await _authRepository.GetUser(username);
                string name = applicationUser.Name;
                string displayName = string.Empty;
                string provider = "Email";
                displayName = "Admin";
                return Ok(new { username, name, displayName, provider, role, menuTree, menuIds });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        private IEnumerable<MenuVm> GetMenuTree(IEnumerable<MenuVm> menus)
        {
            if (menus.Any())
            {
                foreach (var menu in menus)
                {
                    var childMenus = menus.Where(x => x.ParentId == menu.Id);

                    if (childMenus != null)
                    {
                        menu.Children = childMenus;
                        foreach (var item in menu.Children)
                        {
                            GetMenuTree(menu.Children);
                        }
                    }
                }
                return menus.Where(x => x.ParentId == 0).OrderBy(x => x.OrderId);
            }
            else
            {
                return new List<MenuVm>();
            }
        }

        [HttpGet, Route("auth/username/{userId}")]
        public async Task<IActionResult> GetUserName(string userId)
        {
            try
            {
                ApplicationUser applicationUser = await _authRepository.GetUserById(userId);
                return Ok(applicationUser.UserName);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet, Route("auth/get-user-and-role/{userId}")]
        public async Task<IActionResult> GetUserAndRole(string userId)
        {
            try
            {
                return Ok(await _authRepository.GetUserWithRole(userId));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }







    }
}
