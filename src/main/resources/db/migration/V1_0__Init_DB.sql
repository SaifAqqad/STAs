###############################
# Hibernate Sequence table
# see https://stackoverflow.com/a/59729185/13162549
create table hibernate_sequence
(
    next_val bigint
) engine = InnoDB;
insert into hibernate_sequence
values (1);

###############################
# User table
CREATE TABLE user
(
    id            BIGINT       NOT NULL,
    first_name    VARCHAR(255) NULL,
    last_name     VARCHAR(255) NULL,
    email         VARCHAR(255) NOT NULL,
    password      VARCHAR(255) NULL,
    date_of_birth date         NULL,
    `role`        VARCHAR(255) NOT NULL,
    token2fa      VARCHAR(255) NULL,
    is_using2fa   BIT(1)       NULL,
    is_enabled    BIT(1)       NULL,
    CONSTRAINT pk_user PRIMARY KEY (id)
) engine = InnoDB;

ALTER TABLE user
    ADD CONSTRAINT uc_user_email UNIQUE (email);

###############################
# UserToken table
CREATE TABLE user_token
(
    id          BIGINT      NOT NULL,
    token       VARCHAR(64) NULL,
    expiry_date datetime    NULL,
    type        INT         NULL,
    user_id     BIGINT      NOT NULL,
    CONSTRAINT pk_usertoken PRIMARY KEY (id)
) engine = InnoDB;

ALTER TABLE user_token
    ADD CONSTRAINT uc_usertoken_token UNIQUE (token);
ALTER TABLE user_token
    ADD CONSTRAINT FK_USERTOKEN_ON_USER FOREIGN KEY (user_id) REFERENCES user (id);

###############################
# Connection table
CREATE TABLE connection
(
    id                    BIGINT        NOT NULL,
    service_name          VARCHAR(255)  NULL,
    service_user_id       VARCHAR(255)  NULL,
    service_token         VARCHAR(1000) NULL,
    service_refresh_token VARCHAR(255)  NULL,
    service_token_expiry  datetime      NULL,
    service_user_profile  JSON          NULL,
    user_id               BIGINT        NOT NULL,
    CONSTRAINT pk_connection PRIMARY KEY (id)
) engine = InnoDB;
ALTER TABLE connection
    ADD CONSTRAINT FK_CONNECTION_ON_USER FOREIGN KEY (user_id) REFERENCES user (id);

###############################
# StudentProfile table
CREATE TABLE student_profile
(
    id                BIGINT        NOT NULL,
    name              VARCHAR(255)  NULL,
    contact_email     VARCHAR(255)  NULL,
    location          VARCHAR(255)  NULL,
    about             VARCHAR(5000) NULL,
    contact_phone     VARCHAR(255)  NULL,
    university        VARCHAR(255)  NULL,
    major             VARCHAR(255)  NULL,
    image_uri         VARCHAR(255)  NULL,
    uuid              VARCHAR(255)  NULL,
    is_public         BIT(1)        NULL,
    include_in_search BIT(1)        NULL,
    links             JSON          NULL,
    user_id           BIGINT        NOT NULL,
    FULLTEXT (name, location, university),
    CONSTRAINT pk_studentprofile PRIMARY KEY (id)
) engine = InnoDB;

ALTER TABLE student_profile
    ADD CONSTRAINT FK_STUDENTPROFILE_ON_USER FOREIGN KEY (user_id) REFERENCES user (id);

###############################
# Activity table
CREATE TABLE activity
(
    id            BIGINT        NOT NULL,
    name          VARCHAR(255)  NULL,
    `description` VARCHAR(5000) NULL,
    date          date          NULL,
    image_uri     VARCHAR(255)  NULL,
    profile_id    BIGINT        NOT NULL,
    CONSTRAINT pk_activity PRIMARY KEY (id)
) engine = InnoDB;
ALTER TABLE activity
    ADD CONSTRAINT FK_ACTIVITY_ON_PROFILE FOREIGN KEY (profile_id) REFERENCES student_profile (id);

###############################
# Project table
CREATE TABLE project
(
    id            BIGINT        NOT NULL,
    name          VARCHAR(255)  NULL,
    category      VARCHAR(255)  NULL,
    `description` VARCHAR(5000) NULL,
    url           VARCHAR(255)  NULL,
    image_uri     VARCHAR(255)  NULL,
    start_date    date          NULL,
    end_date      date          NULL,
    profile_id    BIGINT        NOT NULL,
    CONSTRAINT pk_project PRIMARY KEY (id)
) engine = InnoDB;
ALTER TABLE project
    ADD CONSTRAINT FK_PROJECT_ON_PROFILE FOREIGN KEY (profile_id) REFERENCES student_profile (id);

###############################
# Experience table
CREATE TABLE experience
(
    id            BIGINT        NOT NULL,
    company_name  VARCHAR(255)  NULL,
    job_title     VARCHAR(255)  NULL,
    `description` VARCHAR(5000) NULL,
    start_date    date          NULL,
    end_date      date          NULL,
    profile_id    BIGINT        NOT NULL,
    CONSTRAINT pk_experience PRIMARY KEY (id)
) engine = InnoDB;
ALTER TABLE experience
    ADD CONSTRAINT FK_EXPERIENCE_ON_PROFILE FOREIGN KEY (profile_id) REFERENCES student_profile (id);

###############################
# Course table
CREATE TABLE course
(
    id              BIGINT        NOT NULL,
    name            VARCHAR(255)  NULL,
    `description`   VARCHAR(5000) NULL,
    student_comment VARCHAR(5000) NULL,
    publisher       VARCHAR(255)  NULL,
    url             VARCHAR(255)  NULL,
    image_uri       VARCHAR(255)  NULL,
    profile_id      BIGINT        NOT NULL,
    CONSTRAINT pk_course PRIMARY KEY (id)
) engine = InnoDB;
ALTER TABLE course
    ADD CONSTRAINT FK_COURSE_ON_PROFILE FOREIGN KEY (profile_id) REFERENCES student_profile (id);
