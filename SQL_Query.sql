/*SQL Internship Project*/
/*MySQL Workbench*/
/*Suicides in India 2001-2012 (Dataset)*/
/*Create Database*/
create database SuicidesInIndia;
/*Create Table*/
create table Records(
State char(20),
Year char(4),
Type_code char(20),
Type char(40),
Gender char(6),
Age_group char(6),
Total int
);
/*Data loaded through command prompt*/
/*Data Analysis:-*/

/*1. Show Male Vs Female Ratio of deaths from 2001 to 2012. */
select mc.Year, round((mc.Total_Deaths/fc.Total_Deaths),1) as Male_Female_Ratio from 
(select Year, Gender, sum(Total) as Total_Deaths from records where Gender='Male' group by Year) as mc,
(select Year, Gender, sum(Total) as Total_Deaths from records where Gender='Female' group by Year) as fc
where mc.Year=fc.Year;

/*	Find the ultimate gender from the entire dataset that which gender commit suicide most often 
(male/female).*/
/*Generally male persons are committed suicide more often in all years*/
select mc.Year, mc.Total_Deaths as Male, fc.Total_Deaths as Female from 
(select Year, Gender, sum(Total) as Total_Deaths from records where Gender='Male' group by Year) as mc,
(select Year, Gender, sum(Total) as Total_Deaths from records where Gender='Female' group by Year) as fc
where mc.Year=fc.Year;

/*2. Which age group has the maximum probability to commit suicide? */
/*As per the dataset, I got the 0-100+ age group has the maximum probability. I take it as in general or 
common rows. So, I removed that and consider the second one as the top i.e. 15-29 age group has the 
maximum probability to commit suicide */
select Age_group, sum(Total) as Total_Deaths from records group by Age_group order by 2 desc limit 6 
offset 1;

/*3. Show a table with two columns. State name and total no of deaths in descending order.*/
Select State, sum(Total) as Total_Deaths from records group by State order by 2 desc;

/* Find the top five states in terms of total deaths.*/
/*Top 5 states are Maharashtra, West Bengal, Tamil Nadu, Andhra Pradesh, and Karnataka*/
Select State, sum(Total) as Total_Deaths from records group by State order by 2 desc limit 5;

/*4. Show a type code and gender wise death rate table in West Bengal.*/
Select Type_code, Gender, sum(Total) as Total_Deaths from records where State='West Bengal' group by 
Type_code, Gender;

/* Which type code is more dangerous for females?*/
/*Education_Status, Means_adopted, and Social_Status are more dangerous for females.*/
select Type_code, Total_Deaths from
(Select Type_code, Gender, sum(Total) as Total_Deaths from records where State='West Bengal' group by 
Type_code, Gender) as temp where Gender='Female' order by 2 desc;

/*5. Show Male Vs Female Ratio of deaths due to love affairs.*/
/*Male:Female = 11:10*/
select round((mc.Total_Deaths/fc.Total_Deaths),1) as Male_Female_Ratio from 
(select Gender, sum(Total) as Total_Deaths from records where Type='Love Affairs' and Gender="Male" 
group by Gender) as mc, (select Gender, sum(Total) as Total_Deaths from records where Type='Love Affairs' 
and Gender="Female" group by Gender) as fc;

/*Which gender type commits suicide most often for this reason?*/
/*Male commits suicide most often*/
select Gender, sum(Total) as Total_Deaths from records where Type='Love Affairs' group by Gender;

/*6. How many students died in the last five years?*/
select Year, sum(Total) as Total_Deaths from records where Year between '2008' and '2012' and 
Type='Student' group by Year;

/*Total Students*/
/*34550 students were died in last 5 years*/
Select sum(Total_Deaths) as Total_Students from (select Year, sum(Total) as Total_Deaths from 
records where Year between '2008' and '2012' and Type='Student' group by Year) as temp;

/*7. Show the percentage of death rate between males and females due to unemployment and unemployed.*/
/*Male Percentage= 82.86% and Female Percentage= 17.14% */
select concat(round(((mc.Total_Deaths*100)/(mc.Total_Deaths+fc.Total_Deaths)),2),'%') as Male_Percentage,
concat(round(((fc.Total_Deaths*100)/(mc.Total_Deaths+fc.Total_Deaths)),2),'%') as Female_Percentage from 
(select Gender, sum(Total) as Total_Deaths from records where Gender='Male' and Type like 'Unemploy%' 
group by Gender) as mc,(select Gender, sum(Total) as Total_Deaths from records where Gender='Female' 
and Type like 'Unemploy%' group by Gender) as fc;

/*8. Filter the data for female where suicide had done for Domestic problems (Dowry, Non-Settlement 
of Marriage, family problem, pregnancy)*/
select * from records where Gender='Female' and Total>0 and (Type like 'Dowry%' or Type like 
'Cancellation%' or Type like 'Family%' or Type like '%Pregnancy%');

/*Which state has the maximum number of domestic problems? */
/*Maharashtra has the maximum number of domestic problems*/
Select State, sum(Total) as Total_Deaths from (select * from records where Gender='Female' and Total>0 
and (Type like 'Dowry%' or Type like 'Cancellation%' or Type like 'Family%' or Type like '%Pregnancy%')) 
as temp group by State order by 2 desc limit 10;

/*Which year domestic problems reach the highest level? */
/*In 2011, domestic problems reach the highest level i.e. 16381 deaths*/
Select Year, sum(Total) as Total_Deaths from (select * from records where Gender='Female' and Total>0 
and (Type like 'Dowry%' or Type like 'Cancellation%' or Type like 'Family%' or Type like '%Pregnancy%')) 
as temp group by Year order by 2 desc limit 10;

/*9. Which Age group generally hang themselves?*/
/*15-29 age group*/
select Age_group, sum(Total) as Total_Deaths from records where Type like '%Hanging%' group by Age_group
order by 2 desc;

/*10. Show the table where suicide has done for Social Abuse (Rape) cases.*/
select * from records where Type like '%Rape%' and Total>0;

/*Find the top five states where social abuse is the primary cause of suicide.*/
/*Top 5 states are Madhya Pradesh, Maharashtra, Chhattisgarh, Uttar Pradesh, and Gujarat*/
select State, sum(Total) as Total_Deaths from (select * from records where Type like '%Rape%' and Total>0)
as temp group by state order by 2 desc limit 5;

/*11. Show the data where suicide had done for Family problem (property, poverty, family problem) cases.*/
select * from records where total>0 and (Type like 'Property%' or Type like 'Poverty%' or Type like 
'Family%');

/*	Show the percentage of deaths between males and females for a family problem.*/
/*Male =62.96% and Female =37.04% */
select concat(round((mc.Total_Deaths*100)/(mc.Total_Deaths+fc.Total_Deaths),2),'%') as Male_Percentage, 
concat(round((fc.Total_Deaths*100)/(mc.Total_Deaths+fc.Total_Deaths),2),'%') as Female_Percentage from
(select Gender, sum(Total) as Total_Deaths from (select * from records where total>0 and (Type like 
'Property%' or Type like 'Poverty%' or Type like 'Family%')) as temp where Gender='Male' group by 
Gender) as mc, (select Gender, sum(Total) as Total_Deaths from (select * from records where total>0 and 
(Type like 'Property%' or Type like 'Poverty%' or Type like 'Family%')) as temp where Gender='Female' 
group by Gender) as fc;

/*12. In which year and state maximum suicide happened due to Education (failure in the exam, career 
problem) cases for the age group of 15-45.*/
/*Year*/
/*In 2011, maximum suicide happened due to Education */
select Year, sum(Total) as Total_Deaths from records where (Type like 'Failure%' or Type like 
'%career%') and (Age_group='15-29' or Age_group='30-44') group by Year order by 1;

/*State*/
/*In West bengal, maximum suicide happened due to Education */
select State, sum(Total) as Total_Deaths from records where (Type like 'Failure%' or Type like 
'%career%') and (Age_group='15-29' or Age_group='30-44') group by State order by 2 desc;

/*	Show the top five states and number of deaths that happened for education cases*/
/*Top 5 states are West Bengal, Maharashtra, Tamil Nadu, Andhra Pradesh, and Madhya Pradesh*/
select State, sum(Total) as Total_Deaths from records where (Type like 'Failure%' or Type like 
'%career%') and (Age_group='15-29' or Age_group='30-44') group by State order by 2 desc limit 5;

/*13.Show the table where males had committed suicide for Addiction (Drug, Alcohol).*/
select * from records where Gender='Male' and Total>0 and (Type like 'Drug%' or Type like '%Alcohol%');

/*Which age group generally addicted and committed suicide? */
/*30-44 age group is generally addicted and committed suicide*/
select Age_group, sum(Total) as Total_Deaths from (select * from records where Gender='Male' and Total>0 
and (Type like 'Drug%' or Type like '%Alcohol%')) as temp group by Age_group order by 2 desc;

/*In which state maximum deaths has happened for this reason (total death)? */
/*In Maharashtra, maximum deaths has happened due to addiction*/
select State, sum(Total) as Total_Deaths from (select * from records where Gender='Male' and Total>0
and (Type like 'Drug%' or Type like '%Alcohol%')) as temp group by State order by 2 desc limit 5;
 
 /*14.What is the Top 3 reason for both male and female to commit suicide?*/
/*Male*/
/*Top 3 reasons for males are Married, others, and By Hanging*/
select Type, sum(Total) as Total_Deaths from records where gender='Male' group by Type order by 2 desc
limit 3;

/*Female*/
/*Top 3 reasons for females are Married, house wife, and By Hanging*/
select Type, sum(Total) as Total_Deaths from records where gender='Female' group by Type order by 2 desc 
limit 3;

/*15.Show the ratio of mental illness suicide cases for males and females in India.*/
/*Male: Female = 9:5 */
select round(mc.Total_Deaths/fc.Total_Deaths,1) as Male_Female_Ratio from (select Gender, sum(Total) as 
Total_Deaths from records where gender='Male' group by Gender and Type like '%Mental%') as mc,
(select Gender, sum(Total) as Total_Deaths from records where gender='Female' group by Gender and Type 
like '%Mental%') as fc;

/*16. Show state wise the percentage of Relationship (love affairs, Divorce, Divorcee) death cases for 
males and females of 15-44 age groups.*/
select State, concat(round((Total_Deaths*100)/(select sum(Total_Deaths) from (select State, sum(Total) as 
Total_Deaths from records where (Age_group='15-29' or Age_group='30-44') and (Type like 'Love%' or Type 
like 'Divorce%') group by State) as temp1),2),'%') as Death_Percentage  from (select State, sum(Total) as 
Total_Deaths from records where (Age_group='15-29' or Age_group='30-44') and (Type like 'Love%' or Type 
like 'Divorce%') group by State) as temp;

/*Show the top five states and their percentage of deaths*/
/*Top 5 states are Andhra Pradesh, Maharashtra, Gujarat, Odisha, and Madhya Pradesh */
select State, concat(round((Total_Deaths*100)/(select sum(Total_Deaths) from (select State, sum(Total) as 
Total_Deaths from records where (Age_group='15-29' or Age_group='30-44') and (Type like 'Love%' or Type 
like 'Divorce%') group by State) as temp1),2),'%') as Death_Percentage  from (select State, sum(Total) as 
Total_Deaths from records where (Age_group='15-29' or Age_group='30-44') and (Type like 'Love%' or Type 
like 'Divorce%') group by State) as temp order by 2 desc limit 5;

/*17. How many deaths or suicides have done for sudden mental trauma (death of a dear person, cancer, 
illness) cases? */
select * from records where Total >0  and (Type like 'Cancer' or Type like 'Death%' or Type like 
'%illness%');

/*Total Deaths*/
/*316896 deaths has done for sudden mental trauma cases. */
select sum(Total) as Total_Deaths from (select * from records where Total >0  and (Type like 'Cancer' 
or Type like 'Death%' or Type like '%illness%')) as temp;

/*Show state wise result*/
/*Maharashtra is at the top with 52757 deaths due to sudden mental trauma cases. */
select State, sum(Total) as Total_Deaths from (select * from records where Total >0  and (Type like 
'Cancer' or Type like 'Death%' or Type like '%illness%')) as temp group by State order by 2 desc limit 5;

/*Show year wise result*/
/*In 2010, maximum deaths has done for sudden mental trauma cases. */
select Year, sum(Total) as Total_Deaths from (select * from records where Total >0  and (Type like 
'Cancer' or Type like 'Death%' or Type like '%illness%')) as temp group by Year;

/*18. Show year wise rank of deaths for students who are educated (graduate and above)*/
/*2012 gets rank 1 due to deaths for educated students (graduate and above)*/
select Year, sum(Total) as Total_Deaths, Rank() Over(order by sum(Total) desc) as Ranking from records 
where Type like '%Graduate%' or Type like 'Diploma' group by Year;

/*	Find state wise ratio of deaths (male vs female)*/
select mc.State, round(mc.Total_Deaths/fc.Total_Deaths,1) as Male_Female_Ratio from (select State, 
sum(Total) as Total_Deaths from records where (Type like '%Graduate%' or Type like 'Diploma') and 
Gender='Male' group by State) as mc, (select State, sum(Total) as Total_Deaths from records where 
(Type like '%Graduate%' or Type like 'Diploma') and Gender='Female' group by State) as fc where 
mc.State=fc.State order by 2 desc limit 10;
