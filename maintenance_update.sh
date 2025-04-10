
#!/bin/bash

# Define colors
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
BOLD='\e[1m'
RESET='\e[0m'

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
    echo -e "${YELLOW} 0. Display main menu Info${RESET}"
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
    echo -e "${YELLOW} 99. Exit${RESET}"
    echo -e "${BLUE}========================================${RESET}"
}

# Function to show database, user, and schema info after selection
Show_Context() {
    local schemas=$(psql -P pager=off -d "$D" -U "$U" -t -c "SHOW search_path;" | tr -d ' ')
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
    psql -P pager=off -d "$INITIAL_DB" -U "$U" -c "SELECT datname AS database, pg_catalog.pg_get_userbyid(datdba) AS owner FROM pg_catalog.pg_database WHERE datname NOT IN ('template0', 'template1') ORDER BY 1;"
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

    echo -n -e "${BLUE}Enter password (hidden): ${RESET}"
    read -s P
    echo
    export PGPASSWORD="$P"
    # Set a default initial database for listing databases
    INITIAL_DB="postgres"

    # Check if the user exists and list databases
    psql -P pager=off -d "$INITIAL_DB" -U "$U" -c "SELECT datname AS database, pg_catalog.pg_get_userbyid(datdba) AS owner FROM pg_catalog.pg_database WHERE datname NOT IN ('template0', 'template1') ORDER BY 1;" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Could not connect with user '$U'. Please check the username and try again.${RESET}"
        exit 1
    fi
    
    while true
    do
    echo -n -e "${BLUE}Enter database name (or press Enter for default: '$INITIAL_DB'): ${RESET}"
    read D
    D=${D:-$INITIAL_DB}

    # Check if the database exists
    DB_EXISTS=$(psql -d "$INITIAL_DB" -U "$U" -tAc "SELECT 1 FROM pg_database WHERE datname = '$D';")
    
    if [ "$DB_EXISTS" = "1" ]; then
        break
    else
        echo -e "${RED}Error: Database '$D' does not exist. Please enter a valid database name.${RESET}"
    fi
    done
    
    D=${D:-$INITIAL_DB}  # Default to 'postgres' if no input

    Display_Menu

    while true; do
        echo -n -e "${BLUE}Select an option: ${RESET}"
        read MENU
        case $MENU in
            0) Display_Menu;;
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
            99) break ;;
            *) echo -e "${RED}Invalid option${RESET}" ;;
        esac
    done
    unset PGPASSWORD
}

# 1. Version Info - Displays PostgreSQL version and startup time
Version_Info() {
    psql -P pager=off -d "$D" -U "$U" -c "
    SELECT 'Port: ' || setting AS port_info FROM pg_settings WHERE name = 'port'
    UNION ALL
    SELECT 'Version: ' || version() AS version_info
    UNION ALL
    SELECT 'Startup Time: ' || pg_postmaster_start_time() AS startup_time;"
}

# 2. Schema List - Lists all non-system schemas
Schema_List() {
    psql -P pager=off -d "$D" -U "$U" -c "
    SELECT nspname AS schema_name, pg_catalog.pg_get_userbyid(nspowner) AS owner
    FROM pg_catalog.pg_namespace
    WHERE nspname !~ '^pg_' AND nspname <> 'information_schema'
    ORDER BY 1;"
}

# 3. Active Sessions - Shows currently active sessions
Active_Sessions() {
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
    SELECT spcname AS tablespace_name, pg_catalog.pg_get_userbyid(spcowner) AS owner,
           pg_catalog.pg_tablespace_location(oid) AS location,
           pg_size_pretty(pg_tablespace_size(oid)) AS size
    FROM pg_tablespace
    ORDER BY 1;"
}

# 7. Top 15 Queries - Shows top 15 queries by execution time
Top_Queries() {
    psql -P pager=off -d "$D" -U "$U" -c "
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_stat_statements') THEN
            CREATE EXTENSION pg_stat_statements;
            RAISE NOTICE 'pg_stat_statements extension created';
        END IF;
    END\$\$;
    SELECT queryid, calls, round(total_plan_time::numeric, 2) AS total_time_ms,
           round(mean_plan_time::numeric, 2) AS mean_time_ms, rows, query
    FROM pg_stat_statements
    WHERE dbid = (SELECT oid FROM pg_database WHERE datname = '$D')
    ORDER BY total_plan_time DESC
    LIMIT 15;"
}

# 8. Vacuum Info (Basic) - Displays basic vacuum-related statistics
Vacuum_Info() {
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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
    psql -P pager=off -d "$D" -U "$U" -c "
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

# Start the script
main $*
