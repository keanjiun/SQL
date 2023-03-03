Create Table EmployeeDemographics (
Age int,
Gender varchar(50))

Insert Into EmployeeDemographics Values
(30, 'Male')

Select *
From EmployeeDemographics

Select *
From EmployeeDemographics
Inner Join EmployeeSalary
On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

Select EmployeeID, FirstName, Age
From EmployeeDemographics
Union
Select EmployeeID, JobTitle, Salary
From EmployeeSalary
Order By EmployeeID

Select FirstName, LastName, Age,
Case
	When Age > 30 Then 'Old'
	When Age Between 27 and 30 Then 'Young'
	Else 'Baby'
End
From EmployeeDemographics
Where Age is Not Null
Order By Age

Select FirstName, LastName, JobTitle, Salary,
Case
	When JobTitle = 'Salesman' Then Salary + (Salary*.10)
	When JobTitle = 'Accountant' Then Salary + (Salary*.05)
	When JobTitle = 'HR' Then Salary*1.0001
	Else Salary*1.03
End As SalaryAfterRaise
From EmployeeDemographics
Join EmployeeSalary
On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

Select JobTitle, Count(JobTitle) As CountJobTitle
From EmployeeDemographics
Join EmployeeSalary
On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Group By JobTitle
Having Count(JobTitle) > 1

Select *
From EmployeeDemographics

Update EmployeeDemographics
Set Age = 31, Gender = 'Female'
Where EmployeeID = 1012

Delete From EmployeeDemographics
Where EmployeeID = 1005

Select FirstName, LastName, Gender, Salary, Count(Gender) Over (Partition By Gender) As TotalGender
From EmployeeDemographics
Join EmployeeSalary
On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

With CTE_Employee as
(Select FirstName, LastName, Gender, Salary, Count(Gender) Over (Partition By Gender) As TotalGender
From EmployeeDemographics
Join EmployeeSalary
On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID)

Select FirstName, Salary
From CTE_Employee

Create Table #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int)

Select *
From #temp_Employee

Insert Into #temp_Employee Values (
'1001', 'HR', '45000')

Insert Into #temp_Employee 
Select *
From EmployeeSalary

Drop Table If Exists #temp_Employee2

Create Table #temp_Employee2 (
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int)

Insert Into #temp_Employee2
Select FirstName, LastName, Gender, Salary, Count(Gender) Over (Partition By Gender) As TotalGender
From EmployeeDemographics
Join EmployeeSalary
On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')


 Using Trim, LTRIM, RTRIM

Select EmployeeID, Trim(EmployeeID) as IDTRIM
From EmployeeErrors
	
Select EmployeeID, LTrim(EmployeeID) as IDTRIM
From EmployeeErrors

Select EmployeeID, RTrim(EmployeeID) as IDTRIM
From EmployeeErrors

 Using Replace

Select LastName,Replace(LastName, '- Fired', '') as LastNameFixed
From EmployeeErrors


Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3)
From EmployeeErrors as err
Join EmployeeDemographics as dem
 On Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)

 Using UPPER and lower

Select FirstName, LOWER(FirstName) LowCase
From EmployeeErrors

Select FirstName, UPPER(FirstName) Cap
From EmployeeErrors

Create Procedure Test
As
Select *
From EmployeeDemographics

Exec Test

CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select *
From #temp_employee

Exec Temp_Employee @JobTitle = 'Salesman'

Select *
From EmployeeSalary

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

Select a.EmployeeID, AllAvgSalary
From (Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary 
	From EmployeeSalary) a

Select EmployeeID, JobTitle, Salary
From EmployeeSalary
Where EmployeeID in (
	Select EmployeeID
	From EmployeeDemographics
	Where Age >30)