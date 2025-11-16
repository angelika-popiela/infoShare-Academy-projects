/*
"Analiza ekonomiczno-spo³ecznych przemian w krajach powsta³ych po rozpadzie ZSRR w okresie 1992-2012 na podstawie bazy danych World Development Indicators" 

Energy world indicators:

1. Fossil fuel energy consumption (% of total) - CHOSEN
2. Renewable energy consumption (% of total final energy consumption) - CHOSEN
3. CO2 emissions (metric tons per capita) - CHOSEN
4. Electricity production from natural gas sources (% of total) - REJECTED
5. Electricity production from renewable sources, excluding hydroelectric (% of total) - REJECTED 
 */


--1. Fossil fuel energy consumption (% of total) (FIRST PERIOD) -------------------------------------------------
create view v_fossil_fuel_consumption_1992 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Fossil fuel energy consumption (% of total)"
	and i.year = 1992
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--1. Fossil fuel energy consumption (% of total)  (SECOND PERIOD) --
create view v_fossil_fuel_consumption_2012 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Fossil fuel energy consumption (% of total)"
	and i.year = 2012
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--Country ranking --

select
	ffc92.CountryName,
	ffc92.wskaznik as wskaznik_1992,
	ffc12.wskaznik as wskaznik_2012,
	round(ffc12.wskaznik / ffc92.wskaznik-1,
	2) as spadek_wskaznika
from
	v_fossil_fuel_consumption_1992 ffc92
join v_fossil_fuel_consumption_2012 ffc12
on
	ffc92.CountryCode = ffc12.CountryCode
order by
	spadek_wskaznika

	-- Average of fossil fuel energy consumption in time --

select
	CountryName,
	round(AVG(i.Value),
	2) as average_1992_2012
from
	Indicators i
where
	IndicatorName = "Fossil fuel energy consumption (% of total)"
	and "Year" between 1992 and 2012
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
group by
	CountryName
order by
	average_1992_2012 desc


	
	--2. Renewable energy consumption (% of total final energy consumption) (FIRST PERIOD) -------------------------------------------------
create view v_renewable_energy_cn_1992 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Renewable energy consumption (% of total final energy consumption)"
	and i.year = 1992
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--2. Renewable energy consumption (% of total final energy consumption) (SECOND PERIOD)--
create view v_renewable_energy_cn_2012 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Renewable energy consumption (% of total final energy consumption)"
	and i.year = 2012
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--Country ranking --

select
	ren_energy_cn92.CountryName,
	ren_energy_cn92.wskaznik as wskaznik_1992,
	ren_energy_cn12.wskaznik as wskaznik_2012,
	case
		when ren_energy_cn92.wskaznik < 0 then round(ren_energy_cn12.wskaznik / ren_energy_cn92.wskaznik-1,
		2)*-1
		when ren_energy_cn92.wskaznik > 0 then round(ren_energy_cn12.wskaznik / ren_energy_cn92.wskaznik-1,
		2)
		else round(ren_energy_cn12.wskaznik / ren_energy_cn92.wskaznik-1,
		2)
	end wzrost_wskaznika
from
	v_renewable_energy_cn_1992 ren_energy_cn92
join v_renewable_energy_cn_2012 ren_energy_cn12
on
	ren_energy_cn92.CountryCode = ren_energy_cn12.CountryCode
where
	wzrost_wskaznika is not null
order by
	wzrost_wskaznika desc

	-- Average of renewable energy consumption in time --

select
	CountryName,
	round(AVG(i.Value),
	2) as average_1992_2012
from
	Indicators i
where
	IndicatorName = "Renewable energy consumption (% of total final energy consumption)"
	and "Year" between 1992 and 2012
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
group by
	CountryName
order by
	average_1992_2012 desc

	
	
	--3. CO2 emissions (metric tons per capita) (FIRST PERIOD) -------------------------------------------------
create view v_CO2_emissions_1991 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "CO2 emissions (metric tons per capita)"
	and i.year = 1992
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--3. CO2 emissions (metric tons per capita) (SECOND PERIOD)--
create view v_CO2_emissions_2011 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "CO2 emissions (metric tons per capita)"
	and i.year = 2011
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--Country ranking --

select
	co2_emissions_91.CountryName,
	co2_emissions_91.wskaznik as wskaznik_1992,
	co2_emissions_11.wskaznik as wskaznik_2012,
	case
		when co2_emissions_91.wskaznik < 0 then round(co2_emissions_11.wskaznik / co2_emissions_91.wskaznik-1,
		2)*-1
		when co2_emissions_91.wskaznik > 0 then round(co2_emissions_11.wskaznik / co2_emissions_91.wskaznik-1,
		2)
		else round(co2_emissions_11.wskaznik / co2_emissions_91.wskaznik-1,
		2)
	end spadek_wskaznika
from
	v_CO2_emissions_1991 co2_emissions_91
join v_CO2_emissions_2011 co2_emissions_11
on
	co2_emissions_91.CountryCode = co2_emissions_11.CountryCode
order by
	spadek_wskaznika

	-- Average of CO2 emissions in time --

select
	CountryName,
	round(AVG(i.Value),
	2) as average_1991_2011
from
	Indicators i
where
	IndicatorName = "CO2 emissions (metric tons per capita)"
	and "Year" between 1991 and 2011
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
group by
	CountryName
order by
	average_1991_2011 desc

	
	
	--REJECTED INDICATORS --
	--4. Electricity production from natural gas sources (% of total) (FIRST PERIOD) -------------------------------------------------
create view v_electricity_prod_from_gas_1992 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Electricity production from natural gas sources (% of total)"
	and i.year = 1992
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--4. Electricity production from natural gas sources (% of total) (SECOND PERIOD)--
create view v_electricity_prod_from_gas_2012 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Electricity production from natural gas sources (% of total)"
	and i.year = 2012
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--Country ranking --

select
	electricity_from_gas_92.CountryName,
	electricity_from_gas_92.wskaznik as wskaznik_1992,
	electricity_from_gas_12.wskaznik as wskaznik_2012,
	case
		when electricity_from_gas_92.wskaznik < 0 then round(electricity_from_gas_12.wskaznik / electricity_from_gas_92.wskaznik-1,
		2)*-1
		when electricity_from_gas_92.wskaznik > 0 then round(electricity_from_gas_12.wskaznik / electricity_from_gas_92.wskaznik-1,
		2)
		else round(electricity_from_gas_12.wskaznik / electricity_from_gas_92.wskaznik-1,
		2)
	end wzrost_wskaznika
from
	v_electricity_prod_from_gas_1992 electricity_from_gas_92
join v_electricity_prod_from_gas_2012 electricity_from_gas_12
on
	electricity_from_gas_92.CountryCode = electricity_from_gas_12.CountryCode
order by
	wzrost_wskaznika desc

	-- Average of electricity production from natural gas sources (% of total) in time --

select
	CountryName,
	round(AVG(i.Value),
	2) as srednia_produkcja_energii_elektrycznej_z_gazu_1992_2012
from
	Indicators i
where
	IndicatorName = "Electricity production from natural gas sources (% of total)"
	and "Year" between 1992 and 2012
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
group by
	CountryName
order by
	srednia_produkcja_energii_elektrycznej_z_gazu_1992_2012 desc

	
	
	--5. Electricity production from renewable sources, excluding hydroelectric (% of total) (FIRST PERIOD) ------------------------------------------------- 
create view v_electricity_prod_from_ren_1992 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year",
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Electricity production from renewable sources, excluding hydroelectric (% of total)"
	and i.year = 1992
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--5. Electricity production from renewable sources, excluding hydroelectric (% of total) (SECOND PERIOD)--
create view v_electricity_prod_from_ren_2012 as
select
	i.CountryName,
	i.CountryCode,
	i.IndicatorName,
	i."Year" ,
	round(i.Value) as wskaznik
from
	Indicators i
where
	i.IndicatorName = "Electricity production from renewable sources, excluding hydroelectric (% of total)"
	and i.year = 2012
	and CountryName in('Armenia', 'Azerbaijan', 'Belarus', 'Estonia', 'Georgia', 'Kazakhstan', 
'Kyrgyz Republic', 'Latvia', 'Lithuania', 'Moldova', 'Poland', 'Tajikistan', 'Turkmenistan', 'Ukraine', 'Uzbekistan')
order by
	CountryName

	--Country ranking --

select
	electricity_from_ren_92.CountryName,
	electricity_from_ren_92.wskaznik as wskaznik_1992,
	electricity_from_ren_12.wskaznik as wskaznik_2012,
	case
		when electricity_from_ren_92.wskaznik < 0 then round(electricity_from_ren_12.wskaznik / electricity_from_ren_92.wskaznik-1,
		2)*-1
		when electricity_from_ren_92.wskaznik > 0 then round(electricity_from_ren_12.wskaznik / electricity_from_ren_92.wskaznik-1,
		2)
		else round(electricity_from_ren_12.wskaznik / electricity_from_ren_92.wskaznik-1,
		2)
	end spadek_wskaznika
from
	v_electricity_prod_from_ren_1992 electricity_from_ren_92
join v_electricity_prod_from_ren_2012 electricity_from_ren_12
on
	electricity_from_ren_92.CountryCode = electricity_from_ren_12.CountryCode
order by
	spadek_wskaznika
