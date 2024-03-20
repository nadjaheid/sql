/* 1.
Imprima o campo company_name. 
Encontre o número de corridas de táxi para cada empresa de táxi 
de 15 a 16 de novembro de 2017, nomeie o campo resultante como 
trips_amount e imprima-o também. Classifique os resultados pelo #
campo trips_amount em ordem decrescente.*/
SELECT
    cabs.company_name as company_name,
    COUNT(trips.trip_id) as trips_amount
FROM
    cabs
    INNER JOIN trips on trips.cab_id = cabs.cab_id
WHERE
    CAST(trips.start_ts as date)>='2017-11-15'
    AND CAST(trips.start_ts as date)<='2017-11-16'
GROUP BY
    company_name
ORDER BY
    trips_amount DESC;

/*2.
Encontre o número de corridas para cada empresa de táxi cujo 
nome contém as palavras "Amarelo" ou "Azul" de 1 a 7 de novembro 
de 2017. Nomeie a variável resultante como trips_amount. 
Agrupe os resultados pelo campo company_name.*/

SELECT
    combined_results.company_name,
    SUM(combined_results.trips_amount) as trips_amount
FROM (
    SELECT
        cabs.company_name as company_name,
        COUNT(trips.trip_id) as trips_amount
    FROM 
        cabs
    JOIN trips ON cabs.cab_id = trips.cab_id
    WHERE
        cabs.company_name LIKE '%Amarelo%'
        AND CAST(trips.start_ts as date) BETWEEN '2017-11-01' AND '2017-11-07'
    GROUP BY
        cabs.company_name
    
    UNION

    SELECT
        cabs.company_name as company_name,
        COUNT(trips.trip_id) as trips_amount
    FROM 
        cabs
    JOIN trips ON cabs.cab_id = trips.cab_id
    WHERE
        cabs.company_name LIKE '%Azul%'
        AND CAST(trips.start_ts as date) BETWEEN '2017-11-01' AND '2017-11-07'
    GROUP BY
        cabs.company_name
) AS combined_results
GROUP BY
    combined_results.company_name;

/*3.
De 1 a 7 de novembro de 2017, as empresas de táxi 
mais populares foram Flash Cab e Taxi Affiliation Services. 
Encontre o número de corridas para essas duas empresas e nomeie 
a variável resultante como trips_amount. Junte as corridas de todas as 
outras empresas no grupo "Outros". Agrupe os dados por nomes de empresas de táxi. 
Nomeie o campo com os nomes das empresas de táxi company. 
Ordene o resultado em ordem decrescente por trips_amount.*/

SELECT
    CASE 
        WHEN company_name = 'Flash Cab' THEN 'Flash Cab' 
        WHEN company_name = 'Taxi Affiliation Services' THEN 'Taxi Affiliation Services' 
        ELSE 'Other' 
    END AS company,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
INNER JOIN 
    trips 
ON 
    trips.cab_id = cabs.cab_id
WHERE 
    CAST(trips.start_ts AS DATE) BETWEEN '2017-11-01' AND '2017-11-07'
GROUP BY 
    company
ORDER BY 
    trips_amount DESC;

/*4.
Recupere os identificadores dos bairros O'Hare e Loop da tabela neighborhoods.*/

SELECT
    neighborhood_id,
    name 
FROM 
    neighborhoods
WHERE 
name LIKE '%Hare' OR name LIKE 'Loop';

/*5.
Para cada hora, recupere os registros de condições climáticas 
da tabela weather_records. Usando o operador CASE, divida todas 
as horas em dois grupos: Bad se o campo descrição contiver as 
palavras rain ou storm e Good para outros. Nomeie o campo resultante 
como weather_conditions. A tabela final deve incluir dois campos: 
data e hora (ts) e weather_conditions.*/

SELECT
    ts,
    CASE
        WHEN description LIKE '%rain%' OR description LIKE '%storm%' THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions
FROM 
    weather_records;

/*6.
Recupere da tabela trips todas as corridas que começaram no Loop 
(pickup_location_id: 50) em um sábado e terminaram em O'Hare 
(dropoff_location_id: 63). Obtenha as condições meteorológicas para cada corrida. 
Use o método que você aplicou na tarefa anterior. 
Além disso, recupere a duração de cada corrida. 
Ignore corridas para as quais os dados sobre as condições 
meteorológicas não estão disponíveis.*/

SELECT
    trips.start_ts AS start_ts,
    CASE
        WHEN weather_records.description LIKE '%rain%' OR weather_records.description LIKE '%storm%' THEN 'Bad'
        ELSE 'Good'
    END AS weather_conditions,
    trips.duration_seconds AS duration_seconds
FROM 
    trips
INNER JOIN 
    weather_records
ON 
    DATE_TRUNC('hour', trips.start_ts) = DATE_TRUNC('hour', weather_records.ts)
WHERE 
    trips.pickup_location_id = 50
    AND trips.dropoff_location_id = 63
    AND EXTRACT(DOW FROM trips.start_ts) = 6
    AND weather_records.description IS NOT NULL
ORDER BY
    trips.trip_id;
