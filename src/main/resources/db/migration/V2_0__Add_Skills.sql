CREATE TABLE endorsement
(
    id       BIGINT AUTO_INCREMENT NOT NULL,
    user_id  BIGINT                NOT NULL,
    skill_id BIGINT                NOT NULL,
    CONSTRAINT pk_endorsement PRIMARY KEY (id)
);

CREATE TABLE skill
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
    name       VARCHAR(255)          NULL,
    level      INT                   NULL,
    profile_id BIGINT                NOT NULL,
    CONSTRAINT pk_skill PRIMARY KEY (id)
);

ALTER TABLE endorsement
    ADD CONSTRAINT FK_ENDORSEMENT_ON_SKILL FOREIGN KEY (skill_id) REFERENCES skill (id);

ALTER TABLE endorsement
    ADD CONSTRAINT FK_ENDORSEMENT_ON_USER FOREIGN KEY (user_id) REFERENCES user (id);

ALTER TABLE skill
    ADD CONSTRAINT FK_SKILL_ON_PROFILE FOREIGN KEY (profile_id) REFERENCES student_profile (id);