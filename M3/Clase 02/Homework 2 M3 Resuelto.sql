use adventureworks;
-- 1) Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", entre los años 2000 y 2003, cuyo método de envío sea "CARGO TRANSPORT 5"
SELECT DISTINCT c.LastName, c.FirstName
FROM salesorderheader h
	JOIN contact c
		ON (h.ContactID = c.ContactID)
	JOIN salesorderdetail d
		ON (h.SalesOrderID = d.SalesOrderID)
	JOIN product p
		ON (d.ProductID = p.ProductID)
	JOIN productsubcategory s
		ON (p.ProductSubcategoryID = s.ProductSubcategoryID)
	JOIN shipmethod e
		ON (e.ShipMethodID = h.ShipMethodID)
WHERE YEAR(h.OrderDate) BETWEEN 2000 AND 2003
AND s.Name = 'Mountain Bikes'
AND e.Name = 'CARGO TRANSPORT 5';

-- 2) Obtener un listado contactos que hayan ordenado productos de la subcategoría "Mountain Bikes", entre los años 2000 y 2003 con la cantidad de productos adquiridos y ordenado por este valor, de forma descendente.
SELECT c.LastName, c.FirstName, SUM(d.OrderQty) as Cantidad
FROM salesorderheader h
	JOIN contact c
		ON (h.ContactID = c.ContactID)
	JOIN salesorderdetail d
		ON (h.SalesOrderID = d.SalesOrderID)
	JOIN product p
		ON (d.ProductID = p.ProductID)
	JOIN productsubcategory s
		ON (p.ProductSubcategoryID = s.ProductSubcategoryID)
WHERE YEAR(h.OrderDate) BETWEEN 2002 AND 2003
AND s.Name = 'Mountain Bikes'
GROUP BY c.LastName, c.FirstName
ORDER BY Cantidad DESC;

-- 3) Obtener un listado de cual fue el volumen de compra (cantidad) por año y método de envío.
SELECT YEAR(h.OrderDate) as Año, e.Name AS MetodoEnvio, SUM(d.OrderQty) as Cantidad
FROM salesorderheader h
	JOIN salesorderdetail d
		ON (h.SalesOrderID = d.SalesOrderID)
	JOIN shipmethod e
		ON (e.ShipMethodID = h.ShipMethodID)
GROUP BY YEAR(h.OrderDate), e.Name
ORDER BY YEAR(h.OrderDate), e.Name;

-- 4) Obtener un listado por categoría de productos, con el valor total de ventas y productos vendidos.
SELECT c.Name AS Categoria, SUM(d.OrderQty) as Cantidad, SUM(d.LineTotal) as Total
FROM salesorderheader h
	JOIN salesorderdetail d
		ON (h.SalesOrderID = d.SalesOrderID)
	JOIN product p
		ON (d.ProductID = p.ProductID)
	JOIN productsubcategory s
		ON (p.ProductSubcategoryID = s.ProductSubcategoryID)
	JOIN productcategory c
		ON (s.ProductCategoryID = c.ProductCategoryID)
GROUP BY c.Name
ORDER BY c.Name;

-- 5) Obtener un listado por país (según la dirección de envío), con el valor total de ventas y productos vendidos, sólo para aquellos países donde se enviaron más de 15 mil productos.
SELECT cr.Name as Pais, SUM(d.OrderQty) as Cantidad, SUM(d.LineTotal) as Total
FROM salesorderheader h
	JOIN salesorderdetail d
		ON (h.SalesOrderID = d.SalesOrderID)
	JOIN address a
		ON (h.ShipToAddressID = a.AddressID)
	JOIN stateprovince sp
		ON (a.StateProvinceID = sp.StateProvinceID)
	JOIN countryregion cr
		ON (sp.CountryRegionCode = cr.CountryRegionCode)
GROUP BY cr.Name
HAVING SUM(d.OrderQty) > 15000
ORDER BY cr.Name;

-- 6) Obtener un listado de las cohortes que no tienen alumnos asignados, utilizando la base de datos henry, desarrollada en el módulo anterior.
USE henry;
SELECT *
FROM cohorte as c
LEFT JOIN alumno as a ON (c.idCohorte=a.IdCohorte)
WHERE a.IdCohorte is null;