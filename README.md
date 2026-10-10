# Credit Risk Analysis

## Opis Projektu
Kompleksowy projekt analityczny, którego celem jest ocena ryzyka kredytowego oraz zbadanie czynników wpływających na niewypłacalność klientów (Default Rate). Projekt symuluje realne zadania w dziale ryzyka bankowego (Risk Department) - od ekstrakcji i analizy danych w relacyjnej bazie, przez czyszczenie w Pythonie, aż po budowę dashboardu menedżerskiego.

Dane pochodzą z serwisu Kaggle (*Credit Risk Dataset*) i zawierają historyczne informacje o klientach, ich dochodach, celach pożyczkowych oraz statusie spłaty.

## Wykorzystane Technologie
* **Baza danych:** PostgreSQL (DBeaver)
* **Języki:** SQL, (Python, Power BI, Excel Power Query) - w planach

## Struktura Repozytorium (Stan Obecny)
```text
credit-risk-analysis/
├── dane/
│   ├── surowe_dane/               
│   │   └── credit_risk_dataset.csv  # Surowe dane pobrane z Kaggle
│   └── przetworzone_dane/            
├── dashboard/
├── notebooks/
├── sql/
│   ├── 01_create_tables.sql         # Skrypt tworzący schemat bazy danych
│   └── 02_analysis_queries.sql      # Zapytania analityczne
├── .env                           
├── .gitignore
├── requirements.txt               
└── README.md
```
## Etap 1: Analiza w języku SQL
W pierwszym etapie utworzono lokalną bazę danych (skrypt `01_create_table.sql`) i przetworzono dane za pomocą zapytań SQL. Skrypt `02_analysis_queries.sql` zawiera odpowiedzi na 11 kluczowych problemów biznesowych:

1. **Jaka jest ogólna kondycja portfela kredytowego i jaki procent pożyczek pozostaje niespłaconych?** Wyliczenie bazowego odsetka niespłaconych pożyczek w całym portfelu.
2. **Czy w bazie znajdują się błędne dane (anomalie) mogące zaburzyć analizę?** Identyfikacja anomalii i błędów w bazie (np. wiek > 90 lat, staż pracy > 50 lat).
3. **Jak forma posiadania mieszkania wpływa na ryzyko niewypłacalności klienta?** Zestawienie statusu mieszkaniowego (własność, wynajem, hipoteka) z rzetelnością w spłatach.
4. **Na jakie cele klienci pożyczają najczęściej i jak cel pożyczki koreluje z ich zarobkami?** Analiza powiązań między przeznaczeniem kredytu a średnimi zarobkami i kwotą zadłużenia.
5. **Czy system ocen ryzyka (Loan Grades) prawidłowo odzwierciedla przypisane oprocentowanie?** Weryfikacja rozkładu oprocentowania w stosunku do nadanej oceny ryzyka bankowego.
6. **Gdzie leży krytyczna granica obciążenia budżetu klienta (Wskaźnik DTI)?** Kategoryzacja klientów według udziału raty w dochodzie i badanie progu wzrostu ryzyka.
7. **Jakie są bezpośrednie straty finansowe banku wynikające z udzielania pożyczek seryjnym dłużnikom?** Obliczenie "utopionego kapitału" wynikającego z udzielania kredytów osobom z historią bankructwa.
8. **W jakim stopniu staż pracy stanowi bufor bezpieczeństwa przy spłacie kredytu?** Ocena wpływu stabilności i długości zatrudnienia na zdolność kredytową.
9. **Jak wygląda profil "Klienta Idealnego"?** Zbudowanie profilu klienta o najwyższych dochodach i zerowym ryzyku niewypłacalności.
10. **W jakich segmentach klientów bank topi najwięcej kapitału? (Dashboard Ryzyka)** Macierz łącząca cel pożyczki, status mieszkaniowy i łączną kwotę strat kapitałowych.
11. **Jakie jest specyficzne ryzyko młodych dorosłych (18-26 lat) biorących kredyty studenckie?** Szczegółowe badanie ryzyka kredytów edukacyjnych dla grupy wiekowej 18-26 lat.

## Wnioski etapu 1: 
* **Próg obciążenia budżetu:** Gdy rata pochłania więcej niż 25% dochodu, ryzyko niewypłacalności drastycznie rośnie z 11,5% do aż **52,9%**. Próg ten powinien być twardym limitem akceptacji wniosków.
* **Mieszkanie jako tarcza ochronna:** Najemcy (`RENT`) nie spłacają **31,5%** pożyczek. Klienci z własnym domem (`OWN`) są 4-krotnie bezpieczniejsi (tylko **7,4%** niespłaconych).
* **Koszt "drugiej szansy":** Udzielanie pożyczek osobom z historycznym wpisem o bankructwie kosztowało bank **23,6 mln USD** utraconego kapitału.
* **Najbardziej toksyczne segmenty:** Największe kwoty utopiono w pożyczkach medycznych i konsolidacyjnych dla najemców (łącznie **22,6 mln USD** straty). Z kolei najwyższy odsetek dłużników to najemcy pożyczający na remont (**43,3%** default rate).
* **Brakujące dane to czerwona flaga:** Wnioski bez podanego stażu pracy (`NULL`) to ogromne ryzyko – aż **31,5%** z nich kończy się windykacją.
* **Kredyty studenckie:** W grupie 18-26 lat pożyczki na edukację są w głównej mierze niespłacane przez osoby wynajmujące (`RENT`), stanowią one blisko **25%** wszystkich niespłaconych kredytów. Pokazuje to trudność finansową z jaką spotykają się młodzi dorośli, którzy studiują.
