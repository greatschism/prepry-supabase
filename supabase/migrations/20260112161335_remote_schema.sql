create schema if not exists "cms";


  create table "cms"."anatomy" (
    "id" integer generated always as identity not null,
    "anatomical_segment" text not null,
    "exam_id" integer,
    "anatomy_id" integer,
    "parent_anatomy_id" integer,
    "archived" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "cms"."anatomy" enable row level security;


  create table "cms"."chapters" (
    "id" integer not null,
    "name" text not null,
    "percentage" integer,
    "exam_id" integer,
    "credentialing_body_id" uuid,
    "archived" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "chapter_id" integer,
    "chapter_uuid" text
      );


alter table "cms"."chapters" enable row level security;


  create table "cms"."credentialing_bodies" (
    "id" uuid not null default gen_random_uuid(),
    "acronym" text not null,
    "name" text not null,
    "archived" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "cms"."credentialing_bodies" enable row level security;


  create table "cms"."exam_groupings" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "archived" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "cms"."exam_groupings" enable row level security;


  create table "cms"."exams" (
    "id" integer not null,
    "name" text not null,
    "description" text,
    "exam_grouping_id" uuid,
    "credentialing_body_id" uuid,
    "archived" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "abbreviation" text
      );


alter table "cms"."exams" enable row level security;


  create table "cms"."question_banks" (
    "id" uuid not null default gen_random_uuid(),
    "exam_id" integer,
    "name" text not null,
    "slug" text not null,
    "description" text
      );


alter table "cms"."question_banks" enable row level security;


  create table "cms"."questions" (
    "id" uuid not null default gen_random_uuid(),
    "exam_id" integer,
    "chapter_id" integer,
    "anatomy_id" integer,
    "question_bank_id" uuid,
    "question" text not null,
    "answer" text not null,
    "dis1" text,
    "dis2" text,
    "dis3" text,
    "dis4" text,
    "explain" text,
    "explain_html" text,
    "explain_html_id" text,
    "media" text,
    "uuid" text not null,
    "questions_id" integer,
    "question_type" text default 'singleChoice'::text,
    "question_metadata" jsonb,
    "keywords" text[],
    "difficulty" integer,
    "peer_score" integer,
    "is_free" boolean default false,
    "question_references" text,
    "version" integer default 1,
    "answer_distribution" jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "archived" boolean not null default false
      );


alter table "cms"."questions" enable row level security;


  create table "cms"."static_quiz_questions" (
    "quiz_id" uuid not null,
    "question_id" uuid not null,
    "sort_order" integer not null default 0
      );


alter table "cms"."static_quiz_questions" enable row level security;


  create table "cms"."static_quizzes" (
    "id" uuid not null default gen_random_uuid(),
    "title" text not null,
    "type" text not null,
    "video_id" uuid,
    "created_at" timestamp with time zone default now()
      );


alter table "cms"."static_quizzes" enable row level security;


  create table "cms"."videos" (
    "id" uuid not null default gen_random_uuid(),
    "title" text not null,
    "url" text not null,
    "duration_seconds" integer,
    "created_at" timestamp with time zone default now()
      );


alter table "cms"."videos" enable row level security;


  create table "public"."notes" (
    "id" uuid not null default gen_random_uuid(),
    "title" text not null,
    "body" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."notes" enable row level security;

CREATE UNIQUE INDEX anatomy_pkey ON cms.anatomy USING btree (id);

CREATE UNIQUE INDEX chapters_pkey ON cms.chapters USING btree (id);

CREATE UNIQUE INDEX credentialing_bodies_pkey ON cms.credentialing_bodies USING btree (id);

CREATE UNIQUE INDEX exam_groupings_pkey ON cms.exam_groupings USING btree (id);

CREATE UNIQUE INDEX exams_pkey ON cms.exams USING btree (id);

CREATE INDEX idx_questions_anatomy_id ON cms.questions USING btree (anatomy_id);

CREATE INDEX idx_questions_archived ON cms.questions USING btree (archived);

CREATE INDEX idx_questions_chapter_id ON cms.questions USING btree (chapter_id);

CREATE INDEX idx_questions_exam_id ON cms.questions USING btree (exam_id);

CREATE INDEX idx_questions_question_bank_id ON cms.questions USING btree (question_bank_id);

CREATE INDEX idx_questions_uuid ON cms.questions USING btree (uuid);

CREATE UNIQUE INDEX question_banks_pkey ON cms.question_banks USING btree (id);

CREATE UNIQUE INDEX questions_pkey ON cms.questions USING btree (id);

CREATE UNIQUE INDEX static_quiz_questions_pkey ON cms.static_quiz_questions USING btree (quiz_id, question_id);

CREATE UNIQUE INDEX static_quizzes_pkey ON cms.static_quizzes USING btree (id);

CREATE UNIQUE INDEX videos_pkey ON cms.videos USING btree (id);

CREATE UNIQUE INDEX notes_pkey ON public.notes USING btree (id);

alter table "cms"."anatomy" add constraint "anatomy_pkey" PRIMARY KEY using index "anatomy_pkey";

alter table "cms"."chapters" add constraint "chapters_pkey" PRIMARY KEY using index "chapters_pkey";

alter table "cms"."credentialing_bodies" add constraint "credentialing_bodies_pkey" PRIMARY KEY using index "credentialing_bodies_pkey";

alter table "cms"."exam_groupings" add constraint "exam_groupings_pkey" PRIMARY KEY using index "exam_groupings_pkey";

alter table "cms"."exams" add constraint "exams_pkey" PRIMARY KEY using index "exams_pkey";

alter table "cms"."question_banks" add constraint "question_banks_pkey" PRIMARY KEY using index "question_banks_pkey";

alter table "cms"."questions" add constraint "questions_pkey" PRIMARY KEY using index "questions_pkey";

alter table "cms"."static_quiz_questions" add constraint "static_quiz_questions_pkey" PRIMARY KEY using index "static_quiz_questions_pkey";

alter table "cms"."static_quizzes" add constraint "static_quizzes_pkey" PRIMARY KEY using index "static_quizzes_pkey";

alter table "cms"."videos" add constraint "videos_pkey" PRIMARY KEY using index "videos_pkey";

alter table "public"."notes" add constraint "notes_pkey" PRIMARY KEY using index "notes_pkey";

alter table "cms"."anatomy" add constraint "anatomy_exam_id_fkey" FOREIGN KEY (exam_id) REFERENCES cms.exams(id) not valid;

alter table "cms"."anatomy" validate constraint "anatomy_exam_id_fkey";

alter table "cms"."anatomy" add constraint "anatomy_parent_anatomy_id_fkey" FOREIGN KEY (parent_anatomy_id) REFERENCES cms.anatomy(id) not valid;

alter table "cms"."anatomy" validate constraint "anatomy_parent_anatomy_id_fkey";

alter table "cms"."chapters" add constraint "chapters_credentialing_body_id_fkey" FOREIGN KEY (credentialing_body_id) REFERENCES cms.credentialing_bodies(id) not valid;

alter table "cms"."chapters" validate constraint "chapters_credentialing_body_id_fkey";

alter table "cms"."chapters" add constraint "chapters_exam_id_fkey" FOREIGN KEY (exam_id) REFERENCES cms.exams(id) not valid;

alter table "cms"."chapters" validate constraint "chapters_exam_id_fkey";

alter table "cms"."exams" add constraint "exams_credentialing_body_id_fkey" FOREIGN KEY (credentialing_body_id) REFERENCES cms.credentialing_bodies(id) not valid;

alter table "cms"."exams" validate constraint "exams_credentialing_body_id_fkey";

alter table "cms"."exams" add constraint "exams_exam_grouping_id_fkey" FOREIGN KEY (exam_grouping_id) REFERENCES cms.exam_groupings(id) not valid;

alter table "cms"."exams" validate constraint "exams_exam_grouping_id_fkey";

alter table "cms"."question_banks" add constraint "question_banks_exam_id_fkey" FOREIGN KEY (exam_id) REFERENCES cms.exams(id) not valid;

alter table "cms"."question_banks" validate constraint "question_banks_exam_id_fkey";

alter table "cms"."questions" add constraint "questions_exam_id_fkey" FOREIGN KEY (exam_id) REFERENCES cms.exams(id) not valid;

alter table "cms"."questions" validate constraint "questions_exam_id_fkey";

alter table "cms"."questions" add constraint "questions_question_bank_id_fkey" FOREIGN KEY (question_bank_id) REFERENCES cms.question_banks(id) not valid;

alter table "cms"."questions" validate constraint "questions_question_bank_id_fkey";

alter table "cms"."static_quiz_questions" add constraint "static_quiz_questions_quiz_id_fkey" FOREIGN KEY (quiz_id) REFERENCES cms.static_quizzes(id) not valid;

alter table "cms"."static_quiz_questions" validate constraint "static_quiz_questions_quiz_id_fkey";

alter table "cms"."static_quizzes" add constraint "static_quizzes_type_check" CHECK ((type = ANY (ARRAY['VIDEO'::text, 'ONE_TIME'::text]))) not valid;

alter table "cms"."static_quizzes" validate constraint "static_quizzes_type_check";

alter table "cms"."static_quizzes" add constraint "static_quizzes_video_id_fkey" FOREIGN KEY (video_id) REFERENCES cms.videos(id) not valid;

alter table "cms"."static_quizzes" validate constraint "static_quizzes_video_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION cms.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  new.updated_at := now();
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.is_supabase_or_firebase_project_jwt()
 RETURNS boolean
 LANGUAGE sql
 STABLE STRICT
AS $function$
  SELECT (
    (auth.jwt() ->> 'iss') = 'https://securetoken.google.com/prepry-53b81'
    AND
    (auth.jwt() ->> 'aud') = 'prepry-53b81'
  );
$function$
;

grant select on table "cms"."anatomy" to "anon";

grant delete on table "cms"."anatomy" to "authenticated";

grant insert on table "cms"."anatomy" to "authenticated";

grant select on table "cms"."anatomy" to "authenticated";

grant update on table "cms"."anatomy" to "authenticated";

grant delete on table "cms"."anatomy" to "service_role";

grant insert on table "cms"."anatomy" to "service_role";

grant references on table "cms"."anatomy" to "service_role";

grant select on table "cms"."anatomy" to "service_role";

grant trigger on table "cms"."anatomy" to "service_role";

grant truncate on table "cms"."anatomy" to "service_role";

grant update on table "cms"."anatomy" to "service_role";

grant select on table "cms"."chapters" to "anon";

grant delete on table "cms"."chapters" to "authenticated";

grant insert on table "cms"."chapters" to "authenticated";

grant select on table "cms"."chapters" to "authenticated";

grant update on table "cms"."chapters" to "authenticated";

grant delete on table "cms"."chapters" to "service_role";

grant insert on table "cms"."chapters" to "service_role";

grant references on table "cms"."chapters" to "service_role";

grant select on table "cms"."chapters" to "service_role";

grant trigger on table "cms"."chapters" to "service_role";

grant truncate on table "cms"."chapters" to "service_role";

grant update on table "cms"."chapters" to "service_role";

grant select on table "cms"."credentialing_bodies" to "anon";

grant delete on table "cms"."credentialing_bodies" to "authenticated";

grant insert on table "cms"."credentialing_bodies" to "authenticated";

grant select on table "cms"."credentialing_bodies" to "authenticated";

grant update on table "cms"."credentialing_bodies" to "authenticated";

grant delete on table "cms"."credentialing_bodies" to "service_role";

grant insert on table "cms"."credentialing_bodies" to "service_role";

grant references on table "cms"."credentialing_bodies" to "service_role";

grant select on table "cms"."credentialing_bodies" to "service_role";

grant trigger on table "cms"."credentialing_bodies" to "service_role";

grant truncate on table "cms"."credentialing_bodies" to "service_role";

grant update on table "cms"."credentialing_bodies" to "service_role";

grant select on table "cms"."exam_groupings" to "anon";

grant delete on table "cms"."exam_groupings" to "authenticated";

grant insert on table "cms"."exam_groupings" to "authenticated";

grant select on table "cms"."exam_groupings" to "authenticated";

grant update on table "cms"."exam_groupings" to "authenticated";

grant delete on table "cms"."exam_groupings" to "service_role";

grant insert on table "cms"."exam_groupings" to "service_role";

grant references on table "cms"."exam_groupings" to "service_role";

grant select on table "cms"."exam_groupings" to "service_role";

grant trigger on table "cms"."exam_groupings" to "service_role";

grant truncate on table "cms"."exam_groupings" to "service_role";

grant update on table "cms"."exam_groupings" to "service_role";

grant select on table "cms"."exams" to "anon";

grant delete on table "cms"."exams" to "authenticated";

grant insert on table "cms"."exams" to "authenticated";

grant select on table "cms"."exams" to "authenticated";

grant update on table "cms"."exams" to "authenticated";

grant delete on table "cms"."exams" to "service_role";

grant insert on table "cms"."exams" to "service_role";

grant references on table "cms"."exams" to "service_role";

grant select on table "cms"."exams" to "service_role";

grant trigger on table "cms"."exams" to "service_role";

grant truncate on table "cms"."exams" to "service_role";

grant update on table "cms"."exams" to "service_role";

grant select on table "cms"."question_banks" to "anon";

grant delete on table "cms"."question_banks" to "authenticated";

grant insert on table "cms"."question_banks" to "authenticated";

grant select on table "cms"."question_banks" to "authenticated";

grant update on table "cms"."question_banks" to "authenticated";

grant delete on table "cms"."question_banks" to "service_role";

grant insert on table "cms"."question_banks" to "service_role";

grant references on table "cms"."question_banks" to "service_role";

grant select on table "cms"."question_banks" to "service_role";

grant trigger on table "cms"."question_banks" to "service_role";

grant truncate on table "cms"."question_banks" to "service_role";

grant update on table "cms"."question_banks" to "service_role";

grant select on table "cms"."questions" to "anon";

grant delete on table "cms"."questions" to "authenticated";

grant insert on table "cms"."questions" to "authenticated";

grant select on table "cms"."questions" to "authenticated";

grant update on table "cms"."questions" to "authenticated";

grant delete on table "cms"."questions" to "service_role";

grant insert on table "cms"."questions" to "service_role";

grant references on table "cms"."questions" to "service_role";

grant select on table "cms"."questions" to "service_role";

grant trigger on table "cms"."questions" to "service_role";

grant truncate on table "cms"."questions" to "service_role";

grant update on table "cms"."questions" to "service_role";

grant select on table "cms"."static_quiz_questions" to "anon";

grant delete on table "cms"."static_quiz_questions" to "authenticated";

grant insert on table "cms"."static_quiz_questions" to "authenticated";

grant select on table "cms"."static_quiz_questions" to "authenticated";

grant update on table "cms"."static_quiz_questions" to "authenticated";

grant delete on table "cms"."static_quiz_questions" to "service_role";

grant insert on table "cms"."static_quiz_questions" to "service_role";

grant references on table "cms"."static_quiz_questions" to "service_role";

grant select on table "cms"."static_quiz_questions" to "service_role";

grant trigger on table "cms"."static_quiz_questions" to "service_role";

grant truncate on table "cms"."static_quiz_questions" to "service_role";

grant update on table "cms"."static_quiz_questions" to "service_role";

grant select on table "cms"."static_quizzes" to "anon";

grant delete on table "cms"."static_quizzes" to "authenticated";

grant insert on table "cms"."static_quizzes" to "authenticated";

grant select on table "cms"."static_quizzes" to "authenticated";

grant update on table "cms"."static_quizzes" to "authenticated";

grant delete on table "cms"."static_quizzes" to "service_role";

grant insert on table "cms"."static_quizzes" to "service_role";

grant references on table "cms"."static_quizzes" to "service_role";

grant select on table "cms"."static_quizzes" to "service_role";

grant trigger on table "cms"."static_quizzes" to "service_role";

grant truncate on table "cms"."static_quizzes" to "service_role";

grant update on table "cms"."static_quizzes" to "service_role";

grant select on table "cms"."videos" to "anon";

grant delete on table "cms"."videos" to "authenticated";

grant insert on table "cms"."videos" to "authenticated";

grant select on table "cms"."videos" to "authenticated";

grant update on table "cms"."videos" to "authenticated";

grant delete on table "cms"."videos" to "service_role";

grant insert on table "cms"."videos" to "service_role";

grant references on table "cms"."videos" to "service_role";

grant select on table "cms"."videos" to "service_role";

grant trigger on table "cms"."videos" to "service_role";

grant truncate on table "cms"."videos" to "service_role";

grant update on table "cms"."videos" to "service_role";

grant delete on table "public"."notes" to "anon";

grant insert on table "public"."notes" to "anon";

grant references on table "public"."notes" to "anon";

grant select on table "public"."notes" to "anon";

grant trigger on table "public"."notes" to "anon";

grant truncate on table "public"."notes" to "anon";

grant update on table "public"."notes" to "anon";

grant delete on table "public"."notes" to "authenticated";

grant insert on table "public"."notes" to "authenticated";

grant references on table "public"."notes" to "authenticated";

grant select on table "public"."notes" to "authenticated";

grant trigger on table "public"."notes" to "authenticated";

grant truncate on table "public"."notes" to "authenticated";

grant update on table "public"."notes" to "authenticated";

grant delete on table "public"."notes" to "service_role";

grant insert on table "public"."notes" to "service_role";

grant references on table "public"."notes" to "service_role";

grant select on table "public"."notes" to "service_role";

grant trigger on table "public"."notes" to "service_role";

grant truncate on table "public"."notes" to "service_role";

grant update on table "public"."notes" to "service_role";


  create policy "allow_firebase_auth"
  on "cms"."anatomy"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."chapters"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."credentialing_bodies"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."exam_groupings"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."exams"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."question_banks"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."questions"
  as permissive
  for all
  to public
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."static_quiz_questions"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."static_quizzes"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "allow_firebase_auth"
  on "cms"."videos"
  as permissive
  for all
  to authenticated
using (public.is_supabase_or_firebase_project_jwt());



  create policy "notes_public_read"
  on "public"."notes"
  as permissive
  for select
  to public
using (true);


CREATE TRIGGER trg_questions_set_updated_at BEFORE UPDATE ON cms.questions FOR EACH ROW EXECUTE FUNCTION cms.set_updated_at();


