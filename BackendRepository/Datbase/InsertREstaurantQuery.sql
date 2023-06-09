USE [MenuApp]
GO
/****** Object:  StoredProcedure [dbo].[usp_Insert_restaurant]    Script Date: 12/23/2021 6:03:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashan Raj kc 
-- =============================================
ALTER PROCEDURE [dbo].[usp_Insert_restaurant]
(
	@Name NVARCHAR(450)
   ,@PhoneNumber NVARCHAR(10)
   ,@GeoCode NVARCHAR(250)
   ,@Website NVARCHAR(250)
   ,@FacebookUrl NVARCHAR(250)
   ,@InstagramUrl NVARCHAR(250)
   ,@Description NVARCHAR(250)
   ,@StateId INT
   ,@StatusId INT
   ,@CountryId INT
   ,@DistrictId INT
   ,@City NVARCHAR(250)
   ,@DailyAverageOrder INT
   ,@NumberOfTable INT
   ,@cuisinesTable AS cuisinesTable READONLY
   ,@DayTable AS DayTable READONLY
   ,@RestaurantPaymentTable AS RestaurantPaymentTable READONLY
   ,@LoggedInuser NVARCHAR(450)
   ,@CreatedBy NVARCHAR(450)
   ,@CreatedDate DATETIME
   ,@HomeDeliveryTable AS HomeDeliveryTable READONLY
   ,@RestaurantImage AS RestaurantImage READONLY
)
AS BEGIN

		SET NOCOUNT ON;

		BEGIN TRY
			BEGIN TRANSACTION
			DECLARE @TotalNumberOfBranch INT
				
				, @PresentNumberOfBranch INT
				, @PresentNumberOfQr INT
				, @BusinessId INT
				, @RestaurantId INT
				

			DECLARE @InsertedRestaurantId TABLE
				(
					Id INT
				)

			SET @BusinessId =
			(SELECT TOP 1 b.Id FROM Business b)

			SET @TotalNumberOfBranch =
			(SELECT bs.NoOfBranch FROM BusinessSetting bs WHERE bs.BusinessId = @BusinessId)

			SET @PresentNumberOfBranch = ISNULL(
			(SELECT COUNT(r.Id) FROM Resturant r WHERE r.BusinessId = @BusinessId)
			, 0)

			IF (@TotalNumberOfBranch < @PresentNumberOfBranch)
			BEGIN;
				THROW 5000001, 'User cannot add more restaurant', 1
			END

			INSERT INTO Resturant (BusinessId, Name, IsActive, CreatedBy, CreatedDate)
			OUTPUT INSERTED.Id INTO @InsertedRestaurantId
				VALUES (@BusinessId, @Name, DEFAULT, @CreatedBy, @CreatedDate)

			SET @RestaurantId =
			(SELECT TOP (1) Id FROM @InsertedRestaurantId)

			SELECT @RestaurantId
			, cu.Id FROM @cuisinesTable cu

			INSERT INTO RestaurantCuisine (RestaurantId, CuisineId)
				SELECT @RestaurantId, cu.Id FROM @cuisinesTable cu

			INSERT INTO RestaurantHomeDelivery (ResturantId, HomeDeliveryId, Remarks)
				SELECT @RestaurantId, hdt.Id, hdt.Remarks FROM @HomeDeliveryTable hdt

			INSERT INTO RestaurantImage (ImageName, RestaurantId)
				SELECT ri.Filename, @RestaurantId FROM @RestaurantImage ri

			INSERT INTO RestaurantOpeningHour (DaysId, OpeningTime, ClosingTime, ResturantId)
				SELECT dt.Id, dt.OpeningTime, dt.ClosingTime, @RestaurantId FROM @DayTable dt

			INSERT INTO RestaurantPaymentOption (RestaurantId, PaymentOptionId, QRCode)
				SELECT @RestaurantId, rpt.Id, rpt.Filename FROM @RestaurantPaymentTable rpt

			INSERT INTO RestaurantProfile (ResturantId, CountryId, StateId, DistrictId, City, GeoCode, PhoneNumber, Website, FacebookUrl, InstagramUrl, StatusId, DailyAverageOrderId, Description, NoOfTableId)
				VALUES (@RestaurantId, @CountryId, @StateId, @DistrictId, @City, @GeoCode, @PhoneNumber, @Website, @FacebookUrl, @InstagramUrl, @StatusId, @DailyAverageOrder, @Description, @NumberOfTable)

			
			
				INSERT INTO RestaurantMenu (RestaurantId, Title, QRCode, CreatedBy, CreatedDate, UID)
					VALUES (@RestaurantId, @Name, N'', @CreatedBy, DEFAULT, LEFT(NEWID(),6));
			

			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			DECLARE @ErrorMessage NVARCHAR(MAX)
			ROLLBACK TRANSACTION;
			SELECT @ErrorMessage = ERROR_MESSAGE();
			THROW 50001, @ErrorMessage, 1;
		END CATCH;




	END