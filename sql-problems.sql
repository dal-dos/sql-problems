--Q1
SELECT lastName, firstName, salary
FROM Employee
WHERE branchNumber = 3
ORDER BY lastName, firstName

--Q2
SELECT a.accNumber, a.type, t.transNumber, t.amount
FROM Account a, Transactions t
WHERE a.balance > 120000 and a.accNumber = t.accNumber
ORDER BY t.accNumber, t.transNumber

--Q3
SELECT c1.lastName, c1.firstName, c1.birthDate
FROM Customer c1, Customer c2
WHERE c2.firstName = 'Carol' and c2.lastName = 'Alexander' and c1.birthDate < c2.birthDate
ORDER BY lastName, firstName

--Q4
SELECT distinct c1.customerID, c1.lastName, c1.income, a1.accNumber
FROM Customer c1, Owns o1, Account a1
WHERE c1.income > 60000 and c1.customerID = o1.customerID and o1.accNumber = a1.accNumber and c1.customerID IN
(SELECT c2.customerID
FROM Customer c2, Owns o2, Account a2, Transactions t2
WHERE c2.customerID = o2.customerID and o2.accNumber = a2.accNumber and a2.accNumber = t2.accNumber and t2.amount > 110000)
ORDER BY customerID, accNumber

--Q5
SELECT c1.customerID, a1.type, a1.accNumber, a1.balance
FROM Customer c1, Account a1, Owns o1
WHERE c1.customerID = o1.customerID and o1.accNumber = a1.accNumber and (a1.type = 'BUS' or a1.type = 'SAV') and c1.customerID IN 
(
	SELECT c2.customerID
	FROM Customer c2, Account a2, Branch b2, Owns o2, owns o3, Account a3, Branch b3
	WHERE c2.customerID = o2.customerID and c2.customerID = o3.customerID and o2.accNumber = a2.accNumber and o3.accNumber = a3.accNumber
			and b2.branchNumber = a2.branchNumber and b3.branchNumber = a3.branchNumber and (a2.type = 'BUS' and a3.type = 'SAV') and (b2.branchName = 'Berlin' or b2.branchName = 'London') 
			and (b3.branchName = 'Berlin' or b3.branchName = 'London')
)
ORDER BY customerID, type, accNumber

--Q6

SELECT t.transNumber, t.amount, (100 * (t.amount / a.balance)) AS 'percent'
FROM Transactions t, Account a
WHERE t.accNumber = 42 and a.accNumber = t.accNumber
ORDER BY amount
DESC

--Q7

SELECT DISTINCT c.customerID 
FROM Customer c, Owns o, Account a, Branch b
WHERE c.customerID = o.customerID and o.accNumber = a.accNumber and a.branchNumber = b.branchNumber and b.branchName = 'Berlin'
EXCEPT
SELECT DISTINCT c.customerID --all customers who own an account at london
FROM Customer c, Owns o, Account a, Branch b, Customer c3
WHERE c.customerID = o.customerID and o.accNumber = a.accNumber and a.branchNumber = b.branchNumber and b.branchName = 'London' and c3.customerID IN 
(
SELECT DISTINCT c1.customerID --all customers who's buddies own account at london
FROM Customer c1, Customer c2, Owns o1, Owns o2, Account a1, Branch b1, Owns o3, Account a3, Branch b2
WHERE c1.customerID <> c2.customerID and c1.customerID = o1.customerID and c2.customerID = o2.customerID and 
o1.accNumber = o2.accNumber and o1.accNumber = a1.accNumber and a1.branchNumber = b1.branchNumber and b1.branchName <> 'London' 
and o2.customerID = o3.customerID and o3.accNumber <> o2.accNumber and o3.accNumber = a3.accNumber and a3.branchNumber = b2.branchNumber and b2.branchName = 'London'
)
ORDER BY customerID

--Q8

SELECT c.customerID, c.lastName, c.firstName, c.income, e.salary
FROM Customer c LEFT OUTER JOIN Employee e ON c.firstName = e.firstName and c.lastName = e.lastName
WHERE c.income > 60000
ORDER BY lastName, firstName

--Q9

SELECT DISTINCT c.customerID, c.lastName, c.firstName, c.income, e.salary
FROM Customer c, Employee e
WHERE c.income > 60000 and e.salary IN (SELECT e1.salary FROM Employee e1 WHERE c.firstName = e1.firstName and c.lastName = e1.lastName)
UNION
SELECT c.customerID, c.lastName, c.firstName, c.income, NULL
FROM Customer c, Employee e
WHERE c.income > 60000 and NOT EXISTS (SELECT e1.salary FROM Employee e1 WHERE c.firstName = e1.firstName and c.lastName = e1.lastName)
ORDER BY lastName, firstName


--Q10

SELECT DISTINCT c1.customerID, c1.lastName, c1.firstName
FROM Customer c1, Owns o1, Account a1, Owns o2, Account a2, Owns o3, Account a3
WHERE c1.customerID = o1.customerID and o1.accNumber = a1.accNumber and o1.customerID = o2.customerID and o2.accNumber = a2.accNumber and 
o1.customerID = o3.customerID and o3.accNumber = a3.accNumber and o1.accNumber <> o2.accNumber and o1.accNumber <> o3.accNumber and o2.accNumber <> o3.accNumber and
((a1.type = 'BUS' and a2.type = 'SAV' and a3.type = 'CHQ') or (a1.type = 'SAV' and a2.type = 'BUS' and a3.type = 'CHQ') or (a1.type = 'CHQ' and a2.type = 'BUS' and a3.type = 'SAV') or
(a1.type = 'BUS' and a2.type = 'CHQ' and a3.type = 'SAV') or (a1.type = 'SAV' and a2.type = 'CHQ' and a3.type = 'BUS') or (a1.type = 'CHQ' and a2.type = 'SAV' and a3.type = 'BUS'))
ORDER BY customerID
--Q11

SELECT MAX(e.salary) AS 'Highest salary of a branch manager'
FROM Employee e, Branch b
WHERE e.branchNumber = b.branchNumber and e.sin = b.managerSIN


--Q12

SELECT e.sin, e.firstName, e.lastName, e.salary
FROM Employee e, Branch b
WHERE e.branchNumber = b.branchNumber and b.branchName = 'London' and e.salary = (SELECT MAX(e1.salary) FROM Employee e1)
ORDER BY sin

--Q13

SELECT COUNT(DISTINCT c.firstName) AS 'customer firstNames', COUNT(DISTINCT c.lastName) AS 'customer lastNames',
COUNT(DISTINCT e.firstName) AS 'employee firstNames', COUNT(DISTINCT e.lastName) AS 'employee lastNames'
FROM Customer c, Employee e

--Q14

SELECT b.branchName, MIN(e.salary) AS minSalary, MAX(e.salary) AS maxSalary, AVG(e.salary) AS avgSalary
FROM Employee e, Branch b
WHERE e.branchNumber = b.branchNumber
GROUP BY branchName
ORDER BY branchName

--Q15

SELECT DISTINCT c1.customerID, c1.lastName, c1.birthDate
FROM Customer c1, Owns o1, Account a1, Owns o2, Account a2, Owns o3, Account a3
WHERE c1.customerID = o1.customerID and o1.customerID = o2.customerID and o1.customerID = o3.customerID and 
o1.accNumber = a1.accNumber and o2.accNumber = a2.accNumber and o3.accNumber = a3.accNumber and
a1.branchNumber <> a2.branchNumber and a1.branchNumber <> a3.branchNumber and a2.branchNumber <> a3.branchNumber
ORDER BY customerID

--Q16

SELECT DISTINCT AVG(c1.income) AS 'avg income before 1970', AVG(c2.income) AS 'avg income after/during 1970', 
ABS(AVG(c1.income) - AVG(c2.income)) AS 'difference of income before 1970 and after/during 1970'
FROM Customer c1, Customer c2
WHERE c1.birthDate < '1970-01-01' and c2.birthDate > '1969-12-31'

--Q17
SELECT c1.customerID, c1.lastName, c1.firstName, c1.income, AVG(a1.balance) AS 'avg balance'
FROM Customer c1, Owns o1, Account a1
WHERE c1.customerID = o1.customerID and o1.accNumber = a1.accNumber and 
(c1.lastName LIKE '_r%' or (c1.firstName LIKE '[aeiouAEIOU]%' and c1.firstName NOT LIKE '%[aeiouAEIOU]'))
GROUP BY c1.customerID, c1.lastName, c1.firstName, c1.income
HAVING COUNT(o1.accNumber) > 3
ORDER BY customerID

--Q18
SELECT a1.accNumber, a1.balance, SUM(t1.amount) AS 'sum of trans amts', a1.balance - SUM(t1.amount) AS 'balance - sum of trans amts'
FROM Account a1, Branch b1, Transactions t1
WHERE a1.accNumber = t1.accNumber and a1.branchNumber = b1.branchNumber and b1.branchName = 'New York'
GROUP BY a1.accNumber, a1.balance
HAVING COUNT(t1.transNumber) > 12
ORDER BY accNumber

--Q19

SELECT a1.accNumber, MIN(t1.amount) AS 'min trans amt', AVG(t1.amount) AS 'avg trans amts', MAX(t1.amount) AS 'max trans amts'
FROM Account a1, Branch b1, Transactions t1
WHERE a1.accNumber = t1.accNumber and a1.branchNumber = b1.branchNumber and b1.branchNumber = (SELECT DISTINCT b1.branchNumber 
FROM Account a1, Branch b1, Customer c1, Owns o1
WHERE c1.income = (SELECT MAX(income) FROM Customer WHERE income < ( SELECT MAX( income ) FROM Customer)) and c1.customerID = o1.customerID
and o1.accNumber = a1.accNumber and a1.branchNumber = b1.branchNumber)
GROUP BY a1.accNumber
HAVING COUNT (t1.transNumber) > 10
ORDER BY accNumber

--Q20

SELECT b1.branchName, a1.type, a1.accNumber , t1.transNumber, COUNT(t2.transNumber) AS 'amt of transactions'
FROM Branch b1, Account a1, Transactions t1, Account a2, Transactions t2
WHERE a1. accNumber = t1.accNumber and a1.branchNumber = b1. branchNumber and a1.accNumber = a2.accNumber and a2.accNumber = t2.accNumber
GROUP BY b1.branchName, a1.type, a1.accNumber , t1.transNumber
HAVING AVG(t2.amount) > 3*(SELECT AVG(t3.amount) FROM Account a3, Transactions t3 WHERE a3.accNumber = t3.accNumber and a3.type = a1.type)
ORDER BY branchName, type, accNumber, transNumber

