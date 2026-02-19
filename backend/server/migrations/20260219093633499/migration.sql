BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "fcm_token" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fcm_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "token" text NOT NULL,
    "deviceType" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "pushedAt" timestamp without time zone,
    "pushService" text NOT NULL
);

-- Indexes
CREATE INDEX "fcm_token_user_idx" ON "fcm_token" USING btree ("userId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "message" ADD COLUMN "messageType" text;
ALTER TABLE "message" ADD COLUMN "mediaUrl" text;
ALTER TABLE "message" ADD COLUMN "mediaSizeBytes" bigint;
ALTER TABLE "message" ADD COLUMN "mediaMimeType" text;
ALTER TABLE "message" ADD COLUMN "mediaExpiresAt" timestamp without time zone;
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
-- MIGRATION VERSION FOR chatapp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chatapp', '20260219093633499', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260219093633499', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260129181124635', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181124635', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260129181059877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181059877', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
