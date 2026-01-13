# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Supabase database management repository for the Prepry application. The primary purpose is to manage database schema migrations across development and production environments using Supabase CLI.

**See [SCHEMA.md](./SCHEMA.md) for a complete database schema reference.**

## Environment Setup

**Prerequisites:**
- Docker must be installed and running
- Supabase CLI must be installed

**Initial setup:**
```bash
supabase login
supabase start
```

## Project Structure

### Environments

There are two distinct projects:
- **Development (`dev`)**: Project name "Prepry-Dev", ID: `cabwwckcdahyaoextulv`
- **Production (`prod`)**: Project name "Prepry - Production", ID: `acivbmjpnzprvmwlpozk`

**Check current project:**
```bash
supabase projects list
```

**Switch projects:**
```bash
supabase link --project-ref cabwwckcdahyaoextulv  # dev
supabase link --project-ref acivbmjpnzprvmwlpozk  # prod
```

### Database Schema

The database uses two primary schemas:
- `cms` schema: Contains all content management system tables including anatomy, chapters, credentialing_bodies, exam_groupings, exams, question_banks, questions, static_quiz_questions, static_quizzes, and videos
- `public` schema: Contains user-facing tables like notes

All migrations are stored in `supabase/migrations/` with timestamp-prefixed filenames.

## Common Commands

### Creating Migrations

**IMPORTANT:** Always ensure you're on the `dev` project before creating migrations.

```bash
# Create a new migration file
supabase migration new <migration_name>
```

This creates a new SQL file in `supabase/migrations/`. Edit the file to add your migration SQL.

### Testing Migrations Locally

```bash
# Start local Supabase (if not running)
supabase start

# Apply all migrations to local database
supabase db reset
```

The `db reset` command resets the local database and reapplies all migrations from scratch.

### Publishing Migrations

**To development:**
```bash
supabase link --project-ref cabwwckcdahyaoextulv
supabase db push
```

**To production:**
```bash
supabase link --project-ref acivbmjpnzprvmwlpozk
supabase db push
```

## Configuration

The `supabase/config.toml` file contains local development configuration:
- Local API port: 54321
- Local database port: 54322
- Studio port: 54323
- PostgreSQL version: 17
- Seed file: `./seed.sql` (if present)

## Development Workflow

1. Ensure you're linked to the `dev` project
2. Create a new migration with `supabase migration new <name>`
3. Write your SQL in the generated migration file
4. Test locally with `supabase db reset`
5. Verify the migration works correctly
6. Push to dev with `supabase db push`
7. **Update SCHEMA.md** - After creating migrations, update the schema documentation (see below)
8. When ready, push to production (carefully review first)

### Updating SCHEMA.md

**IMPORTANT:** After creating new migrations, you MUST update SCHEMA.md to keep the schema reference current.

**Process:**
1. Check the "Last synced with migration" timestamp at the top of SCHEMA.md
2. Identify all migration files AFTER that timestamp (based on filename ordering in `supabase/migrations/`)
3. Read those new migration files and analyze the schema changes
4. Update SCHEMA.md to reflect:
   - New tables, columns, or relationships
   - Modified indexes or constraints
   - New functions or triggers
   - Updated security policies
5. Update the "Last synced with migration" timestamp in SCHEMA.md to the latest migration filename

**Example:**
- SCHEMA.md shows: `Last synced with migration: 20260112161335_remote_schema.sql`
- New migrations exist: `20260113120000_add_user_profiles.sql`, `20260113140000_add_quiz_scores.sql`
- Read both files, update SCHEMA.md with the changes, then set: `Last synced with migration: 20260113140000_add_quiz_scores.sql`

This ensures future Claude instances can quickly understand the current database structure without re-analyzing all migrations from scratch.
