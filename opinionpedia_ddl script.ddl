-- Generated by Oracle SQL Developer Data Modeler 19.2.0.182.1216
--   at:        2020-01-04 10:15:21 PST
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c



CREATE TABLE "Option" (
    id              INTEGER NOT NULL,
    prompt          VARCHAR2(1000 CHAR),
    created         DATE,
    updated         DATE,
    question_id     INTEGER NOT NULL,
    user_username   VARCHAR2(300 CHAR) NOT NULL
);

ALTER TABLE "Option"
    ADD CONSTRAINT option_pk PRIMARY KEY ( id,
                                           question_id,
                                           user_username );

CREATE TABLE question (
    id              INTEGER NOT NULL,
    prompt          VARCHAR2(3000 CHAR) NOT NULL,
    description     VARCHAR2(10000 CHAR),
    created         DATE NOT NULL,
    updated         DATE NOT NULL,
    user_username   VARCHAR2(300 CHAR) NOT NULL
);

ALTER TABLE question ADD CONSTRAINT question_pk PRIMARY KEY ( id );

CREATE TABLE status (
    tag_user_username           VARCHAR2(300 CHAR) NOT NULL,
    tag_question_id             INTEGER NOT NULL,
    tag_option_id               INTEGER NOT NULL,
    tag_option_id2              INTEGER NOT NULL,
    tag_option_user_username    VARCHAR2(300 CHAR) NOT NULL,
    tag_id4                     INTEGER NOT NULL,
    tag_id13                    INTEGER NOT NULL,
    tag_id5                     INTEGER NOT NULL,
    tag_username2               VARCHAR2(300 CHAR) NOT NULL,
    tag_username1               VARCHAR2(300 CHAR) NOT NULL,
    tag_id6                     INTEGER NOT NULL,
    tag_name                    VARCHAR2(1000 CHAR) NOT NULL,
    user_username               VARCHAR2(300 CHAR) NOT NULL,
    title                       VARCHAR2(300 CHAR) NOT NULL,
    question_id                 INTEGER NOT NULL,
    option_id                   INTEGER NOT NULL,
    option_id2                  INTEGER NOT NULL,
    option_user_username        VARCHAR2(300 CHAR) NOT NULL,
    vote_id                     INTEGER NOT NULL,
    vote_option_id              INTEGER NOT NULL,
    vote_option_id2             INTEGER NOT NULL,
    vote_option_user_username   VARCHAR2(300 CHAR) NOT NULL,
    vote_user_username          VARCHAR2(300 CHAR) NOT NULL,
    vote_question_id            INTEGER NOT NULL,
    description                 VARCHAR2(2000 CHAR),
    created                     DATE,
    updated                     DATE
);

ALTER TABLE status
    ADD CONSTRAINT status_pk PRIMARY KEY ( tag_user_username,
                                           tag_question_id,
                                           tag_option_id,
                                           tag_option_id2,
                                           tag_option_user_username,
                                           tag_id4,
                                           tag_id13,
                                           tag_id5,
                                           tag_username2,
                                           tag_username1,
                                           tag_id6,
                                           tag_name,
                                           user_username,
                                           title,
                                           question_id,
                                           option_id,
                                           option_id2,
                                           option_user_username,
                                           vote_id,
                                           vote_option_id,
                                           vote_option_id2,
                                           vote_option_user_username,
                                           vote_user_username,
                                           vote_question_id );

CREATE TABLE tag (
    name                        VARCHAR2(1000 CHAR) NOT NULL,
    description                 VARCHAR2(10000 CHAR),
    created                     DATE NOT NULL,
    updated                     DATE NOT NULL,
    username                    VARCHAR2(300 CHAR) NOT NULL,
    id1                         INTEGER NOT NULL,
    user_username               VARCHAR2(300 CHAR) NOT NULL,
    question_id                 INTEGER NOT NULL,
    option_id                   INTEGER NOT NULL,
    option_id2                  INTEGER NOT NULL,
    option_user_username        VARCHAR2(300 CHAR) NOT NULL,
    vote_id                     INTEGER NOT NULL,
    vote_option_id              INTEGER NOT NULL,
    vote_option_id2             INTEGER NOT NULL,
    vote_option_user_username   VARCHAR2(300 CHAR) NOT NULL,
    vote_user_username          VARCHAR2(300 CHAR) NOT NULL,
    vote_question_id            INTEGER NOT NULL
);

ALTER TABLE tag
    ADD CONSTRAINT tag_pk PRIMARY KEY ( user_username,
                                        question_id,
                                        option_id,
                                        option_id2,
                                        option_user_username,
                                        vote_id,
                                        vote_option_id,
                                        vote_option_id2,
                                        vote_option_user_username,
                                        vote_user_username,
                                        vote_question_id,
                                        name );

CREATE TABLE "User" (
    username   VARCHAR2(300 CHAR) NOT NULL,
    password   CHAR(128 CHAR),
    created    DATE,
    updated    DATE,
    body       VARCHAR2(4000)
);

ALTER TABLE "User" ADD CONSTRAINT user_pk PRIMARY KEY ( username );

CREATE TABLE vote (
    id                     INTEGER NOT NULL,
    header                 INTEGER,
    body                   VARCHAR2(3000 CHAR),
    created                DATE,
    updated                DATE,
    option_id              INTEGER NOT NULL,
    option_id2             INTEGER NOT NULL,
    option_user_username   VARCHAR2(300 CHAR) NOT NULL,
    user_username          VARCHAR2(300 CHAR) NOT NULL,
    question_id            INTEGER NOT NULL
);

ALTER TABLE vote
    ADD CONSTRAINT vote_pk PRIMARY KEY ( id,
                                         option_id,
                                         option_id2,
                                         option_user_username,
                                         user_username,
                                         question_id );

ALTER TABLE "Option"
    ADD CONSTRAINT option_question_fk FOREIGN KEY ( question_id )
        REFERENCES question ( id );

ALTER TABLE "Option"
    ADD CONSTRAINT option_user_fk FOREIGN KEY ( user_username )
        REFERENCES "User" ( username );

ALTER TABLE question
    ADD CONSTRAINT question_user_fk FOREIGN KEY ( user_username )
        REFERENCES "User" ( username );

ALTER TABLE status
    ADD CONSTRAINT status_option_fk FOREIGN KEY ( option_id,
                                                  option_id2,
                                                  option_user_username )
        REFERENCES "Option" ( id,
                              question_id,
                              user_username );

ALTER TABLE status
    ADD CONSTRAINT status_question_fk FOREIGN KEY ( question_id )
        REFERENCES question ( id );

ALTER TABLE status
    ADD CONSTRAINT status_tag_fk FOREIGN KEY ( tag_user_username,
                                               tag_question_id,
                                               tag_option_id,
                                               tag_option_id2,
                                               tag_option_user_username,
                                               tag_id4,
                                               tag_id13,
                                               tag_id5,
                                               tag_username2,
                                               tag_username1,
                                               tag_id6,
                                               tag_name )
        REFERENCES tag ( user_username,
                         question_id,
                         option_id,
                         option_id2,
                         option_user_username,
                         vote_id,
                         vote_option_id,
                         vote_option_id2,
                         vote_option_user_username,
                         vote_user_username,
                         vote_question_id,
                         name );

ALTER TABLE status
    ADD CONSTRAINT status_user_fk FOREIGN KEY ( user_username )
        REFERENCES "User" ( username );

ALTER TABLE status
    ADD CONSTRAINT status_vote_fk FOREIGN KEY ( vote_id,
                                                vote_option_id,
                                                vote_option_id2,
                                                vote_option_user_username,
                                                vote_user_username,
                                                vote_question_id )
        REFERENCES vote ( id,
                          option_id,
                          option_id2,
                          option_user_username,
                          user_username,
                          question_id );

ALTER TABLE tag
    ADD CONSTRAINT tag_option_fk FOREIGN KEY ( option_id,
                                               option_id2,
                                               option_user_username )
        REFERENCES "Option" ( id,
                              question_id,
                              user_username );

ALTER TABLE tag
    ADD CONSTRAINT tag_question_fk FOREIGN KEY ( question_id )
        REFERENCES question ( id );

ALTER TABLE tag
    ADD CONSTRAINT tag_user_fk FOREIGN KEY ( user_username )
        REFERENCES "User" ( username );

ALTER TABLE tag
    ADD CONSTRAINT tag_vote_fk FOREIGN KEY ( vote_id,
                                             vote_option_id,
                                             vote_option_id2,
                                             vote_option_user_username,
                                             vote_user_username,
                                             vote_question_id )
        REFERENCES vote ( id,
                          option_id,
                          option_id2,
                          option_user_username,
                          user_username,
                          question_id );

ALTER TABLE vote
    ADD CONSTRAINT vote_option_fk FOREIGN KEY ( option_id,
                                                option_id2,
                                                option_user_username )
        REFERENCES "Option" ( id,
                              question_id,
                              user_username );

ALTER TABLE vote
    ADD CONSTRAINT vote_question_fk FOREIGN KEY ( question_id )
        REFERENCES question ( id );

ALTER TABLE vote
    ADD CONSTRAINT vote_user_fk FOREIGN KEY ( user_username )
        REFERENCES "User" ( username );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             0
-- ALTER TABLE                             21
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0