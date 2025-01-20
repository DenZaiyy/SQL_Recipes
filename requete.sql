-- 1: Afficher toutes les recettes disponibles (nom de la recette, catégorie et temps de préparation) triées de façon décroissante sur la durée de réalisation

SELECT r.name as RecipeName, r.preparation_time as RecipePreparationTime, c.name as CategoryName FROM Recipe r
INNER JOIN category c ON r.category_id = c.id
ORDER BY r.preparation_time DESC

-- 2: En modifiant la requête précédente, faites apparaître le nombre d’ingrédients nécessaire par recette.

SELECT r.id, r.name as RecipeName, r.preparation_time as RecipePreparationTime, c.name as CategoryName, COUNT(ir.recipe_id) as TotalIngredient FROM Recipe r
INNER JOIN category c ON r.category_id = c.id
INNER JOIN ingredient_recipe ir ON r.id = ir.recipe_id
GROUP BY r.id, r.name, r.preparation_time, c.name
ORDER BY r.preparation_time DESC

-- 3: Afficher les recettes qui nécessitent au moins 30 min de préparation

SELECT * FROM recipe r
WHERE r.preparation_time >= "00:30"
ORDER BY r.preparation_time DESC

-- 4: Afficher les recettes dont le nom contient le mot « Salade » (peu importe où est situé le mot en question)

SELECT * FROM recipe r
WHERE r.name LIKE "%Salade%"

-- 5: Insérer une nouvelle recette : « Pâtes à la carbonara » dont la durée de réalisation est de 20 min avec les instructions de votre choix. Pensez à alimenter votre base de données en conséquence afin de pouvoir lister les détails de cette recettes (ingrédients)
    -- Recette
INSERT INTO recipe (name, preparation_time, category_id) VALUES ('Pâtes à la carbonara', '00:20:00', 2);

    -- Ingrédients
INSERT INTO ingredient (name, unit_measure, price) VALUES ('Pâtes', 'kg', 1.5);
INSERT INTO ingredient (name, unit_measure, price) VALUES ('Lardons', 'g', 0.03);
INSERT INTO ingredient (name, unit_measure, price) VALUES ('Parmesan', 'g', 0.05);

    -- Association des ingrédients à la recette "Pâtes à la carbonara"
INSERT INTO ingredient_recipe (recipe_id, ingredient_id, quantity) VALUES (21, (SELECT id FROM ingredient WHERE name = 'Pâtes'), 0.3);
INSERT INTO ingredient_recipe (recipe_id, ingredient_id, quantity) VALUES (21, (SELECT id FROM ingredient WHERE name = 'Lardons'), 150);
INSERT INTO ingredient_recipe (recipe_id, ingredient_id, quantity) VALUES (21, (SELECT id FROM ingredient WHERE name = 'Oeuf'), 2);
INSERT INTO ingredient_recipe (recipe_id, ingredient_id, quantity) VALUES (21, (SELECT id FROM ingredient WHERE name = 'Crème'), 0.2);
INSERT INTO ingredient_recipe (recipe_id, ingredient_id, quantity) VALUES (21, (SELECT id FROM ingredient WHERE name = 'Parmesan'), 50);

-- 6: Modifier le nom de la recette ayant comme identifiant id_recette = 3 (nom de la recette à votre convenance)

UPDATE recipe r
SET r.name = "Poulet curry"
WHERE r.id = 3

-- 7: Supprimer la recette n°2 de la base de données

DELETE FROM recipe r
WHERE r.id = 2

-- 8: Afficher le prix total de la recette n°5

SELECT ROUND(SUM(i.price * ir.quantity), 2) as "Prix total"
FROM recipe r
INNER JOIN ingredient_recipe ir ON ir.recipe_id = r.id
INNER JOIN ingredient i ON ir.ingredient_id = i.id 
WHERE r.id = 5

-- 9: Afficher le détail de la recette n°5 (liste des ingrédients, quantités et prix)

SELECT r.name as RecipeName, i.name as IngredientName, ir.quantity, i.price
FROM recipe r
INNER JOIN ingredient_recipe ir ON ir.recipe_id = r.id
INNER JOIN ingredient i ON ir.ingredient_id = i.id 
WHERE r.id = 5

-- 10: Ajouter un ingrédient en base de données : Poivre, unité : cuillère à café, prix : 2.5 €

INSERT INTO ingredient (name, unit_measure, price) VALUES ("poivre", "cuillère à café", 2.5)

-- 11: Modifier le prix de l’ingrédient n°12 (prix à votre convenance)

UPDATE ingredient i
SET i.price = 5
WHERE i.id = 12

-- 12: Afficher le nombre de recettes par catégories : X entrées, Y plats, Z desserts

SELECT c.name, COUNT(*) as "Nombre de recettes"
FROM recipe r
INNER JOIN category c ON r.category_id = c.id
GROUP BY c.name

-- 13: Afficher les recettes qui contiennent l’ingrédient « Poulet »

SELECT r.name
FROM recipe r
INNER JOIN ingredient_recipe ir ON ir.recipe_id = r.id
INNER JOIN ingredient i ON ir.ingredient_id = i.id 
WHERE i.name = "Poulet"

-- 14: Mettez à jour toutes les recettes en diminuant leur temps de préparation de 5 minutes

UPDATE recipe
SET preparation_time = DATE_SUB(preparation_time, INTERVAL 5 MINUTE)

-- 15: Afficher les recettes qui ne nécessitent pas d’ingrédients coûtant plus de 2€ par unité de mesure

SELECT r.name as "Recipe Name"
FROM recipe r
WHERE NOT EXISTS (
    SELECT *
    FROM ingredient_recipe ir
    INNER JOIN ingredient i ON ir.ingredient_id = i.id
    WHERE ir.recipe_id = r.id
    AND i.price >= 2
);

-- 16: Afficher la / les recette(s) les plus rapides à préparer

SELECT r.name as "Recipe Name", r.preparation_time 
FROM recipe r
ORDER BY r.preparation_time ASC
LIMIT 5;

-- 17: Trouver les recettes qui ne nécessitent aucun ingrédient (par exemple la recette de la tasse d’eau chaude qui consiste à verser de l’eau chaude dans une tasse)

SELECT r.name as "Recipe Name"
FROM recipe r
WHERE NOT EXISTS (
	SELECT *
	FROM ingredient_recipe ir
	WHERE ir.recipe_id = r.id
)

-- 18: Trouver les ingrédients qui sont utilisés dans au moins 3 recettes

SELECT i.name, COUNT(ir.id)
FROM ingredient i
INNER JOIN ingredient_recipe ir ON ir.ingredient_id = i.id
GROUP BY i.name
HAVING COUNT(ir.recipe_id) >= 3

-- 19: Ajouter un nouvel ingrédient à une recette spécifique

INSERT INTO Ingredient (name, unit_measure, price) VALUES ('Coco', 'kg', 2);

INSERT INTO Ingredient_recipe (recipe_id, ingredient_id, quantity) VALUES (
    (SELECT id FROM recipe WHERE name = "Tasse d'eau chaude"),
    (SELECT id FROM ingredient WHERE name = "Coco"),
    1
)

-- 20: Bonus : Trouver la recette la plus coûteuse de la base de données (il peut y avoir des ex aequo, il est donc exclu d’utiliser la clause LIMIT)

SELECT r.id, r.name, ROUND(SUM(ir.quantity * i.price), 2) AS total_cost
FROM recipe r
INNER JOIN ingredient_recipe ir ON r.id = ir.recipe_id
INNER JOIN ingredient i ON ir.ingredient_id = i.id
GROUP BY r.id, r.name
HAVING SUM(ir.quantity * i.price) >= ALL (
	SELECT SUM(ir.quantity * i.price) AS total_cost
	FROM recipe r
	INNER JOIN ingredient_recipe ir ON r.id = ir.recipe_id
	INNER JOIN ingredient i ON ir.ingredient_id = i.id
	GROUP BY r.id
);