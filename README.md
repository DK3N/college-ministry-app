# Disciples on Campus App!

An ongoing cross-platform mobile app project built with Flutter and Supabase for my campus ministry. It helps us organize our member directory, keep track of baptism dates, link discipleship mentors, and store member preferences for fun encouragement (a little movie night, anyone?).

<!-- Tip: Drop a 5-second recording or screenshot here if you have one -->
<!-- <p align="center"><img src="assets/demo.png" width="280" alt="App Demo" /></p> -->

---

## What It Does & How It Works

* **Automatic Profile Creation:** When a new user signs up through Supabase Auth, a PostgreSQL trigger immediately creates an empty row in the `MEMBER` table linked to their auth UID. This keeps the backend consistent so the client doesn't have to fire off a separate creation call.
* **Granular Database Security (RLS):** Set up Postgres Row Level Security so members can search the directory (needed for the mentor lookup tool), but can strictly only read and update their own personal records and baptism details.
* **Reactive Stream Syncing (`.stream()`):** Leveraged Supabase's Realtime WebSocket stream listener filtered with `.firstWhere((list) => list.isNotEmpty)` to wait for backend database triggers to finish. This completely eliminates network timing race conditions during sign-up and guarantees the user's `member_id` is captured the millisecond it's created.
* **Smart Form Updates:** The encouragement profile has over 30 optional questions (MBTI, favorite snacks, prayer requests, etc.). Instead of sending every field and accidentally overwriting saved data with `null`, the app filters out untouched inputs locally before sending an `.upsert()`.
* **Global State Management (Provider):** Implemented `Provider` (`UserState`) as a centralized session store across the app widget tree. It caches the authenticated `member_id` globally, preventing redundant database re-queries whenever navigating between pages.

---

## Built With

* **Frontend:** Flutter / Dart
* **Backend:** Supabase (PostgreSQL, Supabase Auth, PostgREST API, Realtime Streams)
* **State Management:** Provider (`UserState`)

---

## Database Design
Designed by me, not an LLM! 😉 (probably some room for improvement here). Thanks COP 4710 @ FIU.

```
auth.users (id uuid)
  │
  └──► [Trigger: on_auth_user_created]
        │
        ▼
   public.MEMBER
   ├── member_id (int8, PK)
   ├── first_name / last_name (text)
   ├── birthdate (date)
   ├── sex (sex_enum)
   ├── school (school_enum)
   ├── is_minister / is_cg_leader (bool)
   ├── user_id (uuid, FK ──► auth.users.id)
   └── cg_id (int8, FK ──────► COMMUNITY_GROUP.cg_id)
        │
        ├──► public.BAPTISM
        │    ├── baptized_member_id (int8, PK/FK ──► MEMBER.member_id)
        │    ├── date (date)
        │    └── location (text)
        │
        ├──► public.PERFORMED_BAPTISM
        │    ├── baptized_member_id (int8, PK/FK ──► MEMBER.member_id)
        │    └── performer_member_ids (int8[])
        │
        ├──► public.MEMBER_FACTS
        │    ├── member_id (int8, PK/FK ──► MEMBER.member_id)
        │    └── [30+ preference & encouragement columns]
        │
        ├──► public.BIBLE_STUDY
        │    ├── lead_member_id (int8, FK ──► MEMBER.member_id)
        │    ├── support_member_id (int8, FK ──► MEMBER.member_id)
        │    └── student_full_name, school, student_sex, year_of_school, hometown, last_study
        │
        └──► public.ANNOUNCEMENT
             ├── a_id (int8, PK)
             ├── author_member_id (int8, FK ──► MEMBER.member_id)
             └── subject, description, datetime (timestamptz)

   public.COMMUNITY_GROUP
   ├── cg_id (int8, PK)
   └── name, meet_time, day_of_week

   public.CALENDAR_EVENT
   ├── event_id (int8, PK)
   └── title, description, datetime (timestamptz), is_weekly
```

---
## Running It Locally

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.5.3` or higher)
* A Supabase project set up with Postgres

### Quickstart

1. **Clone the repo:**
```bash
git clone https://github.com/DK3N/college-ministry-app.git
cd college-ministry-app
```

2. **Install packages:**
```bash
flutter pub get
```

3. **Add your Supabase keys:**
   In your environment configuration (or `lib/main.dart`), add your project URL and publishable key:
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  publishableKey: 'YOUR_SUPABASE_PUBLISHABLE_KEY',
);
```

4. **Launch the app:**
```bash
flutter run
```
