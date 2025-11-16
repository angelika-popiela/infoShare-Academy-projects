
/*7. World Development Indicators - Najlepsi z najlepszych i najgorsi z najgorszych - czyli
paÒstwa/regiony ktÛre w danych dziedzinach w nied≥ugim czasie sta≥y siÍ potentatami lub
popad≥y w ruinÍ */


select * from Country c 

select * from CountryNotes cn 

select distinct i.IndicatorName  from Indicators i 

/* 1. Fossil fuel energy consumption (% of total)
2. Fuel exports (% of merchandise exports)
3. Exports of goods and services (annual % growth)
4. Imports of goods and services (annual % growth)
5. High-technology exports (% of manufactured exports)
6. Inflation, consumer prices (annual %)
7. Ores and metals exports (% of merchandise exports)
8. Ores and metals imports (% of merchandise imports)
9. Energy use (kg of oil equivalent per capita)
10. Renewable energy consumption (% of total final energy consumption) */ 



--MOTHER QUERY (VIEW)-----------------------------------------------------------------------------------
create view v_primary_view as
select
c.Region ,
i.CountryName ,
i.CountryCode ,
i.IndicatorName ,
i."Year" ,
round(i.Value) as wskaznik
from Indicators i
join Country c
on i.CountryCode = c.CountryCode
where c.Region <> ""


--1. Fossil fuel energy consumption (% of total) (FIRST PERIOD)--------------------------------------------------------------------------
create view v_fossil_fuel_consumption_2006 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Fossil fuel energy consumption (% of total)" and vp.year = 2006
order by CountryName

--1. Fossil fuel energy consumption (% of total)  (SECOND PERIOD) --
create view v_fossil_fuel_consumption_2010 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Fossil fuel energy consumption (% of total)" and vp.year = 2010
order by CountryName


--1. Fossil fuel energy consumption (% of total)  (THIRD PERIOD) --
create view v_fossil_fuel_consumption_2008 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Fossil fuel energy consumption (% of total)" and vp.year = 2008
order by CountryName

select vp.wskaznik from Indicators i 

--TOP 10 NAJGORSZYCH PA—STW FF consumption (ze wskzanikiem pomiedzy 2008)
select
ffc06.CountryName,
ffc06.wskaznik as wskaznik_2006,
ffc08.wskaznik as wskaznik_2008,
ffc10.wskaznik as wskaznik_2010,
round(ffc10.wskaznik/ffc06.wskaznik-1,2) as spadek_wskaznika
from v_fossil_fuel_consumption_2006 ffc06
join v_fossil_fuel_consumption_2010 ffc10
on ffc06.CountryCode = ffc10.CountryCode
join v_fossil_fuel_consumption_2008 ffc08
on ffc08.CountryCode = ffc06.CountryCode
order by spadek_wskaznika 
Limit 10

--TOP 10 NAJLEPSZYCH PA—STW FF consumption
select
ffc06.CountryName,
ffc06.wskaznik as wskaznik_2006,
ffc10.wskaznik as wskaznik_2010,
round(ffc10.wskaznik/ ffc06.wskaznik-1,2) as wzrost_wskaznika
from v_fossil_fuel_consumption_2006 ffc06
join v_fossil_fuel_consumption_2010 ffc10
on ffc06.CountryCode = ffc10.CountryCode
order by wzrost_wskaznika desc
Limit 10

--REGIONY FF consumption
select
ffc06.region,
round(AVG(ffc06.wskaznik)) as wskaznik_2006,
round(AVG(ffc10.wskaznik)) as wskaznik_2010,
round((AVG(ffc10.wskaznik)) / (AVG(ffc06.wskaznik))-1,2) as spadek_wzrost
from v_fossil_fuel_consumption_2006 ffc06
join v_fossil_fuel_consumption_2010 ffc10
on ffc06.CountryCode = ffc10.CountryCode
group by ffc06.region
order by spadek_wzrost desc


/*-- 2. Fuel exports (% of merchandise exports) */-------------------------------------------------------


--2. Fuel exports (% of merchandise exports) (FIRST PERIOD)

create view v_fuel_exports_2010 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Fuel exports (% of merchandise exports)" and vp.year = 2010 
order by CountryName

--2. Fuel exports (% of merchandise exports) (FIRST PERIOD)
create view v_fuel_exports_2014 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Fuel exports (% of merchandise exports)" and vp.year = 2014 
order by CountryName

--TOP 10 SPADEK Fuel exports
select
fes10.CountryName,
fes10.wskaznik as wskaznik_2010,
fes14.wskaznik as wskaznik_2014,
case when fes10.wskaznik < 0 then round(fes14.wskaznik/fes10.wskaznik-1,2)*-1
when fes10.wskaznik > 0 then round(fes14.wskaznik/fes10.wskaznik-1,2) 
else round(fes14.wskaznik/fes10.wskaznik-1,2) end spadek_wskaznika
from v_fuel_exports_2010 fes10
join v_fuel_exports_2014 fes14
on fes10.CountryCode = fes14.CountryCode
where spadek_wskaznika is not null 
order by spadek_wskaznika 
Limit 10


--TOP 10 NAJWI KSZY WZROST Fuel exports
select
fes10.CountryName,
fes10.wskaznik as wskaznik_2010,
fes14.wskaznik as wskaznik_2014,
case when fes10.wskaznik < 0 then round(fes14.wskaznik/fes10.wskaznik-1,2)*-1
when fes10.wskaznik > 0 then round(fes14.wskaznik/fes10.wskaznik-1,2) 
else round(fes14.wskaznik/fes10.wskaznik-1,2) end wzrost_wskaznika
from v_fuel_exports_2010 fes10
join v_fuel_exports_2014 fes14
on fes10.CountryCode = fes14.CountryCode
where wzrost_wskaznika is not null 
order by wzrost_wskaznika desc
Limit 10

--REGIONY Fuel exports (% of merchandise exports)
select
fes10.region,
round(AVG(fes10.wskaznik)) as wskaznik_2010,
round(AVG(fes14.wskaznik)) as wskaznik_2014,
round((AVG(fes14.wskaznik)) / (AVG(fes10.wskaznik))-1,2) as spadek_wzrost
from v_fuel_exports_2010 fes10
join v_fuel_exports_2014 fes14
on fes10.CountryCode = fes14.CountryCode
group by fes10.region
order by spadek_wzrost desc


--3. Exports of goods and services (annual % growth)--------------------------------------------------------------------

--(FIRST PERIOD)--
create view v_exports_goods_services_2010 as 
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Exports of goods and services (annual % growth)" and vp.year = 2010 
order by CountryName

--(SECOND PERIOD)--
create view v_exports_goods_services_2014 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Exports of goods and services (annual % growth)" and vp.year = 2014 
order by CountryName

--TOP 10 SPADEK Exports of goods and services (annual % growth)
select
ex_gs10.CountryName,
ex_gs10.wskaznik as wskaznik_2010,
ex_gs14.wskaznik as wskaznik_2014,
case when ex_gs10.wskaznik < 0 then round(ex_gs14.wskaznik/ex_gs10.wskaznik-1,2)*-1
when ex_gs10.wskaznik > 0 then round(ex_gs14.wskaznik/ex_gs10.wskaznik-1,2) 
else round(ex_gs14.wskaznik/ex_gs10.wskaznik-1,2) end spadek_wskaznika
from v_exports_goods_services_2010 ex_gs10
join v_exports_goods_services_2014 ex_gs14
on ex_gs10.CountryCode = ex_gs14.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 
Limit 10


--TOP 10 WZROST Exports of goods and services (annual % growth)

select
ex_gs10.CountryName,
ex_gs10.wskaznik as wskaznik_2010,
ex_gs14.wskaznik as wskaznik_2014,
case when ex_gs10.wskaznik < 0 then round(ex_gs14.wskaznik/ex_gs10.wskaznik-1,2)*-1
when ex_gs10.wskaznik > 0 then round(ex_gs14.wskaznik/ex_gs10.wskaznik-1,2) 
else round(ex_gs14.wskaznik/ex_gs10.wskaznik-1,2) end wzrost_wskaznika
from v_exports_goods_services_2010 ex_gs10
join v_exports_goods_services_2014 ex_gs14
on ex_gs10.CountryCode = ex_gs14.CountryCode
where wzrost_wskaznika is not null
order by wzrost_wskaznika desc
Limit 10


--REGIONY Exports of goods and services (annual % growth)
select
ex_gs10.region,
round(AVG(ex_gs10.wskaznik)) as wskaznik_2010,
round(AVG(ex_gs14.wskaznik)) as wskaznik_2014,
round((AVG(ex_gs14.wskaznik)) / (AVG(ex_gs10.wskaznik))-1,2) as spadek_wzrost
from v_exports_goods_services_2010 ex_gs10
join v_exports_goods_services_2014 ex_gs14
on ex_gs10.CountryCode = ex_gs14.CountryCode
group by ex_gs10.region
order by spadek_wzrost desc


-- 4. Imports of goods and services (annual % growth) ----------------------------------------------------------------------------

--(FIRST PERIOD)--
create view v_imports_goods_services_2010 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Imports of goods and services (annual % growth)" and vp.year = 2010 
order by CountryName

--(SECOND PERIOD)--
create view v_imports_goods_services_2014 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Imports of goods and services (annual % growth)" and vp.year = 2014 
order by CountryName

--TOP 10 SPADEK Imports of goods and services (annual % growth)

select
imp_gs10.CountryName,
imp_gs10.wskaznik as wskaznik_2010,
imp_gs14.wskaznik as wskaznik_2014,
case when imp_gs10.wskaznik < 0 then round(imp_gs14.wskaznik/imp_gs10.wskaznik-1,2)*-1
when imp_gs10.wskaznik > 0 then round(imp_gs14.wskaznik/imp_gs10.wskaznik-1,2) 
else round(imp_gs14.wskaznik/imp_gs10.wskaznik-1,2) end spadek_wskaznika
from v_imports_goods_services_2010 imp_gs10
join v_imports_goods_services_2014 imp_gs14
on imp_gs10.CountryCode = imp_gs14.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 
Limit 10


--TOP 10 WZROST Imports of goods and services (annual % growth)

select
imp_gs10.CountryName,
imp_gs10.wskaznik as wskaznik_2010,
imp_gs14.wskaznik as wskaznik_2014,
case when imp_gs10.wskaznik < 0 then round(imp_gs14.wskaznik/imp_gs10.wskaznik-1,2)*-1
when imp_gs10.wskaznik > 0 then round(imp_gs14.wskaznik/imp_gs10.wskaznik-1,2) 
else round(imp_gs14.wskaznik/imp_gs10.wskaznik-1,2) end wzrost_wskaznika
from v_imports_goods_services_2010 imp_gs10
join v_imports_goods_services_2014 imp_gs14
on imp_gs10.CountryCode = imp_gs14.CountryCode
where wzrost_wskaznika is not null
order by wzrost_wskaznika desc
Limit 10


--REGIONY Imports of goods and services (annual % growth) -- 
select
imp_gs10.region,
round(AVG(imp_gs10.wskaznik)) as wskaznik_2010,
round(AVG(imp_gs14.wskaznik)) as wskaznik_2014,
round((AVG(imp_gs14.wskaznik)) / (AVG(imp_gs10.wskaznik))-1,2) as spadek_wzrost
from v_imports_goods_services_2010 imp_gs10
join v_imports_goods_services_2014 imp_gs14
on imp_gs10.CountryCode = imp_gs14.CountryCode
group by imp_gs10.region
order by spadek_wzrost desc

-- 5. High-technology exports (% of manufactured exports) ------------------------------------------------

--(FIRST PERIOD)--
create view v_high_tech_exp_2009 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "High-technology exports (% of manufactured exports)" and vp.year = 2009 
order by CountryName

--(SECOND PERIOD)--
create view v_high_tech_exp_2013 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "High-technology exports (% of manufactured exports)" and vp.year = 2013 
order by CountryName


-- High-technology exports (% of manufactured exports) SPADEK 

select
ht_exp09.CountryName,
ht_exp09.wskaznik as wskaznik_2009,
ht_exp13.wskaznik as wskaznik_2013,
case when ht_exp09.wskaznik < 0 then round(ht_exp13.wskaznik/ht_exp09.wskaznik-1,2)*-1
when ht_exp09.wskaznik > 0 then round(ht_exp13.wskaznik/ht_exp09.wskaznik-1,2) 
else round(ht_exp13.wskaznik/ht_exp09.wskaznik-1,2) end spadek_wskaznika
from v_high_tech_exp_2009 ht_exp09
join v_high_tech_exp_2013 ht_exp13
on ht_exp09.CountryCode = ht_exp13.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 
Limit 10

-- High-technology exports (% of manufactured exports) WZROST

select
ht_exp09.CountryName,
ht_exp09.wskaznik as wskaznik_2009,
ht_exp13.wskaznik as wskaznik_2013,
case when ht_exp09.wskaznik < 0 then round(ht_exp13.wskaznik/ht_exp09.wskaznik-1,2)*-1
when ht_exp09.wskaznik > 0 then round(ht_exp13.wskaznik/ht_exp09.wskaznik-1,2) 
else round(ht_exp13.wskaznik/ht_exp09.wskaznik-1,2) end wzrost_wskaznika
from v_high_tech_exp_2009 ht_exp09
join v_high_tech_exp_2013 ht_exp13
on ht_exp09.CountryCode = ht_exp13.CountryCode
where wzrost_wskaznika is not null
order by wzrost_wskaznika desc
Limit 10


--REGIONY High-technology exports (% of manufactured exports)-- 
select
ht_exp09.region,
round(AVG(ht_exp09.wskaznik)) as wskaznik_2009,
round(AVG(ht_exp13.wskaznik)) as wskaznik_2013,
round((AVG(ht_exp13.wskaznik)) / (AVG(ht_exp09.wskaznik))-1,2) as spadek_wzrost
from v_high_tech_exp_2009 ht_exp09
join v_high_tech_exp_2013 ht_exp13
on ht_exp09.CountryCode = ht_exp13.CountryCode
group by ht_exp09.region
order by spadek_wzrost desc

---6. Inflation, consumer prices (annual %)------------------------------------------

--(FIRST PERIOD)--
create view v_inflation_2010 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Inflation, consumer prices (annual %)" and vp.year = 2010 
order by CountryName

--(SECOND PERIOD)--
create view v_inflation_2014 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Inflation, consumer prices (annual %)" and vp.year = 2014 
order by CountryName

--SPADEK Infalcja -- 
select
inf_10.CountryName,
inf_10.wskaznik as wskaznik_2010,
inf_14.wskaznik as wskaznik_2014,
case when inf_10.wskaznik < 0 then round(inf_14.wskaznik/inf_10.wskaznik-1,2)*-1
when inf_10.wskaznik > 0 then round(inf_14.wskaznik/inf_10.wskaznik-1,2) 
else round(inf_14.wskaznik/inf_10.wskaznik-1,2) end spadek_wskaznika
from v_inflation_2010 inf_10
join v_inflation_2014 inf_14
on inf_10.CountryCode = inf_14.CountryCode
order by spadek_wskaznika 
Limit 11


--WZROST Infalcja -- 
select
inf_10.CountryName,
inf_10.wskaznik as wskaznik_2010,
inf_14.wskaznik as wskaznik_2014,
case when inf_10.wskaznik < 0 then round(inf_14.wskaznik/inf_10.wskaznik-1,2)*-1
when inf_10.wskaznik > 0 then round(inf_14.wskaznik/inf_10.wskaznik-1,2) 
else round(inf_14.wskaznik/inf_10.wskaznik-1,2) end wzrost_wskaznika
from v_inflation_2010 inf_10
join v_inflation_2014 inf_14
on inf_10.CountryCode = inf_14.CountryCode
order by wzrost_wskaznika desc
Limit 20


--REGIONY Inflacja -- 

select
inf_10.region,
round(AVG(inf_10.wskaznik)) as wskaznik_2010,
round(AVG(inf_14.wskaznik)) as wskaznik_2014,
round((AVG(inf_14.wskaznik)) / (AVG(inf_10.wskaznik))-1,2) as spadek_wzrost
from v_inflation_2010 inf_10
join v_inflation_2014 inf_14
on inf_10.CountryCode = inf_14.CountryCode
group by inf_10.region
order by spadek_wzrost desc

--7. Ores and metals exports (% of merchandise exports)-------------------------------------------------------------------


--(FIRST PERIOD)--
create view v_ores_metals_exports_2009 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Ores and metals exports (% of merchandise exports)" and vp.year = 2009 
order by CountryName

--(SECOND PERIOD)--
create view v_ores_metals_exports_2013 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Ores and metals exports (% of merchandise exports)" and vp.year = 2013
order by CountryName

--SPADEK "Ores and metals exports (% of merchandise exports) --
select
or_met_exp09.CountryName,
or_met_exp09.wskaznik as wskaznik_2009,
or_met_exp13.wskaznik as wskaznik_2013,
case when or_met_exp09.wskaznik < 0 then round(or_met_exp13.wskaznik/or_met_exp09.wskaznik-1,2)*-1
when or_met_exp09.wskaznik > 0 then round(or_met_exp13.wskaznik/or_met_exp09.wskaznik-1,2) 
else round(or_met_exp13.wskaznik/or_met_exp09.wskaznik-1,2) end spadek_wskaznika
from v_ores_metals_exports_2009 or_met_exp09
join v_ores_metals_exports_2013 or_met_exp13
on or_met_exp09.CountryCode = or_met_exp13.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 
Limit 10


--WZROST "Ores and metals exports (% of merchandise exports) --
select
or_met_exp09.CountryName,
or_met_exp09.wskaznik as wskaznik_2009,
or_met_exp13.wskaznik as wskaznik_2013,
case when or_met_exp09.wskaznik < 0 then round(or_met_exp13.wskaznik/or_met_exp09.wskaznik-1,2)*-1
when or_met_exp09.wskaznik > 0 then round(or_met_exp13.wskaznik/or_met_exp09.wskaznik-1,2) 
else round(or_met_exp13.wskaznik/or_met_exp09.wskaznik-1,2) end wzrost_wskaznika
from v_ores_metals_exports_2009 or_met_exp09
join v_ores_metals_exports_2013 or_met_exp13
on or_met_exp09.CountryCode = or_met_exp13.CountryCode
where wzrost_wskaznika is not null
order by wzrost_wskaznika desc
Limit 10

--REGIONY-- "Ores and metals exports (% of merchandise exports)-- 

select
or_met_exp09.region,
round(AVG(or_met_exp09.wskaznik)) as wskaznik_2009,
round(AVG(or_met_exp13.wskaznik)) as wskaznik_2013,
round((AVG(or_met_exp13.wskaznik)) / (AVG(or_met_exp09.wskaznik))-1,2) as spadek_wzrost
from v_ores_metals_exports_2009 or_met_exp09
join v_ores_metals_exports_2013 or_met_exp13
on or_met_exp09.CountryCode = or_met_exp13.CountryCode
group by or_met_exp09.region
order by spadek_wzrost desc

-- 8. Ores and metals imports (% of merchandise imports)----------------------------------------------------------

--(FIRST PERIOD)--
create view v_ores_metals_imports_2009 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Ores and metals imports (% of merchandise imports)" and vp.year = 2009 
order by CountryName

--(SECOND PERIOD)--
create view v_ores_metals_imports_2013 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Ores and metals imports (% of merchandise imports)" and vp.year = 2013
order by CountryName

--SPADEK "Ores and metals imports (% of merchandise imports) --
select
or_met_imp09.CountryName,
or_met_imp09.wskaznik as wskaznik_2009,
or_met_imp13.wskaznik as wskaznik_2013,
case when or_met_imp09.wskaznik < 0 then round(or_met_imp13.wskaznik/or_met_imp09.wskaznik-1,2)*-1
when or_met_imp09.wskaznik > 0 then round(or_met_imp13.wskaznik/or_met_imp09.wskaznik-1,2) 
else round(or_met_imp13.wskaznik/or_met_imp09.wskaznik-1,2) end spadek_wskaznika
from v_ores_metals_imports_2009 or_met_imp09
join v_ores_metals_imports_2013 or_met_imp13
on or_met_imp09.CountryCode = or_met_imp13.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 
Limit 10


--WZROST "Ores and metals imports (% of merchandise imports) --
select
or_met_imp09.CountryName,
or_met_imp09.wskaznik as wskaznik_2009,
or_met_imp13.wskaznik as wskaznik_2013,
case when or_met_imp09.wskaznik < 0 then round(or_met_imp13.wskaznik/or_met_imp09.wskaznik-1,2)*-1
when or_met_imp09.wskaznik > 0 then round(or_met_imp13.wskaznik/or_met_imp09.wskaznik-1,2) 
else round(or_met_imp13.wskaznik/or_met_imp09.wskaznik-1,2) end wzrost_wskaznika
from v_ores_metals_imports_2009 or_met_imp09
join v_ores_metals_imports_2013 or_met_imp13
on or_met_imp09.CountryCode = or_met_imp13.CountryCode
where wzrost_wskaznika is not null
order by wzrost_wskaznika desc
Limit 10

--REGIONY-- "Ores and metals imports (% of merchandise imports)-- 

select
or_met_imp09.region,
round(AVG(or_met_imp09.wskaznik)) as wskaznik_2009,
round(AVG(or_met_imp13.wskaznik)) as wskaznik_2013,
round((AVG(or_met_imp13.wskaznik)) / (AVG(or_met_imp09.wskaznik))-1,2) as spadek_wzrost
from v_ores_metals_imports_2009 or_met_imp09
join v_ores_metals_imports_2013 or_met_imp13
on or_met_imp09.CountryCode = or_met_imp13.CountryCode
group by or_met_imp09.region
order by spadek_wzrost desc


--9. Energy use (kg of oil equivalent per capita) ------------------------------------------------------------

--(FIRST PERIOD)--
create view v_energy_use_2008 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Energy use (kg of oil equivalent per capita)" and vp.year = 2008
order by CountryName

--(SECOND PERIOD)--
create view  v_energy_use_2012 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Energy use (kg of oil equivalent per capita)" and vp.year = 2012
order by CountryName


--SPADEK Energy use (kg of oil equivalent per capita) --
select
energy_use08.CountryName,
energy_use08.wskaznik as wskaznik_2008,
energy_use12.wskaznik as wskaznik_2012,
case when energy_use08.wskaznik < 0 then round(energy_use12.wskaznik/energy_use08.wskaznik-1,2)*-1
when energy_use08.wskaznik > 0 then round(energy_use12.wskaznik/energy_use08.wskaznik-1,2) 
else round(energy_use12.wskaznik/energy_use08.wskaznik-1,2) end spadek_wskaznika
from v_energy_use_2008 energy_use08
join v_energy_use_2012 energy_use12
on energy_use08.CountryCode = energy_use12.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 
Limit 10


--WZROST Energy use (kg of oil equivalent per capita) --

select
energy_use08.CountryName,
energy_use08.wskaznik as wskaznik_2008,
energy_use12.wskaznik as wskaznik_2012,
case when energy_use08.wskaznik < 0 then round(energy_use12.wskaznik/energy_use08.wskaznik-1,2)*-1
when energy_use08.wskaznik > 0 then round(energy_use12.wskaznik/energy_use08.wskaznik-1,2) 
else round(energy_use12.wskaznik/energy_use08.wskaznik-1,2) end wzrost_wskaznika
from v_energy_use_2008 energy_use08
join v_energy_use_2012 energy_use12
on energy_use08.CountryCode = energy_use12.CountryCode
where wzrost_wskaznika is not null
order by wzrost_wskaznika desc 
Limit 10


--REGIONY-- Energy use (kg of oil equivalent per capita) -- 

select
energy_use08.region,
round(AVG(energy_use08.wskaznik)) as wskaznik_2008,
round(AVG(energy_use12.wskaznik)) as wskaznik_2012,
round((AVG(energy_use12.wskaznik)) / (AVG(energy_use08.wskaznik))-1,2) as spadek_wzrost
from v_energy_use_2008 energy_use08
join v_energy_use_2012 energy_use12
on energy_use08.CountryCode = energy_use12.CountryCode
group by energy_use08.region
order by spadek_wzrost desc

--10. Renewable energy consumption (% of total final energy consumption) -----------------------------------------------------------

--(FIRST PERIOD)--
create view v_renewable_energy_cn_2008 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Renewable energy consumption (% of total final energy consumption)" and vp.year = 2008
order by CountryName

--(SECOND PERIOD)--
create view  v_renewable_energy_cn_2012 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Renewable energy consumption (% of total final energy consumption)" and vp.year = 2012
order by CountryName

--SPADEK Renewable energy consumption (% of total final energy consumption)--

select
ren_energy_cn08.CountryName,
ren_energy_cn08.wskaznik as wskaznik_2008,
ren_energy_cn12.wskaznik as wskaznik_2012,
case when ren_energy_cn08.wskaznik < 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn08.wskaznik-1,2)*-1
when ren_energy_cn08.wskaznik > 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn08.wskaznik-1,2) 
else round(ren_energy_cn12.wskaznik/ren_energy_cn08.wskaznik-1,2) end spadek_wskaznika
from v_renewable_energy_cn_2008 ren_energy_cn08
join v_renewable_energy_cn_2012 ren_energy_cn12
on ren_energy_cn08.CountryCode = ren_energy_cn12.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 
Limit 10


--WZROST Renewable energy consumption (% of total final energy consumption)--

select
ren_energy_cn08.CountryName,
ren_energy_cn08.wskaznik as wskaznik_2008,
ren_energy_cn12.wskaznik as wskaznik_2012,
case when ren_energy_cn08.wskaznik < 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn08.wskaznik-1,2)*-1
when ren_energy_cn08.wskaznik > 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn08.wskaznik-1,2) 
else round(ren_energy_cn12.wskaznik/ren_energy_cn08.wskaznik-1,2) end wzrost_wskaznika
from v_renewable_energy_cn_2008 ren_energy_cn08
join v_renewable_energy_cn_2012 ren_energy_cn12
on ren_energy_cn08.CountryCode = ren_energy_cn12.CountryCode
where wzrost_wskaznika is not null
order by wzrost_wskaznika desc
Limit 10


--REGIONY-- Renewable energy consumption (% of total final energy consumption)-- 

select
ren_energy_cn08.region,
round(AVG(ren_energy_cn08.wskaznik)) as wskaznik_2008,
round(AVG(ren_energy_cn12.wskaznik)) as wskaznik_2012,
round((AVG(ren_energy_cn12.wskaznik)) / (AVG(ren_energy_cn08.wskaznik))-1,2) as spadek_wzrost
from v_renewable_energy_cn_2008 ren_energy_cn08
join v_renewable_energy_cn_2012 ren_energy_cn12
on ren_energy_cn08.CountryCode = ren_energy_cn12.CountryCode
group by ren_energy_cn08.region
order by spadek_wzrost desc


with dane as (
				select
				i.CountryName ,
				i."Year" ,
				i.Value,2 ,
				dense_rank() over (partition by i.CountryName order by i."Year") as ranking
				from indicators i
				where i.IndicatorName = 'Unemployment, male (% of male labor force)' and
				i.CountryName in ('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
				Order by i.CountryName
			)
select
CountryName ,
"Year" ,
Value as wartosc_1992,
lead("Year") over (partition by countryName) as rok ,
lead(value) over (partition by countryName) as wartosc_2012 ,
lead(value) over (partition by countryName) - Value as zmiana
from dane
where "Year" = 1992 Or "Year" = 2012


/* 1. Fossil fuel energy consumption (% of total)
 2. Renewable energy consumption (% of total final energy consumption) 
3. Electricity production from natural gas sources (% of total)
4. Electricity production from renewable sources, excluding hydroelectric (% of total) - 
5. CO2 emissions (metric tons per capita)
 */

1992 i 2012 


and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 


--1. Fossil fuel energy consumption (% of total) (FIRST PERIOD)--------------------------------------------------------------------------
create view v_fossil_fuel_consumption_1992 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Fossil fuel energy consumption (% of total)" and vp.year = 1992 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName

--1. Fossil fuel energy consumption (% of total)  (SECOND PERIOD) --
create view v_fossil_fuel_consumption_2012 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year",
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Fossil fuel energy consumption (% of total)" and vp.year = 2012 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')  
order by CountryName


--TOP SPADEK zuzycia paliw kopalnych 
select
ffc92.CountryName,
ffc92.wskaznik as wskaznik_1992,
ffc12.wskaznik as wskaznik_2012,
round(ffc12.wskaznik/ffc92.wskaznik-1,2) as spadek_wskaznika
from v_fossil_fuel_consumption_1992 ffc92
join v_fossil_fuel_consumption_2012 ffc12
on ffc92.CountryCode = ffc12.CountryCode
order by spadek_wskaznika 


--TOP WZROST zuzycia paliw kopalnych 
select
ffc92.CountryName,
ffc92.wskaznik as wskaznik_1992,
ffc12.wskaznik as wskaznik_2012,
round(ffc12.wskaznik/ ffc92.wskaznik-1,2) as wzrost_wskaznika
from v_fossil_fuel_consumption_1992 ffc92
join v_fossil_fuel_consumption_2012 ffc12
on ffc92.CountryCode = ffc12.CountryCode
order by wzrost_wskaznika desc
Limit 10


select 
CountryName,
round(AVG(wskaznik),2) as zuzycie_paliw_kopalnych_1992_2012 
from v_primary_view 
where IndicatorName = "Fossil fuel energy consumption (% of total)" and "Year" between 1992 and 2012 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
GROUP by CountryName 
order by zuzycie_paliw_kopalnych_1992_2012 desc



/*2. Renewable energy consumption (% of total final energy consumption) */ --------------------------------------------------


--(FIRST PERIOD)--
create view v_renewable_energy_cn_1992 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Renewable energy consumption (% of total final energy consumption)" and vp.year = 1992 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName

--(SECOND PERIOD)--
create view  v_renewable_energy_cn_2012 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Renewable energy consumption (% of total final energy consumption)" and vp.year = 2012 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName

--SPADEK Renewable energy consumption (% of total final energy consumption)-- NIGDZIE NIE SPAD£O ZUØYCIE ENERGII ZE èR”DE£ ODNAWIALNYCH wzgledem ca≥oúci zuzycia--- 

select
ren_energy_cn92.CountryName,
ren_energy_cn92.wskaznik as wskaznik_1992,
ren_energy_cn12.wskaznik as wskaznik_2012,
case when ren_energy_cn92.wskaznik < 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn92.wskaznik-1,2)*-1
when ren_energy_cn92.wskaznik > 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn92.wskaznik-1,2) 
else round(ren_energy_cn12.wskaznik/ren_energy_cn92.wskaznik-1,2) end spadek_wskaznika
from v_renewable_energy_cn_1992 ren_energy_cn92
join v_renewable_energy_cn_2012 ren_energy_cn12
on ren_energy_cn92.CountryCode = ren_energy_cn12.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika 


--WZROST Renewable energy consumption (% of total final energy consumption)-- WSZ DZIE WZROS£O 

select
ren_energy_cn92.CountryName,
ren_energy_cn92.wskaznik as wskaznik_1992,
ren_energy_cn12.wskaznik as wskaznik_2012,
case when ren_energy_cn92.wskaznik < 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn92.wskaznik-1,2)*-1
when ren_energy_cn92.wskaznik > 0 then round(ren_energy_cn12.wskaznik/ren_energy_cn92.wskaznik-1,2) 
else round(ren_energy_cn12.wskaznik/ren_energy_cn92.wskaznik-1,2) end spadek_wskaznika
from v_renewable_energy_cn_1992 ren_energy_cn92
join v_renewable_energy_cn_2012 ren_energy_cn12
on ren_energy_cn92.CountryCode = ren_energy_cn12.CountryCode
where spadek_wskaznika is not null
order by spadek_wskaznika desc



select 
CountryName,
round(AVG(wskaznik),2) as zuzycie_energii_ze_zrodel_odnawialnych_1992_2012 
from v_primary_view 
where IndicatorName = "Renewable energy consumption (% of total final energy consumption)" and "Year" between 1992 and 2012 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
GROUP by CountryName 
order by zuzycie_energii_ze_zrodel_odnawialnych_1992_2012  desc



/*Tajikistan is a country rich in hydro resources, 
the mountainous terrain and the presence of rivers allows the construction of high dams and large hydroelectric power plants (HPPs), 
which is done in the country ñ 95% of electricity is generated by 14 large and medium-sized HPPs. */



--3. Electricity production from natural gas sources (% of total) ---------------------------------------------------------------------
 
--(FIRST PERIOD)--
create view v_electricity_prod_from_gas_1992 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Electricity production from natural gas sources (% of total)" and vp.year = 1992 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName

--(SECOND PERIOD)--
create view v_electricity_prod_from_gas_2012 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Electricity production from natural gas sources (% of total)" and vp.year = 2012 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName


--SPADEK Produkcji energii elektrycznej ze ürÛde≥ gazu ziemnego ----- 

select
electricity_from_gas_92.CountryName,
electricity_from_gas_92.wskaznik as wskaznik_1992,
electricity_from_gas_12.wskaznik as wskaznik_2012,
case when electricity_from_gas_92.wskaznik < 0 then round(electricity_from_gas_12.wskaznik/electricity_from_gas_92.wskaznik-1,2)*-1
when electricity_from_gas_92.wskaznik > 0 then round(electricity_from_gas_12.wskaznik/electricity_from_gas_92.wskaznik-1,2) 
else round(electricity_from_gas_12.wskaznik/electricity_from_gas_92.wskaznik-1,2) end spadek_wskaznika
from v_electricity_prod_from_gas_1992 electricity_from_gas_92
join v_electricity_prod_from_gas_2012 electricity_from_gas_12
on electricity_from_gas_92.CountryCode = electricity_from_gas_12.CountryCode
order by spadek_wskaznika 


--WZROST Produkcji energii elektrycznej ze ürÛde≥ gazu ziemnego ----- 

select
electricity_from_gas_92.CountryName,
electricity_from_gas_92.wskaznik as wskaznik_1992,
electricity_from_gas_12.wskaznik as wskaznik_2012,
case when electricity_from_gas_92.wskaznik < 0 then round(electricity_from_gas_12.wskaznik/electricity_from_gas_92.wskaznik-1,2)*-1
when electricity_from_gas_92.wskaznik > 0 then round(electricity_from_gas_12.wskaznik/electricity_from_gas_92.wskaznik-1,2) 
else round(electricity_from_gas_12.wskaznik/electricity_from_gas_92.wskaznik-1,2) end wzrost_wskaznika
from v_electricity_prod_from_gas_1992 electricity_from_gas_92
join v_electricity_prod_from_gas_2012 electricity_from_gas_12
on electricity_from_gas_92.CountryCode = electricity_from_gas_12.CountryCode
order by wzrost_wskaznika desc


select 
CountryName,
round(AVG(wskaznik),2) as srednia_produkcja_energii_elektrycznej_z_gazu_1992_2012 
from v_primary_view 
where IndicatorName = "Electricity production from natural gas sources (% of total)" and "Year" between 1992 and 2012 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
GROUP by CountryName 
order by srednia_produkcja_energii_elektrycznej_z_gazu_1992_2012 desc



--4. Electricity production from renewable sources, excluding hydroelectric (% of total)------------------------------------------- NIE NADAJE SI  SAME 0 

--(FIRST PERIOD)--
create view v_electricity_prod_from_ren_1992 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Electricity production from renewable sources, excluding hydroelectric (% of total)" and vp.year = 1992 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName

--(SECOND PERIOD)--
create view v_electricity_prod_from_ren_2012 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "Electricity production from renewable sources, excluding hydroelectric (% of total)" and vp.year = 2012 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName

select
electricity_from_ren_92.CountryName,
electricity_from_ren_92.wskaznik as wskaznik_1992,
electricity_from_ren_12.wskaznik as wskaznik_2012,
case when electricity_from_ren_92.wskaznik < 0 then round(electricity_from_ren_12.wskaznik/electricity_from_ren_92.wskaznik-1,2)*-1
when electricity_from_ren_92.wskaznik > 0 then round(electricity_from_ren_12.wskaznik/electricity_from_ren_92.wskaznik-1,2) 
else round(electricity_from_ren_12.wskaznik/electricity_from_ren_92.wskaznik-1,2) end spadek_wskaznika
from v_electricity_prod_from_ren_1992 electricity_from_ren_92
join v_electricity_prod_from_ren_2012 electricity_from_ren_12
on electricity_from_ren_92.CountryCode = electricity_from_ren_12.CountryCode
order by spadek_wskaznika 

/*5. CO2 emissions (metric tons per capita) */ 


--(FIRST PERIOD)--
create view v_CO2_emissions_1991 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "CO2 emissions (metric tons per capita)" and vp.year = 1992 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName

--(SECOND PERIOD)--
create view v_CO2_emissions_2011 as
select
vp.region ,
vp.CountryName ,
vp.CountryCode ,
vp.IndicatorName ,
vp."Year" ,
round(vp.wskaznik) as wskaznik
from v_primary_view as vp
where vp.IndicatorName = "CO2 emissions (metric tons per capita)" and vp.year = 2011 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan') 
order by CountryName


--SPADEK Emisji CO2 ----- 

select
co2_emissions_91.CountryName,
co2_emissions_91.wskaznik as wskaznik_1992,
co2_emissions_11.wskaznik as wskaznik_2012,
case when co2_emissions_91.wskaznik < 0 then round(co2_emissions_11.wskaznik/co2_emissions_91.wskaznik-1,2)*-1
when co2_emissions_91.wskaznik > 0 then round(co2_emissions_11.wskaznik/co2_emissions_91.wskaznik-1,2) 
else round(co2_emissions_11.wskaznik/co2_emissions_91.wskaznik-1,2) end spadek_wskaznika
from v_CO2_emissions_1991 co2_emissions_91
join v_CO2_emissions_2011 co2_emissions_11
on co2_emissions_91.CountryCode = co2_emissions_11.CountryCode
order by spadek_wskaznika 


--WZROST Emisji CO2 ----- 

select
co2_emissions_91.CountryName,
co2_emissions_91.wskaznik as wskaznik_1992,
co2_emissions_11.wskaznik as wskaznik_2012,
case when co2_emissions_91.wskaznik < 0 then round(co2_emissions_11.wskaznik/co2_emissions_91.wskaznik-1,2)*-1
when co2_emissions_91.wskaznik > 0 then round(co2_emissions_11.wskaznik/co2_emissions_91.wskaznik-1,2) 
else round(co2_emissions_11.wskaznik/co2_emissions_91.wskaznik-1,2) end wzrost_wskaznika
from v_CO2_emissions_1991 co2_emissions_91
join v_CO2_emissions_2011 co2_emissions_11
on co2_emissions_91.CountryCode = co2_emissions_11.CountryCode
order by wzrost_wskaznika desc


select 
CountryName,
round(AVG(wskaznik),2) as srednia_CO2_emisja_1991_2011
from v_primary_view 
where IndicatorName = "CO2 emissions (metric tons per capita)" and "Year" between 1991 and 2011 and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
GROUP by CountryName 
order by srednia_CO2_emisja_1991_2011 desc


