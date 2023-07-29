CREATE TABLE uspto_patents(
        publication_number VARCHAR,
        publication_title VARCHAR,
        publication_date DATE,
        publication_type VARCHAR,
        authors VARCHAR,
        sections VARCHAR,
        section_classes VARCHAR,
        section_class_subclasses VARCHAR,
        section_class_subclass_groups VARCHAR,
        abstract TEXT,
        description TEXT,
        claims TEXT,
        created_at TIMESTAMP without time zone,
        updated_at TIMESTAMP without time zone,
        abstract_words_count INT GENERATED ALWAYS AS (array_length(regexp_split_to_array(abstract, E'\\s+'), 1)) STORED,
        description_words_count INT GENERATED ALWAYS AS (array_length(regexp_split_to_array(description, E'\\s+'), 1)) STORED,
        claims_words_count INT GENERATED ALWAYS AS (array_length(regexp_split_to_array(claims, E'\\s+'), 1)) STORED,
        ts_abstract tsvector GENERATED ALWAYS AS (to_tsvector('english', left(coalesce(abstract, ''), 1024*1024))) STORED,
        ts_description tsvector GENERATED ALWAYS AS (to_tsvector('english', left(coalesce(description, ''), 1024*1024))) STORED,
        ts_claims tsvector GENERATED ALWAYS AS (to_tsvector('english', left(coalesce(claims, ''), 1024*1024))) STORED,
        PRIMARY KEY(publication_number)
);

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;

CREATE INDEX idx_uspto_publication_date ON uspto_patents (publication_date);
CREATE INDEX idx_uspto_publication_title ON uspto_patents ((lower(publication_title)));

CREATE INDEX idx_uspto_sections ON uspto_patents USING GIN (sections);
CREATE INDEX idx_uspto_section_classes ON uspto_patents USING GIN (section_classes);
CREATE INDEX idx_uspto_section_class_subclasses ON uspto_patents USING GIN (section_class_subclasses);
CREATE INDEX idx_uspto_section_class_subclass_groups ON uspto_patents USING GIN (section_class_subclass_groups);

CREATE INDEX idx_uspto_ts_abstract ON uspto_patents USING gin(ts_abstract);
CREATE INDEX idx_uspto_ts_description ON uspto_patents USING gin(ts_description);
CREATE INDEX idx_uspto_ts_claims ON uspto_patents USING gin(ts_claims);
