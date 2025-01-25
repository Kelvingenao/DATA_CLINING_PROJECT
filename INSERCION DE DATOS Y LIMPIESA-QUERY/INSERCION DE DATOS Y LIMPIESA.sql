-- creamos la base de datos 
CREATE DATABASE sales_ecommerce;

USE sales_ecommerce;
-- insertamos los datos con la opcion table data import wizard
-- aseguramos que se insertaron corretamente
select * from data_sales;

-- ahora hay que modificar la estructura de la base de datos y renombrar los columna de la tabla

DESCRIBE data_sales;

select * from data_sales; 

ALTER TABLE data_sales RENAME COLUMN identifierHash TO idHash;  

ALTER TABLE data_sales RENAME COLUMN socialNbFollowers TO Followers;  

ALTER TABLE data_sales RENAME COLUMN socialNbFollows TO FollowersN;  

ALTER TABLE data_sales RENAME COLUMN socialProductsLiked TO Liked; 

ALTER TABLE data_sales MODIFY idhash VARCHAR(250);
ALTER TABLE data_sales MODIFY type VARCHAR(250);
ALTER TABLE data_sales MODIFY country varchar(50);
ALTER TABLE data_sales MODIFY language varchar(50);
ALTER TABLE data_sales MODIFY Followers numeric;
ALTER TABLE data_sales MODIFY FollowersN numeric;
ALTER TABLE data_sales MODIFY Liked numeric;
ALTER TABLE data_sales MODIFY productsListed numeric;
ALTER TABLE data_sales MODIFY productsSold numeric;
ALTER TABLE data_sales MODIFY productsPassRate numeric;
ALTER TABLE data_sales MODIFY productsWished numeric;
ALTER TABLE data_sales MODIFY productsBought numeric;
ALTER TABLE data_sales MODIFY gender varchar(20);
ALTER TABLE data_sales MODIFY civilityGenderId numeric;
ALTER TABLE data_sales MODIFY civilityTitle varchar(20);
ALTER TABLE data_sales MODIFY seniorityAsMonths decimal(9,2);
ALTER TABLE data_sales MODIFY seniorityAsYears decimal(9,2);
ALTER TABLE data_sales MODIFY countryCode varchar(20);
ALTER TABLE data_sales MODIFY hasAnyApp varchar(20);
ALTER TABLE data_sales MODIFY hasAndroidApp varchar(20);
ALTER TABLE data_sales MODIFY hasIosApp varchar(20);
ALTER TABLE data_sales MODIFY hasProfilePicture varchar(20);

DESCRIBE data_sales;

/* cambie el tipo de datos ahora tengo que limpiar los datos hay unos
 datos que no son legibles y tanbien a ver si hay datos duplicados 
 */
 
SELECT * FROM data_sales;

/* solo hay una columna lo cual si tiene datos duplicado se puede eliminar y es idhash
lo cual es un ID entonce voy aver si tiene duplicado
*/

SELECT idhash, COUNT(*) AS duplicado
FROM data_sales 
GROUP BY idhash
HAVING COUNT(*) > 1;

/* NO HAY DUPLICADO PERO SI UBIERA DUPLICADO YO LO ELIMINARIA CON LA SIGUIENTE CONSULTA:
CREATE TABLE data_sales_sin_duplicado 
AS SELECT DISTINCT * 
FROM data_sales; 
luego de aver echo eso me aseguro de que los datos sean correcto y que no hayan duplicado 
entonce elimino la tabla con duplicado y renombro esa tabla al nombre principal
asi evito errores al realisar una consulta con la clausula DELECTE 
*/

SELECT * FROM data_sales;
SELECT DISTINCT language FROM data_sales;
-- tengo que atualizar unos datos de la columna language ya que es inlegible

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

-- HORA DE LIMPIAR LOS DATOS DE LA COLUMNA LANGUAGE YA QUE NO SON ENTENDIBLE

UPDATE data_sales
SET language = "English"
WHERE language = "en";

UPDATE data_sales
SET language = "French"
WHERE language = "fr";

UPDATE data_sales
SET language = "German"
WHERE language = "de";

UPDATE data_sales
SET language = "Italian"
WHERE language = "it";

UPDATE data_sales
SET language = "Spanish"
WHERE language = "es";

SELECT DISTINCT gender FROM data_sales;

-- LA COLUMNA GENDER TAMBIEN TIENE DATOS POCO ENTENDIBLE

UPDATE data_sales 
SET gender = CASE 
WHEN gender = "M" THEN "Male"
WHEN gender = "F" THEN "Female"
ELSE gender
END;

-- NOS ASEGURAMOS DE QUE TODO ESTE BIEN

SELECT * FROM data_sales;
SELECT DISTINCT civilityTitle FROM data_sales;
SELECT DISTINCT country FROM data_sales;

-- LISTO TODO CORRECTO