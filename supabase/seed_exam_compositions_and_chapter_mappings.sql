-- Seed Data: Exam Compositions and Chapter Mappings
-- Run this AFTER the migration has been applied to dev/prod
-- This populates the tables based on the existing chapter_map.js mappings

-- =============================================================================
-- Seed Data: Exam Compositions
-- =============================================================================
INSERT INTO cms.exam_compositions (composite_exam_id, base_exam_id) VALUES
    -- Exam 8: RVS = SPI + RVT
    (8, 1),
    (8, 2),
    -- Exam 9: RCS = SPI + AE
    (9, 1),
    (9, 7),
    -- Exam 10: BS = SPI + BR
    (10, 1),
    (10, 6),
    -- Exam 11: SO = SPI + AB + OB/GYN
    (11, 1),
    (11, 3),
    (11, 4),
    -- Exam 12: VS = SPI + RVT
    (12, 1),
    (12, 2)
ON CONFLICT (composite_exam_id, base_exam_id) DO NOTHING;

-- =============================================================================
-- Seed Data: Chapter Mappings
-- Note: base_chapter_id and composite_chapter_id reference cms.chapters(id)
-- These mappings are based on AI-analyzed semantic content relationships
-- =============================================================================

-- Exam 8: RVS (Registered Vascular Specialist)
-- SPI (Exam 1) chapters → RVS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 8, 1, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 2, 'SPI ''Perform Ultrasound Examinations'' → RVS ''Applying Principles of Physics and Hemodynamics'''),
    (2, 2, 'SPI ''Manage Ultrasound Transducers'' → RVS ''Applying Principles of Physics and Hemodynamics'''),
    (3, 2, 'SPI ''Optimize Sonographic Images'' → RVS ''Applying Principles of Physics and Hemodynamics'''),
    (4, 2, 'SPI ''Apply Doppler Concepts'' → RVS ''Applying Principles of Physics and Hemodynamics'''),
    (5, 1, 'SPI ''Provide Clinical Safety and Quality Assurance'' → RVS ''Maintaining Patient Care and Safety''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 1 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 8 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- RVT (Exam 2) chapters → RVS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 8, 2, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 3, 'RVT ''Normal Anatomy, Perfusion, and Function'' → RVS ''Performing Abdominal/Visceral Examinations'''),
    (2, 3, 'RVT ''Pathology, Perfusion, and Function'' → RVS ''Performing Abdominal/Visceral Examinations'''),
    (3, 5, 'RVT ''Surgically Altered Anatomy and Pathology'' → RVS ''Performing Arterial Examinations'''),
    (4, 5, 'RVT ''Physiologic Exams'' → RVS ''Performing Arterial Examinations'''),
    (5, 3, 'RVT ''Ultrasound-guided Procedures/Intraoperative Assessment'' → RVS ''Performing Abdominal/Visceral Examinations'''),
    (6, 2, 'RVT ''Quality Assurance, Safety, and Physical Principles'' → RVS ''Applying Principles of Physics and Hemodynamics'''),
    (7, 1, 'RVT ''Preparation, Documentation, and Communication'' → RVS ''Maintaining Patient Care and Safety''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 2 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 8 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- Exam 9: RCS (Registered Cardiac Sonographer)
-- SPI (Exam 1) chapters → RCS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 9, 1, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 5, 'SPI ''Perform Ultrasound Examinations'' → RCS ''Applying the Physics of Ultrasound'''),
    (2, 5, 'SPI ''Manage Ultrasound Transducers'' → RCS ''Applying the Physics of Ultrasound'''),
    (3, 5, 'SPI ''Optimize Sonographic Images'' → RCS ''Applying the Physics of Ultrasound'''),
    (4, 5, 'SPI ''Apply Doppler Concepts'' → RCS ''Applying the Physics of Ultrasound'''),
    (5, 1, 'SPI ''Provide Clinical Safety and Quality Assurance'' → RCS ''Preparing for Echocardiographic Procedure''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 1 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 9 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- AE (Exam 7) chapters → RCS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 9, 7, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 4, 'AE ''Anatomy and Physiology'' → RCS ''Evaluating Anatomy, Physiology, and Hemodynamics'''),
    (2, 3, 'AE ''Pathology'' → RCS ''Evaluating Valvular Echocardiographic Findings'''),
    (3, 1, 'AE ''Clinical Care and Safety'' → RCS ''Preparing for Echocardiographic Procedure'''),
    (4, 2, 'AE ''Measurement Techniques, Maneuvers, and Sonographic Views'' → RCS ''Performing Echocardiographic Imaging'''),
    (5, 5, 'AE ''Instrumentation, Optimization, and Contrast'' → RCS ''Applying the Physics of Ultrasound''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 7 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 9 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- Exam 10: BS (Breast Sonography - ARRT)
-- SPI (Exam 1) chapters → BS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 10, 1, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 3, 'SPI ''Perform Ultrasound Examinations'' → BS ''Image Formation'''),
    (2, 2, 'SPI ''Manage Ultrasound Transducers'' → BS ''Basic Principles of Ultrasound'''),
    (3, 3, 'SPI ''Optimize Sonographic Images'' → BS ''Image Formation'''),
    (4, 2, 'SPI ''Apply Doppler Concepts'' → BS ''Basic Principles of Ultrasound'''),
    (5, 1, 'SPI ''Provide Clinical Safety and Quality Assurance'' → BS ''Patient Interactions and Management''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 1 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 10 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- BR (Exam 6) chapters → BS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 10, 6, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 5, 'BR ''Anatomy and Physiology'' → BS ''Anatomy and Physiology'''),
    (2, 6, 'BR ''Pathology'' → BS ''Pathology'''),
    (3, 4, 'BR ''Integration of Data'' → BS ''Evaluation and Selection of Representative Images'''),
    (4, 4, 'BR ''Protocols'' → BS ''Evaluation and Selection of Representative Images'''),
    (5, 2, 'BR ''Ultrasound Physics'' → BS ''Basic Principles of Ultrasound'''),
    (6, 7, 'BR ''Emerging Technology and Treatment'' → BS ''Breast Interventions''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 6 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 10 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- Exam 11: SO (Sonography - ARRT)
-- SPI (Exam 1) chapters → SO chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 11, 1, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 3, 'SPI ''Perform Ultrasound Examinations'' → SO ''Image Formation'''),
    (2, 2, 'SPI ''Manage Ultrasound Transducers'' → SO ''Basic Principles of Ultrasound'''),
    (3, 3, 'SPI ''Optimize Sonographic Images'' → SO ''Image Formation'''),
    (4, 2, 'SPI ''Apply Doppler Concepts'' → SO ''Basic Principles of Ultrasound'''),
    (5, 1, 'SPI ''Provide Clinical Safety and Quality Assurance'' → SO ''Patient Interactions and Management''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 1 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 11 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- AB (Exam 3) chapters → SO chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 11, 3, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 5, 'AB ''Anatomy, Perfusion, and Function'' → SO ''Abdomen'''),
    (2, 5, 'AB ''Pathology, Vascular Abnormalities, Trauma'' → SO ''Abdomen'''),
    (3, 2, 'AB ''Abdominal Physics'' → SO ''Basic Principles of Ultrasound'''),
    (4, 4, 'AB ''Clinical Care, Practice, and Quality Assurance'' → SO ''Evaluation and Selection of Representative Images''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 3 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 11 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- OB/GYN (Exam 4) chapters → SO chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 11, 4, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 8, 'OB ''Gynecology - Pelvic Anatomy and Physiology'' → SO ''Gynecology'''),
    (2, 6, 'OB ''Obstetrics - First Trimester'' → SO ''First Trimester Obstetrics'''),
    (3, 7, 'OB ''Obstetrics Second/Third Trimester'' → SO ''Second/Third Trimester and High-Risk Obstetrics'''),
    (4, 4, 'OB ''Protocols and Procedures'' → SO ''Evaluation and Selection of Representative Images'''),
    (5, 2, 'OB ''Physics and Instrumentation'' → SO ''Basic Principles of Ultrasound''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 4 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 11 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- Exam 12: VS (Vascular Sonography - ARRT)
-- SPI (Exam 1) chapters → VS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 12, 1, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 3, 'SPI ''Perform Ultrasound Examinations'' → VS ''Image Formation'''),
    (2, 2, 'SPI ''Manage Ultrasound Transducers'' → VS ''Basic Principles of Ultrasound'''),
    (3, 3, 'SPI ''Optimize Sonographic Images'' → VS ''Image Formation'''),
    (4, 2, 'SPI ''Apply Doppler Concepts'' → VS ''Basic Principles of Ultrasound'''),
    (5, 1, 'SPI ''Provide Clinical Safety and Quality Assurance'' → VS ''Patient Interactions and Management''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 1 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 12 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;

-- RVT (Exam 2) chapters → VS chapters
INSERT INTO cms.chapter_mappings (composite_exam_id, base_exam_id, base_chapter_id, composite_chapter_id, rationale)
SELECT 12, 2, bc.id, cc.id, m.rationale
FROM (VALUES
    (1, 5, 'RVT ''Normal Anatomy, Perfusion, and Function'' → VS ''Abdominal/Pelvic Vasculature'''),
    (2, 5, 'RVT ''Pathology, Perfusion, and Function'' → VS ''Abdominal/Pelvic Vasculature'''),
    (3, 6, 'RVT ''Surgically Altered Anatomy and Pathology'' → VS ''Arterial Peripheral Vasculature'''),
    (4, 6, 'RVT ''Physiologic Exams'' → VS ''Arterial Peripheral Vasculature'''),
    (5, 5, 'RVT ''Ultrasound-guided Procedures/Intraoperative Assessment'' → VS ''Abdominal/Pelvic Vasculature'''),
    (6, 2, 'RVT ''Quality Assurance, Safety, and Physical Principles'' → VS ''Basic Principles of Ultrasound'''),
    (7, 1, 'RVT ''Preparation, Documentation, and Communication'' → VS ''Patient Interactions and Management''')
) AS m(base_ch_num, composite_ch_num, rationale)
JOIN cms.chapters bc ON bc.exam_id = 2 AND bc.chapter_id = m.base_ch_num
JOIN cms.chapters cc ON cc.exam_id = 12 AND cc.chapter_id = m.composite_ch_num
ON CONFLICT (composite_exam_id, base_exam_id, base_chapter_id) DO NOTHING;
