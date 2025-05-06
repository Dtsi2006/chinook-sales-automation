from sqlalchemy import create_engine, text
import pandas as pd
import os

# Connexion à la base MySQL
user = "root"
password = "2021"
host = "localhost"
port = 3306
database = "chinook"  # Remplace par le nom exact si différent

engine = create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")

# Dossier d'export
export_dir = "exports_csv"
os.makedirs(export_dir, exist_ok=True)

# === 1. Création des vues (si elles n'existent pas déjà) ===
vues_sql = {
    "Customers_Outside_USA": """
        CREATE OR REPLACE VIEW Customers_Outside_USA AS
        SELECT CONCAT(FirstName, ' ', LastName) AS FullName, CustomerId, Country 
        FROM Customer WHERE Country NOT IN ('USA');
    """,
    "Customers_From_Brazil": """
        CREATE OR REPLACE VIEW Customers_From_Brazil AS
        SELECT CONCAT(FirstName, ' ', LastName) AS FullName, CustomerId, Country 
        FROM Customer WHERE Country = 'Brazil';
    """,
    "Invoices_Brazil_Customers": """
        CREATE OR REPLACE VIEW Invoices_Brazil_Customers AS
        SELECT CONCAT(Customer.FirstName, ' ', Customer.LastName) AS FullName,
               Invoice.InvoiceId, Invoice.InvoiceDate, Invoice.BillingCountry
        FROM Customer
        JOIN Invoice ON Invoice.CustomerId = Customer.CustomerId
        WHERE Customer.Country = 'Brazil';
    """,
    "InvoiceLine_Track_Artist": """
        CREATE OR REPLACE VIEW InvoiceLine_Track_Artist AS
        SELECT i.InvoiceLineId, t.Name AS Track, ar.Name AS Artist
        FROM invoiceline i
        JOIN track t ON i.TrackId = t.TrackId
        JOIN album al ON al.AlbumId = t.AlbumId
        JOIN artist ar ON ar.ArtistId = al.ArtistId;
    """,
    "TotalSales_By_SalesAgent": """
        CREATE OR REPLACE VIEW TotalSales_By_SalesAgent AS
        SELECT CONCAT(e.FirstName, ' ', e.LastName) AS SalesAgent,
               SUM(i.Total) AS TotalSales
        FROM employee e
        JOIN customer c ON e.EmployeeId = c.SupportRepId
        JOIN invoice i ON c.CustomerId = i.CustomerId
        GROUP BY e.FirstName, e.LastName;
    """,
    "Top5_Tracks_AllTime": """
        CREATE OR REPLACE VIEW Top5_Tracks_AllTime AS
        SELECT t.Name AS TrackName, SUM(il.Quantity) AS TotalQuantity
        FROM invoiceline il
        JOIN track t ON il.TrackId = t.TrackId
        GROUP BY t.Name
        ORDER BY TotalQuantity DESC
        LIMIT 5;
    """,
    "Active_Customers_By_Country": """
        CREATE OR REPLACE VIEW Active_Customers_By_Country AS
        SELECT c.Country, COUNT(DISTINCT c.CustomerId) AS ActiveCustomers
        FROM customer c
        JOIN invoice i ON i.CustomerId = c.CustomerId
        GROUP BY c.Country
        ORDER BY ActiveCustomers DESC;
    """,
    "Top_Genres_By_Country": """
        CREATE OR REPLACE VIEW Top_Genres_By_Country AS
        SELECT i.BillingCountry AS Country, g.Name AS Genre, SUM(il.Quantity) AS TotalPurchased
        FROM invoiceline il
        JOIN invoice i ON il.InvoiceId = i.InvoiceId
        JOIN track t ON il.TrackId = t.TrackId
        JOIN genre g ON t.GenreId = g.GenreId
        GROUP BY Country, Genre
        ORDER BY Country, TotalPurchased DESC;
    """
}

# Création des vues dans la base
with engine.connect() as conn:
    for name, sql in vues_sql.items():
        try:
            conn.execute(text(sql))
            print(f" Vue {name} créée ou mise à jour")
        except Exception as e:
            print(f" Erreur lors de la création de la vue {name} : {e}")

# === 2. Importer et exporter chaque vue ===
dataframes = {}

for view in vues_sql.keys():
    try:
        df = pd.read_sql_query(f"SELECT * FROM {view}", con=engine)
        dataframes[view] = df
        print(f" {view} chargée avec {len(df)} lignes")

        # Export CSV
        export_path = os.path.join(export_dir, f"{view}.csv")
        df.to_csv(export_path, index=False, encoding='utf-8-sig')
        print(f" Exportée : {export_path}")

    except Exception as e:
        print(f" Erreur pour la vue {view} : {e}")
#importer les fichiers
import subprocess
import platform

# Ouvrir le dossier d'export dans l'explorateur de fichiers
def open_folder(path):
    if platform.system() == "Windows":
        subprocess.Popen(f'explorer "{os.path.abspath(path)}"')
    elif platform.system() == "Darwin":  # macOS
        subprocess.Popen(["open", path])
    else:  # Linux
        subprocess.Popen(["xdg-open", path])

# Appel de la fonction pour ouvrir le dossier exports_csv
open_folder(export_dir)
