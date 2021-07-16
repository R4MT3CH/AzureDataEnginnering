/* SQL Starter Script ** CANDIDATES - USE THIS IN YOUR SUBMISSION **
Here’s the problem: Let's say we had a table of all US Presidents, with the date they took office and the date they died. 
Let's say I want to get the periods of time (start date / end date) where at least 3 US Presidents or former US Presidents 
were alive at the same time, sorted in order of 
1.) the most number of presidents/former presidents alive at one time and 
2.) the longest period of time. Here's a sample resultset I am looking for:
NumberOfPresidentsAlive StartDate EndDate NumberOfDays
6 1/1/1853 12/31/1853 364
6 5/5/1854 5/6/1854 1
5 1/1/1854 3/1/1854 59
....
Note that the periods of time should be based on calendar date and that both efficiency and elegancy are highly desired properties of the solution. 
However imperfect, solutions are expected to be authored by the submitter and not shared with others. For bonus points, include a column with a 
comma separated list of the president's names. 
*/
IF OBJECT_ID('tempdb..#President') IS NOT NULL DROP TABLE #President;
Create table #President 
(
PresidentID INT IDENTITY(1,1) PRIMARY KEY,
Name varchar(60),
StartDate date,
DiedDate date
) WITH (DATA_COMPRESSION=PAGE);
go
-- Data Source: https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States_by_date_of_death
Insert into #President(Name,StartDate,DiedDate) 
values 
('George Washington','4/1/1789','12/14/1799')
,('Thomas Jefferson','3/4/1801','7/4/1826')
,('John Adams','3/4/1797','7/4/1826')
,('James Monroe','3/4/1817','7/4/1831')
,('James Madison','3/4/1809','6/28/1836')
,('William Henry Harrison','3/4/1841','4/4/1841')
,('Andrew Jackson','3/4/1829','6/8/1845')
,('John Quincy Adams','3/4/1825','2/23/1848')
,('James K. Polk','3/4/1845','6/15/1849')
,('Zachary Taylor','3/4/1849','7/9/1850')
,('John Tyler','4/4/1841','1/18/1862')
,('Martin Van Buren','3/4/1837','7/24/1862')
,('Abraham Lincoln','3/4/1861','4/15/1865')
,('James Buchanan','3/4/1857','6/1/1868')
,('Franklin Pierce','3/4/1853','10/8/1869')
,('Millard Fillmore','7/9/1850','3/8/1874')
,('Andrew Johnson','4/15/1865','7/31/1875')
,('James A. Garfield','3/4/1881','9/19/1881')
,('Ulysses S. Grant','3/4/1869','7/23/1885')
,('Chester A. Arthur','9/19/1881','11/18/1886')
,('Rutherford B. Hayes','3/4/1877','1/17/1893')
,('Benjamin Harrison','3/4/1889','3/13/1901')
,('William McKinley','3/4/1897','9/14/1901')
,('Grover Cleveland','3/4/1885','6/24/1908')
--,('Grover Cleveland','3/4/1893', '6/24/1908'),
,('Theodore Roosevelt','9/14/1901','1/6/1919')
,('Warren G. Harding','3/4/1921','7/2/1923')
,('Woodrow Wilson','3/4/1913','2/3/1924')
,('William Howard Taft','3/4/1909','3/8/1930')
,('Calvin Coolidge','7/2/1923','1/5/1933')
,('Franklin D. Roosevelt','3/4/1933','4/12/1945')
,('John F. Kennedy','1/20/1961','11/22/1963')
,('Herbert Hoover','3/4/1929','10/20/1964')
,('Dwight D. Eisenhower','1/20/1953','3/28/1969')
,('Harry S. Truman','4/12/1945','12/26/1972')
,('Lyndon B. Johnson','11/22/1963','1/22/1973')
,('Richard Nixon','1/20/1969','4/22/1994')
,('Ronald Reagan','1/20/1981','6/5/2004')
,('Gerald Ford','7/9/1974','12/26/2006')
,('Jimmy Carter','1/20/1977',Null)
,('George H. W. Bush','1/20/1989',Null)
,('Bill Clinton','1/20/1993',Null)
,('George W. Bush','1/20/2001',Null)
,('Barack Obama','1/20/2009',Null)
,('Donald Trump','1/20/2017',Null);

SELECT * FROM #President Order By StartDate;

--------------------------------

SELECT
    P2.Name, P2.StartDate,P2.DiedDate,P1.Name,P1.StartDate,P1.DiedDate
from  #President P1
    cross join #President as P2
where
	P1.StartDate <= P2.DiedDate
	AND P1.StartDate >= P2.StartDate
	AND P1.DiedDate >= P2.DiedDate
	ORDER BY P2.StartDate ,P2.DiedDate;

---------------------------------

SELECT
    P2.Name, count(P1.Name) As PresidentAliveDurigPeriod,
	P2.StartDate ,P2.DiedDate As EndDate, 
	DATEDIFF(day,P2.StartDate,P2.DiedDate) As DaysAlive,
	string_agg(P1.Name, ', ') As PresidentList
from  #President P1
    cross join #President as P2
where
		P1.StartDate <= P2.DiedDate
	AND P1.StartDate <= P2.DiedDate
	AND P1.DiedDate >= P2.DiedDate
	GROUP BY P2.Name,P2.StartDate ,P2.DiedDate
	ORDER BY P2.StartDate ,P2.DiedDate;	
