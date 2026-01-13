-- Migration: Add exam compositions and chapter mappings tables
-- Purpose: Model composite exams (made of base exams) and chapter mappings for educator filtering

-- =============================================================================
-- Table: cms.exam_compositions
-- Links composite exams to their base exams (e.g., RVS = SPI + RVT)
-- =============================================================================
CREATE TABLE cms.exam_compositions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    composite_exam_id integer NOT NULL REFERENCES cms.exams(id) ON DELETE CASCADE,
    base_exam_id integer NOT NULL REFERENCES cms.exams(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),

    UNIQUE (composite_exam_id, base_exam_id)
);

COMMENT ON TABLE cms.exam_compositions IS 'Links composite exams to their constituent base exams';
COMMENT ON COLUMN cms.exam_compositions.composite_exam_id IS 'The composite exam (e.g., RVS, RCS)';
COMMENT ON COLUMN cms.exam_compositions.base_exam_id IS 'A base exam that makes up part of the composite';

-- Indexes
CREATE INDEX idx_exam_compositions_composite ON cms.exam_compositions(composite_exam_id);
CREATE INDEX idx_exam_compositions_base ON cms.exam_compositions(base_exam_id);

-- =============================================================================
-- Table: cms.chapter_mappings
-- Maps base exam chapters to composite exam chapters for educator reference
-- =============================================================================
CREATE TABLE cms.chapter_mappings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    composite_exam_id integer NOT NULL REFERENCES cms.exams(id) ON DELETE CASCADE,
    base_exam_id integer NOT NULL REFERENCES cms.exams(id) ON DELETE CASCADE,
    base_chapter_id integer NOT NULL REFERENCES cms.chapters(id) ON DELETE CASCADE,
    composite_chapter_id integer NOT NULL REFERENCES cms.chapters(id) ON DELETE CASCADE,
    rationale text,
    created_at timestamptz DEFAULT now(),

    UNIQUE (composite_exam_id, base_exam_id, base_chapter_id)
);

COMMENT ON TABLE cms.chapter_mappings IS 'Maps base exam chapters to composite exam chapters for educator filtering';
COMMENT ON COLUMN cms.chapter_mappings.rationale IS 'AI-analyzed reasoning for the chapter mapping';

-- Indexes
CREATE INDEX idx_chapter_mappings_composite ON cms.chapter_mappings(composite_exam_id);
CREATE INDEX idx_chapter_mappings_base_exam ON cms.chapter_mappings(base_exam_id);
CREATE INDEX idx_chapter_mappings_base_chapter ON cms.chapter_mappings(base_chapter_id);
CREATE INDEX idx_chapter_mappings_composite_chapter ON cms.chapter_mappings(composite_chapter_id);

-- =============================================================================
-- RLS Policies (matching other cms tables)
-- =============================================================================

-- exam_compositions
ALTER TABLE cms.exam_compositions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_firebase_auth" ON cms.exam_compositions
    FOR ALL
    USING (public.is_supabase_or_firebase_project_jwt());

CREATE POLICY "allow_anon_select" ON cms.exam_compositions
    FOR SELECT
    USING (true);

-- chapter_mappings
ALTER TABLE cms.chapter_mappings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_firebase_auth" ON cms.chapter_mappings
    FOR ALL
    USING (public.is_supabase_or_firebase_project_jwt());

CREATE POLICY "allow_anon_select" ON cms.chapter_mappings
    FOR SELECT
    USING (true);

-- =============================================================================
-- Permissions (matching other cms tables)
-- =============================================================================

GRANT SELECT ON cms.exam_compositions TO anon;
GRANT ALL ON cms.exam_compositions TO authenticated;
GRANT ALL ON cms.exam_compositions TO service_role;

GRANT SELECT ON cms.chapter_mappings TO anon;
GRANT ALL ON cms.chapter_mappings TO authenticated;
GRANT ALL ON cms.chapter_mappings TO service_role;

