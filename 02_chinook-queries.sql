-- 1. Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT 
  CONCAT(FirstName, ' ', LastName) AS FullName,
  CustomerId,
  Country 
FROM Customer
WHERE Country NOT IN ('USA');

-- 2. Provide a query only showing the Customers from Brazil.
SELECT 
  CONCAT(FirstName, ' ', LastName) AS FullName,
  CustomerId,
  Country 
FROM Customer
WHERE Country = 'Brazil';

-- 3. Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full 
#name, Invoice ID, Date of the invoice and billing country.
SELECT 
  CONCAT(Customer.FirstName, ' ', Customer.LastName) AS FullName,
  Invoice.InvoiceId,
  Invoice.InvoiceDate,
  Invoice.BillingCountry
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.Country = 'Brazil';

-- 4. Provide a query showing only the Employees who are Sales Agents.
SELECT 
  CONCAT(FirstName, ' ', LastName) AS EmployeeName
FROM Employee
WHERE Title = 'Sales Support Agent';

-- 5. Provide a query showing a unique list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM invoice;

-- 6. Provide a query showing the invoices of customers who are from Brazil.
SELECT DISTINCT 
  CONCAT(Customer.FirstName, ' ', Customer.LastName) AS FullName
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.Country = 'Brazil';

-- 7. Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT 
  CONCAT(Employee.FirstName, ' ', Employee.LastName) AS EmployeeName, 
  Invoice.InvoiceId, 
  Invoice.InvoiceDate, 
  Invoice.BillingCountry
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId;

-- 8. Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT 
  CONCAT(Customer.FirstName, ' ', Customer.LastName) AS CustomerName,
  CONCAT(Employee.FirstName, ' ', Employee.LastName) AS EmployeeName,
  Employee.Country,
  Invoice.InvoiceId,
  Invoice.InvoiceDate,
  Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId;

-- 9. How many Invoices were there in 2021 and 2024? What are the respective total sales for each of those years?
SELECT  Count(*)
FROM invoice
where YEAR(InvoiceDate) in (2021,2024);

-- 10. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT InvoiceId, count(InvoiceId)
FROM invoiceline
WHERE InvoiceId = '37';

-- 11. Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice.
SELECT InvoiceId, count(InvoiceId)
FROM invoiceline
group by InvoiceId;

-- 12. Provide a query that includes the track name with each invoice line item.
SELECT InvoiceLineId, track.Name
FROM invoiceline
JOIN track ON invoiceline.TrackId = track.TrackId;

-- 13. Provide a query that includes the purchased track name AND artist name with each invoice line item.
select i.*, t.name as 'track', ar.name as 'artist'
from invoiceline as i
	join track as t on i.trackid = t.trackid
	join album as al on al.albumid = t.albumid
	join artist as ar on ar.artistid = al.artistid;

-- 14. Provide a query that shows the # of invoices per country.
SELECT BillingCountry, count(billingcountry) as '# of invoices'
FROM invoice
group by BillingCountry;

-- 15. Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resultant table.
SELECT playlist.Name AS Playlist, 
count(*) AS NombreDeMorceaux
FROM playlist
JOIN playlisttrack ON playlist.PlaylistId = playlisttrack.PlaylistId
group by playlist.Name;

-- 16. Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
SELECT t.Name AS Title, 
a.Title AS album,
m.Name AS TypeMedia,
g.Name AS Genre
FROM track t
JOIN mediatype m on t.MediaTypeId = m.MediaTypeId
JOIN genre g on t.GenreId = g.GenreId
JOIN album a on t.AlbumId = a.AlbumId;

-- 17. Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT 
  i.InvoiceId,
  i.InvoiceDate,
  i.BillingCountry,
  COUNT(il.InvoiceLineId) AS NombreDeLignes
FROM invoice i
JOIN invoiceline il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId, i.InvoiceDate, i.BillingCountry;

-- 18. Provide a query that shows total sales made by each sales agent.
SELECT 
  CONCAT(e.FirstName, ' ', e.LastName) AS NomAgent,
  SUM(i.Total) AS TotalVentes
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY NomAgent;

-- 19. Which sales agent made the most in sales in 2021?
SELECT 
	CONCAT(e.FirstName, ' ', e.LastName) AS NomAgent,
	SUM(i.Total) AS TotalVentes
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
WHERE YEAR(i.InvoiceDate) = 2021
GROUP BY  NomAgent
ORDER BY TotalVentes DESC
LIMIT 1;

-- 20. Which sales agent made the most in sales in 2010?
SELECT 
   CONCAT(e.FirstName, ' ', e.LastName) AS NomAgent,
   SUM(i.Total) AS TotalVentes
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
WHERE YEAR(i.InvoiceDate) = 2022
GROUP BY  NomAgent
ORDER BY TotalVentes DESC
LIMIT 1;

-- 21. Which sales agent made the most in sales over all?
SELECT 
   CONCAT(e.FirstName, ' ', e.LastName) AS NomAgent,
   SUM(i.Total) AS TotalVentes
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY NomAgent
ORDER BY TotalVentes DESC
LIMIT 1;

-- 22. Provide a query that shows the # of customers assigned to each sales agent.
SELECT 
  CONCAT(e.FirstName, ' ', e.LastName) AS NomAgent,
  COUNT(c.CustomerId) AS NombreDeClients
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
GROUP BY NomAgent;

-- 23. Provide a query that shows the total sales per country. Which country's customers spent the most?
SELECT 
  BillingCountry AS Pays,
  SUM(Total) AS TotalVentes
FROM invoice
GROUP BY BillingCountry
ORDER BY TotalVentes DESC;

-- 24. Provide a query that shows the most purchased track of 2023.
SELECT 
  t.Name AS TrackName,
  SUM(il.Quantity) AS TotalQuantity
FROM invoiceline il
JOIN invoice i ON il.InvoiceId = i.InvoiceId
JOIN track t ON il.TrackId = t.TrackId
WHERE YEAR(i.InvoiceDate) = 2023
GROUP BY t.Name
ORDER BY TotalQuantity DESC
LIMIT 1;

-- 25. Provide a query that shows the top 5 most purchased tracks over all.
SELECT 
  t.Name AS TrackName,
  SUM(il.Quantity) AS TotalQuantity
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY TotalQuantity DESC
LIMIT 5;

-- 26. Provide a query that shows the top 3 best selling artists.
SELECT 
  ar.Name AS ArtistName,
  SUM(il.UnitPrice * il.Quantity) AS TotalSales
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY TotalSales DESC
LIMIT 3;

-- 27. Provide a query that shows the most purchased Media Type.
SELECT 
  m.Name AS MediaType,
  SUM(il.Quantity) AS TotalPurchased
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
JOIN mediatype m ON t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY TotalPurchased DESC
LIMIT 1;

-- 28.the most purchased music genre for each country
SELECT 
  i.BillingCountry AS Country,
  g.Name AS Genre,
  SUM(il.Quantity) AS TotalPurchased
FROM invoiceline il
JOIN invoice i ON il.InvoiceId = i.InvoiceId
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY Country, Genre
ORDER BY Country, TotalPurchased DESC;

-- 29.Number of active customers per country having at least one invoice
SELECT 
  c.Country,
  COUNT(DISTINCT c.CustomerId) AS ActiveCustomers
FROM customer c
JOIN invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY ActiveCustomers DESC;

