-- extensions
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;

-- patent grants
CREATE TABLE uspto_applications(
        publication_number VARCHAR,
        publication_title VARCHAR,
        publication_date DATE,
        publication_type VARCHAR,
        applicants VARCHAR[],
        inventors VARCHAR[],
        sections VARCHAR[],
        section_classes VARCHAR[],
        section_class_subclasses VARCHAR[],
        section_class_subclass_groups VARCHAR[],
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

CREATE INDEX idx_uspto_applications_publication_date ON uspto_applications (publication_date);
CREATE INDEX idx_uspto_applications_publication_title ON uspto_applications ((lower(publication_title)));

CREATE INDEX idx_uspto_applications_sections ON uspto_applications USING GIN (sections);
CREATE INDEX idx_uspto_applications_section_classes ON uspto_applications USING GIN (section_classes);
CREATE INDEX idx_uspto_applications_section_class_subclasses ON uspto_applications USING GIN (section_class_subclasses);
CREATE INDEX idx_uspto_applications_section_class_subclass_groups ON uspto_applications USING GIN (section_class_subclass_groups);

CREATE INDEX idx_uspto_applications_ts_abstract ON uspto_applications USING gin(ts_abstract);
CREATE INDEX idx_uspto_applications_ts_description ON uspto_applications USING gin(ts_description);
CREATE INDEX idx_uspto_applications_ts_claims ON uspto_applications USING gin(ts_claims);

-- patent grants
CREATE TABLE uspto_grants(
        publication_number VARCHAR,
        publication_title VARCHAR,
        publication_date DATE,
        publication_type VARCHAR,
        applicants VARCHAR[],
        inventors VARCHAR[],
        sections VARCHAR[],
        section_classes VARCHAR[],
        section_class_subclasses VARCHAR[],
        section_class_subclass_groups VARCHAR[],
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


CREATE INDEX idx_uspto_grants_publication_date ON uspto_grants (publication_date);
CREATE INDEX idx_uspto_grants_publication_title ON uspto_grants ((lower(publication_title)));

CREATE INDEX idx_uspto_grants_sections ON uspto_grants USING GIN (sections);
CREATE INDEX idx_uspto_grants_section_classes ON uspto_grants USING GIN (section_classes);
CREATE INDEX idx_uspto_grants_section_class_subclasses ON uspto_grants USING GIN (section_class_subclasses);
CREATE INDEX idx_uspto_grants_section_class_subclass_groups ON uspto_grants USING GIN (section_class_subclass_groups);

CREATE INDEX idx_uspto_grants_ts_abstract ON uspto_grants USING gin(ts_abstract);
CREATE INDEX idx_uspto_grants_ts_description ON uspto_grants USING gin(ts_description);
CREATE INDEX idx_uspto_grants_ts_claims ON uspto_grants USING gin(ts_claims);
