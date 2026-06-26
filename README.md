# Shipping & Logistics Management System (ShippingDB)

A relational, multi-schema T-SQL database modeling retail sales operations and end-to-end logistics fulfillment. The system bridges customer orders with warehouse distribution, driver scheduling, and fleet capacity management.

---

## 🏗️ Schema & Architecture Overview

The project utilizes a modular, multi-schema design to separate commercial data from fulfillment operations:

* **`Sales` Schema:** Tracks commercial operations via `Customers`, `Products`, and `Orders`.
* **`Logistics` Schema:** Manages delivery infrastructure via `Warehouses`, `Drivers`, `Vehicles`, and `Shipments`.

### Key Entities:
1. **Sales.Customers & Products:** Stores global client profiles and item attributes (pricing and item weight).
2. **Sales.Orders:** Captures transaction quantities and total transaction values.
3. **Logistics.Warehouses, Drivers & Vehicles:** Tracks storage capacities, personnel availability, and fleet capabilities (`CapacityKG`).
4. **Logistics.Shipments:** Connects tracking numbers, freight costs, and real-time transit milestones.

---

## 🚀 Analytical Features & Reporting

* **Performance Monitoring:** Uses built-in `DATEDIFF` logic to automatically categorize delivery metrics (`On Time`, `Slightly Late`, `Delayed`).
* **Unified Dashboard:** Deploys a comprehensive database view (`Logistics.vw_ShipmentOverview`) to aggregate commercial and operational tracking metrics into a single source of truth.
* **Business Intelligence Pack:** Includes structured reporting queries optimized for revenue analysis, top-performing product categories, fleet tracking, and warehouse freight cost distribution.
