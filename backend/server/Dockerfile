# ═══════════════════════════════════════════════════════════
# Serverpod — Monorepo Docker Build
# Build context: REPO ROOT (e.g. `gcloud builds submit .`)
# Packages included:
#   - backend/server        (Serverpod server)
#   - packages/api_client   (chatapp_client — local path dep)
# ═══════════════════════════════════════════════════════════

# ─── Stage 1: Build ──────────────────────────────────────
FROM dart:3.9.2 AS build

WORKDIR /workspace

# Copy the workspace root pubspec.yaml and prune mobile_app (not needed for build)
COPY pubspec.yaml .
RUN sed -i '/- apps\/mobile_app/d' pubspec.yaml

# Copy the shared api_client package (local path dependency)
COPY packages/api_client/ packages/api_client/

# Copy the server package (including config/passwords.yaml)
COPY backend/server/ backend/server/

# Resolve & compile from the server directory
WORKDIR /workspace/backend/server

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# ─── Stage 2: Minimal runtime ────────────────────────────
FROM alpine:latest

# Default env vars — Cloud Run overrides these via --set-env-vars
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy Dart runtime libs from the SDK image
COPY --from=build /runtime/ /

# Copy the compiled binary
COPY --from=build /workspace/backend/server/bin/server /app/server

# Copy Serverpod config (production.yaml, passwords.yaml, etc.)
COPY --from=build /workspace/backend/server/config/ /app/config/

# Copy web assets, migrations, and generated protocol descriptor
COPY --from=build /workspace/backend/server/web/       /app/web/
COPY --from=build /workspace/backend/server/migrations/ /app/migrations/
COPY --from=build /workspace/backend/server/lib/src/generated/protocol.yaml \
                  /app/lib/src/generated/protocol.yaml

WORKDIR /app

# Serverpod ports:
#   8080 — API (main, exposed via Cloud Run)
#   8081 — Insights
#   8082 — Web server
EXPOSE 8080 8081 8082

# Use shell form so env vars are expanded at container start time.
# --mode maps to E.g. production.yaml; passwords.yaml must be present in config/.
ENTRYPOINT ["sh", "-c", "./server --mode=${runmode} --server-id=${serverid} --logging=${logging} --role=${role} --apply-migrations"]
