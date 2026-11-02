---
name: laravel-safe-migration
description: "Writes and reviews Laravel database migrations so they are reversible and safe on tables that already hold production data. Use when creating or changing a migration, renaming or dropping columns, adding indexes or foreign keys, or before running migrate on production."
---
# Laravel safe migration

## Step 1: Inspect the current state
```bash
php artisan migrate:status
php artisan db:show            # driver and version (MySQL, PostgreSQL, SQLite behave differently)
php artisan db:table <table>   # current columns and indexes
```

## Step 2: Create a new migration, never edit an old one
Migrations that already ran anywhere shared (staging, production, teammates) are immutable. Create a new one:
```bash
php artisan make:migration add_status_to_orders_table --table=orders
```

## Step 3: Apply the safety rules
- Every `up()` has a working `down()` that reverses it exactly.
- Adding a column to a big table: make it `nullable()` or give it a `default()`. A NOT NULL column without a default fails on existing rows.
- Renaming or dropping a column that running code still reads: split it into releases. Release 1 adds the new column and writes both; backfill; release 2 switches reads; release 3 drops the old column.
- Changing a column type: use `->change()` and restate every attribute you want to keep (nullable, default, comment), because `change()` replaces the definition.
- Foreign keys: `foreignId('user_id')->constrained()`; decide `cascadeOnDelete()` or `nullOnDelete()` explicitly. In `down()`, `dropForeign(['user_id'])` before `dropColumn('user_id')`.
- Indexes on large MySQL tables lock writes on older versions; flag this to the user.
- Data backfills of more than a few thousand rows go in a queued job or a chunked command (`->chunkById(1000, ...)`), not inside the migration.
- Never put `Model` classes in a migration (models change later); use `DB::table()`.

## Step 4: Preview and test both directions
```bash
php artisan migrate --pretend      # print the SQL without running it
php artisan migrate
php artisan migrate:rollback --step=1
php artisan migrate
php artisan test
```
Report the SQL from `--pretend` and say whether rollback worked. If anything here can lock or lose data in production, say so in one sentence at the top of the reply.
