create table credit_risk (
	id serial primary key,					-- unikalny identyfikator
	person_age int,							-- wiek klienta
	person_income numeric,					-- roczny dochód
	person_home_ownership varchar(50),		-- status mieszkaniowy
	person_emp_length numeric,				-- staż pracy
	loan_intent varchar(50),				-- cel kredytu
	loan_grade varchar(10),					-- klasa kredytowa
	loan_amnt numeric,						-- kwota wnioskowanego kredytu
	loan_int_rate numeric,					-- oprocentowanie kredytu
	loan_status int,						-- status kredytu, 0 - spłacony, 1 - niespłacony
	loan_percent_income numeric,			-- stosunek kwoty kredytu do dochodu
	cb_person_default_on_file varchar(10),	-- opóźnienia/bankructwo
	cb_person_cred_hist_length int			-- długość historii kredytowej w latach
)