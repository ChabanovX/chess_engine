> **Project:** *Chess Games Analyzer (Flutter + Cubit)*
> **Primary goals:** (1) Fetch games from Chess.com, (2) Analyse each move locally with Stockfish, (3) Present an annotated visual review.

---

## 1 • What this file is for

This document tells any OpenAI‑powered **Agent** exactly **how to contribute** to this repository without breaking things.  It covers:

1. **Scope & deliverables** — what features matter and what is out‑of‑scope.
2. **Repo layout & key entry points** — where to read and where to write code.
3. **Tooling** — commands for build, test, lint, and analysis.
4. **Design guard‑rails** — architecture, dependencies, coding style.
5. **Task templates** — concrete examples of the correct workflow (fetch → branch → PR).

Agents should read this file **before every run** and follow the check‑lists exactly.

---

## 2 • High‑level architecture

```
lib/
├─ data/                # API & engine glue
│   ├─ sources/         # chess.com REST client, stockfish isolate
│   └─ models/          # DTOs (Game, MoveEval, PlayerStats)
├─ domain/              # Pure Dart business rules
│   ├─ usecases/        # FetchGames, AnalyseGame
│   └─ entities/        # Value objects (Fen, PgnGame, Accuracy)
├─ presentation/        # UI widgets & Cubit states
│   ├─ cubit/           # HomeCubit, AnalysisCubit
│   └─ screens/         # HomePage, GameReportPage
└─ shared/              # util, theming, dependency‑injection

android/  ios/          # stockfish binaries live here (see /engines)
engines/                # pre‑built Stockfish‑NNUE binaries by arch
```

Key decisions:

* **State‑management:** *Cubit* (from flutter\_bloc).  One Cubit per screen.  Domain logic must not depend on Cubit.
* **Clean Architecture:** Data → Domain → Presentation.  Only the next layer inward may be imported.
* **Async:** Use `Stream` for long‑running engine evaluations; keep UI thread 60 fps.

---

## 3 • External dependencies

| Package                  | Purpose                         | Notes                                           |
| ------------------------ | ------------------------------- | ----------------------------------------------- |
| `http`                   | Call Chess.com public API       |                                                 |
| `stockfish_chess_engine` | UCI engine wrapper              | Runs in background isolate; **do not** block UI |
| `chess`                  | PGN/FEN parsing & move legality |                                                 |
| `flutter_bloc`, `bloc`   | Cubit & hydratable state        |                                                 |
| `equatable`              | Value class equality            |                                                 |
| `get_it`                 | Simple DI container             |                                                 |

*Adding a new third‑party package **requires** updating this file and passing `flutter pub run dart_code_metrics:metrics check-unused-files`.*

---

## 4 • Local build, lint & test commands

```bash
# 🔧 Setup
flutter pub get

# ▶️ Hot‑reload the app
flutter run

# ✅ Run unit & widget tests (CI gate)
flutter test --coverage

# 🧹 Lint + format check
flutter analyze
dart format --set-exit-if-changed .

# 🐟 Verify Stockfish integration (desktop only)
dart tool/engine_smoke_test.dart
```

All CI steps run via **GitHub Actions** (`.github/workflows/ci.yml`).  Agents must keep the pipeline green.

---

## 5 • Coding guidelines for Agents

1. **Branch naming:** `agent/<ticket-id>-short-desc`.  Example: `agent/AN-12-fetch-archive`.
2. **Commits:** Conventional Commit style, present‑tense (`feat: add depth slider`).  Keep < 72 char title.
3. **Pull Requests:**

   * Reference the Trello/Jira ticket.
   * Include `## Testing Steps` and screenshots (or GIF).
   * Label with `agent‐output`.
4. **Tests first:** Every domain use‑case or Cubit must ship with unit tests (use `mocktail`).
5. **Never hard‑code** secrets or API keys.  Use `.env` (excluded via `.gitignore`).
6. **Performance budget:** engine analysis ≤ 2 seconds per move at depth 15 on mid‑range device.

---

## 6 • Task templates

### 6.1 Fetch a player’s monthly archive (Use‑case 1)

```plain
Goal        : Implement FetchGamesUseCase
Trigger     : player types username (e.g. "Hikaru") on HomePage
Definition  : Call GET https://api.chess.com/pub/player/{username}/games/{YYYY}/{MM}
Success     : returns List<PgnGame> sorted by end_time desc
Steps       :
 1. Create data/sources/chess_api.dart
 2. Map JSON → GameDto → PgnGame entity
 3. Write unit test with `fixtures/hikaru_2025_05.json`
 4. Update HomeCubit to emit Fetching → Loaded/Pagination
```

### 6.2 Analyse a game with Stockfish (Use‑case 2)

```plain
Goal        : For a PGN, evaluate each half‑move and label it (Brilliant, Blunder…)
Trigger     : user taps a game card on HomePage
Definition  : For each Move M_i, send current FEN to Stockfish at depth=15,
              note score_before; make move; score_after; delta = side⋆(score_after - score_before).
              Map delta → label via thresholds in /lib/domain/analysis/move_classifier.dart.
Success     : returns GameAnalysis { acpl, labels[], ratingEstimate }
Steps       :
 1. Use stockfish_chess_engine; spin it up once per AnalysisCubit
 2. Cache evaluation results in sqflite for offline reuse
 3. Provide progress Stream<double> so UI can animate
```

---

## 7 • CI / CD

* **CI:** GitHub Actions – run on every PR targeting `main`.  Green build is required before merge.
* **CD:** Manual `flutter build apk|ipa` (Fastlane scripts under `/tool`) when tag `vX.Y.Z` is pushed.

---

## 8 • Security & compliance

* Stockfish is GPL‑3; we ship **unmodified** binaries → compatible with closed‑source Flutter code.  Attribution lives in **About → Licences** page.
* Respect Chess.com API rate limits (30 req/s IP, 5 req/s token).  Exponential back‑off is mandatory.
* No PII is stored; only public game data.

---

## 9 • Glossary

| Term          | Meaning                                                         |                         |                    |
| ------------- | --------------------------------------------------------------- | ----------------------- | ------------------ |
| **ACPL**      | Average Centipawn Loss – mean                                   | eval(best) − eval(move) | . Lower is better. |
| **Brilliant** | Engine depth≥15 finds sac line; delta ≤ 0 cp                    |                         |                    |
| **Cubit**     | Lightweight BLoC; emits immutable `State`s via `emit(...)`.     |                         |                    |
| **UCI**       | Universal Chess Interface – text protocol to speak to Stockfish |                         |                    |

---

## 10 • Contact & escalation

*Owner*: @chabanovx (GitHub)
*Core Maintainers*: @chabanovx
If an Agent is unsure about a change, open a Draft PR and tag the owner.

---