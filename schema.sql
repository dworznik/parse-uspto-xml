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
       PRIMARY KEY(publication_number)
);

CREATE EXTENSION pg_trgm;
CREATE EXTENSION btree_gin;

CREATE INDEX idx_publication_date ON uspto_patents (publication_date);
CREATE INDEX idx_publication_title ON uspto_patents ((lower(publication_title)));

CREATE INDEX idx_sections ON uspto_patents USING GIN (sections);
CREATE INDEX idx_section_classes ON uspto_patents USING GIN (section_classes);
CREATE INDEX idx_section_class_subclasses ON uspto_patents USING GIN (section_class_subclasses);
CREATE INDEX idx_section_class_subclass_groups ON uspto_patents USING GIN (section_class_subclass_groups);