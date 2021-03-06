-- 1. How many stops are in the database?
SELECT
  COUNT(stops.id)
FROM
  stops;

-- 2. Find the id value for the stop 'Craiglockhart'.
SELECT
  stops.id
FROM
  stops
WHERE
  stops.name = 'Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT
  stops.id, stops.name
FROM
  stops, route
WHERE
  stops.id = route.stop AND route.company = 'LRT' AND route.num = '4';

-- 4. Add a HAVING clause (to the example) to restrict the output to these two routes.
SELECT
  company, num, COUNT(*)
FROM
  route 
WHERE
  stop = 149 OR stop = 53
GROUP BY
  company, num
HAVING
  COUNT(*) > 1;

-- 5. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT
  a.company, a.num, a.stop, b.stop
FROM
  route a JOIN route b ON (a.company = b.company AND a.num = b.num)
WHERE
  a.stop = 53 AND b.stop = 149;

-- 6. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
SELECT
  a.company, a.num, stopa.name, stopb.name
FROM
  route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN
  stops stopa ON (a.stop = stopa.id)
JOIN
  stops stopb ON (b.stop = stopb.id)
WHERE
  stopa.name = 'Craiglockhart' AND stopb.name = 'London Road';

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith').
SELECT DISTINCT
  a.company, a.num
FROM
  route a JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN
  stops stopa ON (a.stop=stopa.id)
JOIN
  stops stopb ON (b.stop=stopb.id)
WHERE
  stopa.name='Haymarket' AND stopb.name = 'Leith';

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT
  a.company, a.num
FROM
  route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN
  stops stopa ON (a.stop = stopa.id)
JOIN
  stops stopb ON (b.stop = stopb.id)
WHERE
  stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross';

/* 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus,
      including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services. */
SELECT DISTINCT
  stopb.name, b.company, b.num
FROM
  route AS a
JOIN
  route AS b ON a.company = b.company AND a.num = b.num
JOIN
  stops AS stopa ON a.stop = stopa.id
JOIN
  stops AS stopb ON b.stop = stopb.id
WHERE
  stopa.name = 'Craiglockhart' AND a.company = 'LRT';

/* 10. Find the routes involving two buses that can go from Craiglockhart to Lochend.
       Show the bus no. and company for the first bus, the name of the stop for the transfer,
       and the bus no. and company for the second bus. */
SELECT
  a.num AS Num1, a.comp AS Comp1, a.transfer AS Transfer, b.num AS Num2, b.comp AS Comp2
FROM
  (SELECT DISTINCT a.num AS num, a.company AS comp, stopb.name AS transfer
  FROM
    route AS a
  JOIN
    route AS b ON a.company = b.company AND a.num = b.num
  JOIN
    stops AS stopa ON a.stop = stopa.id
  JOIN
    stops AS stopb ON b.stop = stopb.id
  WHERE
    stopa.name = 'Craiglockhart') AS a
  JOIN
  (SELECT DISTINCT a.num AS num, a.company AS comp, stopb.name AS transfer
  FROM
    route AS a
  JOIN
    route AS b ON a.company = b.company AND a.num = b.num
  JOIN
    stops AS stopa ON a.stop = stopa.id
  JOIN
    stops AS stopb ON b.stop = stopb.id
  WHERE
    stopa.name = 'Lochend') AS b ON a.transfer = b.transfer
ORDER BY
  Num1,Transfer, Num2;