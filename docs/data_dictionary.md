# Data Dictionary — SDA Retail

## customers
| Colonne | Type | Rôle |
|---|---|---|
| customer_id | bigint | Identifiant client |
| first_name / last_name | varchar | Identité |
| email | varchar | Email unique |
| gender | varchar | Genre pédagogique |
| birth_date | date | Date de naissance |
| city / province | varchar | Localisation |
| segment | varchar | Retail / Premium / Corporate |
| signup_date | date | Date d'inscription |
| status | varchar | Active / Inactive / Blocked |

## stores
Magasins et canaux physiques/online.

## employees
Employés et rattachement à un magasin.

## categories
Catégories produits.

## products
Catalogue, coûts, prix, marque et date de lancement.

## orders
En-tête de commande : client, magasin, employé, date, canal et statut.

## order_items
Lignes de commande : produit, quantité, prix et remise.

## payments
Paiements associés aux commandes.

## campaigns
Campagnes marketing et budget.

## campaign_events
Événements marketing : impression, clic, lead, conversion.

## inventory
Snapshots de stock par magasin et produit.

## returns
Retours de produits et remboursements.

## Relations principales

```text
customers 1 ---- N orders
orders    1 ---- N order_items
products  1 ---- N order_items
orders    1 ---- N payments
order_items 1 -- N returns
stores    1 ---- N orders
stores    1 ---- N employees
categories 1 --- N products
campaigns 1 ---- N campaign_events
customers 1 ---- N campaign_events
stores/products 1-N inventory
```
