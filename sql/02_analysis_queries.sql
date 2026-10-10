-- 1.

select 
    count(*) as wszystkie_pozyczki,
    count(*) - sum(loan_status) as splacone_pozyczki,
    sum(loan_status) as niesplacone_pozyczki,
    round((sum(loan_status) * 100) / count(*), 2) as procent_niesplaconych
from credit_risk

-- 2.

select 
    person_age as wiek_czlowieka,
    person_emp_length as staz_pracy,
    person_income AS dochod,
    loan_amnt AS kwota_pozyczki,
    loan_status AS status_pozyczki
from credit_risk
where 
    person_age > 90 or person_emp_length > 50

-- 3.

select 
    person_home_ownership as forma_zamieszkania,
    count(*) as liczba_ludzi,
    sum(loan_status) as pozyczki_niesplacone,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS procent_niesplaconych
from credit_risk
group by forma_zamieszkania
order by procent_niesplaconych desc

-- 4.

select 
    loan_intent as cel_pozyczki,
    round(avg(person_income), 2) as srednie_zarobki,
    round(avg(loan_amnt), 2) as srednia_kredytu,
    count(*) as liczba_pozyczek
from credit_risk
group by loan_intent 
order by srednie_zarobki desc

-- 5.

select 
    loan_grade as klasa_kredytowa,
    round(min(loan_int_rate), 2) as minimalne_oprocentowanie,
    round(max(loan_int_rate), 2) as maksymalne_oprocentowanie,
    round(avg(loan_int_rate), 2) as srednie_oprocentowanie,
    count(*) as liczba_ludzi_w_klasie
from credit_risk
group by klasa_kredytowa 
order by klasa_kredytowa

-- 6.

select 
    case 
        when loan_percent_income < 0.10 then '1. obciazenie male (<10%)'
        when loan_percent_income between 0.10 and 0.25 then '2. obciazenie srednie (10-25%)'
        when loan_percent_income > 0.25 then '3. obciazenie duze (>25%'
    end as obciazenie_klienta,
    count(*) as liczba_klientow,
    sum(loan_status) as pozyczki_niesplacone,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS procent_niesplaconych
from credit_risk
group by obciazenie_klienta
order by obciazenie_klienta

-- 7.

select 
    count(*) as liczba_straconych_pozyczek, 
    sum(loan_amnt) as laczna_kwota_strat,
    round(avg(loan_amnt), 2) as srednia_kwota,
    max(loan_amnt) as najwiekszy_dluznik
from credit_risk
where 
    cb_person_default_on_file = 'Y' and loan_status = 1

-- 8.

select 
    case
        when person_emp_length <= 2 then '1. krotki staz (0-2 lata)'
        when person_emp_length between 3 and 5 then '2. sredni staz (3-9 lat)'
        when person_emp_length > 5 then '3. dlugi staz (+10 lat)'
        when person_emp_length is null then '4. brak danych'
    end as staz_pracy_klienta,
    count(*) as liczba_klientow,
    sum(loan_status ) as niesplacone_kredyty,
    ROUND((SUM(loan_status) * 100.0) / COUNT(*), 2) AS procent_niesplaconych
from credit_risk
group by staz_pracy_klienta 
order by staz_pracy_klienta 

-- 9.

select 
    person_age as wiek,
    person_income as dochod,
    person_home_ownership as mieszkanie,
    loan_intent as cel_pozyczki,
    loan_amnt as kwota_pozyczki,
    loan_percent_income as udzial_raty_w_dochodzie
from credit_risk
where 
    person_income > (select avg(person_income) from credit_risk) 
    and cb_person_default_on_file = 'N' 
    and loan_status = 0 
    and person_age < 90 
    and person_emp_length < 50
order by dochod desc, udzial_raty_w_dochodzie desc
limit 10

-- 10.

select 
    person_home_ownership as forma_mieszkania,
    loan_intent as cel_pozyczki,
    count(*) as liczba_pozyczek,
    sum(loan_status) as niesplacone_pozyczki,
    round((sum(loan_status) * 100.0) / count(*), 2) as procent_niesplaconych,
    sum(case when loan_status = 1 then loan_amnt else 0 end) as utopiony_kapital,
    round(avg(person_emp_length), 0) as sredni_staz_pracy,
    sum(loan_amnt) as laczna_kwota_pozyczek
from credit_risk
where 
    person_emp_length < 50 or person_emp_length is null
group by forma_mieszkania, cel_pozyczki
order by utopiony_kapital desc

-- 11.

select 
    person_home_ownership as forma_mieszkania,
    count(*) as liczba_studentow,
    sum(loan_status) as niesplacone_kredyty,
    round((sum(loan_status) * 100.0) / count(*), 2) as procent_niesplaconych,
    round(avg(loan_amnt), 2) as srednia_kwota_pozyczki,
    round(avg(person_income), 2) as sredni_dochod
from credit_risk
where 
    person_age between 18 and 26 and loan_intent = 'EDUCATION'
group by forma_mieszkania
order by procent_niesplaconych desc
