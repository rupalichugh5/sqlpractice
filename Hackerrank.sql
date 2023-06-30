/*
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* * * * * 
* * * * 
* * * 
* * 
*
Write a query to print the pattern P(20).
*/
ECLARE @Counter INT 
SET @Counter = 20
WHILE ( @Counter >= 1 )
BEGIN
    PRINT replicate(' *',@Counter)
    SET @Counter  = @Counter - 1
END

/*
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* 
* * 
* * * 
* * * * 
* * * * *
Write a query to print the pattern P(20).
*/
DECLARE @Counter INT 
SET @Counter = 1
WHILE ( @Counter <= 20 )
BEGIN
    PRINT replicate(' *',@Counter)
    SET @Counter  = @Counter + 1
END


/*
A median is defined as a number separating the higher half of a data set from the lower half. 
Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
*/
select cast(round(((SELECT MAX(Lat_N) FROM
   (SELECT TOP 50 PERCENT Lat_N FROM Station ORDER BY Lat_N) AS BH)
   +
   (SELECT Min(Lat_N) FROM
   (SELECT TOP 50 PERCENT Lat_N FROM Station ORDER BY Lat_N desc) AS TH))/2,4) as decimal(6,4)) as median