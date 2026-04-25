
⚔️

SKILL DUEL
PLATFORM

Project Scope & Product Requirements Document

Built with Flutter · Firebase · Flame Engine

VERSION 2.0 — FULL MVP EDITION

v2.0   ·   April 2026

1. Vision & Concept


Skill Duel is a competitive 1v1 mobile platform where players challenge each other to knowledge and skill battles across their most passionate interests — football, chess, gaming, and more. Think Chess.com's ranked ladder energy, applied to any subject you care deeply about.

🎯  Core Insight
SoloLearn proved that async challenge formats are addictive. Chess.com proved ELO ranking systems create obsessive retention. Skill Duel combines both — bringing ranked competitive dueling to communities that have no dedicated battleground: football fans, COD players, chess tacticians.


1.1  The Problem
Football fans have no competitive knowledge platform — just passive apps and stats pages.
COD / gaming knowledge is scattered across Reddit and YouTube, never gamified.
Trivia apps feel like homework. No stakes, no rank, no rival.
The SoloLearn duel format is addictive but locked inside a coding niche.

1.2  The Solution
Async 1v1 duels: both players answer independently, winner revealed after both submit.
ELO rating system: every duel affects your rank. Skill is tracked and meaningful.
Niche categories: Football, Chess Tactics, COD/FPS, General Gaming.
Seasons & leaderboards: monthly resets, rank tiers from Bronze to Master.
Social layer: challenge friends directly or get matched by skill level.
Daily Challenge: one special free duel per day with a global leaderboard.
Shareable result cards: viral hooks built into every duel outcome.

2. MVP Scope — What Ships at Launch


📌  MVP Philosophy
The MVP proves the entire core loop end-to-end: register → pick category → duel → result → rank update → share. Every feature below is required for this loop to feel complete and competitive. Nothing has been deferred unless it cannot be built solo in 12 weeks.


2.1  MVP Feature List
Feature
Description
Status
User Authentication
Google Sign-In, email/password, anonymous guest mode via Firebase Auth
MVP
Onboarding Flow
3-step welcome carousel + avatar/username setup after registration
MVP
Category Selection
Football and Chess at launch. COD and Gaming as locked placeholders shown in UI
MVP
Question Bank
300 Football + 200 Chess curated questions. Difficulty tiers: Easy, Medium, Hard
MVP
Direct Challenge
Generate a duel code, share via WhatsApp/Instagram. Opponent joins via code or deep link
MVP
Auto Matchmaking
Match within ±150 ELO range. Expands to ±300 after 30s. Open challenge after 60s
MVP
Async Duel Engine
10 questions per duel. 20-second timer per question. Both players answer independently
MVP
Timer Warning State
Red pulsing timer and subtle screen tint when 5 seconds remain
MVP
ELO Rating System
Per-category ELO starting at 1000. K-factor 32 below 1200, 16 above. Cloud Function calculated
MVP
Duel Results Screen
Win and loss states. Score comparison, ELO change, new ELO display
MVP
Answer Review Screen
Post-duel review of all 10 answers with correct/wrong state and explanations
MVP
Share Result Card
Shareable graphic card generated after each duel. One-tap share to WhatsApp/Instagram/X
MVP
Waiting for Opponent
Suspense screen while opponent plays. Score locked until both submit
MVP
Duel Cancelled Screen
Walkover win handling when opponent abandons or never accepts within 24 hours
MVP
User Profile
Avatar, username, ELO per category, win/loss record, recent duels, achievements row
MVP
Global Leaderboard
Top 100 per category. Weekly and All-Time toggle. Podium top 3 display
MVP
Friend System
Add friends by username/link. Challenge friends directly. Online status indicator
MVP
Duel History
Full paginated history with W/L filter, score, ELO change, category per duel
MVP
Notifications
Push via Firebase Cloud Messaging: challenged, opponent submitted, your turn, daily challenge
MVP
Daily Challenge
One special free duel per day per category. Countdown timer to reset. Global daily leaderboard
MVP
Tutorial Overlay
Coach marks on first duel: timer explanation, answer tap, async explainer. Skip option
MVP
Report Question Modal
Flag bad/wrong questions during or after duel. 5 report reasons + optional note
MVP
Network Error Screen
Offline detection with duel progress saved confirmation and reconnect action
MVP
Upgrade to Pro Screen
Pro subscription pitch: unlimited duels, no ads, advanced stats, exclusive frames
MVP
Purchase Success Screen
Gold celebration screen post-purchase. Pro badge + unlocked benefits checklist
MVP
Settings Screen
Account, notifications toggles, linked accounts, app version, delete account
MVP
Empty State Screen
First-time user empty duel history with single CTA to start first duel
MVP
Dark Mode
Full dark UI, always on. Non-negotiable brand identity
MVP


🚫  Deliberately Deferred to V2
Seasons system, rank tier screen, season end summary, custom tournament brackets, community question submissions, chat/trash talk, COD and Gaming categories live question banks, web admin dashboard. These are growth features, not launch requirements.


3. Complete Screen Inventory (36 Screens)


All 36 screens have been designed and have corresponding Stitch prompts. The table below maps every screen to its category, MVP status, and Stitch prompt reference.

Screen
Category
Version
01 — Splash Screen
Auth & Onboarding
MVP
02 — Onboarding Carousel
Auth & Onboarding
MVP
03 — Login Screen
Auth & Onboarding
MVP
04 — Sign Up Screen
Auth & Onboarding
MVP
05 — Avatar Setup
Auth & Onboarding
MVP
06 — Home / Category Select
Core Loop
MVP
07 — Category Detail
Core Loop
MVP
08 — Matchmaking Screen
Core Loop
MVP
09 — Direct Challenge Screen
Core Loop
MVP
10 — Active Question Screen
Core Loop
MVP
11 — Answer Selected State
Core Loop
MVP
12 — Timer Warning State
Core Loop
MVP
13 — Waiting for Opponent
Core Loop
MVP
14 — Duel Cancelled / Walkover
Core Loop
MVP
15 — Win Results Screen
Results
MVP
16 — Loss Results Screen
Results
MVP
17 — Answer Review Screen
Results
MVP
18 — Share Result Card
Results
MVP
19 — Daily Challenge Screen
Daily & Seasons
MVP
20 — Daily Challenge Completed
Daily & Seasons
MVP
21 — Season End Summary
Daily & Seasons
V2
22 — Friends Screen
Social
MVP
23 — Add Friend / Search
Social
MVP
24 — Opponent Public Profile
Social
V2
25 — Notifications Screen
Social
MVP
26 — Duel History Screen
Social
MVP
27 — My Profile Screen
Profile & Progress
MVP
28 — Global Leaderboard
Profile & Progress
MVP
29 — Rank Tier Screen
Profile & Progress
V2
30 — Settings Screen
Utility
MVP
31 — Upgrade to Pro
Utility
MVP
32 — Purchase Success
Utility
MVP
33 — Report Question Modal
Utility
MVP
34 — Tutorial Overlay
Utility
MVP
35 — Network Error / Offline
Utility
MVP
36 — Empty State
Utility
MVP


4. Technical Architecture


4.1  Full Tech Stack
Technology
Purpose
Priority
Flutter
Cross-platform framework. Single codebase for iOS + Android. Dart language.
Core
Firebase Auth
Google Sign-In, email/password, anonymous auth. First-class Flutter SDK.
Core
Cloud Firestore
User profiles, question bank, leaderboards, duel metadata, friends.
Core
Firebase Realtime DB
Live duel state sync. Low-latency, built for real-time game state.
Core
Firebase Cloud Functions
ELO calculation, duel finalization, receipt verification, anti-cheat.
Core
Firebase Cloud Messaging
Push notifications for challenges, turn alerts, daily challenge reminder.
Core
Firebase Storage
User avatars, generated share result card images.
Core
in_app_purchase (Flutter)
Handles both Google Play Billing and Apple StoreKit from one package.
Core
Flutter Flame
Lightweight 2D engine for timer animations and result screen effects.
Optional
Riverpod
State management. Cleaner async handling than BLoC for this app size.
Core
Hive
Local cache for offline question browsing and profile data.
Core
Dynamic Links / App Links
Deep links for duel codes — opens app directly to duel from WhatsApp.
Core


4.2  Firebase Data Structure
Firestore Collections:
  users/{uid}
    username, avatar, eloMap: {football: 1050, chess: 980}
    wins, losses, isPro, createdAt, fcmToken

  questions/{id}
    category, subcategory, difficulty (1-3)
    question, options[4], answer, explanation
    reportedCount, isActive

  leaderboards/{category}/weekly/{uid}
    elo, rank, username, avatar

  friends/{uid}/list/{friendUid}
    username, avatar, eloMap, status

Realtime Database:
  duels/{duelId}
    status: waiting | in_progress | completed | cancelled
    category, difficulty, createdAt, completedAt
    playerA: { uid, elo, answers[], score, submitted, timePerQuestion[] }
    playerB: { uid, elo, answers[], score, submitted, timePerQuestion[] }
    questions: [q1Id, q2Id, ...q10Id]

  matchmaking/{category}/{difficulty}
    queue: [{ uid, elo, timestamp }]

  daily/{category}/{date}
    questionIds: [...], playerCount, topScores[10]


4.3  App Architecture — Folder Structure
lib/
├── core/
│   ├── theme/          # Colors, typography, dark mode tokens
│   ├── utils/          # ELO calculator, share card generator
│   ├── services/       # Firebase wrappers, notification service
│   └── router/         # GoRouter navigation + deep link handling
├── features/
│   ├── auth/           # Login, register, avatar setup screens
│   ├── home/           # Home screen, category cards
│   ├── duel/           # Engine, question UI, timer, matchmaking
│   ├── results/        # Win/loss screen, answer review, share card
│   ├── daily/          # Daily challenge screen + completed state
│   ├── profile/        # My profile, opponent profile, history
│   ├── leaderboard/    # Global + friend rankings
│   ├── friends/        # Friends list, add friend, notifications
│   ├── settings/       # Settings, upgrade to pro, purchase success
│   └── onboarding/     # Splash, carousel, first-run tutorial
├── models/             # Duel, User, Question, ELO data classes
└── main.dart


5. Payment Integration


✅  Key Decision
No custom payment gateway (Stripe, Paystack, etc.) is needed. Google Play and the App Store are the payment processors. You build the pitch UI — the OS handles billing. This saves 3–4 weeks of payment integration work.


5.1  How It Works
Both platforms use the Flutter in_app_purchase package — one package handles both Google Play Billing API and Apple StoreKit automatically.

User taps 'Upgrade to Pro' on Screen 31 (Upgrade to Pro Screen).
Your Flutter code calls the in_app_purchase package with product ID skill_duel_pro_monthly.
The OS presents its native payment sheet — Google Pay or Apple Pay. You do NOT design this screen, the OS owns it entirely.
On successful payment, Google/Apple sends a purchase token to your app.
Your app sends the token to a Firebase Cloud Function for server-side verification.
The Cloud Function calls Google Play Developer API or Apple App Store Server API to verify the receipt.
On successful verification, the Cloud Function sets user.isPro = true in Firestore.
App listens to Firestore in real time, detects isPro = true, and navigates to Screen 32 (Purchase Success Screen).

// Flutter — trigger purchase
final products = await InAppPurchase.instance.queryProductDetails({'skill_duel_pro_monthly'});
final purchaseParam = PurchaseParam(productDetails: products.productDetails.first);
InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

// Flutter — listen to purchase stream
InAppPurchase.instance.purchaseStream.listen((purchases) {
  for (final purchase in purchases) {
    if (purchase.status == PurchaseStatus.purchased) {
      // Send purchase.verificationData.serverVerificationData to Cloud Function
      verifyReceiptCloudFunction(purchase.verificationData.serverVerificationData);
    }
  }
});

// Cloud Function — verify and unlock Pro
exports.verifyPurchase = functions.https.onCall(async (data, context) => {
  const receipt = data.receiptToken;
  const isValid = await verifyWithGooglePlay(receipt); // or Apple
  if (isValid) {
    await admin.firestore().doc('users/' + context.auth.uid).update({ isPro: true });
  }
});


5.2  Revenue Split
Item
Detail
Google Play Commission
15% on first $1M revenue per year, 30% above that
Apple App Store Commission
15% for small developers earning under $1M/year, 30% above
Your net on $3.99/month
~$3.39 per subscriber on Google Play (15% tier)
Subscription Product ID
skill_duel_pro_monthly — defined in Play Console and App Store Connect
Free trial
3 days — configured in Play Console / App Store Connect dashboard, no code needed
Restore purchases
in_app_purchase.restorePurchases() — required by both app stores


5.3  App Store Setup Required
Google Play Console: Create app → Create subscription product skill_duel_pro_monthly → Set price $3.99 → Enable free trial 3 days → Link to Firebase service account for receipt verification.
App Store Connect: Create app → Create auto-renewable subscription → Set price tier → Enable 3-day free trial → Download receipt verification private key.
Both store listings must be live before the in_app_purchase package can return real products during development — use sandbox/test accounts for testing.

6. Core Duel Engine — Deep Dive


6.1  Async Duel Flow
Player A selects category + difficulty, taps Start Duel.
Matchmaking: either enters friend code or joins auto-match queue.
Cloud Function creates duel document in Realtime DB, selects 10 random questions from Firestore matching category and difficulty.
Player A sees questions one at a time, 20-second timer each. Answers stored locally then synced.
After question 10, Player A sees Waiting for Opponent screen. Score is locked and hidden.
Player B receives FCM push notification: 'You've been challenged to a Football duel!'
Player B plays same 10 questions. On submission, Cloud Function compares scores.
Both players receive FCM push: 'Results are in!' Both see results screen simultaneously.
Cloud Function calculates new ELO for both players and writes to Firestore.

6.2  ELO Calculation
// Dart — ELO logic (also mirrored in Cloud Function for authority)
double expectedScore(double ratingA, double ratingB) {
  return 1 / (1 + pow(10, (ratingB - ratingA) / 400));
}

double newRating(double rating, double expected, double actual, int k) {
  return (rating + k * (actual - expected)).roundToDouble();
}
// actual: 1.0 = win, 0.5 = draw, 0.0 = loss
// k: 32 if rating < 1200, else 16
// ELO is ALWAYS calculated server-side in Cloud Function — never trust client


6.3  Question Bank Schema
{
  id: "ftb_001",
  category: "football",           // football | chess | cod | gaming
  subcategory: "premier_league",  // granular topic
  difficulty: 2,                  // 1=easy, 2=medium, 3=hard
  question: "Which player has the most PL assists of all time?",
  options: ["Ryan Giggs", "Frank Lampard", "Wayne Rooney", "Cesc Fabregas"],
  answer: "Ryan Giggs",
  explanation: "Ryan Giggs recorded 162 Premier League assists.",
  source: "premierleague.com",    // required for every question
  isActive: true,
  reportedCount: 0,
  createdAt: timestamp
}


6.4  Minimum Question Counts at Launch
Category
Count
Football — Premier League
150 questions
Football — World Cup / International
80 questions
Football — African Football / AFCON
70 questions
Chess — Openings & Theory
80 questions
Chess — Famous Games & Players
70 questions
Chess — Tactics & Rules
50 questions
TOTAL AT LAUNCH
500 questions minimum


7. Monetization


💡  Principle
Skill Duel is never pay-to-win. ELO is earned, not bought. Paying users get cosmetics and convenience — never a gameplay advantage. This is non-negotiable for community trust.


Revenue Stream
Description
Version
Skill Duel Pro
$3.99/month or $28.99/year. Unlimited duels/day, no ads, advanced stats, exclusive avatar frames, Pro badge on profile.
MVP
3-Day Free Trial
Configured in Play Console / App Store Connect. Removes barrier to first conversion.
MVP
Interstitial Ads
Shown between duels for free users. Capped at 1 per 3 duels. Removed with Pro.
MVP
Restore Purchase
Required by both app stores. in_app_purchase.restorePurchases() call.
MVP
Season Pass
Monthly premium cosmetic track. $4.99/season.
V2
Cosmetic Packs
Animated result screens, duel backgrounds, rare avatar items. $0.99–$2.99.
V2


8. Build Timeline — 14 Weeks to Launch


📅  Updated Timeline
The original 12-week plan has been extended to 14 weeks to account for payment integration, 36-screen UI implementation from Stitch designs, and proper question bank curation. This is a realistic solo developer timeline.


Phase
Duration
Deliverables
Phase 1
Week 1–2
Project setup, Flutter + Firebase config, GoRouter navigation, dark theme system, design tokens from Stitch exports, splash + onboarding screens.
Phase 2
Week 3
Auth flow: Google Sign-In, email/password, anonymous mode, avatar setup, Firebase Auth integration.
Phase 3
Week 4–5
Question bank: Firestore schema, seed 500 questions (Football + Chess), question display UI, timer component, difficulty filtering.
Phase 4
Week 6–7
Duel engine: matchmaking queue, duel session creation, async question flow, answer storage, waiting screen, duel cancellation handling.
Phase 5
Week 8
Results system: win/loss screens, answer review, ELO Cloud Function, share result card generator, Firestore ELO writes.
Phase 6
Week 9
Social features: friends system, add friend, opponent profile, duel history, notifications (FCM setup).
Phase 7
Week 10
Profile, leaderboard, daily challenge with countdown + daily leaderboard, push notification handlers.
Phase 8
Week 11
Payments: in_app_purchase setup, Play Console + App Store Connect config, Cloud Function receipt verification, Pro unlock flow, purchase success screen.
Phase 9
Week 12
Remaining utility screens: settings, report question, tutorial overlay, network error, empty state, upgrade to pro screen.
Phase 10
Week 13
Beta testing with 20–50 real users. Question quality audit. Bug fixes. Performance profiling. Edge case handling.
Phase 11
Week 14
App store submission (iOS + Android). Store listing copy, screenshots, metadata. Launch marketing prep.


9. Launch & Growth Strategy


9.1  Viral Loop
🔁  The Share Mechanic
After every duel, both winner and loser get a shareable result card (Screen 18). The card shows score, ELO change, category, and a personal challenge link: 'Can you beat me? skillduel.app/@kofi_duel'. One tap shares to WhatsApp Stories or Instagram Stories. Every share is a free ad. Every viewer is a potential install.


9.2  Launch Channels
Football: Football Twitter/X and WhatsApp group links. Result cards with tribal team language travel fast.
Chess: r/chess, Chess.com forums, chess Discord servers. This community loves anything that tests knowledge.
African market: deep WhatsApp penetration makes the share mechanic extremely effective. Football passion is unmatched.
Gaming TikTok: one creator showing a COD knowledge duel can produce 50k+ installs overnight.

9.3  Retention Mechanics
ELO rank: players protect their number obsessively. Losing 30 ELO hurts. That emotion brings them back.
Daily challenge: one reason to open the app every single day even without an active duel.
Friend rivalries: @chess_king_99 just hit 1400 ELO — triggers an instant challenge.
Push notifications: opponent submitted, challenged, daily challenge ready — three daily re-engagement hooks.

10. Success Metrics


Metric
Target & Meaning
D1 Retention
Target >55% — users return the day after install
D7 Retention
Target >35% — strong signal of habit formation
Duels per DAU
Target >3 — users playing multiple duels per session
Challenge Accept Rate
Target >60% of issued challenges accepted within 24h
Daily Challenge Completion
Target >40% of DAU completing the daily challenge
Pro Conversion (30-day)
Target >4% of 30-day active users upgrading to Pro
Share Rate
Target >25% of completed duels generating a share action
Question Report Rate
Target <1% — low rate means question quality is high
Avg Session Length
Target >8 minutes per session
Week 1 MAU → Week 4 MAU Ratio
Target >60% — measures early cohort retention


11. Risks & Mitigations


Risk
Description & Mitigation
Level
Question Exhaustion
Players see repeats. Mitigation: 500 questions at launch, weighted random selection, community submission in V2.
High
Empty Auto-Match Queue
Not enough players for live matching. Mitigation: Direct challenge removes this dependency. Focus on friend invites at launch.
High
Cheating / Googling
20-second timer makes Googling impractical for most questions. App-level detection in V2.
Medium
Bad Question Quality
Destroys trust instantly. Mitigation: Human review of every question, source required, report system ships at launch.
High
App Store Rejection
Standard quiz app, no gambling, no adult content. Low risk.
Low
Payment Receipt Spoofing
Client-side purchase faking. Mitigation: ALL receipt verification in Cloud Functions server-side. Never trust client.
Medium
Push Notification Opt-Out
Users disable notifications, breaking the async loop. Mitigation: In-app notification center as fallback (Notifications screen).
Medium


Skill Duel Platform  ·  Project Scope v2.0 — Full MVP Edition  ·  April 2026
