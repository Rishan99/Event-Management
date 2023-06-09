USE [MenuApp]
GO
/****** Object:  StoredProcedure [dbo].[usp_Bulk_Promocode_Upload]    Script Date: 1/15/2023 9:51:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_Bulk_Promocode_Upload] (
@CreatedBy NVARCHAR,
@RestaurantIds AS RestaurantIdsTable READONLY,
@Details AS BulkPromocodeUploadData READONLY)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @CurrentDate DATETIME = DATEADD(MINUTE, 345, GETUTCDATE()), @PromocodeName NVARCHAR(450), @Promocode NVARCHAR(450)
		   ,@Description NVARCHAR(450), @IsPercentage BIT, @AmountOrPercentage DECIMAL(18, 2), @MinimumPurchase DECIMAL(18, 2)
		   ,@ValidityId INT ,@TotalUsage INT ,@PerUserLimit INT, @StartDate DATETIME ,@ExpiryDate DATETIME ,@StartTime TIME(7)
		   ,@ExpireTime TIME(7), @MaxDiscount DECIMAL(18, 2), @RestaurantId INT

	DECLARE @InsertedPromocodeId TABLE (
		Id INT
	)

	BEGIN TRY
		BEGIN TRANSACTION


		SELECT
			* INTO #temp
		FROM @Details d
		WHILE EXISTS (SELECT * FROM #temp t)
		SELECT TOP (1)
			@PromocodeName = t.[Name]
		   ,@Promocode = t.[Code]
		   ,@Description = t.[Description]
		   ,@IsPercentage = t.[IsPercentage]
		   ,@AmountOrPercentage = t.[Amount Or Percentage]
		   ,@MinimumPurchase = t.[Minimum Purchase]
		   ,@ValidityId = t.[Validity]
		   ,@TotalUsage = t.[Total Usage]
		   ,@PerUserLimit = t.[Per User Limit]
		   ,@StartDate = t.[Start Date]
		   ,@ExpiryDate = t.[Expiry Date]
		   ,@StartTime = t.[Start Time]
		   ,@ExpireTime = t.[Expire Time]
		   ,@MaxDiscount = t.[Maximum Discount]
		FROM #temp t

		BEGIN


			INSERT INTO PromoCode (Name, Code, Description, IsPercentage, AmountOrPercentage, MinPurchase, IsActive, ValidityId, TotalUsageNumber, PerUserLimit, CreatedBy, CreatedDate, StartDate, ExpiryDate, StartTime, ExpireTime, MaxDiscount)
			OUTPUT INSERTED.Id INTO @InsertedPromocodeId
			VALUES (@PromocodeName, @Promocode, @Description, @IsPercentage, @AmountOrPercentage, @MinimumPurchase, DEFAULT, @ValidityId, @TotalUsage, @PerUserLimit, @CreatedBy, DEFAULT, @StartDate, @ExpiryDate, @StartTime, @ExpireTime, @MaxDiscount);

			DELETE TOP (1) FROM #temp

		END
			BEGIN
				INSERT INTO PromoCodeAssociation (PromoCodeId, RestaurantId, CreatedDate, CreatedBy)
				((SELECT pid.Id, ri.RestaurantId, GETDATE(), @CreatedBy FROM @InsertedPromocodeId AS pid CROSS JOIN @RestaurantIds AS ri));
			END
		SELECT T.Validity FROM #temp AS T
		COMMIT TRANSACTION
		DROP TABLE #temp
	END TRY

	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(MAX)
		ROLLBACK TRANSACTION;
		SELECT
			@ErrorMessage = ERROR_MESSAGE();
		THROW 50001, @ErrorMessage, 1;
	END CATCH
END