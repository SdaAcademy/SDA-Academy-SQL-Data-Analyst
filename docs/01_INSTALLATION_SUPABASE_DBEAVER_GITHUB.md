# Installation et configuration — SDA Academy SQL

## 1. Créer le projet PostgreSQL Cloud

Nous utilisons **Supabase**.

1. Aller sur https://supabase.com/
2. Créer un compte / se connecter.
3. Cliquer sur **New project**.
4. Nom : `SDA Academy SQL`.
5. Choisir une région proche de tes utilisateurs.
6. Définir un mot de passe PostgreSQL fort et le conserver dans un gestionnaire de mots de passe.
7. Attendre la création du projet.

> Ne mets jamais le mot de passe PostgreSQL dans GitHub.

## 2. Créer la base

Dans Supabase :
- ouvrir **SQL Editor**
- créer une nouvelle query
- copier `database/01_schema/01_create_schema.sql`
- Run

Puis, dans l'ordre :
1. `database/02_seed/01_seed_data.sql`
2. `database/03_views/01_analytical_views.sql`
3. `database/04_quality_checks/01_quality_checks.sql`

Le seed contient plusieurs centaines de clients et 1 500 commandes avec des lignes de commande, paiements, retours, campagnes et stocks.

## 3. Vérifier

```sql
SELECT COUNT(*) FROM sda_retail.customers;
SELECT COUNT(*) FROM sda_retail.orders;
SELECT COUNT(*) FROM sda_retail.order_items;
SELECT COUNT(*) FROM sda_retail.products;
```

Puis :

```sql
SELECT *
FROM sda_retail.v_monthly_sales
ORDER BY month;
```

## 4. Connecter DBeaver

Installer DBeaver : https://dbeaver.io/

Dans Supabase, récupérer les paramètres de connexion PostgreSQL depuis **Connect**.

Dans DBeaver :
1. New Database Connection
2. PostgreSQL
3. renseigner Host, Port, Database, User, Password
4. Test Connection
5. Finish

Pour un environnement pédagogique, utilise de préférence une connexion SSL.

## 5. GitHub

Créer un repository, par exemple :

`SDA-Academy-SQL-Data-Analyst`

Puis :

```bash
git clone https://github.com/<TON_COMPTE>/SDA-Academy-SQL-Data-Analyst.git
cd SDA-Academy-SQL-Data-Analyst
```

## 6. Branches étudiants

Chaque étudiant crée une branche :

```bash
git checkout -b feature/jean-ticket-001
```

Après le travail :

```bash
git add .
git commit -m "feat: analyse des ventes mensuelles"
git push -u origin feature/jean-ticket-001
```

Puis Pull Request vers `main`.

## 7. Règles GitHub recommandées

Sur `main` :
- protéger la branche
- interdire le push direct aux apprenants
- imposer une Pull Request
- demander au moins 1 review
- supprimer les branches après merge

## 8. Organisation des responsabilités

### Formateur
- admin PostgreSQL / Supabase
- propriétaire du repo
- crée les missions
- valide les Pull Requests
- maintient les datasets

### Apprenant
- lecture de la base
- écriture de requêtes SQL
- documentation
- commit
- Pull Request
- réponse aux commentaires de review

## 9. Sécurité

Ne jamais mettre dans GitHub :
- mot de passe PostgreSQL
- clé Supabase secrète
- token GitHub
- connection string complète avec mot de passe

Créer un fichier `.env.example` si nécessaire et laisser les secrets dans `.env` local.

## 10. Option équipe

Pour plusieurs classes, créer :
- 1 projet Supabase de formation
- 1 repository GitHub principal
- 1 branche par apprenant
- éventuellement 1 repository `teacher` privé contenant les corrections

Pour une formation importante, séparer ensuite :
- `SDA-Academy-SQL-Data-Analyst` : apprenants
- `SDA-Academy-SQL-Corrections` : formateur, privé
