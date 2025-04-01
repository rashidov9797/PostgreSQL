# PostgreSQL

# PostgreSQL Maintenance Tool

This shell script is designed to manage and monitor PostgreSQL databases. It includes 16 useful functions for database administration, monitoring, and optimization.

## Installation
1. Download the script:
https://github.com/rashidov9797/PostgreSQL.git

2. Make it executable:
chmod +x maintenance.sh

3. Run the script:
./maintenance.sh



Features

1. Version Info: Displays PostgreSQL version and startup time.
2. Schema List: Lists all non-system schemas.
3. Active Sessions: Shows currently active sessions.
4. Lock List: Displays current locks.
5. Dead Tuple List: Shows tables with dead tuples.
6. Tablespace Info: Displays tablespace details.
7. Top 15 Queries: Shows top 15 queries by execution time.
8. Vacuum Info (Basic): Displays basic vacuum statistics.
9. Commit & Hit Ratio: Shows commit and cache hit ratios.
10. Replication Delay: Displays replication status and delay.
11. Object Count by Schema: Counts objects per schema.
12. Index Usage Statistics: Shows index usage and size.
13. Unused Indexes: Lists indexes with zero scans.
14. Long Running Queries: Shows queries running longer than 1 minute.
15. Vacuum Info (Detailed): Shows detailed vacuum and autovacuum stats.
16. Switch Database/User: Allows switching between databases and users.

![image](https://github.com/user-attachments/assets/a36db033-a503-4f84-8067-ce2ba8b074a4)


Usage

When prompted with Select an option:, enter a number between 1 and 16.

Use 99 to exit the script.

Switch Database/User: Allows switching between databases and users.


Contact
For questions or feedback, reach out at: azikrashidov1103@gmail.com

