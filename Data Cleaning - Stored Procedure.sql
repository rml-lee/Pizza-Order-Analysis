DELIMITER $$
CREATE PROCEDURE clean_data()
BEGIN

# orders table

-- Creating a timestamp column
ALTER TABLE orders
ADD timestamp timestamp NULL;



-- Add timestamp values
UPDATE orders
SET
    timestamp = CONCAT(date, ' ', time);



-- Drop original date and time columns
ALTER TABLE orders
DROP date,
DROP time;


-- Clean junk character from ingredients column
UPDATE pizza_types
SET
    ingredients = REPLACE(ingredients, '�', '')
WHERE
    ingredients LIKE '%�%';

END $$

DELIMITER ;