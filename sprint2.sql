-- Sprint 2: Bases de dades relacionals i introducció a SQL
---  NIVELL 1
-- Exercici 1 (pdf)
-- Exercici 2 (join)
use transactions;
-- Llistat dels països que estan generant vendes
Select distinct c.country 
from company c
JOIN transaction t
ON c.id = t.company_id
where t.declined=False
order by c.country ASC;

-- Des de quants països es generen les vendes
SELECT COUNT(DISTINCT c.country) AS nombre_països_amb_vendes
FROM company c
JOIN transaction t
ON c.id = t.company_id
where t.declined=False;

-- Identifica la companyia amb la mitjana més gran de vendes.
SELECT c.company_name, round(AVG (t.amount),2) AS mitjana_vendes
FROM company c
JOIN transaction t
ON c.id = t.company_id
where t.declined = FALSE
GROUP BY c.id
ORDER BY mitjana_vendes DESC
LIMIT 1;

-- Exercici 3 (subqueries)
-- Mostra totes les transaccions realitzades per empreses d'Alemanya
SELECT *
FROM transaction
WHERE company_id IN (SELECT id
    FROM company
    WHERE country = 'Germany');


-- Exercici 3
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT *
FROM transaction
WHERE company_id IN (SELECT id
    FROM company
    WHERE country = 'Germany');
    
-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT DISTINCT c.company_name, t.amount
FROM company c, transaction t
WHERE c.id = t.company_id AND t.amount > (
    SELECT AVG(amount) 
    FROM transaction
);

SELECT distinct c.company_name, t.amount
FROM transaction t
JOIN company c
ON t.company_id= c.id
WHERE t.amount > (
    SELECT AVG(t.amount)
    FROM transaction t
);

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT *
FROM company c
WHERE NOT EXISTS (
    SELECT 1
    FROM transaction t
    WHERE t.company_id = c.id
);

SELECT c.company_name
from transaction t
JOIN company c
ON t.company_id= c.id
where t.declined is NULL;

--- NIVELL 2
-- Exercici 1
/* Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
Mostra la data de cada transacció juntament amb el total de les vendes.*/
Select SUM(t.amount) AS total_ventes, DATE(t.timestamp) AS data
From transaction t
where t.declined = FALSE
Group by DATE(t.timestamp)
Order by total_ventes DESC
Limit 5;

-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
Select c.country, Round(AVG(t.amount),2) AS mitjana_ventes
From transaction t
Join company c
ON t.company_id= c.id
where t.declined = FALSE
Group by c.country
Order by mitjana_ventes DESC;

-- Exercici 3
/*En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència 
a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan 
situades en el mateix país que aquesta companyia.*/

--- Mostra el llistat aplicant JOIN i subconsultes.
Select *
From transaction t
join company c
on t.company_id = c.id
Where t.declined= False and c.country IN (
	Select country
	from company
	where company_name="Non Institute"
);


--- Mostra el llistat aplicant solament subconsultes.
Select *
from transaction t
where t.declined= False and t.company_id IN (
	Select c.id
    from company c
    where c.country IN (
		Select c.country
        from company c
        where company_name= "Non Institute"
        )
and t.declined=False
);

---- Nivell 3
-- Exercici 1
/* Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions 
amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol 
del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.*/
Select c.company_name, c.phone, c.country, date(t.timestamp) as date, t.amount
from transaction t
join company c
on t.company_id =c.id
where t.amount between 350 and 400 
AND date(t.timestamp) in ('2015-04-29', '2018-07-20', '2024-03-13') 
and t.declined=False
order by t.amount desc;

--- Exercici 2
/* Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis 
si tenen més de 400 transaccions o menys.*/
Select c.company_name, count(t.id) as total_transations,
	Case
        when count(t.id) > 400 then 'Més de 400'
        else 'Menys o igual a 400'
	end as classificació
from transaction t
join company c
on t.company_id =c.id
where t.declined=False
group by c.id
order by total_transations desc;
