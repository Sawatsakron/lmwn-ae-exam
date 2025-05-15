# LMWN Analytics Engineering Exam Project

This repository contains a data modeling solution for a food delivery platform built with dbt (data build tool), created as part of the Lineman Wongnai Analytics Engineering position examination.

## Project Overview

This project demonstrates how to transform raw data from a food delivery platform into a structured data model that supports various business reporting needs. The solution provides analytical reports for:

- **Performance Marketing Team**: Campaign effectiveness, customer acquisition, and retargeting performance
- **Fleet Management Team**: Driver performance, delivery zone analysis, and incentive impact
- **Customer Service Team**: Complaint summaries, driver-related complaints, and restaurant quality issues

## Prerequisites

Before getting started, make sure you have the following installed:

- [Python](https://www.python.org/downloads/) (3.8 or higher)
- [dbt](https://docs.getdbt.com/docs/installation)
- [DuckDB](https://duckdb.org/docs/installation/) (Optional: for local database operations)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Sawatsakron/lmwn-ae-exam
cd lmwn_ae_exam
```

### 2. Set Up Your Environment
Create and activate a virtual environment:

```bash
python -m venv <your-venv-name>
# On Windows
dbt-env\Scripts\activate
# On macOS/Linux
source dbt-env/bin/activate
```
Install the required dependencies:

```bash
pip install -r requirements.txt
```

### 3. Configure dbt Profile
Make sure your dbt profile (~/lmwn_ae_exam/profiles.yml) includes the following configuration:

```bash
lmwn_ae_exam:
  target: local
  outputs:
    local:
      type: duckdb
      path: 'ae_exam_db.duckdb' # Or your own ae_exam_db.duckdb
```

### 4. Run the Project
Navigate to the project directory and run:

```bash
cd lmwn_ae_exam
dbt run   # Build all models
dbt test  # Run tests
```
### Tips 
To view an indivitual model use:

```bash
dbt show --select <model_name>
```

## Documentation
For more detailed documentation on the data models and relationships, run:

```bash
dbt docs generate
dbt docs serve
```
This will start a local server with interactive documentation for the project.

### ERD and Data Blueprint

- [Data BluePrint (Google Sheet Link)](https://docs.google.com/spreadsheets/d/1t9mdWPSbq29gVbXXHmJ_IyeCGajlUzm99QUgXFEDN_w/edit?usp=sharing)

- ERD
  - [Performance Marketing Team](https://dbdiagram.io/d/Performance-Marketing-Team-682271d85b2fc4582f492240)

  - [Fleet Management Team](https://dbdiagram.io/d/Fleet-Management-Team-6825a39e5b2fc4582fb800a7)

  - [Customer Service Team](https://dbdiagram.io/d/Customer-Service-Team-6825a57e5b2fc4582fb85479)






### Auther: Sawatsakron Maharuankwan