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
