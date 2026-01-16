-- Add options_order, ordered, and quiz_type columns to cms.questions

ALTER TABLE cms.questions
  ADD COLUMN options_order integer[] NOT NULL DEFAULT '{}',
  ADD COLUMN ordered boolean NOT NULL DEFAULT false,
  ADD COLUMN quiz_type text;
