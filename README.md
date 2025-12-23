# 🐘 PostgreSQL Maintenance Tool

A powerful shell script designed to manage and monitor PostgreSQL databases.  
Includes **18 useful functions** for database administration, monitoring, and optimization.

---

## 📥 Installation

1. **Download the file:**
```bash
   wget https://github.com/rashidov9797/PostgreSQL/archive/refs/tags/v3.tar.gz
   tar -xzf v3.0.0.tar.gz
   cd PostgreSQL-3.0.0
```

2. **Make it executable:**
```bash
   chmod +x maintenance.sh
```

3. **Run the script:**
```bash
   ./maintenance.sh
```

---

## ✨ Features

| # | Feature | Description |
|---|---------|-------------|
| 1 | 🔢 Version Info | Display PostgreSQL version |
| 2 | 📊 Schema List | List all database schemas |
| 3 | 🔴 Active Sessions | Show active database sessions |
| 4 | 🔒 Lock List | Display locked resources |
| 5 | 💀 Dead Tuple List | Show dead tuples awaiting cleanup |
| 6 | 💾 Tablespace Info | Tablespace information and usage |
| 7 | 🔝 Top 15 Queries | Most executed queries (requires pg_stat_statements) |
| 8 | 🧹 Vacuum Info (Basic) | Basic vacuum process information |
| 9 | 📈 Commit & Hit Ratio | Database commit and cache hit ratios |
| 10 | 🔄 Replication Delay | Replication lag information |
| 11 | 📋 Object Count by Schema | Count of objects per schema |
| 12 | 📊 Index Usage Statistics | Index usage and performance stats |
| 13 | ⚠️ Unused Indexes | Identify unused indexes |
| 14 | ⏱️ Long Running Queries | Detect long-running queries |
| 15 | 🧹 Vacuum Info (Detailed) | Detailed vacuum information |
| 16 | 🔄 Switch Database/User | Change database or user connection |
| 17 | 🚨 Log Error/Fatal/Panic Count | Count errors in PostgreSQL logs |
| 18 | 📤 Export Reports (CSV/HTML) | Export reports in CSV or HTML format |
| 99 | 🚪 Exit | Exit the script |

---

<img width="793" height="811" alt="image" src="https://github.com/user-attachments/assets/972f5723-b971-4f91-b060-e5945f6f65c2" />


---

## 🚀 Usage

1. **At startup**, enter your PostgreSQL username and database name
2. **Select an option** by entering a number between 1 and 18
3. Use **99** to exit the script
4. **Option 16** allows you to switch between databases and users without restarting

---

## 🆕 What's New in v3.0

- ✅ **Option 17**: Log Error/Fatal/Panic Count  
  Saves to `/home/postgres/pg_errors_YYYYMMDD.log`

- ✅ **Option 18**: Export Reports (CSV/HTML)  
  Saves reports under `/home/postgres/`
  - **CSV**: Multiple separate files
  - **HTML**: Single combined file `ALL_REPORT_YYYYMMDD_HHMMSS.html`

---

## 🔐 Recommended: Configure `.pgpass`

To avoid password prompts, configure `.pgpass` for the OS user running the script (e.g., `postgres`).
```bash
# Create .pgpass file
touch /home/postgres/.pgpass

# Add your credentials (format: hostname:port:database:username:password)
echo "localhost:5432:*:postgres:your_password" >> /home/postgres/.pgpass

# Set correct permissions
chmod 600 /home/postgres/.pgpass
```

**Format:**
```
hostname:port:database:username:password
```

**Example:**
```
localhost:5432:*:postgres:mypassword
```



## 👤 Author

**Azamat**  
GitHub: [@rashidov9797](https://github.com/rashidov9797)

---

## ⭐ Support

If you find this tool helpful, please give it a star on GitHub!
