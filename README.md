# Initial Setup

You can refer to (this link)[https://supabase.com/docs/guides/deployment/managing-environments] to help setting up this project locally, but since there are many steps there that must be done only once, here's the setup you need to run this ongoing project locally:

- Make sure Docker is installed and running
- Run these two commands:

```bash
supabase login
supabase start
```

# Projects

Currently, we have two projects: `dev` and `prod`. The `dev` is called `Prepry-Dev` and its id is `cabwwckcdahyaoextulv`, while the `prod` one is called `Prepry - Production` and its id is `acivbmjpnzprvmwlpozk`.
In order to check which project is selected, run:

```bash
supabase projects list
```

To switch between projects, you can run `supabase link`, like this:

```bash
supabase link --project-ref cabwwckcdahyaoextulv #switches to dev
supabase link --project-ref acivbmjpnzprvmwlpozk #switches to prod
```

# DB Commands

Most of the work in this github repo is based on handling database migrations from one project to another.

## Creating Migrations

For creating a new migration, **first make sure if you're using the `dev` project** and run:

```bash
supabase migration new <migration name>
```

Then edit the SQL file that was created in `supabase/migrations/`.
Make sure the local db is running. If not, simply run:

```bash
supabase start
```

You can then test it locally by running:

```bash
supabase db reset
```

## Publishing Changes

Once the migration is working as intended, publish it to `dev` by running:

```bash
supabase link --project-ref cabwwckcdahyaoextulv
supabase db push
```

And to `prod` when it's the correct time:

```bash
supabase link --project-ref acivbmjpnzprvmwlpozk
supabase db push
```
