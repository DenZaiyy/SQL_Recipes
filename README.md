# SQL Request to review bases of knowledge

This exercice is about SQL request to review bases of knowledge

## Objectives

Objective about this exercice, it's to know how to create database from zero, and create table, column, foreing keys and data in it.

## Exemples of requests

I show you one example of request to add new ingredient in my database and use it in a recipe

```sql
-- Insert new ingredient with datas
INSERT INTO ingredient (name, unit_measure, price) VALUES ('Coco', 'kg', 2);

-- Insert ingredient in recipe using associative table for table "Recipe" and "Ingredient"
INSERT INTO ingredient_recipe (recipe_id, ingredient_id, quantity) VALUES (
    (SELECT id FROM recipe WHERE name = "Tasse d'eau chaude"),
    (SELECT id FROM ingredient WHERE name = "Coco"),
    1
)
```