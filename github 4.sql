---subordering of minimum and maximum values ​​from the table by cities

----creating table

CREATE TABLE [dbo].[product](
	[product_name] [nvarchar](20) NULL,
	[production_date] [date] NULL,
	[number] [int] NULL,
	[price] [decimal](9, 3) NULL,
	[city] [nvarchar](20) NULL
) ON [PRIMARY]
GO

---inserting data
insert into product(city,product_name,production_date,number,price)
values('Baku','Yoghurt','2020-01-01',100,2.550),
('Ankara','Tea','2020-05-02',150,10.500),
('Baku','Sausage','2021-03-19',240,13.75),
('Istanbul','Rice','2022-04-30',500,4.500),
('Ankara','Sugar','2019-07-19',660,5.500),
('Istanbul','Soap','2022-01-01',1000,11.30),
('Ankara','Waffles','2022-02-02',330,8.500),
('Istanbul','Fruit Juice','2021-03-01',2200,2.000),
('Baku','Alcohol','2022-05-05',1200,25.000),
('Ankara','Water','2022-10-10',900,1.800),
('Baku','Bread','2022-07-05',240,2.000),
('Istanbul','Cake','2023-09-18',465,3.700),
('Baku','Pasta','2018-07-01',1250,3.400),
('Ankara','Milk','2021-03-20',1345,2.800),
('Istanbul','Chip','2022-10-30',680,3.000)


---plotting the maximum and minimum values ​​side by side for each city

declare @t table(seher nvarchar(20),deyer1 decimal(9,3),deyer2 decimal(9,3))
insert into @t(seher,deyer1,deyer2)
select distinct(city),a,b from(
select product_name,production_date,number,price,city,max(max_pr) over(partition by city) as a,MIN(min_pr) over(partition by city) as b from(
select product_name,production_date,number,price,city,(case when max_price=price then price else null end) as max_pr,
(case when min_price=price then price else null end) as min_pr  from(
select product_name,production_date,number,city,price,
max(price) over(partition by city) max_price,MIN(price) over(partition by city) min_price  from product
)x
)t
)y
select*from @t

-----plotting the maximum and minimum values ​​for each city from top to bottom ('union all' by method)


declare @x table (seher nvarchar(20),deyer decimal(18,3))

insert into @x 
select seher ,deyer1 from @t
union all 
select seher,deyer2 from @t
select * from @x order by 1

