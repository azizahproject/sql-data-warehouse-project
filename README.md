# Data Warehouse & Analytics Project

## 📁 Overview
This project is developed as part of the **Data Warehouse Course by [DataWithBaraa]([https://www.youtube.com/@DataWithBaraa](https://youtu.be/9GVqKuTVANE?si=AuaewLte6OVauUrR))** on YouTube.  
It demonstrates the implementation of a complete **Data Warehouse (DWH)** using the **Bronze–Silver–Gold layered architecture**.  

The project aims to ensure data reliability, traceability, and consistency across all transformation stages — from raw ingestion to analytical consumption.  
It includes real-world practices such as data cleansing, standardization, integration, and quality validation.

---

## 🎯 Project Goals
- Establish a clear **ETL (Extract–Transform–Load)** pipeline across multiple data layers.  
- Ensure **data consistency, accuracy, and integrity** throughout transformations.  
- Implement **data quality checks** to detect duplicates, nulls, or logical inconsistencies.  
- Create a maintainable foundation for **reporting and decision-making analytics**.  

---

## 🧱 Architecture Layers
<img width="1260" height="820" alt="Data Architecture drawio" src="https://github.com/user-attachments/assets/58524e1d-1ad6-4ed7-be4e-0ba82ac4c476" />
   
   1. Bronze Layer:  Raw data ingestion layer | Stores unprocessed, original data from CRM and ERP source systems. |
   
   2. Silver Layer: Cleansed & conformed layer | Standardizes, validates, and integrates data for analytical use. |

   3. Gold Layer: Analytical layer | Contains curated, business-ready datasets for reporting and insights. |

---

## 🚀 Project Requirements
### Building the Data Warehouse (Data Engineering)

**Objective**
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

## 🧩 Key Components
- **SQL-based Data Modeling** — All transformations and validations implemented via T-SQL scripts.  
- **Data Quality Validation** — Ensures each dataset meets defined quality standards before moving to the next layer.  
- **Documentation Consistency** — All scripts follow standardized headers and section comment structures for maintainability.  
- **Learning-Oriented Design** — Built for hands-on practice aligned with real-world data warehousing methods.  

---

## 🙌 Acknowledgment
This project is inspired by the **Data Warehouse series by [DataWithBaraa]([https://www.youtube.com/@DataWithBaraa](https://youtu.be/9GVqKuTVANE?si=AuaewLte6OVauUrR))** —  
a comprehensive learning resource that guides professionals through practical steps in building a modern, layered data warehouse.

---

📅 *Last Updated: November 3, 2025*  
👩‍💻 *Author: Azizah*  
🎥 *Learning Source: DataWithBaraa (YouTube)*  
🧩 *Project Type: Educational / Practice-Based/Portfolio*
