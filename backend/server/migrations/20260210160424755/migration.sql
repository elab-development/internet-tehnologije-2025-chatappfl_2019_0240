BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "channel" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "type" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "channel_member" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "channelId" bigint NOT NULL,
    "role" text NOT NULL,
    "joinedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "channel_view_state" (
    "id" bigserial PRIMARY KEY,
    "channelId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "lastReadMessageId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fcm_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "token" text NOT NULL,
    "deviceType" text NOT NULL
);

-- Indexes
CREATE INDEX "fcm_token_user_idx" ON "fcm_token" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "message" (
    "id" bigserial PRIMARY KEY,
    "content" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "senderId" bigint NOT NULL,
    "channelId" bigint NOT NULL,
    "status" text
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "channel_member"
    ADD CONSTRAINT "channel_member_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "channel_member"
    ADD CONSTRAINT "channel_member_fk_1"
    FOREIGN KEY("channelId")
    REFERENCES "channel"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "channel_view_state"
    ADD CONSTRAINT "channel_view_state_fk_0"
    FOREIGN KEY("channelId")
    REFERENCES "channel"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "channel_view_state"
    ADD CONSTRAINT "channel_view_state_fk_1"
    FOREIGN KEY("userId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "fcm_token"
    ADD CONSTRAINT "fcm_token_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "message"
    ADD CONSTRAINT "message_fk_0"
    FOREIGN KEY("senderId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "message"
    ADD CONSTRAINT "message_fk_1"
    FOREIGN KEY("channelId")
    REFERENCES "channel"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR chatapp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chatapp', '20260210160424755', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260210160424755', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
