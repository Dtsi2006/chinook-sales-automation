
# Projet Chinook – Automatisation et Analyse des Rapports de Ventes

Ce projet fait partie du programme **« 12 projets pour devenir Data Analyst »** proposé par [Lecoinstat](https://lecoinstat.com/) et animé par @Natacha Njongwa Yepnga.

---

## 📌 Contexte

L’objectif était de répondre à une problématique métier concrète :  
> **Fournir à l’entreprise un rapport automatisé sur les ventes totales par produit, genre musical, client et pays pour le dernier trimestre.**

Les données utilisées proviennent de la **Chinook Database**, une base de référence contenant des informations détaillées sur les ventes musicales, les clients, les vendeurs et les genres.

---

## 💡 Résumé storytelling

Grâce à ce projet, j’ai su transformer des données brutes issues de Chinook Database en **insights clairs et actionnables**, avec un reporting automatisé et des visualisations percutantes sous Power BI.  
Ce travail m’a permis de consolider mes compétences en :
- Extraction SQL (requêtes et vues)
- Automatisation des exports CSV en Python (via `MySQL` et `pandas`)
- Construction de dashboards interactifs (Power BI)  

Une expérience concrète de bout en bout, allant de la base de données jusqu’au tableau de bord décisionnel.

---

## 🏗️ Étapes réalisées

✅ Extraction et agrégation des données via **requêtes SQL** (`SELECT`, `WHERE`, `GROUP BY`, `HAVING`)  
✅ Création de **vues SQL** pour automatiser les rapports  
✅ Automatisation des exports CSV en utilisant **Python** (`MySQL`, `pandas`)  
✅ Création d’un **dashboard interactif sous Power BI** pour analyser les résultats et fournir des insights métier

---

## 📈 KPI clés (issus des dashboards)

- **Chiffre d’affaires total** : 2,33 K  
- **Unités vendues** : 557  
- **Nombre total de genres musicaux** : 24  
- **Nombre de clients actifs** : 59  

### Principaux insights
- 📌 Genres musicaux les plus performants : Rock, Latin, Metal  
- 📌 Répartition géographique : USA en tête (22 % des ventes), suivi du Canada, Brésil et France  
- 📌 Top vendeurs : Jane Peacock, Margaret Park, Steve Johnson  
- 📌 Évolution des ventes par année et par vendeur  
- 📌 Analyse détaillée des performances par genre et par pays

---

## 📂 Contenu du dépôt

```
/sql
  chinook-queries.sql
  Creation_de_vues_sur_MYSQL.sql
/python
  export_views_to_csv.py
/dashboard
  PDF des dashboards Power BI
```

---

## 💻 Technologies utilisées

- **MySQL** (requêtes, agrégats, vues)  
- **Python** (`sqlalchemy`, `pandas` pour l’automatisation des exports)  
- **Power BI** (visualisation et création de dashboard interactif)

---

## 🔗 Ressources externes

- Source exercices : [GitHub – LucasMcL/15-sql_queries_02-chinook](https://github.com/LucasMcL/15-sql_queries_02-chinook)  
- Formation : [Lecoinstat](https://lecoinstat.com/) – 12 projets pour devenir Data Analyst

---

## 📥 Comment utiliser ce projet

1. Importer la base **Chinook** dans votre instance MySQL  
2. Exécuter les scripts SQL dans le dossier `/sql` pour créer les vues  
3. Lancer le script Python `/python/export_views_to_csv.py` pour générer les fichiers CSV  
4. Charger les CSV dans Power BI pour recréer ou adapter le dashboard


