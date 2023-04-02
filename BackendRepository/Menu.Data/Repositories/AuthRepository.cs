using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Dapper;
using Menu.Data.AuthModels;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Menu.Data.Infrastructure;
using Menu.Data.Utilities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.WebEncoders.Testing;
using DynamicParameters = Dapper.DynamicParameters;

namespace Menu.Data.Repositories
{

    public interface IAuthRepository
    {
        Task<bool> Login(LoginVm loginVm);
        Task Logout();
        Task<string> Register(RegisterVm model);
        Task<ApplicationUser> GetUserName(string username);

        Task<ApplicationUser> GetUserById(string userId);


        Task<string> GetRoleByUser(ApplicationUser user);

        Task<AspnetUserVm> GetRoleByUser(string username);

        Task<string> CreateRole(string roleName);

        Task ChangePassword(ChangePasswordVm changePasswordVm);

        IQueryable<ApplicationUser> GetAllUsers();
        IQueryable<ApplicationUserRole> GetAllRoles();

        Task<IEnumerable<AspnetUserVm>> GetAllUsersWithRole(bool showSuperAdmin);

        Task<string> GetUserId(string username);
        Task<ApplicationUser> GetUser(string username);

        Task<AspnetUserVm> GetUserWithRole(string userId);


        Task<ApplicationUser> FindByEmail(string email);

        Task<string> GetUserRole(string username);
        Task<string> GetUserNameByUserId(string userId);







    }
    public class AuthRepository : IAuthRepository
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly AppDbContext _appDbContext;
        private readonly RoleManager<ApplicationUserRole> _roleManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly AppDbContext _dbContext;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConnectionFactory _connectionFactory;


        public AuthRepository(UserManager<ApplicationUser> userManager, AppDbContext appDbContext, RoleManager<ApplicationUserRole> roleManager, SignInManager<ApplicationUser> signInManager, AppDbContext dbContext,
            IHttpContextAccessor httpContextAccessor, IConnectionFactory connectionFactory)
        {
            _userManager = userManager;
            _appDbContext = appDbContext;
            _roleManager = roleManager;
            _signInManager = signInManager;
            _dbContext = dbContext;
            _httpContextAccessor = httpContextAccessor;
            _connectionFactory = connectionFactory;

        }

        public async Task<bool> Login(LoginVm loginVm)
        {
            SignInResult result = await _signInManager.PasswordSignInAsync(loginVm.Username, loginVm.Password, true, false);
            return result.Succeeded;
        }
        public async Task Logout()
        {
            await _signInManager.SignOutAsync();
        }
        public async Task<string> Register(RegisterVm model)
        {
            if (string.IsNullOrEmpty(model.Username))
                throw new Exception("Username is required.");

            ApplicationUser loggedInUser = await _userManager.FindByNameAsync(model.Username);
            if (loggedInUser != null)
            {
                throw new Exception($"{model.Username} is already registered,");
            }

            using TransactionScope trans = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            {
                try
                {
                    var toRegister = new ApplicationUser() { UserName = model.Username, Name = model.Name, Email = model.Username };

                    var result = await _userManager.CreateAsync(toRegister, model.Password);

                    if (!result.Succeeded)
                    {
                        throw new Exception(result.Errors.FirstOrDefault()?.Description);
                    }

                    ApplicationUser user = await _userManager.FindByNameAsync(model.Username);
                    if (user is null)
                    {
                        throw new Exception("Invalid user");
                    }

                    IdentityResult addUserToRole = await _userManager.AddToRoleAsync(user, model.Role);

                    if (!addUserToRole.Succeeded)
                    {
                        throw new Exception(addUserToRole.Errors.FirstOrDefault()?.Description);
                    }

                    int accessLevelId = model.Role == "Admin" ? 1 : 2;
                    await using var conn = _connectionFactory.GetSqlConnection(_dbContext);
                    const string query = @"INSERT INTO MenuAspNetUser(AspNetUserId, MenuId)
                    SELECT @userId, mal.MenuId FROM MenuAccessLevel mal WHERE mal.AccessLevelId = @AccessLevelId";
                    var param = new DynamicParameters();
                    param.Add("@AccessLevelId", accessLevelId);
                    param.Add("@userId", user.Id);
                    await conn.ExecuteAsync(query, param, commandType: CommandType.Text);
                    var value = await _userManager.AddLoginAsync(user, new UserLoginInfo("Email", user.Id, user.Name));
                    trans.Complete();
                    return user.Id;
                }
                catch (Exception e)
                {
                    trans.Dispose();
                    throw new Exception(e.Message);
                }
            }

        }
        public async Task<ApplicationUser> GetUserById(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user is null)
            {
                throw new Exception("Invalid User");
            }

            return user;
        }
        public async Task<string> GetRoleByUser(ApplicationUser user)
        {
            var result = await _userManager.GetRolesAsync(user);
            return result.FirstOrDefault();
        }
        public async Task<AspnetUserVm> GetRoleByUser(string username)
        {
            var user = await GetUser(username);
            var role = await GetUserWithRole(user.Id);
            return role;

        }
        public async Task<string> CreateRole(string roleName)
        {
            IdentityResult result = await _roleManager.CreateAsync(new ApplicationUserRole() { Name = $"{roleName}" });
            if (!result.Succeeded)
            {
                throw new Exception(result.Errors.FirstOrDefault()?.Description);
            }

            return roleName;
        }
        public async Task ChangePassword(ChangePasswordVm changePasswordVm)
        {
            ApplicationUser applicationUser = await _userManager.FindByNameAsync(GeneralUtility.GetUsernameFromClaim(_httpContextAccessor));
            if (applicationUser is null) throw new Exception("Invalid User");

            if (string.IsNullOrEmpty(changePasswordVm.Password)) throw new Exception("Password is required");
            if (string.IsNullOrEmpty(changePasswordVm.ConfirmPassword)) throw new Exception("Confirm Password is required");
            if (string.IsNullOrEmpty(changePasswordVm.OldPassword)) throw new Exception("Confirm Password is required");

            if (string.CompareOrdinal(changePasswordVm.ConfirmPassword, changePasswordVm.OldPassword) == 0)
            {
                throw new Exception("Old and new password cannot be same");
            }

            if (string.CompareOrdinal(changePasswordVm.ConfirmPassword, changePasswordVm.Password) != 0)
            {
                throw new Exception("Invalid password and confirm Password");
            }

            IdentityResult identityResult = await _userManager.ChangePasswordAsync(user: applicationUser,
                changePasswordVm.OldPassword, changePasswordVm.Password);

            if (!identityResult.Succeeded)
            {
                throw new Exception(identityResult.Errors.FirstOrDefault()?.Description);
            }

        }
        public IQueryable<ApplicationUser> GetAllUsers()
        {
            return _userManager.Users;

        }
        public IQueryable<ApplicationUserRole> GetAllRoles()
        {
            return _roleManager.Roles;
        }
        public async Task<IEnumerable<AspnetUserVm>> GetAllUsersWithRole(bool showSuperAdmin)
        {
            await using var conn = _connectionFactory.GetSqlConnection(_dbContext);
            string query = @"SELECT anu.Id, anu.UserName ,anu.EmailConfirmed, anr.Name Role FROM AspNetUsers anu
                INNER JOIN AspNetUserRoles anur ON anur.UserId = anu.Id
            INNER JOIN AspNetRoles anr ON anr.Id = anur.RoleId WHERE anr.Name != 'Customer'" + (!showSuperAdmin ? "  AND  anu.IsSuperAdmin = 0 " : "");
            return await conn.QueryAsync<AspnetUserVm>(query, commandType: CommandType.Text);
        }
        public async Task<string> GetUserId(string username)
        {
            var user = await _userManager.FindByNameAsync(username);
            return user.Id;
        }
        public async Task<ApplicationUser> GetUser(string username)
        {
            return await _userManager.FindByNameAsync(username);
        }
        public async Task<AspnetUserVm> GetUserWithRole(string userId)
        {
            ApplicationUser applicationUser = await _userManager.FindByIdAsync(userId);
            var role = (await _userManager.GetRolesAsync(applicationUser)).FirstOrDefault();

            AspnetUserVm aspnetUserVm = new AspnetUserVm()
            {
                Id = applicationUser.Id,
                UserName = applicationUser.UserName,
                Role = role

            };

            return aspnetUserVm;
        }
        public async Task<string> GeneratePasswordResetToken(string userName)
        {
            ApplicationUser user = await GetUserName(userName);
            string emailConfirmedLink = await _userManager.GeneratePasswordResetTokenAsync(user);
            return emailConfirmedLink;
        }


        public async Task<ApplicationUser> FindByEmail(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user is null)
            {
                throw new Exception("Invalid User");
            }

            return user;
        }

        public async Task<ApplicationUser> GetUserName(string username)
        {
            var data = await _userManager.FindByNameAsync(username);
            if (data is null)
            {
                throw new Exception("No User with " + username + " exists");
            }
            return data;
        }


        public async Task<string> GetUserRole(string username)
        {
            var user = await GetUserName(username);
            var roleForUser = await _userManager.GetRolesAsync(user);
            var role = roleForUser.FirstOrDefault();
            return role;
        }

        public async Task<string> GetUserNameByUserId(string userId)
        {
            await using var conn = _connectionFactory.GetSqlConnection(_dbContext);
            const string query = "select anu.UserName from AspNetUsers anu where anu.Id = @UserName";
            var param = new DynamicParameters();
            param.Add("@UserName", userId);
            return await conn.QueryFirstOrDefaultAsync<string>(query, param, commandType: CommandType.Text);


        }

    }
}
