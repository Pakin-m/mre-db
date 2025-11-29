-- functions/concepts.sql
-- Concept tagging and fragment concept listing.

CREATE SCHEMA IF NOT EXISTS mre;

CREATE OR REPLACE FUNCTION mre.fn_add_concept_to_fragment(
    p_fragment_id BIGINT,
    p_concept_id  BIGINT
)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
    VOLATILE
AS $$
DECLARE
    v_rows_inserted INTEGER;
BEGIN
    INSERT INTO fragment_concepts (fragment_id, concept_id)
    VALUES (p_fragment_id, p_concept_id)
    ON CONFLICT DO NOTHING;

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;

    RETURN v_rows_inserted > 0;
END;
$$;


CREATE OR REPLACE FUNCTION mre.fn_remove_concept_from_fragment(
    p_fragment_id BIGINT,
    p_concept_id  BIGINT
)
    RETURNS INTEGER
    LANGUAGE plpgsql
    VOLATILE
AS $$
DECLARE
    v_rows_deleted INTEGER;
BEGIN
    DELETE FROM fragment_concepts
    WHERE fragment_id = p_fragment_id
      AND concept_id  = p_concept_id;

    GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;

    RETURN v_rows_deleted;
END;
$$;


CREATE OR REPLACE FUNCTION mre.fn_list_fragment_concepts(
    p_fragment_id BIGINT
)
    RETURNS TABLE (
                      concept_id   BIGINT,
                      name         TEXT,
                      description  TEXT
                  )
    LANGUAGE plpgsql
    STABLE
AS $$
BEGIN
    RETURN QUERY
        SELECT
            c.id,
            c.name,
            c.description
        FROM fragment_concepts fc
                 JOIN fragments f ON f.id = fc.fragment_id
                 JOIN concepts  c ON c.id = fc.concept_id
        WHERE fc.fragment_id = p_fragment_id
        ORDER BY c.name;
END;
$$;
