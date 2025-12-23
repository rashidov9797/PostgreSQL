# PostgreSQL Maintenance Tool

Interactive **Bash** tool for PostgreSQL DBAs to quickly monitor, troubleshoot, and export reports from PostgreSQL databases.

✅ 18 functions (monitoring + maintenance)  
✅ Log **ERROR/FATAL/PANIC** counter (with extracted lines saved to file)  
✅ Export reports to **CSV (Excel)** or **single HTML file**

---

## What's New (v3)

Compared to the previous version (v2), this release adds:

- **17. Log Error/Fatal/Panic Count**
  - Automatically detects PostgreSQL log settings (`logging_collector`, `log_directory`, `data_directory`)
  - Picks latest log file and counts **ERROR/FATAL/PANIC**
  - Saves extracted lines to: `/home/postgres/pg_errors_YYYYMMDD.log`

- **18. Export Reports (CSV/HTML)**
  - Export all reports at once
  - **CSV**: multiple `.csv` files (Excel-friendly)
  - **HTML**: one consolidated report file:
    `/home/postgres/pg_reports_YYYYMMDD_HHMMSS/ALL_REPORT_YYYYMMDD_HHMMSS.html`

- Vacuum report split into:
  - **8. Vacuum Info (Basic)**
  - **15. Vacuum Info (Detailed)**

<img width="793" height="811" alt="image" src="https://github.com/user-attachments/assets/37d520a0-0614-4502-90ab-f3105497da13" />


---

## Important: Configure `.pgpass` (recommended)

To avoid password prompts and make the tool run smoothly, configure PostgreSQL password file **.pgpass** for the OS user that runs the script.


---

## Quick Start

```bash
chmod +x maintenance.sh
./maintenance.sh
