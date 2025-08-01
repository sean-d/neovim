# Database Tools

Interact with databases directly from Neovim using vim-dadbod and vim-dadbod-ui.

## Overview

This database integration provides:
- **Multiple Database Support** - PostgreSQL, MySQL, SQLite, Redis, MongoDB, and more
- **Interactive UI** - Browse databases, tables, and schemas in a drawer interface
- **Query Management** - Save, organize, and rerun queries
- **SQL Completion** - Intelligent autocomplete for SQL statements
- **Results Viewer** - Format and display query results
- **Connection Management** - Securely store and manage database connections
- **Notification Integration** - Uses nvim-notify for database messages
- **Icon Support** - Beautiful icons for databases, tables, and queries with Nerd Fonts

## Prerequisites

Install database clients for the databases you use:
```bash
# PostgreSQL
brew install postgresql

# MySQL
brew install mysql-client

# SQLite (usually pre-installed)
sqlite3 --version

# Redis
brew install redis

# MongoDB
brew install mongodb-community
```

## Database UI

The database UI opens in a drawer on the right side of your screen, similar to the file explorer.

### UI Structure
```
▾ Connections
  ▸ 🗄️ production_db
  ▾ 🗄️ development_db
    ▾ 󰦨 Buffers
      development.sql
    ▾  Saved queries
      user_stats.sql
      daily_reports.sql
    ▾  Schemas
      ▾ public
        ▾  Tables
          users
          orders
          products
```

## Key Mappings

### Database Commands
| Key | Description |
|-----|-------------|
| `<leader>Dt` | Toggle database UI drawer 🗄️ |
| `<leader>Da` | Add new connection 🔌 |
| `<leader>Df` | Find database buffer 🔍 |

### Inside Database UI
| Key | Description |
|-----|-------------|
| `o` or `<Enter>` | Open/expand item |
| `S` | Open in vertical split |
| `d` | Delete buffer/saved query |
| `A` | Add new connection |
| `R` | Rename item |
| `q` | Close UI |
| `?` | Show help |

### In SQL Buffers
The vim-dadbod plugin provides default mappings for SQL execution:
- Select your query visually or position cursor in query
- Use the plugin's execution commands (see vim-dadbod documentation)
- Results appear in a split window

## Setting Up Connections

### Method 1: Environment Variables
Add to your shell config:
```bash
export DATABASE_URL="postgresql://user:password@localhost:5432/mydb"
```

### Method 2: Project-specific
Create `.env` file in project root:
```env
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
DEV_DATABASE_URL=postgresql://user:password@localhost:5432/mydb_dev
```

### Method 3: Interactive
1. Press `<leader>Da` to add connection
2. Enter connection URL when prompted
3. Connection is saved securely

### Connection URL Formats

#### PostgreSQL
```
postgresql://[user[:password]@][host][:port][/dbname][?param1=value1&...]
postgresql://user:pass@localhost:5432/mydb?sslmode=disable
```

#### MySQL
```
mysql://[user[:password]@][host][:port][/dbname]
mysql://root:password@localhost:3306/myapp
```

#### SQLite
```
sqlite:///path/to/database.db
sqlite:///Users/me/data.db
```

#### Redis
```
redis://[user[:password]@][host][:port][/db-number]
redis://localhost:6379/0
```

## Query Workflow

### 1. Connect to Database
```vim
:DBUI
" Navigate to your database and press 'o'
```

### 2. Write Query
Create new query buffer:
- Navigate to database in UI
- Press `o` on "New query" option

Or open existing SQL file:
```vim
:e queries/user_report.sql
```

### 3. Execute Query
- Write your SQL query
- Execute using vim-dadbod's built-in commands
- Results appear in a new split window

### 4. Save Query
In the database UI:
- Navigate to "Saved queries"
- Your executed queries can be saved here

## SQL Completion

SQL completion works automatically in `.sql` files:
- Table names after FROM, JOIN
- Column names after SELECT, WHERE  
- SQL keywords
- Database-specific functions

The completion is intelligently triggered after typing:
- `FROM ` (with space)
- `JOIN ` (with space)
- `WHERE `
- `SELECT `
- And other SQL keywords

This prevents annoying popups while typing regular text.

## Table Helpers

When viewing a table in the UI, press `<Enter>` to see quick actions:
- List all records
- Describe table structure
- Show indexes
- Table statistics

## Best Practices

### 1. Connection Security
- Never commit database URLs with passwords
- Use environment variables for sensitive data
- Consider using SSH tunnels for remote databases

### 2. Query Organization
```
project/
├── queries/
│   ├── reports/
│   │   ├── daily_sales.sql
│   │   └── user_activity.sql
│   ├── maintenance/
│   │   ├── cleanup_old_data.sql
│   │   └── optimize_tables.sql
│   └── migrations/
│       ├── 001_create_users.sql
│       └── 002_add_orders.sql
```

### 3. Development Workflow
- Use separate connections for dev/staging/prod
- Test queries in development first
- Save frequently-used queries
- Use transactions for safety

## Advanced Features

### Execute from Command Line
```vim
:DB postgresql://localhost/mydb SELECT * FROM users LIMIT 10
```

### Execute Current Query
In a SQL buffer connected to a database:
```vim
:DB
" Executes query under cursor or visual selection
```

### Assign to Variable
```vim
:let g:prod_db = "postgresql://prod-server/app"
:DB g:prod_db SELECT COUNT(*) FROM orders
```

### Output to File
```vim
:DB postgresql://localhost/mydb SELECT * FROM users > users.csv
```

## Troubleshooting

### Connection Refused
```bash
# Check if database is running
brew services list | grep postgresql

# Start service if needed
brew services start postgresql
```

### Authentication Failed
- Check username/password
- Verify database exists
- Check pg_hba.conf for PostgreSQL

### Slow Queries
- Add EXPLAIN ANALYZE before query
- Check indexes
- Monitor with `\timing` in psql

## Docker Database Connections

For databases running in Docker:
```vim
" Use host.docker.internal on macOS
postgresql://user:pass@host.docker.internal:5432/db

" Or use container name
postgresql://user:pass@my-postgres-container:5432/db
```

## Tips

1. **Quick Table Preview**: Navigate to table and press `o` for instant preview
2. **Export Results**: Use `> filename.csv` at end of query
3. **Multi-statement**: Separate with `;` to run multiple queries
4. **Comments**: Use `--` for single line, `/* */` for multi-line
5. **History**: Previous queries are saved in buffers list

---
[← Back to Docker Integration](docker.md) | [Debugging (DAP) →](debugging.md)