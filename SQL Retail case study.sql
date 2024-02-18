Create Database Retail

Select*from Customer
Select*From Transactions
Select*From Prod_cat_Info

--DATA PREPRATION AND UNDERSTANDING--

--Q1.

Select*From
(Select Count(Customer_ID) As CUSTOMER_COUNT From Customer 
Union
Select Count(Prod_cat_code) AS PRODUCT_COUNT From prod_cat_info
Union
Select Count(transaction_id)  AS TRASACTION_COUNT From Transactions) as A

--Q2.

Select Count(total_amt) as 'Return' From Transactions
Where total_amt <0

--Q3.

Alter Table Transactions
Alter Column tran_date date

Alter Table Customer
Alter  Column DOB Date


--Q4.

Select 
       DATEDIFF(Day, Min(Tran_date),Max(Tran_date)) As Days,
       DATEDIFF(Month,Min(Tran_date),Max(Tran_date) ) As Months,
       DATEDIFF(Year, Min(Tran_date),Max(Tran_date)) As Years
From Transactions

--Q5.

Select Distinct prod_cat_code,prod_cat
From prod_cat_info
Where Prod_subcat='DIY'

--DATA ANALYSIS--

--Q1.

 Select Top 1 Store_Type ,COUNT(Store_type)As Frequency From [dbo].[Transactions] 
 Group by Store_Type
 Order By Frequency desc
	
--Q2.

SELECT Count(Customer_Id) AS MALES
FROM Customer
WHERE GENDER = 'M'
SELECT Count(Customer_Id) AS MALES
FROM Customer
WHERE GENDER = 'F'

--Q3.

Select Top 1 City_code,Count(Customer_id) as Customer_Count
From Customer
Group By city_code Order by Customer_Count desc

--Q4.

Select Count(Prod_subcat) as Books
From prod_cat_info
Where prod_cat='Books'

--Q5.

Select Max(Qty) as Product_Count
From Transactions
where Qty>0

--Q6.

 SELECT [prod_cat], SUM((TOTAL_AMT)-(TAX)) AS Revenue
FROM [prod_cat_info] as A
INNER JOIN [Transactions] AS B ON A.[prod_cat_code] = B.[prod_cat_code]
GROUP BY [prod_cat]
HAVING [prod_cat] IN ('Electronics' , 'Books')


--Q7.

SELECT [cust_id], count([transaction_id]) as Number_of_transactions
FROM [Transactions]
where [total_amt] > 0
group by [cust_id]
having count([transaction_id]) > 10 

--Q8.

Select Sum(Total_amt) As Revenue
From Transactions AS A
Inner join prod_cat_info AS B
On A.prod_cat_code=B.prod_cat_code
Where prod_cat='Clothing' Or prod_cat='Electronics'
And Store_type like 'Flagship'

--Q9.

 Select B.prod_subcat,Sum(total_amt) as Revenue From Transactions as A
 inner join prod_cat_info as B
 On B.prod_sub_cat_code=A.prod_subcat_code
 inner join Customer as C
 On C.customer_id =A.cust_id
 Where prod_cat='Electronics' And Gender='M'
 Group By prod_subcat

 --Q10.

 Select Top 5 Prod_Subcat, (Sum(Total_Amt)/(Select Sum(Total_Amt) From Transactions))*100 As [Sales%], 
(Count(Case When Qty < 0 Then Qty Else Null End)/Sum(Qty))*100 As [Return%]
From Transactions As A
Inner Join Prod_Cat_Info As B
On A.Prod_Cat_Code = B.Prod_Cat_Code And Prod_Subcat_Code = Prod_Sub_Cat_Code
Group By Prod_Subcat
Order By Sum(Total_Amt) Desc


 --Q11.

 select customer_Id,Sum(Total_amt) as Revenue
 from Customer 
 Inner join Transactions 
 On Transactions.cust_id= customer_Id
where Datediff(year,DOB,GETDATE()) between 25 and 35
And tran_date >=DATEADD(day,-30, (Select Max(tran_date)From Transactions ))
  Group by Customer_id Order By Revenue desc

--Q12.

Select Top 1  prod_cat ,Sum(total_amt) as Returns
From Transactions
Inner join prod_cat_info
On prod_cat_info.prod_cat_code=Transactions.prod_cat_code
Where total_amt<0 
And tran_date>=DATEADD(Month,-3,(select Max(tran_date) from Transactions))
Group by prod_cat Order by [Returns] Asc

--Q13.

Select Top 1 Store_type,Sum(total_amt) as Sales,Sum(Cast(Qty as float)) As Total_Amount
From Transactions
group by Store_type 
order by Sales Desc

--Q14.

Select prod_cat,Avg(total_amt) as Avg_revenue
From Transactions AS A
Inner Join prod_cat_info AS B
On B.prod_cat_code=A.prod_cat_code
Group by prod_cat
Having avg(total_amt)>(Select avg(total_amt) from Transactions)

--Q15.

Select Prod_subcat,Prod_cat,Avg(Total_Amt) as Avg_revenue ,Sum(Total_amt) as Total_revenue
From Transactions AS A
Inner join prod_cat_info AS B
On B.prod_cat_code=A.prod_cat_code
where prod_cat in (Select Top 5 prod_cat
         From Transactions
     Inner Join prod_cat_info
     On B.prod_cat_code=A.prod_cat_code
     Group by prod_cat
     Order by Sum(cast(qty as Float)) desc)
Group by prod_cat,prod_subcat order by prod_cat,prod_subcat


