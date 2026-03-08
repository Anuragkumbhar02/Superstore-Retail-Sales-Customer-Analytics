# 📊 Superstore-Retail-Sales-Customer-Analytics

## 📌 Project Overview

This project presents an **interactive sales analytics dashboard** built using the Superstore dataset.
The goal is to analyze **sales performance, profitability, delivery efficiency, and product performance** across different regions and customer segments.

The dashboard enables business stakeholders to quickly identify:

* High-performing product categories
* Profitability trends
* Delivery performance by shipping mode
* Loss-making products that require attention

The project demonstrates an **end-to-end data analytics workflow**, including data preparation, KPI creation using DAX, and interactive dashboard design in Power BI.

---

# 🎯 Business Problem

Retail companies generate large amounts of transactional data but often struggle to extract meaningful insights.

Key challenges include:

* Identifying **which products generate the most profit**
* Understanding **sales trends across years**
* Detecting **loss-making products**
* Evaluating **shipping performance and delivery times**
* Comparing **sales performance across product categories**

Without proper analytics, businesses risk:

* Reduced profit margins
* Poor inventory decisions
* Inefficient logistics
* Missed growth opportunities

This dashboard provides a **centralized analytical solution** for monitoring these critical business metrics.

---

# 📂 Dataset Description

The dataset contains retail sales transactions with the following key attributes:

| Column        | Description                                         |
| ------------- | --------------------------------------------------- |
| Order ID      | Unique order identifier                             |
| Order Date    | Date when order was placed                          |
| Ship Date     | Date when order was shipped                         |
| Ship Mode     | Shipping method used                                |
| Customer Name | Name of the customer                                |
| Segment       | Customer segment (Consumer, Corporate, Home Office) |
| Region        | Sales region                                        |
| Category      | Product category                                    |
| Sub-Category  | Product sub-category                                |
| Sales         | Total revenue from the order                        |
| Quantity      | Number of items sold                                |
| Discount      | Discount applied                                    |
| Profit        | Profit earned                                       |

---

# 🛠 Tools & Technologies

| Tool     | Purpose                                 |
| -------- | --------------------------------------- |
| Excel    | Initial data exploration                |
| MySQL    | Data querying and validation            |
| Power BI | Dashboard development                   |
| DAX      | KPI calculations                        |
| GitHub   | Project documentation & version control |

---

# 📊 Key KPIs

The dashboard tracks the following important metrics:

* **Total Sales:** 7.11M
* **Total Profit:** 853.09K
* **Average Delivery Days:** 3.95
* **Profit Margin:** 11.99%

Example DAX calculations used in the project:

```DAX
Total Sales =
SUM(Superstore[Sales])
```

```DAX
Total Profit =
SUM(Superstore[Profit])
```

```DAX
Avg Delivery Days =
AVERAGE(Superstore[Delivery Days])
```

```DAX
Profit Margin % =
DIVIDE(
    SUM(Superstore[Profit]),
    SUM(Superstore[Sales])
)
```

---

# 📈 Dashboard Features

### 🔹 Sales Trend Analysis

* Line chart showing **Total Sales and Total Profit over years**
* Helps identify **growth patterns and yearly performance**

### 🔹 Profit by Sub-Category

* Highlights the **most profitable product sub-categories**
* Helps businesses focus on high-margin products

### 🔹 Delivery Performance

* Average delivery days analyzed by **Ship Mode**
* Helps evaluate logistics efficiency

### 🔹 Category Sales Analysis

* Comparison of **Technology, Furniture, and Office Supplies**
* Identifies top-performing product categories

### 🔹 Loss-Making Products

* Table showing products generating **negative profit**
* Helps identify areas where pricing or cost strategy needs improvement

### 🔹 Ship Mode Delivery Details

* Order-level analysis of delivery days
* Helps track logistics performance and service quality

---

# 📷 Dashboard Preview

![Superstore Dashboard](images/superstore_dashboard.png)

---

# 📊 Key Insights

Some insights derived from the analysis include:

* **Technology category generates the highest sales revenue**
* Certain products generate **consistent losses**, indicating pricing or cost issues
* **Standard Class shipping** has the highest delivery time compared to other shipping modes
* Profit and sales show **steady growth over the years**
* Some sub-categories contribute significantly more to profit than others

These insights help businesses improve **product strategy, pricing decisions, and logistics planning**.

---

# 📁 Project Structure

```
Superstore-Sales-Dashboard
│
├── data
│   └── superstore_dataset.csv
│
├── dashboard
│   └── superstore_dashboard.pbix
│
├── images
│   └── superstore_dashboard.png
│
└── README.md
```

---

# 🎯 Skills Demonstrated

This project highlights the following data analytics skills:

* Data cleaning and transformation
* Data modeling in Power BI
* Writing DAX measures
* Business KPI development
* Dashboard design and storytelling
* Data-driven decision support

---

# 👨‍💻 Author

Anurag Kumbhar
Aspiring Data Analyst with skills in:

* SQL
* Power BI
* Excel
* Data Visualization

---

⭐ If you found this project helpful, consider **starring the repository**.
