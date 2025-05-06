-- Vue 1 : Clients hors USA
CREATE OR REPLACE VIEW Customers_Outside_USA AS
SELECT 
  CONCAT(FirstName, ' ', LastName) AS FullName,
  CustomerId,
  Country 
FROM Customer
WHERE Country NOT IN ('USA');

-- Vue 2 : Clients du Brésil
CREATE OR REPLACE VIEW Customers_From_Brazil AS
SELECT 
  CONCAT(FirstName, ' ', LastName) AS FullName,
  CustomerId,
  Country 
FROM Customer
WHERE Country = 'Brazil';

-- Vue 3 : Factures des clients brésiliens
CREATE OR REPLACE VIEW Invoices_Brazil_Customers AS
SELECT 
  CONCAT(Customer.FirstName, ' ', Customer.LastName) AS FullName,
  Invoice.InvoiceId,
  Invoice.InvoiceDate,
  Invoice.BillingCountry
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.Country = 'Brazil';

-- Vue 4 : Agents commerciaux uniquement
CREATE OR REPLACE VIEW SalesAgents_Only AS
SELECT CONCAT(FirstName, ' ', LastName) AS EmployeeName
FROM Employee
WHERE Title = 'Sales Support Agent';

-- Vue 5 : Pays de facturation uniques
CREATE OR REPLACE VIEW Unique_Billing_Countries AS
SELECT DISTINCT BillingCountry 
FROM invoice;

-- Vue 6 : Noms des clients brésiliens avec facture
CREATE OR REPLACE VIEW Brazilian_Customers_Invoices AS
SELECT DISTINCT CONCAT(Customer.FirstName, ' ', Customer.LastName) AS FullName
FROM Customer
JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.Country = 'Brazil';

-- Vue 7 : Factures par agent commercial
CREATE OR REPLACE VIEW Invoices_By_SalesAgent AS
SELECT CONCAT(Employee.FirstName, ' ', Employee.LastName) AS EmployeeName, 
       Invoice.InvoiceId, Invoice.InvoiceDate, Invoice.BillingCountry
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId;

-- Vue 8 : Détail factures + client + vendeur
CREATE OR REPLACE VIEW Invoices_Details_With_SalesAgent AS
SELECT CONCAT(Customer.FirstName, ' ', Customer.LastName) AS CustomerName,
       CONCAT(Employee.FirstName, ' ', Employee.LastName) AS EmployeeName,
       Employee.Country, Invoice.InvoiceId, Invoice.InvoiceDate, Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
JOIN Employee ON Employee.EmployeeId = Customer.SupportRepId;

-- Vue 9 : Nombre de factures en 2021 et 2024
CREATE OR REPLACE VIEW Invoice_Count_2021_2024 AS
SELECT YEAR(InvoiceDate) AS Year, COUNT(*) AS InvoiceCount
FROM invoice
WHERE YEAR(InvoiceDate) IN (2021, 2024)
GROUP BY YEAR(InvoiceDate);

-- Vue 10 : Nombre de lignes pour la facture 37
CREATE OR REPLACE VIEW InvoiceLine_Count_37 AS
SELECT InvoiceId, COUNT(*) AS LineItemCount
FROM invoiceline
WHERE InvoiceId = 37
GROUP BY InvoiceId;

-- Vue 11 : Nombre de lignes par facture
CREATE OR REPLACE VIEW InvoiceLine_Count_By_Invoice AS
SELECT InvoiceId, COUNT(*) AS LineItemCount
FROM invoiceline
GROUP BY InvoiceId;

-- Vue 12 : Nom du morceau par ligne de facture
CREATE OR REPLACE VIEW InvoiceLine_Track AS
SELECT il.InvoiceLineId, t.Name AS Track
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId;

-- Vue 13 : Morceau et artiste
CREATE OR REPLACE VIEW InvoiceLine_Track_Artist AS
SELECT il.*, t.Name AS Track, ar.Name AS Artist
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId;

-- Vue 14 : Nombre de factures par pays
CREATE OR REPLACE VIEW Invoice_Count_By_Country AS
SELECT BillingCountry, COUNT(*) AS InvoiceCount
FROM invoice
GROUP BY BillingCountry;

-- Vue 15 : Nombre de morceaux par playlist
CREATE OR REPLACE VIEW Track_Count_By_Playlist AS
SELECT p.Name AS Playlist, COUNT(*) AS TrackCount
FROM playlist p
JOIN playlisttrack pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.Name;

-- Vue 16 : Détail des morceaux sans ID
CREATE OR REPLACE VIEW Track_Details AS
SELECT t.Name AS Title, a.Title AS Album, m.Name AS MediaType, g.Name AS Genre
FROM track t
JOIN mediatype m ON t.MediaTypeId = m.MediaTypeId
JOIN genre g ON t.GenreId = g.GenreId
JOIN album a ON t.AlbumId = a.AlbumId;

-- Vue 17 : Factures avec nombre de lignes
CREATE OR REPLACE VIEW Invoices_With_Line_Count AS
SELECT i.InvoiceId, i.InvoiceDate, i.BillingCountry, COUNT(il.InvoiceLineId) AS LineItemCount
FROM invoice i
JOIN invoiceline il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId, i.InvoiceDate, i.BillingCountry;

-- Vue 18 : Ventes par agent
CREATE OR REPLACE VIEW TotalSales_By_SalesAgent AS
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS SalesAgent, SUM(i.Total) AS TotalSales
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY SalesAgent;

-- Vue 19 : Agent avec plus de ventes en 2021
CREATE OR REPLACE VIEW TopSalesAgent_2021 AS
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS SalesAgent, SUM(i.Total) AS TotalSales
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
WHERE YEAR(i.InvoiceDate) = 2021
GROUP BY SalesAgent
ORDER BY TotalSales DESC
LIMIT 1;

-- Vue 20 : Agent avec plus de ventes en 2022
CREATE OR REPLACE VIEW TopSalesAgent_2022 AS
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS SalesAgent, SUM(i.Total) AS TotalSales
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
WHERE YEAR(i.InvoiceDate) = 2022
GROUP BY SalesAgent
ORDER BY TotalSales DESC
LIMIT 1;

-- Vue 21 : Agent avec plus de ventes en général
CREATE OR REPLACE VIEW TopSalesAgent_AllTime AS
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS SalesAgent, SUM(i.Total) AS TotalSales
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY SalesAgent
ORDER BY TotalSales DESC
LIMIT 1;

-- Vue 22 : Nombre de clients par agent
CREATE OR REPLACE VIEW Customer_Count_By_SalesAgent AS
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS SalesAgent, COUNT(c.CustomerId) AS CustomerCount
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
GROUP BY SalesAgent;

-- Vue 23 : Ventes par pays
CREATE OR REPLACE VIEW TotalSales_By_Country AS
SELECT BillingCountry AS Country, SUM(Total) AS TotalSales
FROM invoice
GROUP BY BillingCountry
ORDER BY TotalSales DESC;

-- Vue 24 : Morceau le plus acheté en 2023
CREATE OR REPLACE VIEW TopTrack_2023 AS
SELECT t.Name AS TrackName, SUM(il.Quantity) AS TotalQuantity
FROM invoiceline il
JOIN invoice i ON il.InvoiceId = i.InvoiceId
JOIN track t ON il.TrackId = t.TrackId
WHERE YEAR(i.InvoiceDate) = 2023
GROUP BY t.Name
ORDER BY TotalQuantity DESC
LIMIT 1;

-- Vue 25 : Top 5 morceaux tous temps
CREATE OR REPLACE VIEW Top5_Tracks_AllTime AS
SELECT t.Name AS TrackName, SUM(il.Quantity) AS TotalQuantity
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY TotalQuantity DESC
LIMIT 5;

-- Vue 26 : Top 3 artistes
CREATE OR REPLACE VIEW Top3_Artists AS
SELECT ar.Name AS ArtistName, SUM(il.UnitPrice * il.Quantity) AS TotalSales
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY TotalSales DESC
LIMIT 3;

-- Vue 27 : Type de média le plus acheté
CREATE OR REPLACE VIEW Most_Popular_MediaType AS
SELECT m.Name AS MediaType, SUM(il.Quantity) AS TotalPurchased
FROM invoiceline il
JOIN track t ON il.TrackId = t.TrackId
JOIN mediatype m ON t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY TotalPurchased DESC
LIMIT 1;

-- Vue 28 : Genre musical le plus acheté par pays
CREATE OR REPLACE VIEW Top_Genres_By_Country AS
SELECT i.BillingCountry AS Country, g.Name AS Genre, SUM(il.Quantity) AS TotalPurchased
FROM invoiceline il
JOIN invoice i ON il.InvoiceId = i.InvoiceId
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY Country, Genre
ORDER BY Country, TotalPurchased DESC;

-- Vue 29 : Nombre de clients actifs par pays
CREATE OR REPLACE VIEW Active_Customers_By_Country AS
SELECT c.Country, COUNT(DISTINCT c.CustomerId) AS ActiveCustomers
FROM customer c
JOIN invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY ActiveCustomers DESC;