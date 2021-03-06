
Create procedure proc6
AS
BEGIN

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
           WHERE TABLE_NAME = N'InvoiceStatistics')

			BEGIN
			           DECLARE @tran1 NVARCHAR(20)='Transaction1'
					   BEGIN TRY 
					       BEGIN TRAN @tran1


				                BEGIN TRY

								DELETE FROM InvoiceStatistics
								WHERE InvoiceStatistics.TrackId > 0

								END TRY
								BEGIN CATCH
								  PRINT '-2'
								END CATCH


								BEGIN TRY
								INSERT INTO InvoiceStatistics (TrackId,GenreId,TotalTrackCharge)
								Select Track.TrackId , Track.GenreId , subq1.totalSum  
								from Track , (Select InvoiceLine.TrackId as Id , sum(UnitPrice) as totalSum 
												from InvoiceLine
												group by InvoiceLine.TrackId)subq1
								where subq1.Id = Track.TrackId
								END TRY
								BEGIN CATCH
								 PRINT '-3'
								END CATCH


                       COMMIT TRAN @tran1
                       END TRY

					   BEGIN CATCH
					   SELECT ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_SEVERITY()
					    ROLLBACK TRAN @tran1 
					   END CATCH
					    				
				  
			END
	ELSE      
			BEGIN
			         DECLARE @tran2 NVARCHAR(20)='Transaction2'
					   BEGIN TRY 
					       BEGIN TRAN @tran2

				                 BEGIN TRY
								 CREATE
										TABLE InvoiceStatistics
									(
									TrackId int NOT NULL,
									GenreId int NOT NULL,
									TotalTrackCharge decimal(18,7),
									TimeCreated datetime NOT NULL DEFAULT CURRENT_TIMESTAMP

									CONSTRAINT InvoiceStatistics_pk PRIMARY KEY ( TrackId )  )
                                   END TRY
								   BEGIN CATCH
								     PRINT '-1'
								   END CATCH


								        BEGIN TRY
   										INSERT INTO InvoiceStatistics (TrackId,GenreId,TotalTrackCharge)
											Select Track.TrackId , Track.GenreId , subq1.totalSum  
											from Track , (Select InvoiceLine.TrackId as Id , sum(UnitPrice) as totalSum 
															from InvoiceLine
															group by InvoiceLine.TrackId)subq1
											where subq1.Id = Track.TrackId
										END TRY
										BEGIN CATCH
										PRINT '-3'
										END CATCH
										 
								 COMMIT TRAN @tran2
							      END TRY

								  BEGIN CATCH
								  SELECT ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_SEVERITY()
								   ROLLBACK TRAN @tran2 
								   END CATCH



			END
	
END

