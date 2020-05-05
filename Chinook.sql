--1. `non_usa_customers.sql`: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
select CustomerId, FirstName + ' ' + LastName as FullName, Country from Customer
where Country != 'USA'

--2. `brazil_customers.sql`: Provide a query only showing the Customers from Brazil.
select CustomerId, FirstName + ' ' + LastName as FullName, Country from Customer
where Country = 'Brazil'

--3. `brazil_customers_invoices.sql`: Provide a query showing the Invoices of customers who are from Brazil. 
--The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
select cust.CustomerId, FirstName + ' ' + LastName as FullName, Country, InvoiceId, InvoiceDate, BillingCountry from Customer as cust
left join Invoice as inv on inv.CustomerId = cust.CustomerId
where Country = 'Brazil'


--4. `sales_agents.sql`: Provide a query showing only the Employees who are Sales Agents.
select * from Employee
where Title like '%Agent'

--5. `unique_invoice_countries.sql`: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
select distinct BillingCountry from Invoice

--6. `sales_agent_invoices.sql`: Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
select SUM (Total) as InvoiceTotal, emp.FirstName, emp.LastName 
from Invoice as inv
join Customer as cust on inv.CustomerId = cust.CustomerId
join Employee as emp on cust.SupportRepId = emp.EmployeeId
group by emp.LastName, emp.FirstName
order by emp.LastName, emp.FirstName

--7. `invoice_totals.sql`: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
select Total as InvoiceTotal, cust.FirstName + ' ' + cust.LastName as CustomerFullName, cust.Country, emp.FirstName + ' ' + emp.LastName as SalesAgentName 
from Invoice as inv
join Customer as cust on inv.CustomerId = cust.CustomerId
join Employee as emp on cust.SupportRepId = emp.EmployeeId

--8. `total_invoices_year.sql`: How many Invoices were there in 2009 and 2011?
select datepart(Year, InvoiceDate) as Year, count (InvoiceDate) as [Total Invoices] from invoice
group by datepart(Year, InvoiceDate)
order by datepart(Year, InvoiceDate)

--9. `total_sales_year.sql`: What are the respective total sales for each of those years?
select datepart(Year, InvoiceDate) as Year, count (InvoiceDate) as [Total Invoices], 
SUM (Total) as TotalSales
from invoice
group by datepart(Year, InvoiceDate)
order by datepart(Year, InvoiceDate)

--10. `invoice_37_line_item_count.sql`: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
select count(invoiceId) 
from InvoiceLine 
where InvoiceId = 37

--11. `line_items_per_invoice.sql`: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: [GROUP BY](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql)
select InvoiceId, count(InvoiceId) as CountInvoiceId
from InvoiceLine 
group by InvoiceId

--12. `line_item_track.sql`: Provide a query that includes the purchased track name with each invoice line item.
select InvoiceLineId, InvoiceId, t.TrackId, t.Name, il.UnitPrice, Quantity from InvoiceLine as il
join track as t 
on il.trackid = t.TrackId

--13. `line_item_track_artist.sql`: Provide a query that includes the purchased track name AND artist name with each invoice line item.
select InvoiceLineId, InvoiceId, t.TrackId, t.Name as Track, art.Name as Artist, il.UnitPrice,  Quantity from InvoiceLine as il
join track as t on il.trackid = t.TrackId
join album as alb on t.AlbumId = alb.AlbumId
join artist as art on art.ArtistId = alb.ArtistId

--14. `country_invoices.sql`: Provide a query that shows the # of invoices per country. HINT: [GROUP BY](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql)
select BillingCountry, count(BillingCountry) as CountInvoices
from Invoice
group by BillingCountry

--15. `playlists_track_count.sql`: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table
select count (pt.TrackId) as NumberOfTracks, p.Name
from PlaylistTrack as pt
	join Playlist as p on pt.PlaylistId = p.PlaylistId
group by p.Name

--16. `tracks_no_id.sql`: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.
select t.Name as Track, alb.Title as Album, mt.Name as MediaType, g.Name as Genre, Composer, Milliseconds, Bytes, UnitPrice from Track as t
join album as alb on alb.AlbumId = t.AlbumId
join MediaType as mt on mt.MediaTypeId = t.MediaTypeId
join genre as g on g.GenreId = t.GenreId


--17. `invoices_line_item_count.sql`: Provide a query that shows all Invoices but includes the # of invoice line items.
select count(InvoiceLineId) as NumberOfInvoiceLineItems, i.InvoiceId from Invoice as i
join InvoiceLine as il on i.InvoiceId = il.InvoiceId
group by i.InvoiceId

--18. `sales_agent_total_sales.sql`: Provide a query that shows total sales made by each sales agent.
select 
	SUM(i.Total) AS 'TotalSales', e.EmployeeId, e.Title, e.LastName, e.FirstName
from Employee as e
	join Customer as c on c.SupportRepId = e.EmployeeId
	join Invoice as i on i.CustomerId = c.CustomerId
where e.Title = '%Agent'
group by e.EmployeeId, e.Title, e.LastName, e.FirstName

--19. `top_2009_agent.sql`: Which sales agent made the most in sales in 2009? HINT: [TOP](https://docs.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql)
select Top(1) e.EmployeeId, SUM(i.Total) as TotalSales, e.LastName, e.FirstName from Invoice as i
left join customer as c on i.CustomerId = c.CustomerId
left join Employee as e on c.SupportRepId = e.EmployeeId
group by e.EmployeeId, e.LastName, e.FirstName
order by SUM(i.Total) desc

--20. `top_agent.sql`: Which sales agent made the most in sales over all?
select Top(1) e.Title, SUM(i.Total) as TotalSales, e.LastName, e.FirstName from Invoice as i
left join customer as c on i.CustomerId = c.CustomerId
left join Employee as e on c.SupportRepId = e.EmployeeId
where Title like '%Agent'
group by e.Title, e.LastName, e.FirstName
order by SUM(i.Total) desc

--21. `sales_agent_customer_count.sql`: Provide a query that shows the count of customers assigned to each sales agent.
select e.EmployeeId, e.FirstName, e.LastName, count(c.CustomerId) as CountOfCustomers from Employee as e
join Customer as c on e.EmployeeId = c.SupportRepId
group by e.EmployeeId, e.FirstName, e.LastName

--22. `sales_per_country.sql`: Provide a query that shows the total sales per country.
select BillingCountry, SUM(Total) as TotalSales
from Invoice
group by BillingCountry

--23. `top_country.sql`: Which country's customers spent the most?
select Top(1) BillingCountry, SUM(Total) as TotalSales
from Invoice
group by BillingCountry
order by Sum(Total) desc

--24. `top_2013_track.sql`: Provide a query that shows the most purchased track of 2013.
select COUNT(InvoiceLine.InvoiceLineId) AS purchaseCount, Track.[Name]
from InvoiceLine
	join Track
		ON InvoiceLine.TrackId = Track.TrackId
	join Invoice
		ON InvoiceLine.InvoiceId = Invoice.InvoiceId
WHERE datepart(Year, InvoiceDate) = 2013
GROUP BY Track.[Name]
ORDER BY COUNT(*) DESC

--25. `top_5_tracks.sql`: Provide a query that shows the top 5 most purchased songs.
select TOP(5) t.Name,
	count(il.TrackId) as NumberOFPurchased
from Track as t
	join InvoiceLine as il
		on t.TrackId = il.TrackId
group by t.Name
order by COUNT(il.TrackId) desc

--26. `top_3_artists.sql`: Provide a query that shows the top 3 best selling artists.
select TOP(3)a.Name,
	SUM(i.Total) as NumberOfSales,
	COUNT(a.ArtistId) as AmountOfPurchases
from Artist as a
	join Album as al on a.ArtistId = al.ArtistId
	join Track as t on al.AlbumId = t.AlbumId
	join InvoiceLine as il on il.TrackId = t.TrackId
	join Invoice as i on i.InvoiceId = il.InvoiceId
group by a.Name
order by SUM(i.Total) desc

--27. `top_media_type.sql`: Provide a query that shows the most purchased Media Type.
select TOP(1) mt.Name,
	SUM(il.UnitPrice) as TotalSales,
	COUNT(mt.Name) as AmountOfPurchases
from InvoiceLine as il
	join Track as t on il.TrackId = t.TrackId
	join MediaType as mt on t.MediaTypeId = mt.MediaTypeId	
group by mt.Name
order by COUNT(mt.Name) desc
