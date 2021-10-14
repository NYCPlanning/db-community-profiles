
DROP TABLE IF EXISTS cd_titles;
CREATE TABLE cd_titles (
    borocd text,
    cd_full_title text,
    cd_short_title text
); 
\COPY cd_titles FROM 'data/cd_titles.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS cb_contact;
CREATE TABLE cb_contact (
    borocd text,
    cb_email text,
    cb_website text
); 
\COPY cb_contact FROM 'data/cb_contact.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS cd_bctcb2010;
CREATE TABLE cd_bctcb2010 (
    bctcb2010 text,
    cd text,
    geom geometry(Geometry, 4326)
); 
\COPY cd_bctcb2010 FROM 'data/cd_to_block.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS cd_son;
CREATE TABLE cd_son (
    borocd text,
    neighborhoods text,
    son_issue_1 text,
    son_issue_2 text,
    son_issue_3 text
); 
\COPY cd_son FROM 'data/cd_son.csv' DELIMITER ',' CSV HEADER;


DROP TABLE IF EXISTS cd_tooltips;
CREATE TABLE cd_tooltips (
    acs_tooltip text,
    acs_tooltip_2 text,
    acs_tooltip_3 text,
    borocd text
); 
\COPY cd_tooltips FROM 'data/cd_tooltips.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS cd_decennial_pop;
CREATE TABLE cd_decennial_pop (
    borocd text,
    pop_2000 text,
    pop_2010 text,
    pop_change_00_10 text
); 
\COPY cd_decennial_pop FROM 'data/cd_decennial_pop.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS cd_puma;
CREATE TABLE cd_puma (
    borocd text,
    puma text,
    shared_puma boolean,
    shared_puma_cd text
); 
\COPY cd_puma FROM 'data/cd_puma.csv' DELIMITER ',' CSV HEADER;