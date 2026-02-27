# Lasta 493 Chat App 🚀

Ovo je monorepo projekat baziran na **Flutter** i **Serverpod** arhitekturi, namenjen za chat aplikaciju. Sistem je strukturiran pomoću alata [Melos](https://melos.invertase.dev/) kako bi efikasno upravljao backend-om, klijentskim paketima i samom mobilnom aplikacijom iz jednog korenskog direktorijuma.

## 🏗️ Arhitektura Projekta

Repozitorijum je podeljen u tri glavne celine:

*   **`apps/mobile_app`**: Flutter mobilna aplikacija (klijent/frontend).
*   **`backend/server`**: Serverpod backend kod i API end-pointi.
*   **`packages/api_client`**: Klijentska biblioteka (generisana od strane Serverpoda) preko koje Flutter aplikacija komunicira sa backend-om.

Sve celine su povezane preko `melos.yaml` fajla na nivou celog "workspace-a" (`resolution: workspace`).

---

## 🛠️ Podešavanje Lokalnog Razvojnog Okruženja

Pre nego što počneš sa radom, proveri da li imaš instalirane sledeće alate:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (ver. `^3.32.0`)
- [Dart SDK](https://dart.dev/get-dart)
- [Docker](https://www.docker.com/) (za lokalnu Serverpod Postgres bazu podataka)
- [Melos](https://pub.dev/packages/melos) (Pokreni: `dart pub global activate melos`)
- [Serverpod CLI](https://serverpod.dev/docs)

### 1. Inicijalizacija Workspace-a (Melos)
Ovo će automatski preuzeti zavisnosti (`pub get`) za **sve** projekte i povezati lokalne pakete (poput `api_client` za `mobile_app`):
```bash
melos bootstrap
```

### 2. Pokretanje baze podataka (Lokalno)
Serverpod koristi Docker kontejner za Postgres (i Redis po potrebi). Iz terminala, idi u direktorijum backend-a i pokreni Docker kompoziciju:
```bash
cd backend/server
docker compose up --build --detach
```

### 3. Pokretanje Backend Servera
Kada je baza pokrenuta sa dockerom, potrebno je pokrenuti i sam Dart backend (Serverpod):
```bash
cd backend/server
dart bin/main.dart
```
*(U razvoju preporučujemo korišćenje `dart --observe bin/main.dart` za mogućnost hot reload-a.)*

### 4. Pokretanje Flutter Aplikacije
Server sada sluša na `localhost:8080`. Startuj Flutter aplikaciju iz `apps/mobile_app`:
```bash
cd apps/mobile_app
flutter run
```
> **Napomena:** Ukoliko testiraš na Android emulatoru, imaj u vidu da se URL backend-a obično razrešava na `10.0.2.2`, dok na uređajima/iOS zahteva IP adresu lokalne mreže ili produkcioni URL.

---

## 🚀 CI/CD Integracija (GitHub Actions & Cloud Build)

Projekat je konfigurisan za moderni **CI/CD process** korišćenjem **GitHub Actions** i **Google Cloud Run** infrastrukture.

### GitHub Actions (Nalazi se u `.github/workflows/deploy.yml`)
Pruža pun CI/CD:
1.  **Flutter CI Test**: Pri svakom Push-u i Pull Request-u prolazi analizu i testiranje koda za ceo monorepo (pomoću melos komandi).
2.  **Deploy Backend to Cloud Run**: Kada se uredi 'merge' / push u `main` granu, ova akcija se autentifikuje na tvoj Google Cloud i okida tvoju lokalnu instalacionu skriptu `cloud-run-deploy.sh`.
3.  **Deploy Flutter (Shorebird)**: Kada se push-uje u `main`, okida se i OTA (Over-The-Air) build za Android preko Shorebird-a (ukoliko ga koristiš).

#### ⚠️ Bitna Podešavanja u GitHub-u (Secrets)
Da bi CD radnje radile neometano iz GitHub Actions, unutar tvog GitHub repozitorijuma podesi sledeće **Secrets** (Settings -> Secrets and variables -> Actions):
*   `GCP_CREDENTIALS`: Sadržaj Service Account JSON ključa sa Google Cloud platforme (za automatski deploy).
*   `SHOREBIRD_TOKEN`: Tvoj shorebird CI/CD token ukoliko koristiš Over-The-Air update funkcionalnost.

### Google Cloud Run Skripta (`cloud-run-deploy.sh`)
Ova automatizovana Bash skripta obavlja sledeće:
1. Kompajlira Docker image Serverpod backend-a (`backend/server/Dockerfile`).
2. Šalje imidž na Google Container Registry (kroz `cloudbuild.yaml`).
3. Vrši postavljanje (Deploy) na Serverless Cloud Run infrastrukturu.
4. Preuzima i upisuje produkcioni host (`publicHost`) direktno u fajl `backend/server/config/production.yaml`.

Za manuelno pokretanje (ako ne ideš preko GitHub Actions):
```bash
./cloud-run-deploy.sh
```

Nakon pokretanja Cloud Run deploy-a prvi put, potrebno je ranije aplikaciji primeniti izmene baze (migracije) nad produkcionom instancom:
```bash
cd backend/server
dart run serverpod_cli apply-migrations --mode=production
```

---

## 🛠️ Česte komande / Održavanje

### Generisanje kod klijenta (Serverpod)
Kada god izmeniš `.spy` protokole na backend-u (kako bi kreirao nove modele baze ili endpointe), obavezno moraš izgenerisati novi Dart kod za Server i API_Klijent:
```bash
cd backend/server
serverpod generate
```

### Kreiranje i Rad sa Migracijama
Kada baza pretrpi promene, migraciju generišeš ovako:
```bash
cd backend/server
serverpod create-migration
```
Ako želiš da primeniš postojeće migracije lokalnom serveru:
```bash
dart run serverpod_cli apply-migrations --mode=development
```
