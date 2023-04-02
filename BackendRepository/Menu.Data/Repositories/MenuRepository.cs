using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using Menu.Data.DTOS;
using Menu.Data.Entities;
using Menu.Data.Infrastructure;
using Menu.Data.Model;
using Menu.Data.Utilities;
using Microsoft.AspNetCore.Http;

namespace Menu.Data.Repositories
{
    public interface IMenuRepository
    {
        Task<IEnumerable<MenuVm>> GetAllMenus();
        Task<IEnumerable<MenuVm>> GetMenusByUser(string username);
        Task<bool> HasAccessForMenu(int menuCode, string username);
        Task<IEnumerable<MenuVm>> GetMenusByAccessLevelForAssociation(int accessLevelId);
        Task UpdateMenusForAccessLevel(UpdateMenusForAccessLevel updateData);

        Task UpdateMenusForUser(UpdateMenusForUser updateData);
    }
    public class MenuRepository : IMenuRepository
    {
        private readonly AppDbContext _appDbContext;
        private readonly IConnectionFactory _connectionFactory;
        private readonly IHttpContextAccessor _accessor;
        private readonly IAuthRepository _authRepository;

        public MenuRepository(AppDbContext appDbContext, IConnectionFactory connectionFactory, IHttpContextAccessor accessor, IAuthRepository authRepository)
        {
            _appDbContext = appDbContext;
            _connectionFactory = connectionFactory;
            _accessor = accessor;
            _authRepository = authRepository;
        }

        public async Task<IEnumerable<MenuVm>> GetAllMenus()
        {
            await using var conn = _connectionFactory.GetSqlConnection(_appDbContext);
            var query = $"SELECT * FROM Menu m WHERE m.IsActive = 1 ORDER BY m.OrderId ASC";
            return await conn.QueryAsync<MenuVm>(query, commandType: CommandType.Text);
        }


        public async Task<IEnumerable<MenuVm>> GetMenusByUser(string username)
        {
            using var conn = _connectionFactory.GetSqlConnection(_appDbContext);
            string query = $"SELECT m.* FROM [MenuAspNetUser] mau " +
                           $"INNER JOIN [AspNetUsers] anu ON anu.[Id] = mau.[AspNetUserId] " +
                           $"INNER JOIN [Menu] m ON m.[Id] = mau.[MenuId] " +
                           $"WHERE anu.[Username] = @Username AND m.IsActive = 1 ORDER BY m.OrderId ASC";

            var param = new DynamicParameters();
            param.Add("Username", username);

            return await conn.QueryAsync<MenuVm>(query, param, commandType: CommandType.Text);

        }

        public async Task<bool> HasAccessForMenu(int menuCode, string username)
        {
            using var conn = _connectionFactory.GetSqlConnection(_appDbContext);
            string query = $"DECLARE @UserId AS VARCHAR(512); " +
                           $"SET @UserId = (SELECT[Id] FROM[AspNetUsers] WHERE[UserName] = @Username); " +
                           $"IF EXISTS(SELECT* FROM [MenuAspNetUser] WHERE[AspNetUserId] = @UserId AND[MenuId] = @MenuCode) " +
                           $"SELECT 1; " +
                           $"ELSE " +
                           $"SELECT 0; ";

            var param = new DynamicParameters();
            param.Add("@MenuCode", menuCode);
            param.Add("@Username", username);

            return await conn.ExecuteScalarAsync<bool>(query, param, commandType: CommandType.Text);

        }

        public async Task<IEnumerable<MenuVm>> GetMenusByAccessLevelForAssociation(int accessLevelId)
        {
            using var conn = _connectionFactory.GetSqlConnection(_appDbContext);
            string query = $"SELECT m.*, CASE WHEN ISNULL(mal.MenuId, 0) = 0 THEN 0 ELSE 1 END IsSelected " +
                           $"FROM[Menu] m " +
                           $"LEFT JOIN [MenuAccessLevel] mal ON mal.[MenuId] = m.[Id] AND mal.[AccessLevelId] = @AccessLevelId " +
                           $"WHERE m.[IsActive] = 1";

            var param = new DynamicParameters();
            param.Add("@AccessLevelId", accessLevelId);

            return await conn.QueryAsync<MenuVm>(query, param, commandType: CommandType.Text);

        }

        public async Task UpdateMenusForAccessLevel(UpdateMenusForAccessLevel updateData)
        {
            await using var conn = _connectionFactory.GetSqlConnection(_appDbContext);
            string query = $"MERGE [MenuAccessLevel] AS TARGET " +
                           $"USING STRING_SPLIT(@MenuIds, ',') AS SOURCE " +
                           $"ON TARGET.[MenuId] = SOURCE.[Value] AND TARGET.[AccessLevelId] = @AccessLevelId " +
                           $"WHEN MATCHED THEN UPDATE " +
                           $"SET " +
                           $"TARGET.[AdminName] = @AdminName, " +
                           $"TARGET.[ModifiedDate] = @ModifiedDate " +
                           $"WHEN NOT MATCHED BY TARGET " +
                           $"THEN " +
                           $"INSERT([AccessLevelId], [MenuId], [AdminName], [CreatedDate]) " +
                           $"VALUES(@AccessLevelId, SOURCE.[Value], @AdminName, @ModifiedDate) " +
                           $"WHEN NOT MATCHED BY SOURCE AND TARGET.[AccessLevelId] = @AccessLevelId THEN DELETE; ";

            var param = new DynamicParameters();
            param.Add("@AccessLevelId", updateData.Id);
            param.Add("@MenuIds", string.Join(",", updateData.MenuIds));
            param.Add("@AdminName", GeneralUtility.GetUsernameFromClaim(_accessor));
            param.Add("@ModifiedDate", GeneralUtility.GetCurrentDateTime());

            await conn.ExecuteAsync(query, param, commandType: CommandType.Text);

        }

        public async Task UpdateMenusForUser(UpdateMenusForUser updateData)
        {
            await using var conn = _connectionFactory.GetSqlConnection(_appDbContext);

            var user = GeneralUtility.GetUsernameFromClaim(_accessor);
            var username = await _authRepository.GetUserNameByUserId(updateData.UserId);
            // if (string.CompareOrdinal(user, username) == 0)
            // {
            //     throw new Exception("Cannot change own menu access");
            // }


            string query = $"IF(@MenuIds != '') " +
                           $"BEGIN " +
                           $"MERGE [MenuAspNetUser] AS TARGET " +
                           $"USING STRING_SPLIT(@MenuIds, ',') AS SOURCE " +
                           $"ON TARGET.[MenuId] = SOURCE.[Value] AND TARGET.[AspNetUserId] = @UserId " +
                           $"WHEN NOT MATCHED BY TARGET " +
                           $"THEN " +
                           $"INSERT([AspNetUserId], [MenuId]) VALUES(@UserId, SOURCE.[Value]) " +
                           $"WHEN NOT MATCHED BY SOURCE AND TARGET.[AspNetUserId] = @UserId THEN DELETE; " +
                           $"END " +
                           $"ELSE " +
                           $"BEGIN " +
                           $"DELETE FROM [MenuAspNetUser] WHERE [AspNetUserId] = @UserId " +
                           $"END";
            var param = new DynamicParameters();
            param.Add("@UserId", updateData.UserId);
            param.Add("@MenuIds", string.Join(",", updateData.MenuIds));
            await conn.ExecuteAsync(query, param, commandType: CommandType.Text);
        }


    }
}
