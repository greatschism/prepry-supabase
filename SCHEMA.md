# Database Schema Reference

Quick reference for the Prepry database structure.

**Last synced with migration:** `20260113194816_add_exam_compositions_and_chapter_mappings.sql`

---

> **IMPORTANT:** When new migrations are created, update this file by analyzing migration files from the one AFTER the "Last synced with migration" timestamp through the latest migration. Then update the timestamp reference above.

## Schemas

- `cms` - Content management system tables (exam content, questions, videos)
- `public` - Public-facing user data

## Entity Relationship Overview

```
credentialing_bodies (1) ──→ (N) exams
exam_groupings (1) ──→ (N) exams
exams (1) ──→ (N) chapters, anatomy, question_banks, questions
exams (composite) ──→ exam_compositions ──→ exams (base)
exam_compositions + chapter_mappings (maps base chapters → composite chapters)
question_banks (1) ──→ (N) questions
anatomy (self-referencing hierarchy via parent_anatomy_id)
static_quizzes (1) ──→ (N) static_quiz_questions (M) ──→ (1) questions
videos (1) ──→ (N) static_quizzes
```

## Tables

### cms.credentialing_bodies
Organizations that issue certifications (e.g., ABIM, ABFM)
- `id` (uuid, PK)
- `acronym`, `name` (text)
- Standard fields: `archived`, `created_at`, `updated_at`

### cms.exam_groupings
Groupings for related exams
- `id` (uuid, PK)
- `name` (text)

### cms.exam_compositions
Links composite exams to their constituent base exams (e.g., RVS = SPI + RVT)
- `id` (uuid, PK)
- `composite_exam_id` → exams (the composite exam)
- `base_exam_id` → exams (a base exam that makes up part of the composite)
- `created_at` (timestamptz)
- UNIQUE constraint on (composite_exam_id, base_exam_id)

### cms.chapter_mappings
Maps base exam chapters to composite exam chapters for educator reference/filtering
- `id` (uuid, PK)
- `composite_exam_id` → exams
- `base_exam_id` → exams
- `base_chapter_id` → chapters
- `composite_chapter_id` → chapters
- `rationale` (text) - AI-analyzed reasoning for the chapter mapping
- `created_at` (timestamptz)
- UNIQUE constraint on (composite_exam_id, base_exam_id, base_chapter_id)

### cms.exams
Certification exams
- `id` (int, PK)
- `name`, `description`, `abbreviation` (text)
- `exam_grouping_id` → exam_groupings
- `credentialing_body_id` → credentialing_bodies

### cms.chapters
Exam content chapters with coverage percentages
- `id` (int, PK)
- `name` (text)
- `percentage` (int) - coverage weight
- `exam_id` → exams
- `credentialing_body_id` → credentialing_bodies
- `chapter_id`, `chapter_uuid` (legacy identifiers)

### cms.anatomy
Anatomical segments with hierarchical structure
- `id` (int, PK)
- `anatomical_segment` (text)
- `exam_id` → exams
- `anatomy_id` (int) - legacy identifier
- `parent_anatomy_id` → anatomy (self-reference for hierarchy)

### cms.question_banks
Collections of questions
- `id` (uuid, PK)
- `name`, `slug`, `description` (text)
- `exam_id` → exams

### cms.questions
Exam questions (multiple choice)
- `id` (uuid, PK)
- `question`, `answer` (text) - question text and correct answer
- `dis1`, `dis2`, `dis3`, `dis4` (text) - distractors (wrong answers)
- `explain`, `explain_html` (text) - answer explanations
- `media` (text) - media attachments
- `question_type` (text, default: 'singleChoice')
- `question_metadata` (jsonb) - flexible metadata
- `keywords` (text[]) - searchable keywords
- `difficulty`, `peer_score` (int) - difficulty metrics
- `is_free` (bool) - whether question is free/premium
- `question_references` (text) - source references
- `version` (int) - question version
- `answer_distribution` (jsonb) - stats on answer choices
- `exam_id` → exams
- `chapter_id` → chapters
- `anatomy_id` → anatomy
- `question_bank_id` → question_banks
- `uuid`, `questions_id` (legacy identifiers)

### cms.videos
Educational videos
- `id` (uuid, PK)
- `title`, `url` (text)
- `duration_seconds` (int)

### cms.static_quizzes
Pre-built quiz collections
- `id` (uuid, PK)
- `title`, `type` (text)
- `type` CHECK: must be 'VIDEO' or 'ONE_TIME'
- `video_id` → videos

### cms.static_quiz_questions
Junction table for static quizzes and questions
- `quiz_id` → static_quizzes (composite PK)
- `question_id` → questions (composite PK)
- `sort_order` (int) - question order in quiz

### public.notes
User notes
- `id` (uuid, PK)
- `title`, `body` (text)

## Indexes

Key performance indexes on `cms.questions`:
- `idx_questions_exam_id`, `idx_questions_chapter_id`, `idx_questions_anatomy_id`
- `idx_questions_question_bank_id`, `idx_questions_uuid`
- `idx_questions_archived`

Indexes on `cms.exam_compositions`:
- `idx_exam_compositions_composite`, `idx_exam_compositions_base`

Indexes on `cms.chapter_mappings`:
- `idx_chapter_mappings_composite`, `idx_chapter_mappings_base_exam`
- `idx_chapter_mappings_base_chapter`, `idx_chapter_mappings_composite_chapter`

## Functions

### cms.set_updated_at()
Trigger function that automatically updates `updated_at` timestamp.
Currently applied to: `cms.questions`

### public.is_supabase_or_firebase_project_jwt()
Authentication helper that validates Firebase JWT tokens.
Checks: `iss = 'https://securetoken.google.com/prepry-53b81'` and `aud = 'prepry-53b81'`

## Security Policies

### cms.* tables
All CMS tables use RLS with `allow_firebase_auth` policy:
- Requires authenticated users with valid Firebase JWT (via `is_supabase_or_firebase_project_jwt()`)
- Grants full CRUD access to authenticated Firebase users
- Anonymous users have SELECT-only access to most tables

### public.notes
- `notes_public_read` policy: allows public SELECT access

## Permissions

- **anon role**: SELECT on cms.* tables, full access on public.notes
- **authenticated role**: full CRUD on cms.* and public.notes
- **service_role**: full admin access on all tables

## Common Patterns

- All cms.* tables have `archived` flag for soft deletes (except exam_compositions, chapter_mappings, question_banks, static_quiz_questions, static_quizzes, videos)
- Most tables use `created_at` and `updated_at` timestamps
- UUIDs used for primary keys except: exams, chapters, anatomy, questions (use integers with UUIDs as alternate identifiers)
