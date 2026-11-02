-- Data Cleaing

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardizing Data
-- 3. Null Values Or Blank Values 
-- 4. Remove Any Additional Columns Or Rows


-- Remove Duplicates

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staing
LIKE layoffs;

SELECT *
FROM layoffs_staing;

INSERT layoffs_staing
SELECT *
FROM layoffs;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) Row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE Row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Yahoo';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `Row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) Row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE Row_num > 1; 

SELECT *
FROM layoffs_staging2
WHERE company = 'Yahoo';

-- Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_staging2 
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2 
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY column `date` date;

-- Null values or blank values 

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Juul';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
INNER JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

UPDATE layoffs_staging2 t1
INNER JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Remove Any Additional Columns Or Rows

ALTER TABLE layoffs_staging2
DROP column Row_num;

-- Exploratory Data Analysis 

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) AS total_laid_offs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) AS total_laid_offs
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Rolling Total (Month)

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS Total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)
GROUP BY `Month`
ORDER BY 1 ASC;

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS Total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, Total_off, SUM(Total_off) OVER(ORDER BY `Month`) AS Rolling_Total
FROM Rolling_Total;

-- Top 5 total laid off each year 

SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY company, `Year`
ORDER BY 3 DESC;

WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging2
GROUP BY company, `Year`
ORDER BY 3 DESC
), Company_Year_Ranking AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY `Year` ORDER BY Total_laid_off DESC) AS `Rank`
FROM Company_Year
WHERE `Year` IS NOT NULL
ORDER BY `Rank` ASC
)
SELECT *
FROM Company_Year_Ranking
WHERE `Rank` <= 5;