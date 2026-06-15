-- Exploratory Data Analysis

select*
from layoffs_staging3;

-- MAX Total laid off, and max percentage laid off
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging3;

-- Companies who went order and how much funding they received
select company, funds_raised_millions
from layoffs_staging3
where percentage_laid_off = 1
order by funds_raised_millions desc;


-- Companies with the highest total number of employees laid off
select company, sum(total_laid_off)
from layoffs_staging3
group by company
order by 2 desc;

-- Starting layoff date to ending layoff date
select min(`date`), max(`date`)
from layoffs_staging3;

-- Industries who had the highest laid off
select industry, sum(total_laid_off)
from layoffs_staging3
group by industry
order by 2 desc;

-- Countries who had the highest laid off
select country, sum(total_laid_off)
from layoffs_staging3
group by country
order by 2 desc;

-- YEARS AND THEIR LAYOFFS
select YEAR(`date`) , sum(total_laid_off)
from layoffs_staging3
group by YEAR(`date`)
order by 1 desc;

-- WHAT STAGES COMPANY WHERE AND THEIR LAYOFFS
select stage, sum(total_laid_off)
from layoffs_staging3
group by stage
order by 2 desc;

-- EACH MONTH IN A YEAR and their  TOTAL LAID OFF
select substring(`date`, 1, 7) as `MONTH`, sum(total_laid_off)
from layoffs_staging3
where substring(`date`, 1, 7) is not null
group by `MONTH`
order by 1 asc;


-- USING A CTE TO SEE HOW THE TOTAL LAID OFF WERE DISTRIBUTED AND ADDED MONTH BY MONTH
WITH Rolling_Total as
(
select substring(`date`, 1, 7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging3
where substring(`date`, 1, 7) is not null
group by `MONTH`
order by 1 asc
)
SELECT `Month`, total_off,
sum(total_off) over(order by `Month`) as rolling_toal
from rolling_total;


-- USING CTE 
-- RANKING THE TOP 5 COMPANIES WITH THE MOST NUMBER OF LAID OFFS PER YEAR

WITh Company_Year (company,years, total_laid_off) as
(
select company, YEAR(`date`), sum(total_laid_off)
from layoffs_staging3
group by company, year(`date`)
order by company asc
), Company_year_rank as
(select *, 
DENSE_RANK() OVER (PARTITION BY years order by total_laid_off desc) as Ranking
from company_year
WHERE years is not null
)
Select*
from company_year_Rank
where ranking <= 5;
