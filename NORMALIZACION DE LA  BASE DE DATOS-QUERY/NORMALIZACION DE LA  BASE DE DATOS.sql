-- normalizacion de la base de datos dividire una columna en varias para que sea mas facil de administrar
DESCRIBE data_sales;
RENAME TABLE data_sales TO users;

-- CREAMO LA TABLA E INSERTAMO LO DATOS DE LA TBLA PRINCIPAL   

CREATE TABLE social_profiles 
AS SELECT DISTINCT idHash, Followers, FollowersN, Liked
FROM users;

-- AGREGAMO UNA COLUMNA PARE EL ID PRIMARY KEY DE ESTA COLUMNA 

ALTER TABLE social_profiles 
ADD COLUMN id_social_profiles INT AUTO_INCREMENT PRIMARY KEY;

-- AGREGAMOS UNA COLUMNA EN LA TABLE PRINCIPAL APARA LA FORENG KEY

ALTER TABLE users 
ADD COLUMN id_social_profiles INT;

SET SQL_SAFE_UPDATES = 0;

SELECT * FROM social_profiles;

-- agregamo el id a la tabla principal

UPDATE users u
INNER JOIN social_profiles s
ON u.idHash = s.idHash
AND U.followers = S.followers
AND U.followersN = S.followersN
AND U.liked = S.liked
SET U.id_social_profiles = S.id_social_profiles;

-- agregamo la llave foranea

ALTER TABLE users
ADD CONSTRAINT FK_idHash
FOREIGN KEY (id_social_profiles)
REFERENCES social_profiles (id_social_profiles);

-- creamo la otra tabla 

CREATE TABLE products AS
SELECT DISTINCT productsListed, productsSold, productsPassRate, productsWished, productsBought
FROM users;

SELECT * FROM products;

ALTER TABLE products ADD COLUMN 
id_product INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE users ADD COLUMN  id_product INT;

-- atualizamo la tabla principal 

UPDATE users u 
INNER JOIN products p 
ON u.productsListed = p.productsListed
AND u.productsSold = p.productsSold
AND u.productsPassRate = p.productsPassRate
AND u.productsWished = p.productsWished
AND u.productsBought = p.productsBought
SET u.id_product = p.id_product;

select * from users
where id_product is not null;

-- agragamo la llave foranea

ALTER TABLE users
ADD CONSTRAINT FK_id_product
FOREIGN KEY (id_product)
REFERENCES Products (id_product);

-- creamo otra tabla 

CREATE TABLE apps AS SELECT DISTINCT hasAnyApp, hasAndroidApp, hasIosApp, hasProfilePicture
FROM users;

-- agregamos columna para la llave foranea 

ALTER TABLE apps ADD COLUMN id_app INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE users ADD COLUMN id_app INT;

-- atualizamo la tabla principal

UPDATE users u
INNER JOIN apps a 
ON u.hasAnyApp = a.hasAnyApp
AND u.hasAndroidApp = a.hasAndroidApp
AND u.hasIosApp = a.hasIosApp
AND u.hasProfilePicture = a.hasProfilePicture
SET u.id_app = a.id_app;

-- agregamo la llave foranea

ALTER TABLE users
ADD CONSTRAINT FK_id_app
FOREIGN KEY (id_app)
REFERENCES apps (id_app);

-- creamo otra tabla 

CREATE TABLE seniority AS SELECT DISTINCT seniority, seniorityAsMonths, seniorityAsYears 
FROM users;

-- agregamo columna para llave foranea en ambas tabla 

ALTER TABLE seniority ADD COLUMN id_seniority INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE users ADD COLUMN id_seniority INT;

-- atualizamos la tabla principal

UPDATE users u
INNER JOIN seniority s 
ON u.seniority = s.seniority
AND u.seniorityAsMonths = s.seniorityAsMonths
AND u.seniorityAsYears = s.seniorityAsYears
SET u.id_seniority = s.id_seniority;

-- agregamos la llave foranea 

ALTER TABLE users
ADD CONSTRAINT FK_id_seniority
FOREIGN KEY (id_seniority)
REFERENCES seniority (id_seniority);

-- creamo la ultima tabla 

CREATE TABLE logins AS SELECT DISTINCT daysSinceLastLogin FROM users;

ALTER TABLE logins ADD COLUMN id_logins INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE users ADD COLUMN id_logins INT;

-- atualiza la tabla principal 

UPDATE users u 
INNER JOIN logins l 
ON u.daysSinceLastLogin = l.daysSinceLastLogin
SET u.id_logins = l.id_logins;

ALTER TABLE users
ADD CONSTRAINT FK_id_logins
FOREIGN KEY (id_logins)
REFERENCES logins (id_logins);

SET SQL_SAFE_UPDATES = 1;

-- ahora eliminamo las columna de las tabla principal solo las columna que estan en las tabla creada

ALTER TABLE users DROP COLUMN Followers;

ALTER TABLE users DROP COLUMN FollowersN;

ALTER TABLE users DROP COLUMN Liked;

ALTER TABLE users DROP COLUMN productsListed;

ALTER TABLE users DROP COLUMN productsSold;

ALTER TABLE users DROP COLUMN productsPassRate;

ALTER TABLE users DROP COLUMN productsWished;

ALTER TABLE users DROP COLUMN productsBought;

ALTER TABLE users DROP COLUMN hasAnyApp;

ALTER TABLE users DROP COLUMN hasAndroidApp;

ALTER TABLE users DROP COLUMN hasIosApp;

ALTER TABLE users DROP COLUMN hasProfilePicture;

ALTER TABLE users DROP COLUMN seniority;

ALTER TABLE users DROP COLUMN seniorityAsMonths;

ALTER TABLE users DROP COLUMN seniorityAsYears;

ALTER TABLE users DROP COLUMN daysSinceLastLogin;

ALTER TABLE social_profiles DROP COLUMN idhash;

-- AQUI ME ENCONTRE CON UN PEQUEÑO INCOMVENIENTE

-- AQUI ELIMINARE UNOS - QUE TIENEN LOS ID AL PRINCIPIO
UPDATE users
SET idhash = REPLACE(idhash, "-", "")
WHERE idhash LIKE "-%";

ALTER TABLE users MODIFY idhash BIGINT PRIMARY KEY;

/* AQUI VOY A VERIFICAR QUE NO TENGA ESPACIO YA QUE TENIA UN - ENTONCE PARA MANTENER LA 
BASE DE DATOS LIMPIA SIN VALORES O SIGNO INCONSISTENTE
*/
SELECT idhash
FROM users
WHERE idhash != TRIM(idhash);

/* TUBE QUE ALMACENAR LOS EN EN TIPO BEGINTYA QUE  DATOS ESTAN FUERA DE RANGO SON MUY LARGO PARA SER ALMACENADO 
COMO TIPO INT ASI QUE TUVE ALMACENAR COMO TIPO BIGINT Y COMO ES EL UNICO VALOR UNICO EN ESTA COLUMNA 
LO AGREGE COMO LLAVE PRIMARIA 
*/
-- listo todas las columna fueron eliminada de la tabla principal

-- ahora voy a verificar que to este correcto 

SELECT * FROM logins;
SELECT * FROM apps;
SELECT * FROM products;
SELECT * FROM seniority;
SELECT * FROM social_profiles;
SELECT * FROM users;

-- todo esta correcto.

