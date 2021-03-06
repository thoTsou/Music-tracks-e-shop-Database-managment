/****** Script for SelectTopNRows command from SSMS  ******/

CREATE PROCEDURE q6
(@_YEAR INT)
AS
BEGIN


Select Track.Name as TrackName,Artist.Name as ArtistName , DATEPART(yy,(Invoice.InvoiceDate)) as 'Year' ,  CASE WHEN  DATEPART(quarter , (Invoice.InvoiceDate) ) = 1 THEN InvoiceLine.UnitPrice END AS Q1 ,
																										 CASE WHEN  DATEPART(quarter , (Invoice.InvoiceDate) ) = 2 THEN InvoiceLine.UnitPrice END AS Q2,
																										 CASE WHEN  DATEPART(quarter , (Invoice.InvoiceDate) ) = 3 THEN InvoiceLine.UnitPrice END AS Q3,
																										 CASE WHEN  DATEPART(quarter , (Invoice.InvoiceDate) ) = 4 THEN InvoiceLine.UnitPrice END AS Q4   
                                                                                                                                                                                  

from InvoiceLine,Invoice,Track,Artist ,Album
where InvoiceLine.InvoiceId = Invoice.InvoiceId AND  DATEPART(yy,(Invoice.InvoiceDate) ) = @_YEAR
AND InvoiceLine.TrackId = Track.TrackId AND Track.AlbumId = Album.AlbumId AND Album.ArtistId = Artist.ArtistId
order by TrackName,ArtistName

END


EXEC q6 2010

