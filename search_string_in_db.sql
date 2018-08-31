
DECLARE @table VARCHAR(30)
DECLARE @column VARCHAR(30)
DECLARE @string_to_search VARCHAR(30)


-- Define the string to search
SET @string_to_search = '%String_to_search%'

-- Create a result Table
CREATE TABLE #resultTable
(
	table_name varchar(30),
	column_name VARCHAR(30),
	nb_occ INTEGER
);

-- For each table
DECLARE table_cursor CURSOR 
  LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR 
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @table
WHILE @@FETCH_STATUS = 0
BEGIN

	PRINT '--------------------------------------------------------'
	PRINT @table
	PRINT '--------------------------------------------------------'
-- For Each column
	DECLARE column_cursor CURSOR
		LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@table;


	OPEN column_cursor
	FETCH NEXT FROM column_cursor INTO @column WHILE @@FETCH_STATUS=0
	BEGIN
		DECLARE @count INT

		PRINT @column
    
    -- Insert the name of the table, the column, and the number of occurences in the result's table. 
		INSERT INTO #resultTable
		EXEC('SELECT '''+@table+''' as table_name, '''+@column+''' as column_name, COUNT(*) as nb_occ FROM td.'+@table+' WHERE '+@column+' LIKE '''+@string_to_search+'''')

		FETCH NEXT FROM column_cursor INTO @column
	END

	CLOSE column_cursor
	DEALLOCATE column_cursor

	FETCH NEXT FROM table_cursor INTO @table
END
CLOSE table_cursor
DEALLOCATE table_cursor

SELECT * FROM #resultTable WHERE nb_occ>0;
DROP TABLE #resultTable;
