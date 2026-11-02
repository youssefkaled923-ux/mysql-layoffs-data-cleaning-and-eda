# 📊 MySQL Project: Layoffs Data Cleaning & Exploratory Data Analysis (EDA)

## 📌 Project Overview
This project demonstrates a complete data analysis workflow using **MySQL**. It tackles a real-world dataset of global company layoffs, focusing on two main phases:
1. **Data Cleaning:** Transforming raw, messy data into a clean, structured, and standardized dataset.
2. **Exploratory Data Analysis (EDA):** Uncovering key business insights, trends, patterns, and high-impact metrics regarding workforce reductions.

---

## 🛠️ Key Skills & SQL Techniques Demonstrated
* **Advanced Data Cleaning:** `ROW_NUMBER()`, `CTEs`, `TRIM()`, `STR_TO_DATE()`, `ALTER TABLE`, `DROP COLUMN`.
* **Handling Missing Values:** Self-Joins (`INNER JOIN`) to populate missing data, null handling.
* **Complex Aggregations & Analysis:** `GROUP BY`, `ORDER BY`, Subqueries.
* **Advanced Window Functions:** `SUM() OVER(ORDER BY ...)` for Rolling Totals, `DENSE_RANK() OVER(PARTITION BY ...)` for yearly company rankings.

---

## 🧹 Phase 1: Data Cleaning Steps
1. **Remove Duplicates:** Used `ROW_NUMBER()` over partitioned attributes via a CTE to identify and delete duplicate rows safely.
2. **Standardize Data:** Cleaned whitespaces (`TRIM`), normalized industry names (e.g., grouping `Crypto%` variations), and formatted string dates into SQL `DATE` types.
3. **Handle Null & Blank Values:** Implemented Self-Joins to populate missing industry details based on existing company records.
4. **Remove Unnecessary Columns/Rows:** Dropped redundant helper columns and removed entries lacking both total and percentage layoff metrics.

---

## 📈 Phase 2: Exploratory Data Analysis (EDA) Highlights
* **Top Companies & Countries:** Identified organizations and countries with the highest cumulative layoffs.
* **Yearly Trends:** Analyzed total layoffs by year to identify peak impact periods.
* **Monthly Rolling Total:** Calculated the cumulative progression of layoffs over time using window functions.
* **Yearly Ranking (Top 5 per Year):** Applied `DENSE_RANK()` partitioned by year to pinpoint the top 5 companies affected each calendar year.

---

## 📁 Repository Structure
1. layoffs.csv                    # Raw Dataset
2. layoffs_cleaning_and_eda.sql    # Full SQL Script
3. README.md                      # Project Documentation

---

## 💻 How to Run This Project
1. Clone this repository or download the `.sql` and `.csv` files.
2. Import `layoffs.csv` into your MySQL Workbench database environment.
3. Execute `layoffs_cleaning_and_eda.sql` sequentially to replicate the cleaning and analysis process.
