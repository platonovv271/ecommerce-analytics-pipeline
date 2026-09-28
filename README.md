# E-Commerce Data Analytics & ETL Pipeline

## Overview
An end-to-end data engineering and analytics project built on real-world Brazilian E-Commerce data (Olist, 100k+ orders). 
The goal of this project is to process raw relational data, perform deep analytics using window functions and columnar stores, and build a clean analytical data mart.

## Tech Stack
* **Query Engine & Storage:** DuckDB, Parquet (Columnar Storage)
* **Data Processing & ETL:** Python, Polars
* **Database Management:** DBeaver
* **Data Source:** Olist E-Commerce Dataset (Kaggle)

## Project Structure
* `sql/` — Analytical SQL queries (aggregations, JOINs, CTEs, window functions).
* `scripts/` — Polars ETL scripts for data cleaning and Parquet conversion.
* `notebooks/` — Exploratory data analysis (EDA).

## How to Run
1. Clone the repository: `git clone https://github.com/platonovv271/ecommerce-analytics-pipeline.git`
2. Install dependencies: `pip install duckdb polars pyarrow`
3. Place Olist `.csv` files into the `data/` folder.