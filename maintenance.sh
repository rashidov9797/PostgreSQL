
#!/bin/bash

# Define colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
BOLD='\e[1m'
RESET='\e[0m'

# Default psql options (force password prompt)

PSQL_OPTS=(-P pager=off -h localhost -p 5432)


# Function to display the initial header
Display_Header() {
    echo -e "${BLUE}========================================${RESET}"
    echo -e "${BLUE} PostgreSQL Maintenance Tool${RESET}"
    echo -e "${BLUE} Create Date: 2025-04-01${RESET}"
    echo -e "${BLUE} Owner: Azamat${RESET}"
    echo -e "${BLUE} My email: azikrashidov1103@gmail.com${RESET}"
    echo -e "${BLUE}========================================${RESET}"
}

# Function to display the initial info (only at startup)
Display_Initial_Info() {
    echo -e "${BLUE}========================================${RESET}"
    echo -e "${BLUE} PostgreSQL Maintenance Tool${RESET}"
    echo -e "${BLUE} Date: $(date +%Y-%m-%d\ %H:%M:%S)${RESET}"
    echo -e "${BLUE}========================================${RESET}"
}

# Function to display the menu (only shown initially)
Display_Menu() {
    echo -e "${BLUE}========================================${RESET}"
    echo -e "${BLUE} PostgreSQL Maintenance Tool${RESET}"
    echo -e "${BLUE} Date: $(date +%Y-%m-%d\ %H:%M:%S)${RESET}"
    echo -e "${BLUE}========================================${RESET}"
    echo -e "${YELLOW} 1. Version Info${RESET}"
    echo -e "${YELLOW} 2. Schema List${RESET}"
    echo -e "${YELLOW} 3. Active Sessions${RESET}"
    echo -e "${YELLOW} 4. Lock List${RESET}"
    echo -e "${YELLOW} 5. Dead Tuple List${RESET}"
    echo -e "${YELLOW} 6. Tablespace Info${RESET}"
    echo -e "${YELLOW} 7. Top 15 Queries${RESET}"
    echo -e "${YELLOW} 8. Vacuum Info (Basic)${RESET}"
    echo -e "${YELLOW} 9. Commit & Hit Ratio${RESET}"
    echo -e "${YELLOW} 10. Replication Delay${RESET}"
    echo -e "${YELLOW} 11. Object Count by Schema${RESET}"
    echo -e "${YELLOW} 12. Index Usage Statistics${RESET}"
    echo -e "${YELLOW} 13. Unused Indexes${RESET}"
    echo -e "${YELLOW} 14. Long Running Queries${RESET}"
    echo -e "${YELLOW} 15. Vacuum Info (Detailed)${RESET}"
    echo -e "${YELLOW} 16. Switch Database/User${RESET}"
    echo -e "${YELLOW} 17. Log Error/Fatal/Panic Count${RESET}"
    echo -e "${YELLOW} 18. Export Reports (CSV/HTML)${RESET}"
    echo -e "${YELLOW} 99. Exit${RESET}"
    echo -e "${BLUE}========================================${RESET}"
}

# Function to show database, user, and schema info after selection
Show_Context() {
    local schemas=$(psql $PSQL_OPTS pager=off -d "$D" -U "$U" -t -c "SHOW search_path;" | tr -d ' ')
    echo -e "${YELLOW}Database: $D | User: $U | Schema: $schemas${RESET}"
    echo -e "${BLUE}-------------------------------------${RESET}"
}

# Function to display function name with stars
Show_Function_Name() {
    local func_name="$1"
    echo -e "${GREEN}=====================${RESET}"
    echo -e "${GREEN}${BOLD}$func_name${RESET}"
    echo -e "${GREEN}=====================${RESET}"
}

# Function to switch database and user
Switch_Database_User() {
    echo -e "${YELLOW}Current Database: $D | Current User: $U${RESET}"
    echo -e "${BLUE}Available databases:${RESET}"
    psql $PSQL_OPTS pager=off -d "$INITIAL_DB" -U "$U" -c "SELECT datname AS database, pg_catalog.pg_get_userbyid(datdba) AS owner FROM pg_catalog.pg_database WHERE datname NOT IN ('template0', 'template1') ORDER BY 1;"
    echo -n -e "${BLUE}Enter new database name (or press Enter to keep '$D'): ${RESET}"
    read new_D
    echo -n -e "${BLUE}Enter new user name (or press Enter to keep '$U'): ${RESET}"
    read new_U
    
    D=${new_D:-$D}
    U=${new_U:-$U}
    echo -e "${GREEN}Switched to - Database: $D | User: $U${RESET}"
}

# Main function to handle user input and menu navigation
main() {
    Display_Header
    echo " "
    Display_Initial_Info
    echo " "

    # Ask for initial username first
    echo -n -e "${BLUE}Enter username: ${RESET}"
    read U
    if [ -z "$U" ]; then
        echo -e "${RED}Error: Username cannot be empty. Exiting.${RESET}"
        exit 1
    fi

    # Set a default initial database for listing databases
    INITIAL_DB="postgres"

    # Check if the user exists and list databases
    psql $PSQL_OPTS pager=off -d "$INITIAL_DB" -U "$U" -c "SELECT datname AS database, pg_catalog.pg_get_userbyid(datdba) AS owner FROM pg_catalog.pg_database WHERE datname NOT IN ('template0', 'template1') ORDER BY 1;" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Could not connect with user '$U'. Please check the username and try again.${RESET}"
        exit 1
    fi

    echo -n -e "${BLUE}Enter database name: ${RESET}"
    read D
    
    D=${D:-$INITIAL_DB}  # Default to 'postgres' if no input

    Display_Menu

    while true; do
        echo -n -e "${BLUE}Select an option: ${RESET}"
        read MENU
        case $MENU in
            1) Show_Function_Name "Version_Info"; Show_Context; Version_Info ;;
            2) Show_Function_Name "Schema_List"; Show_Context; Schema_List ;;
            3) Show_Function_Name "Active_Sessions"; Show_Context; Active_Sessions ;;
            4) Show_Function_Name "Lock_List"; Show_Context; Lock_List ;;
            5) Show_Function_Name "Dead_Tuple_List"; Show_Context; Dead_Tuple_List ;;
            6) Show_Function_Name "Tablespace_Info"; Show_Context; Tablespace_Info ;;
            7) Show_Function_Name "Top_Queries"; Show_Context; Top_Queries ;;
            8) Show_Function_Name "Vacuum_Info"; Show_Context; Vacuum_Info ;;
            9) Show_Function_Name "Commit_Hit_Ratio"; Show_Context; Commit_Hit_Ratio ;;
            10) Show_Function_Name "Replication_Delay"; Show_Context; Replication_Delay ;;
            11) Show_Function_Name "Object_Count_by_Schema"; Show_Context; Object_Count_by_Schema ;;
            12) Show_Function_Name "Index_Usage_Stats"; Show_Context; Index_Usage_Stats ;;
            13) Show_Function_Name "Unused_Indexes"; Show_Context; Unused_Indexes ;;
            14) Show_Function_Name "Long_Running_Queries"; Show_Context; Long_Running_Queries ;;
            15) Show_Function_Name "Vacuum_Info_Detailed"; Show_Context; Vacuum_Info_Detailed ;;
            16) Show_Function_Name "Switch_Database_User"; Switch_Database_User ;;
	    17) Show_Function_Name "Log_Error_Fatal_Panic"; Show_Context; Log_Error_Fatal_Panic ;;
            18) Show_Function_Name "Export_Reports"; Show_Context; Export_Reports ;;
	    99) break ;;
            *) echo -e "${RED}Invalid option${RESET}" ;;
        esac
    done
}

# 1. Version Info - Displays PostgreSQL version and startup time
Version_Info() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT 'Port: ' || setting AS port_info FROM pg_settings WHERE name = 'port'
    UNION ALL
    SELECT 'Version: ' || version() AS version_info
    UNION ALL
    SELECT 'Startup Time: ' || pg_postmaster_start_time() AS startup_time;"
}

# 2. Schema List - Lists all non-system schemas
Schema_List() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT nspname AS schema_name, pg_catalog.pg_get_userbyid(nspowner) AS owner
    FROM pg_catalog.pg_namespace
    WHERE nspname !~ '^pg_' AND nspname <> 'information_schema'
    ORDER BY 1;"
}

# 3. Active Sessions - Shows currently active sessions
Active_Sessions() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT pid AS process_id, usename AS username, datname AS database,
           client_addr AS client_address, state, 
           to_char(now() - query_start, 'HH24:MI:SS') AS elapsed_time,
           substr(query, 1, 30) AS query
    FROM pg_stat_activity
    WHERE state = 'active'
    ORDER BY pid DESC;"
}

# 4. Lock List - Displays current locks
Lock_List() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT k.datname AS database, k.usename AS username, t.relname AS relation,
           l.pid, l.mode, l.granted, substr(k.query, 1, 50) AS query
    FROM pg_locks l
    JOIN pg_stat_activity k ON l.pid = k.pid
    JOIN pg_stat_all_tables t ON l.relation = t.relid
    WHERE k.datname = '$D'
    ORDER BY l.pid DESC;"
}

# 5. Dead Tuple List - Shows tables with dead tuples
Dead_Tuple_List() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT n.nspname AS schema_name, c.relname AS table_name,
           pg_stat_get_live_tuples(c.oid) AS live_tuples,
           pg_stat_get_dead_tuples(c.oid) AS dead_tuples,
           round(100.0 * pg_stat_get_dead_tuples(c.oid) / (pg_stat_get_live_tuples(c.oid) + pg_stat_get_dead_tuples(c.oid)), 2) AS dead_tuple_ratio
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE pg_stat_get_live_tuples(c.oid) > 0 AND c.relkind = 'r'
    ORDER BY dead_tuples DESC;"
}

# 6. Tablespace Info - Displays tablespace details
Tablespace_Info() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT spcname AS tablespace_name, pg_catalog.pg_get_userbyid(spcowner) AS owner,
           pg_catalog.pg_tablespace_location(oid) AS location,
           pg_size_pretty(pg_tablespace_size(oid)) AS size
    FROM pg_tablespace
    ORDER BY 1;"
}

# 7. Top 15 Queries - Shows top 15 queries by execution time

Top_Queries() {

    # Check if pg_stat_statements is preloaded (prevents ERROR spam)
    local preload
    preload=$(psql $PSQL_OPTS pager=off -d "$D" -U "$U" -t -c "SHOW shared_preload_libraries;" 2>/dev/null | tr -d ' ')

    if [[ "$preload" != *"pg_stat_statements"* ]]; then
        echo -e "${YELLOW}pg_stat_statements is installed, but NOT preloaded.${RESET}"
        echo -e "${YELLOW}Fix: add pg_stat_statements to shared_preload_libraries and restart PostgreSQL.${RESET}"
        echo -e "${YELLOW}Current shared_preload_libraries: ${preload}${RESET}"
        return 0
    fi

    # Run report
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT queryid, calls,
           round(total_exec_time::numeric, 2) AS total_exec_ms,
           round(mean_exec_time::numeric, 2) AS mean_exec_ms,
           rows, left(query, 200) AS query
    FROM pg_stat_statements
    WHERE dbid = (SELECT oid FROM pg_database WHERE datname = '$D')
    ORDER BY total_exec_time DESC
    LIMIT 15;"
}






# 8. Vacuum Info (Basic) - Displays basic vacuum-related statistics
Vacuum_Info() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT n.nspname AS schema_name, c.relname AS table_name,
           pg_stat_get_live_tuples(c.oid) AS live_tuples,
           pg_stat_get_dead_tuples(c.oid) AS dead_tuples,
           pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relkind = 'r'
    ORDER BY dead_tuples DESC;"
}

# 9. Commit & Hit Ratio - Shows commit and cache hit ratios
Commit_Hit_Ratio() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT d.datname AS database, u.usename AS username,
           round(100.0 * sd.blks_hit / (sd.blks_read + sd.blks_hit), 2) AS cache_hit_ratio,
           round(100.0 * sd.xact_commit / (sd.xact_commit + sd.xact_rollback), 2) AS commit_ratio
    FROM pg_stat_database sd
    JOIN pg_database d ON d.oid = sd.datid
    JOIN pg_user u ON u.usesysid = d.datdba
    WHERE sd.blks_read + sd.blks_hit > 0 OR sd.xact_commit + sd.xact_rollback > 0;"
}

# 10. Replication Delay - Displays replication status and delay
Replication_Delay() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT CASE WHEN pg_is_in_recovery() THEN 'Standby' ELSE 'Primary' END AS server_type;
    SELECT pg_current_wal_lsn() AS current_lsn, sent_lsn,
           pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn) AS primary_lsn_diff
    FROM pg_stat_replication
    WHERE state = 'streaming' AND sent_lsn IS NOT NULL;
    SELECT pg_last_wal_receive_lsn() AS receive_lsn, pg_last_wal_replay_lsn() AS replay_lsn,
           COALESCE(round(extract(epoch FROM now() - pg_last_xact_replay_timestamp())), 0) AS delay_seconds
    FROM pg_stat_replication LIMIT 1;"
}

# 11. Object Count by Schema - Counts objects per schema
Object_Count_by_Schema() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT n.nspname AS schema_name,
           COUNT(CASE WHEN c.relkind = 'r' THEN 1 END) AS tables,
           COUNT(CASE WHEN c.relkind = 'i' THEN 1 END) AS indexes,
           COUNT(CASE WHEN c.relkind = 'S' THEN 1 END) AS sequences,
           COUNT(CASE WHEN c.relkind = 'v' THEN 1 END) AS views
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema'
    GROUP BY n.nspname
    ORDER BY n.nspname;"
}

# 12. Index Usage Statistics - Shows index usage and size
Index_Usage_Stats() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT 
        n.nspname AS schema_name,
        t.relname AS table_name,
        i.relname AS index_name,
        pg_size_pretty(pg_relation_size(i.oid)) AS index_size,
        idx_scan AS index_scans,
        CASE 
            WHEN idx_scan = 0 THEN 'Unused'
            ELSE 'Used'
        END AS usage_status
    FROM pg_stat_all_indexes s
    JOIN pg_class t ON s.relid = t.oid
    JOIN pg_class i ON s.indexrelid = i.oid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema'
    ORDER BY idx_scan ASC, index_size DESC;"
}

# 13. Unused Indexes - Lists indexes with zero scans
Unused_Indexes() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT 
        n.nspname AS schema_name,
        t.relname AS table_name,
        i.relname AS index_name,
        pg_size_pretty(pg_relation_size(i.oid)) AS index_size,
        idx_scan AS index_scans
    FROM pg_stat_all_indexes s
    JOIN pg_class t ON s.relid = t.oid
    JOIN pg_class i ON s.indexrelid = i.oid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema'
    AND idx_scan = 0
    ORDER BY index_size DESC;"
}

# 14. Long Running Queries - Shows queries running longer than 1 minute
Long_Running_Queries() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT 
        pid AS process_id,
        usename AS username,
        datname AS database,
        to_char(now() - query_start, 'HH24:MI:SS') AS duration,
        state,
        substr(query, 1, 50) AS query
    FROM pg_stat_activity
    WHERE state = 'active' 
    AND now() - query_start > interval '1 minute'
    ORDER BY duration DESC;"
}

# 15. Vacuum Info (Detailed) - Shows detailed vacuum and autovacuum stats
Vacuum_Info_Detailed() {
    psql $PSQL_OPTS pager=off -d "$D" -U "$U" -c "
    SELECT 
        n.nspname AS schema_name,
        c.relname AS table_name,
        pg_stat_get_live_tuples(c.oid) AS live_tuples,
        pg_stat_get_dead_tuples(c.oid) AS dead_tuples,
        to_char(last_vacuum, 'YYYY-MM-DD HH24:MI:SS') AS last_vacuum,
        to_char(last_autovacuum, 'YYYY-MM-DD HH24:MI:SS') AS last_autovacuum,
        vacuum_count AS manual_vacuum_count,
        autovacuum_count AS auto_vacuum_count,
        pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_stat_all_tables s ON s.relid = c.oid
    WHERE c.relkind = 'r'
    ORDER BY dead_tuples DESC;"
}

# 17. Log Error/Fatal/Panic Count - Counts in terminal + writes extracted lines to /home/postgres/
Log_Error_Fatal_Panic() {

    # output file name: yiloykun (YYYYMMDD)
    local DT=$(date +%Y%m%d)
    local OUT_FILE="/home/postgres/pg_errors_${DT}.log"

    # Detect logging settings
    local logging_collector=$(psql $PSQL_OPTS pager=off -d "$D" -U "$U" -t -c "SHOW logging_collector;" | tr -d ' ')
    local log_dir=$(psql $PSQL_OPTS pager=off -d "$D" -U "$U" -t -c "SHOW log_directory;" | tr -d ' ')
    local data_dir=$(psql $PSQL_OPTS pager=off -d "$D" -U "$U" -t -c "SHOW data_directory;" | tr -d ' ')
    local log_destination=$(psql $PSQL_OPTS pager=off -d "$D" -U "$U" -t -c "SHOW log_destination;" | tr -d ' ')

    # If not file logs, warn user
    if [[ "$logging_collector" != "on" ]]; then
        echo -e "${YELLOW}WARNING:${RESET} logging_collector=off (log_destination=$log_destination)."
        echo -e "${YELLOW}Skript hozir file loglarni analiz qiladi. Agar journald bo'lsa, alohida modul qilamiz.${RESET}"
        return 0
    fi

    # Build absolute log directory
    local abs_log_dir=""
    if [[ "$log_dir" == /* ]]; then
        abs_log_dir="$log_dir"
    else
        abs_log_dir="${data_dir%/}/$log_dir"
    fi

    if [[ ! -d "$abs_log_dir" ]]; then
        echo -e "${RED}ERROR:${RESET} Log directory topilmadi: $abs_log_dir"
        return 1
    fi

    # Pick latest log file in that directory
    local LOG_FILE
    LOG_FILE=$(ls -1t "$abs_log_dir"/* 2>/dev/null | head -n 1)

    if [[ -z "$LOG_FILE" || ! -f "$LOG_FILE" ]]; then
        echo -e "${RED}ERROR:${RESET} Log file topilmadi: $abs_log_dir"
        return 1
    fi

    echo -e "${BLUE}Log directory:${RESET} $abs_log_dir"
    echo -e "${BLUE}Using log file:${RESET} $LOG_FILE"
    echo -e "${BLUE}Output file:${RESET} $OUT_FILE"
    echo -e "${BLUE}-------------------------------------${RESET}"

    # Count severities
    local CNT_ERROR CNT_FATAL CNT_PANIC
    CNT_ERROR=$(grep -c "ERROR:" "$LOG_FILE" 2>/dev/null || echo 0)
    CNT_FATAL=$(grep -c "FATAL:" "$LOG_FILE" 2>/dev/null || echo 0)
    CNT_PANIC=$(grep -c "PANIC:" "$LOG_FILE" 2>/dev/null || echo 0)

    echo -e "${GREEN}ERROR:${RESET} $CNT_ERROR"
    echo -e "${GREEN}FATAL:${RESET} $CNT_FATAL"
    echo -e "${GREEN}PANIC:${RESET} $CNT_PANIC"

    # Write extracted lines to /home/postgres/
    {
        echo "Collected: $(date +'%Y-%m-%d %H:%M:%S')"
        echo "Database: $D  User: $U"
        echo "Log file: $LOG_FILE"
        echo "Counts => ERROR:$CNT_ERROR FATAL:$CNT_FATAL PANIC:$CNT_PANIC"
        echo "------------------------------------------------------------"
        grep -E "ERROR:|FATAL:|PANIC:" "$LOG_FILE" 2>/dev/null || true
    } > "$OUT_FILE"

    echo -e "${YELLOW}Saved:${RESET} $OUT_FILE"
}



# --- Export helpers ---
EXPORT_BASE="/home/postgres"

export_psql() {
    # usage: export_psql <name> <fmt:csv|html> <sql>
    local name="$1"
    local fmt="$2"
    local sql="$3"
    local out=""

    mkdir -p "$EXPORT_DIR" 2>/dev/null

    case "$fmt" in
        csv)
            out="$EXPORT_DIR/${name}.csv"
            psql $PSQL_OPTS pager=off --csv -d "$D" -U "$U" -c "$sql" > "$out"
            ;;
        html)
            out="$EXPORT_DIR/${name}.html"
            psql $PSQL_OPTS pager=off -H -d "$D" -U "$U" -c "$sql" > "$out"
            ;;
        *)
            echo -e "${RED}Invalid format:${RESET} $fmt"
            return 1
            ;;
    esac

    echo -e "${GREEN}Saved:${RESET} $out"
}

export_write_text() {
    # usage: export_write_text <name> <text>
    local name="$1"
    local text="$2"
    mkdir -p "$EXPORT_DIR" 2>/dev/null
    echo -e "$text" > "$EXPORT_DIR/${name}.txt"
    echo -e "${GREEN}Saved:${RESET} $EXPORT_DIR/${name}.txt"
}


# --- Export helpers (required by Export_Reports) ---
EXPORT_BASE="/home/postgres"

export_psql() {
    # usage: export_psql <name> <fmt:csv|html> <sql>
    local name="$1"
    local fmt="$2"
    local sql="$3"
    local out=""

    mkdir -p "$EXPORT_DIR" 2>/dev/null

    case "$fmt" in
        csv)
            out="$EXPORT_DIR/${name}.csv"
            psql $PSQL_OPTS pager=off --csv -d "$D" -U "$U" -c "$sql" > "$out"
            ;;
        html)
            out="$EXPORT_DIR/${name}.html"
            psql $PSQL_OPTS pager=off -H -d "$D" -U "$U" -c "$sql" > "$out"
            ;;
        *)
            echo -e "${RED}Invalid format:${RESET} $fmt"
            return 1
            ;;
    esac

    echo -e "${GREEN}Saved:${RESET} $out"
}

Merge_Exported_HTML() {
    local DT=$(date +%Y%m%d_%H%M%S)
    local OUT="$EXPORT_DIR/ALL_REPORT_${DT}.html"

    {
        echo "<html><head><meta charset='utf-8'><title>PostgreSQL Report</title></head><body>"
        echo "<a id='top'></a>"
        echo "<h2>PostgreSQL Maintenance Report</h2>"
        echo "<p><b>Date:</b> $(date +'%Y-%m-%d %H:%M:%S')<br/>"
        echo "<b>Database:</b> $D<br/>"
        echo "<b>User:</b> $U</p>"
        echo "<hr/>"

        echo "<h3>Contents</h3><ol>"
        for f in $(ls -1 "$EXPORT_DIR"/*.html 2>/dev/null | sort); do
            base=$(basename "$f")
            name="${base%.html}"
            echo "<li><a href='#$name'>$name</a></li>"
        done
        echo "</ol><hr/>"

        for f in $(ls -1 "$EXPORT_DIR"/*.html 2>/dev/null | sort); do
            base=$(basename "$f")
            name="${base%.html}"
            echo "<h2 id='$name'>$name</h2>"
            echo "<div>"
            cat "$f"
            echo "</div>"
            echo "<p><a href='#top'>Back to top</a></p>"
            echo "<hr/>"
        done

        echo "</body></html>"
    } > "$OUT"

    echo -e "${GREEN}Saved single HTML:${RESET} $OUT"
}

    


# 18. Export all reports to /home/postgres in CSV or HTML
# - CSV: creates multiple .csv files (normal)
# - HTML: creates ONE single file only (ALL_REPORT_YYYYMMDD_HHMMSS.html)
Export_Reports() {

    echo -e "${YELLOW}Select export format:${RESET}"
    echo -e "${YELLOW} 1) CSV (Excel)${RESET}"
    echo -e "${YELLOW} 2) HTML (single file)${RESET}"
    echo -n -e "${BLUE}Enter choice [1/2]: ${RESET}"
    read fmt_choice

    local FMT="csv"
    case "$fmt_choice" in
        1) FMT="csv" ;;
        2) FMT="html" ;;
        *) echo -e "${RED}Invalid choice${RESET}"; return 1 ;;
    esac

    local DT=$(date +%Y%m%d_%H%M%S)
    EXPORT_BASE="/home/postgres"
    EXPORT_DIR="${EXPORT_BASE}/pg_reports_${DT}"
    mkdir -p "$EXPORT_DIR" || return 1

    echo -e "${BLUE}Export directory:${RESET} $EXPORT_DIR"
    echo -e "${BLUE}Format:${RESET} $FMT"
    echo -e "${BLUE}-------------------------------------${RESET}"

    # helper for CSV (separate files)
    export_csv() {
        local name="$1"
        local sql="$2"
        local out="$EXPORT_DIR/${name}.csv"
        psql -P pager=off --csv -d "$D" -U "$U" -c "$sql" > "$out"
        echo -e "${GREEN}Saved:${RESET} $out"
    }

    # helper for HTML (append sections into one file)
    HTML_OUT="$EXPORT_DIR/ALL_REPORT_${DT}.html"
    html_begin() {
        {
            echo "<html><head><meta charset='utf-8'><title>PostgreSQL Report</title></head><body>"
            echo "<a id='top'></a>"
            echo "<h2>PostgreSQL Maintenance Report</h2>"
            echo "<p><b>Date:</b> $(date +'%Y-%m-%d %H:%M:%S')<br/>"
            echo "<b>Database:</b> $D<br/>"
            echo "<b>User:</b> $U</p>"
            echo "<hr/>"
        } > "$HTML_OUT"
    }

    html_section() {
        local title="$1"
        local sql="$2"
        {
            echo "<h2 id='$title'>$title</h2>"
            echo "<div>"
            psql -P pager=off -H -d "$D" -U "$U" -c "$sql"
            echo "</div>"
            echo "<p><a href='#top'>Back to top</a></p>"
            echo "<hr/>"
        } >> "$HTML_OUT"
    }

    html_end() {
        echo "</body></html>" >> "$HTML_OUT"
        echo -e "${GREEN}Saved:${RESET} $HTML_OUT"
    }

    if [[ "$FMT" == "html" ]]; then
        html_begin
    fi

    # ---- 1) Version Info
    SQL1="
    SELECT 'Port: ' || setting AS port_info FROM pg_settings WHERE name = 'port'
    UNION ALL
    SELECT 'Version: ' || version() AS version_info
    UNION ALL
    SELECT 'Startup Time: ' || pg_postmaster_start_time() AS startup_time;"
    if [[ "$FMT" == "csv" ]]; then export_csv "01_version_info" "$SQL1"; else html_section "01_version_info" "$SQL1"; fi

    # ---- 2) Schema List
    SQL2="
    SELECT nspname AS schema_name, pg_catalog.pg_get_userbyid(nspowner) AS owner
    FROM pg_catalog.pg_namespace
    WHERE nspname !~ '^pg_' AND nspname <> 'information_schema'
    ORDER BY 1;"
    if [[ "$FMT" == "csv" ]]; then export_csv "02_schema_list" "$SQL2"; else html_section "02_schema_list" "$SQL2"; fi

    # ---- 3) Active Sessions
    SQL3="
    SELECT pid AS process_id, usename AS username, datname AS database,
           client_addr AS client_address, state,
           to_char(now() - query_start, 'HH24:MI:SS') AS elapsed_time,
           substr(query, 1, 30) AS query
    FROM pg_stat_activity
    WHERE state = 'active'
    ORDER BY pid DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "03_active_sessions" "$SQL3"; else html_section "03_active_sessions" "$SQL3"; fi

    # ---- 4) Lock List
    SQL4="
    SELECT k.datname AS database, k.usename AS username, t.relname AS relation,
           l.pid, l.mode, l.granted, substr(k.query, 1, 50) AS query
    FROM pg_locks l
    JOIN pg_stat_activity k ON l.pid = k.pid
    JOIN pg_stat_all_tables t ON l.relation = t.relid
    WHERE k.datname = '$D'
    ORDER BY l.pid DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "04_lock_list" "$SQL4"; else html_section "04_lock_list" "$SQL4"; fi

    # ---- 5) Dead Tuple List
    SQL5="
    SELECT n.nspname AS schema_name, c.relname AS table_name,
           pg_stat_get_live_tuples(c.oid) AS live_tuples,
           pg_stat_get_dead_tuples(c.oid) AS dead_tuples,
           round(100.0 * pg_stat_get_dead_tuples(c.oid) /
                 (pg_stat_get_live_tuples(c.oid) + pg_stat_get_dead_tuples(c.oid)), 2) AS dead_tuple_ratio
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE pg_stat_get_live_tuples(c.oid) > 0 AND c.relkind = 'r'
    ORDER BY dead_tuples DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "05_dead_tuple_list" "$SQL5"; else html_section "05_dead_tuple_list" "$SQL5"; fi

    # ---- 6) Tablespace Info
    SQL6="
    SELECT spcname AS tablespace_name, pg_catalog.pg_get_userbyid(spcowner) AS owner,
           pg_catalog.pg_tablespace_location(oid) AS location,
           pg_size_pretty(pg_tablespace_size(oid)) AS size
    FROM pg_tablespace
    ORDER BY 1;"
    if [[ "$FMT" == "csv" ]]; then export_csv "06_tablespace_info" "$SQL6"; else html_section "06_tablespace_info" "$SQL6"; fi

    # ---- 7) Top 15 Queries
    SQL7="
    SELECT queryid, calls, round(total_plan_time::numeric, 2) AS total_time_ms,
           round(mean_plan_time::numeric, 2) AS mean_time_ms, rows, query
    FROM pg_stat_statements
    WHERE dbid = (SELECT oid FROM pg_database WHERE datname = '$D')
    ORDER BY total_plan_time DESC
    LIMIT 15;"


    # ---- 7) Top 15 Queries
SQL7="
SELECT queryid, calls, round(total_exec_time::numeric, 2) AS total_exec_ms,
       round(mean_exec_time::numeric, 2) AS mean_exec_ms, rows, left(query, 200) AS query
FROM pg_stat_statements
WHERE dbid = (SELECT oid FROM pg_database WHERE datname = '$D')
ORDER BY total_exec_time DESC
LIMIT 15;"

if [[ "$FMT" == "csv" ]]; then
    export_csv "07_top_15_queries" "$SQL7"
else
    html_section "07_top_15_queries" "$SQL7"
fi


    # ---- 8) Vacuum Info (Basic)
    SQL8="
    SELECT n.nspname AS schema_name, c.relname AS table_name,
           pg_stat_get_live_tuples(c.oid) AS live_tuples,
           pg_stat_get_dead_tuples(c.oid) AS dead_tuples,
           pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relkind = 'r'
    ORDER BY dead_tuples DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "08_vacuum_info_basic" "$SQL8"; else html_section "08_vacuum_info_basic" "$SQL8"; fi

    # ---- 9) Commit & Hit Ratio
    SQL9="
    SELECT d.datname AS database, u.usename AS username,
           round(100.0 * sd.blks_hit / (sd.blks_read + sd.blks_hit), 2) AS cache_hit_ratio,
           round(100.0 * sd.xact_commit / (sd.xact_commit + sd.xact_rollback), 2) AS commit_ratio
    FROM pg_stat_database sd
    JOIN pg_database d ON d.oid = sd.datid
    JOIN pg_user u ON u.usesysid = d.datdba
    WHERE sd.blks_read + sd.blks_hit > 0 OR sd.xact_commit + sd.xact_rollback > 0;"
    if [[ "$FMT" == "csv" ]]; then export_csv "09_commit_hit_ratio" "$SQL9"; else html_section "09_commit_hit_ratio" "$SQL9"; fi

    # ---- 10) Replication Delay (3 parts)
    SQL10A="SELECT CASE WHEN pg_is_in_recovery() THEN 'Standby' ELSE 'Primary' END AS server_type;"
    SQL10B="
    SELECT pg_current_wal_lsn() AS current_lsn, sent_lsn,
           pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn) AS primary_lsn_diff
    FROM pg_stat_replication
    WHERE state = 'streaming' AND sent_lsn IS NOT NULL;"
    SQL10C="
    SELECT pg_last_wal_receive_lsn() AS receive_lsn, pg_last_wal_replay_lsn() AS replay_lsn,
           COALESCE(round(extract(epoch FROM now() - pg_last_xact_replay_timestamp())), 0) AS delay_seconds;"
    if [[ "$FMT" == "csv" ]]; then
        export_csv "10_replication_server_type" "$SQL10A"
        export_csv "10b_replication_primary_diff" "$SQL10B"
        export_csv "10c_replication_standby_delay" "$SQL10C"
    else
        html_section "10_replication_server_type" "$SQL10A"
        html_section "10b_replication_primary_diff" "$SQL10B"
        html_section "10c_replication_standby_delay" "$SQL10C"
    fi

    # ---- 11) Object Count by Schema
    SQL11="
    SELECT n.nspname AS schema_name,
           COUNT(CASE WHEN c.relkind = 'r' THEN 1 END) AS tables,
           COUNT(CASE WHEN c.relkind = 'i' THEN 1 END) AS indexes,
           COUNT(CASE WHEN c.relkind = 'S' THEN 1 END) AS sequences,
           COUNT(CASE WHEN c.relkind = 'v' THEN 1 END) AS views
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema'
    GROUP BY n.nspname
    ORDER BY n.nspname;"
    if [[ "$FMT" == "csv" ]]; then export_csv "11_object_count_by_schema" "$SQL11"; else html_section "11_object_count_by_schema" "$SQL11"; fi

    # ---- 12) Index Usage Statistics
    SQL12="
    SELECT
        n.nspname AS schema_name,
        t.relname AS table_name,
        i.relname AS index_name,
        pg_size_pretty(pg_relation_size(i.oid)) AS index_size,
        idx_scan AS index_scans,
        CASE WHEN idx_scan = 0 THEN 'Unused' ELSE 'Used' END AS usage_status
    FROM pg_stat_all_indexes s
    JOIN pg_class t ON s.relid = t.oid
    JOIN pg_class i ON s.indexrelid = i.oid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema'
    ORDER BY idx_scan ASC, index_size DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "12_index_usage_statistics" "$SQL12"; else html_section "12_index_usage_statistics" "$SQL12"; fi

    # ---- 13) Unused Indexes
    SQL13="
    SELECT
        n.nspname AS schema_name,
        t.relname AS table_name,
        i.relname AS index_name,
        pg_size_pretty(pg_relation_size(i.oid)) AS index_size,
        idx_scan AS index_scans
    FROM pg_stat_all_indexes s
    JOIN pg_class t ON s.relid = t.oid
    JOIN pg_class i ON s.indexrelid = i.oid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname !~ '^pg_' AND n.nspname <> 'information_schema'
      AND idx_scan = 0
    ORDER BY index_size DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "13_unused_indexes" "$SQL13"; else html_section "13_unused_indexes" "$SQL13"; fi

    # ---- 14) Long Running Queries
    SQL14="
    SELECT
        pid AS process_id,
        usename AS username,
        datname AS database,
        to_char(now() - query_start, 'HH24:MI:SS') AS duration,
        state,
        substr(query, 1, 50) AS query
    FROM pg_stat_activity
    WHERE state = 'active'
      AND now() - query_start > interval '1 minute'
    ORDER BY duration DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "14_long_running_queries" "$SQL14"; else html_section "14_long_running_queries" "$SQL14"; fi

    # ---- 15) Vacuum Info (Detailed)
    SQL15="
    SELECT
        n.nspname AS schema_name,
        c.relname AS table_name,
        pg_stat_get_live_tuples(c.oid) AS live_tuples,
        pg_stat_get_dead_tuples(c.oid) AS dead_tuples,
        to_char(last_vacuum, 'YYYY-MM-DD HH24:MI:SS') AS last_vacuum,
        to_char(last_autovacuum, 'YYYY-MM-DD HH24:MI:SS') AS last_autovacuum,
        vacuum_count AS manual_vacuum_count,
        autovacuum_count AS auto_vacuum_count,
        pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_stat_all_tables s ON s.relid = c.oid
    WHERE c.relkind = 'r'
    ORDER BY dead_tuples DESC;"
    if [[ "$FMT" == "csv" ]]; then export_csv "15_vacuum_info_detailed" "$SQL15"; else html_section "15_vacuum_info_detailed" "$SQL15"; fi


    # ---- 17) Log count + show lines in HTML
Log_Error_Fatal_Panic

local today=$(date +%Y%m%d)
local log_file="/home/postgres/pg_errors_${today}.log"
local cnt_err=$(grep -c "ERROR:" "$log_file" 2>/dev/null || echo 0)
local cnt_fatal=$(grep -c "FATAL:" "$log_file" 2>/dev/null || echo 0)
local cnt_panic=$(grep -c "PANIC:" "$log_file" 2>/dev/null || echo 0)

if [[ "$FMT" == "csv" ]]; then
    echo "date,error,fatal,panic" > "$EXPORT_DIR/17_log_counts.csv"
    echo "$(date +%F),$cnt_err,$cnt_fatal,$cnt_panic" >> "$EXPORT_DIR/17_log_counts.csv"
    echo -e "${GREEN}Saved:${RESET} $EXPORT_DIR/17_log_counts.csv"
else
    # counts table
    html_section "17_log_counts" "SELECT '$(date +%F)' AS date, $cnt_err AS error, $cnt_fatal AS fatal, $cnt_panic AS panic;"

    # log lines under counts
    if [[ -f "$log_file" ]]; then

        {
            echo "<h2 id='17_log_errors'>17_log_errors (last 200)</h2><div><pre>"
            grep "ERROR:" "$log_file" 2>/dev/null | tail -n 200 | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
            echo "</pre></div><p><a href='#top'>Back to top</a></p><hr/>"
        } >> "$HTML_OUT"

        {
            echo "<h2 id='17_log_fatal'>17_log_fatal (last 200)</h2><div><pre>"
            grep "FATAL:" "$log_file" 2>/dev/null | tail -n 200 | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
            echo "</pre></div><p><a href='#top'>Back to top</a></p><hr/>"
        } >> "$HTML_OUT"

        {
            echo "<h2 id='17_log_panic'>17_log_panic (last 50)</h2><div><pre>"
            grep "PANIC:" "$log_file" 2>/dev/null | tail -n 50 | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
            echo "</pre></div><p><a href='#top'>Back to top</a></p><hr/>"
        } >> "$HTML_OUT"

    else
        {
            echo "<h2 id='17_log_details'>17_log_details</h2>"
            echo "<p>Log file not found: $log_file</p><hr/>"
        } >> "$HTML_OUT"
    fi
fi


    if [[ "$FMT" == "html" ]]; then
        html_end
        echo -e "${GREEN}DONE:${RESET} Single HTML exported to $HTML_OUT"
    else
        echo -e "${GREEN}DONE:${RESET} CSV exported to $EXPORT_DIR"
    fi
}






# Start the script
main $*
