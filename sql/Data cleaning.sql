-- DATA CLEANING

select*
from layoffs;


-- CREATE A FALSE TABLE TO NOT AFFECT THE RAW DATA
CREATE TABLE layoffs_staging
like layoffs;


-- REMOVING DUPLICATES

INSERT into layoffs_staging
select*
from layoffs;



WITH duplicate_cte as
(
select *,
ROW_NUMBER() OVER( 
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions ) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

select*
from layoffs_staging
where company = 'Yahoo';

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging3
select *,
ROW_NUMBER() OVER( 
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions ) as row_num
from layoffs_staging;

select*
from layoffs_staging3
where row_num > 1;

DELETE
from layoffs_staging3
where row_num > 1;

-- STANDARDIZING DATA

select company, trim(company)
from layoffs_staging3;

## updating tables
update layoffs_staging3
set company = trim(company);

select *
from layoffs_staging3
where industry like 'Crypto%';

update layoffs_staging3
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct industry
from layoffs_staging3;


-- Standardizing Location
select distinct country
from layoffs_staging3
order by 1;

select distinct country
from layoffs_staging3
where country like "United States%";

update layoffs_staging3
set country = "United States"
where country like "United States%";


-- Standardizing date
select `date`

from layoffs_staging3;

update layoffs_staging3
set `date` = str_to_date(`date`, '%m/%d/%Y') ;

alter table layoffs_staging3 
modify column `date` DATE;

select*
from layoffs_staging3;


-- TAKING CARE OF NULLS
update layoffs_staging3
set industry = null
where industry = '';

select *
from layoffs_staging3
where industry is null or industry = ''
order by company asc;

select*
from layoffs_staging3
where company = 'Airbnb';

select *
from layoffs_staging3
where industry is null or industry = '';

select *
from layoffs_staging3 t1
join layoffs_staging3 t2
  on t1.company = t2.company
 where (t1.industry is null or t1.industry = '')
 and t2.industry is not null;
 
 select t1.industry, t2.industry
from layoffs_staging3 t1
join layoffs_staging3 t2
  on t1.company = t2.company
 where (t1.industry is null or t1.industry = '')
 and t2.industry is not null;
 
 Update layoffs_staging3 t1
 join layoffs_staging3 t2
  on t1.company = t2.company
set t1.industry = t2.industry
 where t1.industry is null 
 and t2.industry is not null;

select*
from layoffs_staging3
where company like 'Bally%';

select *
from layoffs_staging3
where industry is null or industry = '';


-- DELETING NULL DATA when not necessary
select*
from layoffs_staging3
where total_laid_off is null and percentage_laid_off is null;

DELETE
from layoffs_staging3
where total_laid_off is null and percentage_laid_off is null;

-- DROPPING A COLUMN
alter table layoffs_staging3
drop column row_num;

select*
from layoffs_staging3

-- FINAL CLEAN DATA


