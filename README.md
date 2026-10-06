# SDA Academy — SQL for Data Analysts

Environnement pédagogique complet pour apprendre SQL comme un Data Analyst en entreprise.

## Stack

- PostgreSQL Cloud via Supabase
- DBeaver pour SQL
- Git + GitHub pour le versionnement
- VS Code pour éditer les fichiers SQL/Markdown
- Power BI / Python pour la suite de la chaîne analytique

## Architecture

```text
                         SDA RETAIL
                             |
                 +-----------+-----------+
                 |                       |
            PostgreSQL Cloud          GitHub
             (Supabase)             (SQL/code)
                 |                       |
          +------+------+                |
          |             |                |
       DBeaver      SQL Editor           |
          |             |                |
          +------+------+----------------+
                         |
                    Data Analyst
                         |
                +--------+--------+
                |        |        |
               SQL    Python   Power BI
```

## Base de données

La base pédagogique s'appelle `sda_retail` (dans Supabase, chaque projet possède déjà sa base PostgreSQL).

Domaines :
- sales
- customers
- products
- stores
- employees
- payments
- marketing
- inventory
- returns

## Démarrage rapide

1. Créer un projet sur Supabase.
2. Ouvrir le SQL Editor.
3. Exécuter `database/01_schema/01_create_schema.sql`.
4. Exécuter `database/02_seed/01_seed_data.sql`.
5. Exécuter `database/03_views/01_analytical_views.sql`.
6. Exécuter `database/04_quality_checks/01_quality_checks.sql`.
7. Connecter DBeaver à PostgreSQL avec les paramètres fournis par Supabase.
8. Cloner ce dépôt et travailler avec des branches Git.
9. Choisir une mission dans `missions/`.
10. Écrire les requêtes dans `sql/07_business_analysis/` ou dans le dossier de la mission.
11. Commit + Pull Request + revue.

## Règle d'or

> Les données vivent dans PostgreSQL. Le code SQL, la documentation et les analyses vivent dans GitHub.

Ne jamais committer un mot de passe, une clé API ou une chaîne de connexion contenant un secret.

## Workflow étudiant

```bash
git clone <URL_DU_REPO>
cd SDA-Academy-SQL-Data-Analyst
git checkout -b feature/prenom-ticket-001
git add .
git commit -m "feat: analyse des ventes mensuelles"
git push -u origin feature/prenom-ticket-001
```

Puis ouvrir une Pull Request vers `main`.

## Progression pédagogique

1. Bases SQL
2. Filtrage
3. Agrégations
4. JOIN
5. Sous-requêtes et CTE
6. Window functions
7. Analyse business
8. Projet final
