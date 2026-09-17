# Algerian Grocery Companion

## Product, UX, Architecture, Backend, and AI Agent Build Blueprint

**Document status:** Product and engineering source of truth  
**Primary platform:** Android and iOS phones  
**Recommended stack:** Flutter, Dart, Drift with SQLite, Supabase PostgreSQL  
**Primary market:** Algeria  
**Currency:** Algerian dinar, stored as integer DZD values  
**Working title:** Algerian Grocery Companion. Replace this after the final brand name is chosen.

---

## 1. Executive Summary

This project is a mobile-first grocery spending and food tracking application designed around how Algerian households actually buy food and household products. It combines three connected tools:

1. **Calculator:** fast purchase entry, monthly budgets, price memory, product detection, unit-price comparisons, and spending insights.
2. **Later Buy:** products postponed because their current price is too high, with target prices, reminders, and a record of whether waiting saved money.
3. **Food Notebook:** dated notes for meals, food reactions, product opinions, shopping observations, meal ideas, and other food-related tracking.

All three tools share one calendar, one product catalog, and one history. A product entered in Calculator can be postponed to Later Buy, referenced in a Notebook entry, and displayed on the relevant calendar date without duplicating data.

The app must be **offline-first**. Adding a purchase, reviewing history, opening the calendar, viewing notes, calculating budgets, and receiving local reminders must continue to work without internet access. Cloud services are used for optional accounts, backup, multi-device sync, shared product information, barcode lookup, and later AI features.

The core product promise is:

> Record a grocery item in seconds, remember its history automatically, and turn personal purchase data into useful decisions.

The app is not a generic finance tracker, a calorie counter, or an AI chatbot. Its differentiation is its Algerian context: DZD, kilogram-based market purchases, local products, local buying habits, recurring essentials, price increases, and monthly household grocery planning.

---

## 2. Product Principles

Every product, design, and engineering decision should follow these principles.

### 2.1 Speed before feature depth

The most frequent action is adding a purchase. The target flow is:

> Open app -> type product -> enter price -> save

A returning product should normally take no more than 3 to 5 seconds to record. Smart features must reduce work, not add required fields.

### 2.2 Local-first and reliable

The app must not depend on connectivity for its core functions. The local database is the immediate source used by the interface. Cloud synchronization runs in the background and may fail without blocking the user.

### 2.3 Intelligence must be explainable

Most smart behavior should be deterministic. The app should be able to explain insights using the user's own records:

- "You normally pay 145 to 155 DA for this product."
- "At your current pace, your projected total is 72,400 DA."
- "You usually buy eggs every 18 to 22 days."

Do not label ordinary calculations as AI. Use generative AI only where language interpretation or open-ended reasoning creates clear value.

### 2.4 One data model, multiple views

Calculator, Later Buy, Calendar, Notebook, Products, and Insights must refer to shared entities. Do not create independent copies of products or dates for each feature.

### 2.5 Algeria-specific defaults

The default currency is DZD. Support Arabic, French, and English product names and search aliases. Prioritize common local units and buying patterns, including kg, g, L, ml, piece, pack, tray, bag, bottle, can, and dozen.

### 2.6 Privacy by default

Personal grocery history can reveal household size, routines, health interests, location, and economic circumstances. Collect the minimum necessary data, keep local use possible without an account, and make cloud backup optional and clear.

---

## 3. Goals and Non-Goals

### 3.1 Primary goals

- Make grocery purchase entry extremely fast.
- Show current monthly spending, remaining budget, and projected month-end spending.
- Remember products, quantities, units, stores, and previous prices.
- Detect price changes and compare normalized unit prices.
- Allow expensive products to be postponed to Later Buy without losing their observed price.
- Provide reminders based on dates, target prices, and personal buying patterns.
- Store food-related notes with dates and links to products or purchases.
- Present all activity through a unified calendar and daily timeline.
- Work offline and synchronize safely when a user chooses cloud backup.
- Grow into an Algerian product database through curated records and user contributions.

### 3.2 Explicit non-goals for version 1

- Full personal finance management outside grocery and household spending.
- Medical nutrition advice or diagnosis.
- Automatic nationwide real-time price tracking.
- Social feeds, public profiles, or gamification.
- Recipe generation as a core feature.
- Detailed calorie and macro tracking.
- Automatic moral labels such as "good" or "bad" food.
- A general-purpose note application.
- Required account creation before using the app.

---

## 4. Target Users

### 4.1 Primary user

An individual or household member in Algeria who buys groceries regularly and wants to understand monthly spending, remember prices, and avoid forgetting postponed purchases.

### 4.2 Secondary users

- A person shopping for parents or an extended family.
- A couple coordinating a household budget.
- A price-conscious shopper comparing stores and package sizes.
- Someone keeping dated food notes or observations.
- A small household that wants a simple record without using a complex budgeting app.

### 4.3 User constraints

- Connectivity may be inconsistent.
- Some users will prefer Arabic, French, or a mixture of both.
- Users may enter product names in Arabic script, Latin script, Darja transliteration, or French.
- Prices may refer to a whole line total or a unit price.
- Fresh food is often sold by weight and may not have a barcode.
- Users may not know exact ingredients or package information.
- The app must remain useful even when the shared product database is incomplete.

---

## 5. Product Modules

## 5.1 Home

Home is the current-month command center. It should answer five questions immediately:

1. How much have I spent this month?
2. How much of my budget remains?
3. Am I spending faster than planned?
4. What needs attention?
5. What is the fastest next action?

### Home content hierarchy

- Month selector.
- Total spent.
- Remaining budget.
- Budget progress bar.
- Projected month-end total.
- Comparison with the previous month.
- Quick Add button.
- Today and recent activity.
- Important Later Buy reminders.
- Expected recurring products.
- Category summary.
- One to three high-value insights, not an endless feed.

### Empty state

The initial Home screen should explain the first action in one sentence and display a prominent Add Purchase button. Do not show meaningless charts with zero values.

## 5.2 Calculator

Calculator is the main transaction-entry and product-intelligence surface.

### Required purchase fields

- Product.
- Quantity.
- Unit.
- Price.
- Price mode: total price or unit price.
- Date and time, defaulting to now.

### Optional fields

- Store.
- Category.
- Brand.
- Package size.
- Barcode.
- Note.
- Expiry date.
- Basket or shopping trip.

### Quick Add behavior

As the user types, search these sources in order:

1. Frequently used personal products.
2. Recently used personal products.
3. Other personal products and aliases.
4. Cached shared product catalog.
5. Remote shared catalog, if online.

A suggestion should show the product name, useful variant or size, last price, and optionally the last store. Choosing it should prefill the usual unit, quantity, and other remembered fields without forcing the user to keep them.

### Save actions

- **Bought:** creates a purchase and affects totals.
- **Buy Later:** creates or updates a Later Buy item and does not affect spending totals.
- **Add to Shopping List:** creates a planned item with an optional estimate.
- **Save Draft:** optional in a later release for incomplete basket sessions.

### Immediate response after entry

After saving, show a compact confirmation with the most relevant comparison:

- Difference from last purchase.
- Difference from usual price range.
- Unit-price comparison.
- Category budget impact.
- Duplicate warning if an almost identical entry was created moments earlier.

The confirmation must never block rapid sequential entry.

## 5.3 Later Buy

Later Buy records products intentionally postponed, usually because of price. It is not the same as a generic shopping list.

### Later Buy fields

- Product.
- Observed price.
- Quantity and unit.
- Target price, optional.
- Store where observed, optional.
- Reason: expensive, not urgent, unavailable, compare elsewhere, custom.
- Created date.
- Reminder date, optional.
- Status: active, bought, skipped, dismissed, expired.
- Linked purchase when eventually bought.

### Core behavior

When a user later enters the same product, the app checks active Later Buy records. If the new normalized price meets the target or is lower than the observed price, display a non-blocking notice. The user can convert the item to Bought without re-entering existing data.

### Was It Worth Waiting

When resolved, calculate:

- Days waited.
- Original observed total or normalized price.
- Final purchase price.
- Absolute difference.
- Percentage difference.
- Whether the user saved or paid more.

Do not claim savings when package size or units are not comparable. If normalization is impossible, state that clearly.

## 5.4 Food Notebook

Notebook is a structured food and grocery journal, not a general notes replacement.

### Note fields

- Title.
- Rich plain text or lightweight Markdown body.
- Created and event dates.
- Note type.
- Tags.
- Linked products.
- Linked purchases.
- Optional photos.
- Optional mood or rating only if later validated as useful.

### Initial note types

- Food diary.
- Shopping note.
- Price observation.
- Product review.
- Meal idea.
- Custom food note.

### Connections

- A Product Review should link directly to a product page.
- A Price Observation can be converted into Later Buy or a purchase.
- A Meal Idea can later add selected ingredients to a shopping list.
- Every note appears on the shared calendar according to its event date.

## 5.5 Calendar

The calendar is the single date system for the entire application.

### Calendar views

- Month view with daily spend and small activity indicators.
- Week view in a later release.
- Day timeline showing purchases, Later Buy observations, reminders, notes, and shopping trips.

### Daily summary

A date may show:

- Total spent.
- Number of purchased products.
- Number of Later Buy observations.
- Number of notes.
- Category color indicators.

Tapping a date opens a chronological day timeline. Filters should let the user show all activity or only purchases, Later Buy, notes, and reminders.

## 5.6 Products

Products is the user's remembered catalog and price history.

### Product page

- Name, brand, variant, and package size.
- Generic or branded classification.
- Barcode when applicable.
- Category.
- Ingredients and nutrition when available.
- Preferred unit.
- Last price.
- Typical price range.
- Price history chart.
- Purchase frequency.
- Stores and recent prices.
- Active Later Buy status.
- Linked notes.
- Edit aliases and personal defaults.

### Product identity rules

Do not merge products only because their names are similar. Package size, variant, brand, and unit can make them materially different. Generic produce such as tomatoes may remain a general product with weight-based purchases. Branded packaged products should use exact variants where known.

## 5.7 Insights

Insights turns history into explanations and comparisons.

### Initial insights

- Current spending pace and projected monthly total.
- Month-over-month spending difference.
- Category budget status.
- Highest absolute price increases.
- Frequently repeated products.
- Products likely due for repurchase.
- Later Buy outcomes.
- Store-level basket comparisons when enough comparable data exists.
- Personal grocery inflation based on matched products and normalized units.

Every insight must include its basis or a path to supporting records. Avoid false precision when data is sparse.

## 5.8 Settings and Profile

- Language.
- Theme.
- DZD number formatting.
- First day of week.
- Monthly budget.
- Category budgets.
- Household size, optional.
- Default store, units, and purchase date behavior.
- Notification permissions and preferences.
- Data export and import.
- Local-only or cloud backup status.
- Account management.
- Product contribution consent.
- Privacy controls.

---

## 6. Information Architecture and Navigation

### 6.1 Recommended bottom navigation

Use five primary destinations:

1. **Home**
2. **Calendar**
3. **Add** as a visually distinct central action
4. **Later Buy**
5. **Notebook**

Products, Insights, Shopping Lists, Stores, and Settings are accessible from Home, search, or a secondary menu. If usability testing shows frequent product-history access, Products may replace Notebook in the bottom bar while Notebook moves to the secondary menu. Do not exceed five persistent navigation items.

### 6.2 Global search

Search should find:

- Products and aliases.
- Purchases.
- Notes.
- Stores.
- Categories.
- Later Buy items.

Search results must be grouped by type. Product search should work with normalized spelling and multilingual aliases.

### 6.3 Navigation state

Each bottom navigation branch should preserve its own navigation stack and scroll position. Quick Add appears above the current context and returns the user to the previous view after save.

---

## 7. Core User Flows

## 7.1 First launch

1. Choose interface language.
2. Explain local-first storage and optional backup.
3. Set an optional monthly grocery budget.
4. Set household size, optional.
5. Ask for notification permission only when the user creates the first reminder, not during an unexplained permission wall.
6. Enter Home with a clear Add Purchase action.

Account creation is skippable.

## 7.2 Add a known product

1. Tap Add.
2. Type part of the product name.
3. Select a personal product suggestion.
4. Last quantity, unit, and price context appear.
5. Enter or confirm current price.
6. Tap Bought.
7. Local transaction commits immediately.
8. Totals and comparisons update.
9. Background sync is queued if enabled.

## 7.3 Add an unknown product

1. Tap Add.
2. Search produces no suitable match.
3. Tap Create Product.
4. Enter only product name and necessary purchase data.
5. Optional metadata remains collapsed.
6. Save product and purchase in one local database transaction.

## 7.4 Scan barcode

1. Open Add and tap Scan.
2. Camera reads barcode locally.
3. Search local and cached catalog.
4. If not found and online, query remote catalog.
5. If found, open prefilled purchase form.
6. If not found, open Create Product with barcode filled.
7. The user enters price and saves.

## 7.5 Postpone an expensive product

1. Enter or scan product and current observed price.
2. Price context shows that it is higher than a comparable previous price.
3. Tap Buy Later.
4. Optionally set target price and reminder.
5. Save without changing monthly spending.
6. Later Buy receives the item and the calendar records the observation.

## 7.6 Resolve Later Buy

1. User opens the item or enters the same product in Calculator.
2. The app displays original observed price and target.
3. User chooses Bought.
4. Confirm current quantity, unit, price, store, and date.
5. Create purchase and mark Later Buy as bought in one transaction.
6. Display Was It Worth Waiting when values are comparable.

## 7.7 Add a notebook entry

1. Tap Notebook, then New Note.
2. Choose note type or blank food note.
3. Write title and body.
4. Link products or purchases if desired.
5. Choose event date.
6. Save locally.
7. Note appears in Notebook, linked product pages, and the Calendar.

---

## 8. UI and Design System

## 8.1 Visual direction

The interface should feel modern, calm, practical, and trustworthy. It should not resemble a bank dashboard overloaded with charts, nor a playful calorie app. Use strong typographic hierarchy, generous spacing, clear numbers, and restrained color.

### Suggested visual qualities

- Light and dark themes.
- Rounded but not cartoonish surfaces.
- High contrast for totals and primary actions.
- Color used to explain status, never as the only signal.
- Subtle motion for confirmations, state changes, and chart transitions.
- Large touch targets suitable for quick use while shopping.

## 8.2 Design tokens

Create semantic tokens rather than hard-coded colors:

- `colorPrimary`
- `colorOnPrimary`
- `colorSurface`
- `colorSurfaceElevated`
- `colorTextPrimary`
- `colorTextSecondary`
- `colorSuccess`
- `colorWarning`
- `colorDanger`
- `colorInfo`
- `colorPriceIncrease`
- `colorPriceDecrease`
- category colors

Also define spacing, radii, shadows, typography, animation duration, and chart tokens in one theme layer.

## 8.3 Typography and localization

Choose typefaces with complete Arabic, Latin, French accent, and numeral support. Test mixed-direction strings such as an Arabic product name followed by `1 L` and `650 DA`. Respect right-to-left layout instead of only right-aligning text.

## 8.4 Reusable components

- Money display.
- Budget progress card.
- Product suggestion row.
- Product avatar or category icon.
- Quantity and unit input.
- Price input with total/unit toggle.
- Date and time picker.
- Store selector.
- Category chip.
- Insight card with explanation.
- Empty state.
- Error state.
- Offline and sync status indicator.
- Calendar day cell.
- Daily timeline item.
- Price change badge.
- Bottom sheet scaffold.
- Destructive confirmation dialog.

## 8.5 Accessibility

- Minimum 44 by 44 logical pixel interactive targets.
- Dynamic type support where practical.
- Screen-reader labels for icons, charts, and states.
- Do not communicate increases and decreases with red and green alone.
- Respect reduced-motion settings.
- Support keyboard navigation for future tablet and desktop targets.
- Ensure charts have textual summaries.

---

## 9. Recommended Technology Stack

| Layer | Recommendation | Reason |
|---|---|---|
| Mobile framework | Flutter | One Android and iOS codebase with strong custom UI control |
| Language | Dart | Native Flutter language, sound null safety, productive tooling |
| State management | Riverpod | Testable dependency injection and predictable asynchronous state |
| Navigation | GoRouter | Declarative routing, deep links, nested navigation |
| Local database | Drift on SQLite | Typed relational queries, migrations, streams, transactions |
| Immutable models | Freezed where useful | Value equality and union states, without applying code generation everywhere |
| Serialization | json_serializable | Predictable API model conversion |
| Cloud database | Supabase PostgreSQL | Relational model, SQL analytics, row-level security |
| Authentication | Supabase Auth | Optional accounts and cross-device identity |
| Server functions | Supabase Edge Functions | Trusted operations, catalog moderation, and later AI proxying |
| File storage | Supabase Storage | Optional note images and exported backups |
| Barcode scanning | mobile_scanner | Cross-platform camera scanning |
| Notifications | flutter_local_notifications | Offline local reminders |
| Secure secrets | flutter_secure_storage | Session tokens and device secrets |
| Charts | fl_chart or equivalent maintained package | Native Flutter visualizations |
| Monitoring | Sentry or equivalent, opt-in policy compliant | Crash and performance diagnosis |
| CI | GitHub Actions | Analyze, test, build, and migration checks |

Package versions must be selected at implementation time from current stable releases. Future agents must not copy stale version numbers from this document.

---

## 10. Application Architecture

Use a feature-first Clean Architecture variant without turning every operation into unnecessary boilerplate.

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router/
    theme/
    localization/
  core/
    database/
    network/
    sync/
    money/
    units/
    errors/
    logging/
    widgets/
  features/
    home/
      data/
      domain/
      presentation/
    purchases/
    products/
    later_buy/
    notebook/
    calendar/
    insights/
    shopping_lists/
    settings/
  shared/
    models/
    providers/
```

### 10.1 Layer responsibilities

**Presentation** owns screens, widgets, view state, input validation presentation, and navigation events.

**Domain** owns business concepts and rules such as comparable prices, monthly projections, recurring purchase detection, and Later Buy resolution.

**Data** owns repository implementations, local data access, remote data access, mapping, synchronization metadata, and caching.

Do not let widgets call Supabase, SQLite, notification plugins, or AI APIs directly.

### 10.2 Repository pattern

Define interfaces at the feature or domain boundary:

```dart
abstract interface class PurchaseRepository {
  Stream<List<Purchase>> watchPurchases(PurchaseFilter filter);
  Future<Purchase> createPurchase(CreatePurchaseCommand command);
  Future<void> updatePurchase(UpdatePurchaseCommand command);
  Future<void> deletePurchase(String id);
}
```

Repository implementations write locally first, then enqueue synchronization. UI observes local database streams so it reacts instantly.

### 10.3 Dependency direction

- Presentation may depend on domain abstractions.
- Domain must not depend on Flutter UI, Supabase, SQLite, or plugins.
- Data implements domain repository contracts.
- Platform-specific services are wrapped behind interfaces.

### 10.4 Error model

Use typed failures such as:

- Validation failure.
- Not found.
- Database failure.
- Sync conflict.
- Authentication failure.
- Network unavailable.
- Permission denied.
- Catalog rate limit.
- Unsupported unit conversion.

Map technical errors to short user-facing messages. Log diagnostic context without logging private note contents or full purchase histories.

---

## 11. Local Data Model

Use UUIDv7 or another sortable globally unique identifier generated on device. Every synchronizable row should include:

- `id`
- `owner_id`, nullable before account attachment if needed
- `created_at`
- `updated_at`
- `deleted_at`, nullable tombstone
- `sync_state`
- `device_id`
- `server_version`, nullable

### 11.1 Core tables

#### users_local

- local profile identifier
- remote user identifier, nullable
- preferred language
- monthly budget
- household size
- first day of week
- cloud sync enabled

#### products

- id
- canonical product id, nullable reference to shared catalog
- personal display name
- normalized search name
- brand
- variant
- barcode
- category id
- product type: generic, branded, imported, custom
- package quantity
- package unit
- preferred purchase unit
- ingredients text, nullable
- nutrition JSON or normalized child records later
- archived flag

#### product_aliases

- id
- product id
- alias
- normalized alias
- language code, nullable
- source: user, catalog, imported

#### purchases

- id
- product id
- shopping trip id, nullable
- quantity decimal
- unit id
- entered price integer
- price mode: total or per-unit
- computed total DZD integer
- normalized base quantity decimal, nullable
- normalized DZD per base unit decimal, nullable
- store id, nullable
- category snapshot id or name
- purchased at UTC timestamp
- local timezone identifier or offset snapshot
- expiry date, nullable
- note, nullable

#### shopping_trips

- id
- title, nullable
- store id, nullable
- started at
- completed at, nullable
- estimated total
- actual total derived from purchases

#### later_buy_items

- id
- product id
- observed quantity
- observed unit
- observed price
- observed normalized price, nullable
- target price, nullable
- target normalized price, nullable
- store id, nullable
- reason
- status
- reminder at, nullable
- resolved purchase id, nullable
- created at
- resolved at, nullable

#### notes

- id
- title
- body
- note type
- event at
- created at
- updated at

#### note_product_links

- note id
- product id

#### note_purchase_links

- note id
- purchase id

#### note_attachments

- id
- note id
- local URI
- remote storage path, nullable
- MIME type
- upload state

#### categories

- id
- name
- icon key
- color key
- parent category id, nullable
- monthly budget, nullable
- system or custom flag

#### stores

- id
- name
- optional branch or area
- optional latitude and longitude only with explicit user action
- archived flag

#### reminders

- id
- related entity type
- related entity id
- scheduled at
- recurrence rule, nullable
- local notification id
- enabled
- delivered at, nullable

#### shopping_lists and shopping_list_items

Plan for these tables even if the interface ships after the first MVP. Items should reference products where possible and store quantity, unit, estimate, checked state, and converted purchase id.

#### sync_queue

- operation id
- entity type
- entity id
- operation: upsert or delete
- payload version
- attempts
- next retry at
- last error code

### 11.2 Money representation

DZD currently has practical whole-dinar usage for this application. Store entered and total monetary values as integer DZD to avoid floating-point errors. Use decimal types only for normalized unit calculations and quantities.

Never store money in a binary floating-point type.

### 11.3 Quantity and unit representation

Create a unit registry with dimensions:

- mass: g, kg
- volume: ml, cl, L
- count: piece, pack, tray, dozen, can, bottle, bag

Convert only compatible units. A pack cannot be compared with a piece unless a product-specific conversion is known. Preserve the original entered quantity and unit even when normalized values are available.

---

## 12. Backend Architecture

## 12.1 Supabase responsibilities

Supabase should provide:

- Optional user authentication.
- Encrypted transport and server-side access controls.
- Cloud backup and multi-device synchronization.
- Shared Algerian product catalog.
- Barcode lookup.
- Moderated user product submissions.
- Optional note-image storage.
- Server-side analytics jobs when local calculation is insufficient.
- Secure proxy for future AI providers.

Core app use must not require Supabase availability.

## 12.2 Suggested cloud schemas

### Private user schema

Mirror synchronizable local entities using `user_id` ownership:

- profiles
- user_products
- purchases
- shopping_trips
- later_buy_items
- notes
- note links
- categories
- stores
- reminders metadata
- shopping lists

### Shared catalog schema

- catalog_products
- catalog_aliases
- catalog_barcodes
- brands
- catalog_categories
- product_ingredients
- nutrition_facts
- product_submissions
- submission_evidence
- moderation_actions

Do not mix shared catalog editing rights with private user records.

## 12.3 Row-level security

Enable Row Level Security on every user-owned table.

Policies must enforce:

- A signed-in user can select only rows where `user_id = auth.uid()`.
- Inserts require `user_id = auth.uid()`.
- Updates and deletes require ownership.
- Shared catalog is readable by clients but writable only through trusted functions or moderator roles.
- Product submissions are insertable by authenticated users and readable by their owners, with moderation access controlled separately.

Never rely on hidden UI controls as authorization.

## 12.4 Authentication

Allow local-only use first. Cloud backup requires an account. Initial sign-in options can be email magic link or OTP, depending on current Supabase support and delivery reliability in the target market.

Account linking must attach existing local data without duplication. The linking process should:

1. Authenticate.
2. Assign ownership to local records.
3. Pull remote changes.
4. Reconcile IDs and duplicates.
5. Push unsynced local records.
6. Confirm completion while keeping local copies.

## 12.5 Edge Functions

Use server functions for operations that require trusted credentials or validation:

- Submit or moderate shared products.
- Merge approved catalog duplicates.
- Request external barcode providers.
- Generate signed upload operations if needed.
- Call a future AI provider without exposing keys.
- Apply abuse and rate limits.

Do not move simple spending calculations to server functions.

---

## 13. Offline-First Synchronization

## 13.1 Source of truth

For interactive app behavior, SQLite is the operational source of truth. Supabase is a synchronized backup and shared-data service.

## 13.2 Local write sequence

1. Validate command.
2. Start SQLite transaction.
3. Write or update domain row.
4. Add sync queue operation if cloud sync is enabled.
5. Commit transaction.
6. UI updates from database stream.
7. Background worker attempts upload.

The user must never wait for the network to confirm a normal local entry.

## 13.3 Pull sequence

- Store a per-table or global sync cursor.
- Fetch rows updated after the cursor, including tombstones.
- Apply changes in a local transaction.
- Advance cursor only after the full batch succeeds.
- Retry with exponential backoff and jitter.

## 13.4 Conflict policy

Use explicit policies by entity:

- Purchases: last valid edit wins initially, but retain audit metadata for diagnosis.
- Notes: detect concurrent body edits and preserve both versions rather than silently discarding text.
- Product personal defaults: latest update wins.
- Shared catalog: server is authoritative.
- Deletes: tombstones win unless a later explicit restore exists.

Do not implement a universal last-write-wins policy without considering data loss.

## 13.5 Idempotency

Every queued operation must have a unique operation ID. Server upserts must be safe to repeat. A timeout after upload must not create a duplicate purchase when retried.

---

## 14. Smart Rules Engine

Implement deterministic intelligence as pure Dart services with unit tests.

## 14.1 Price change

Compare only compatible products and units.

```text
percentage_change = ((current_normalized_price - previous_normalized_price)
                    / previous_normalized_price) * 100
```

If no normalized comparison exists, compare exact same product and package only. Show both absolute and percentage difference when meaningful.

## 14.2 Typical price range

For a product with enough observations, use a robust range such as median and interquartile behavior rather than a raw average that is distorted by mistakes. Exclude obvious invalid values only with transparent rules, not silent arbitrary deletion.

## 14.3 Monthly projection

A simple first version:

```text
elapsed_fraction = elapsed_days / days_in_month
projected_total = spent_so_far / elapsed_fraction
```

Improve later using day-of-week and historical purchase patterns. Do not show a strong warning in the first few days unless the overspend is extreme. Label projections as estimates.

## 14.4 Threshold detection

Support:

- Absolute monthly budget threshold.
- Category budget thresholds.
- Spending pace threshold.
- Unusual purchase amount relative to a product's history.
- High price relative to the product's typical normalized range.

Provide actionable explanations. "You may exceed the budget" is incomplete. Prefer "At the current pace, projected spending is about 12,400 DA above your 60,000 DA budget. Meat accounts for 48% of the increase versus last month."

## 14.5 Recurring purchase detection

For each frequently purchased product:

1. Sort purchase dates.
2. Calculate gaps.
3. Require a minimum number of observations.
4. Use median gap and a tolerance band.
5. Reduce confidence when intervals vary widely.
6. Suggest a restock only within a reasonable due window.

Do not claim a habit from two purchases.

## 14.6 Unit-price comparison

Normalize mass to DZD/kg, volume to DZD/L, and exact count items to DZD/piece where conversion is known. Display the calculation and package assumptions.

## 14.7 Personal grocery inflation

Build an index only from products purchased in both comparison periods with compatible quantities. Weighting can begin with the user's earlier-period spending share. State coverage, for example: "Based on 18 matched products representing 71% of last month's recorded spending."

## 14.8 Suggestion ranking

Rank suggestions by usefulness and confidence. Limit Home to a few items. Inputs can include:

- Budget risk.
- Reminder due state.
- Expected recurring purchase.
- Later Buy target met.
- Expiry approaching.
- Material price change.
- Missing data that blocks a valuable comparison.

Never flood the user with repeated low-value alerts.

---

## 15. AI and Product Detection Strategy

## 15.1 What should not use generative AI

- Totals.
- Budget progress.
- Price differences.
- Unit conversions.
- Recurring date detection.
- Threshold warnings.
- Calendar organization.
- Product search over known records.
- Reminder scheduling.

These are cheaper, faster, safer, and more testable as deterministic code.

## 15.2 Appropriate later AI uses

- Parse a messy natural-language entry such as "2 kg chicken 980 each from market" into a reviewable draft.
- Explain ingredient lists in plain language without making medical claims.
- Compare two product ingredient lists using cited catalog data.
- Produce spending reduction suggestions grounded only in selected user history.
- Suggest likely catalog matches from uncertain package text or an OCR result.
- Translate and normalize product names across Arabic, French, English, and Darja spellings.

## 15.3 AI safety and trust rules

- AI output is advisory and visibly labeled.
- Never invent product ingredients or nutrition.
- Show the source record used for product facts.
- Require user confirmation before AI creates or changes purchases.
- Never make medical diagnoses.
- Do not send private history to an AI provider without explicit feature use and clear disclosure.
- Send only the minimum data required for the request.
- Provide a non-AI path for all essential tasks.

## 15.4 Product recognition pipeline

Use this order:

1. Exact barcode match.
2. Exact personal product or alias match.
3. Exact shared catalog match.
4. Normalized text search.
5. Fuzzy candidate search.
6. Optional OCR or AI-assisted candidate ranking.
7. User confirmation.

AI should rank candidates, not silently decide product identity.

---

## 16. Algerian Product Catalog

The catalog must support generic fresh foods, Algerian branded products, and imports.

### 16.1 Catalog quality levels

- **Verified:** reviewed by a trusted moderator or official source.
- **Community confirmed:** corroborated by multiple reliable submissions.
- **User submitted:** visible with caution where appropriate.
- **Personal only:** stored for one user and not submitted.

### 16.2 Required catalog fields

- Canonical name.
- Localized names.
- Brand.
- Variant.
- Package amount and unit.
- Barcode or barcodes.
- Category.
- Country or market availability when known.
- Ingredients with source date.
- Nutrition with serving basis.
- Source and verification status.
- Created and updated timestamps.

Prices should not live as a single global product field. Prices are observations tied to time, quantity, user or aggregate region, and store. Version 1 should rely primarily on the user's private price history.

### 16.3 Contribution workflow

If a barcode is unknown:

1. User creates a personal product.
2. App asks separately whether to submit catalog details.
3. Submission excludes private purchase history unless the user explicitly contributes an anonymized observation.
4. Server validates required fields and rate limits.
5. Moderation checks duplicates and evidence.
6. Approved product receives a canonical catalog ID.
7. Personal record can link to the canonical product without losing custom naming.

---

## 17. Notifications and Reminders

### Initial notification types

- User-selected Later Buy date.
- Expected recurring purchase.
- Target price met from a newly entered personal observation.
- Monthly budget pace warning.
- Category threshold warning.
- Expiry reminder when expiry tracking is enabled.

### Notification rules

- Ask permission contextually.
- Let users disable each category.
- Apply quiet hours.
- Deduplicate repeated alerts.
- Do not imply live price monitoring unless the system actually has a current external observation.
- Local reminders must work offline.
- Tapping a notification deep-links to its exact item.

---

## 18. Security, Privacy, and Data Governance

### 18.1 Local security

- Store auth tokens in secure platform storage.
- Do not put secrets in source control or application assets.
- Consider optional app lock in a later release.
- Use database encryption only after evaluating performance, key recovery, and platform support. Do not advertise encryption at rest unless implemented and verified.

### 18.2 Network security

- HTTPS only.
- Validate server responses.
- Apply rate limits to catalog search, submissions, uploads, and AI routes.
- Keep service-role and AI provider keys server-side.

### 18.3 Data controls

Users should be able to:

- Export their data in readable JSON or CSV.
- Delete individual records.
- Delete cloud data and account.
- Continue in local-only mode where feasible.
- See last successful sync.
- Understand what product data is private versus contributed.

### 18.4 Analytics

Use privacy-conscious analytics only if needed. Avoid sending product names, notebook text, exact grocery histories, or precise location as event properties. Make crash reports scrub sensitive values.

---

## 19. Performance Requirements

- Cold start target on a normal mid-range Android device: under 2 seconds where practical.
- Quick Add form usable immediately after opening.
- Local product suggestions returned in under 100 ms for common catalogs.
- Local purchase save perceived as instant, ideally under 150 ms.
- Smooth scrolling at device refresh rate.
- Calendar month changes without visible database stalls.
- Charts aggregate data outside widget build methods.
- Shared catalog search uses pagination and cached results.
- Image attachments are resized before upload.

Performance testing must include lower-cost Android devices, not only flagship phones and emulators.

---

## 20. Testing Strategy

## 20.1 Unit tests

Prioritize:

- Money calculations.
- Unit normalization.
- Price comparison eligibility.
- Percentage changes.
- Budget projection.
- Recurrence detection.
- Later Buy outcome calculation.
- Date boundaries and timezone handling.
- Search normalization.
- Conflict resolution.

## 20.2 Database tests

- Migrations from every supported schema version.
- Transaction rollback.
- Foreign key behavior.
- Tombstones and sync queue writes.
- Large histories and aggregate queries.

## 20.3 Widget tests

- Quick Add validation.
- Product suggestions.
- Bought versus Buy Later behavior.
- Empty and error states.
- RTL layouts.
- Large text scaling.

## 20.4 Integration tests

- First launch to first purchase.
- Offline creation followed by online sync.
- Account linking with existing local data.
- Barcode found and not-found paths.
- Later Buy conversion to purchase.
- Notebook links and Calendar appearance.
- Notification deep links.
- Delete and restore conflict cases.

## 20.5 Golden tests

Use golden image tests for critical components in light, dark, English, French, and Arabic layouts. Keep goldens focused on stable UI primitives rather than every full screen.

## 20.6 Backend tests

- RLS policies with multiple users.
- Anonymous access rejection to private data.
- Catalog read rules.
- Submission moderation permissions.
- Edge Function validation and rate limiting.

---

## 21. Observability

- Structured logs with severity and operation IDs.
- Crash reporting with private fields removed.
- Sync success, failure, retry, and queue-depth diagnostics.
- Database migration outcome.
- Performance spans for startup, search, calendar queries, and sync.
- A user-accessible diagnostics export that excludes secret tokens and optionally excludes content.

Do not use logs as a shadow database of user behavior.

---

## 22. Development and Deployment

### 22.1 Environments

- Local development.
- Staging Supabase project.
- Production Supabase project.

Never share production credentials with development builds.

### 22.2 Configuration

Use compile-time environment definitions or a controlled configuration layer for public endpoint identifiers. Secrets remain on the server. Provide an `.env.example` only for non-secret placeholders and document setup.

### 22.3 Continuous integration

Every pull request should run:

- Dart formatting check.
- Static analysis.
- Unit and widget tests.
- Database migration tests.
- Secret scan.
- Build smoke test.

Protected release workflows should build signed Android and iOS artifacts using secured CI secrets.

### 22.4 Database migrations

- Local Drift migrations are versioned and tested.
- Supabase SQL migrations are committed in order.
- Destructive migrations require backup and rollback planning.
- Schema changes should remain backward compatible during rolling client adoption where possible.

---

## 23. Delivery Roadmap

## Phase 0: Product foundation

- Confirm product name and visual direction.
- Create user flows and low-fidelity wireframes.
- Validate Quick Add with prospective users.
- Define categories, units, and terminology in Arabic, French, and English.
- Set up repository, CI, linting, themes, and navigation shell.

## Phase 1: Local MVP

- Local-only onboarding.
- Products and aliases.
- Quick Add purchase flow.
- Monthly total and budget.
- Purchase history.
- Calendar month and daily timeline.
- Later Buy with manual reminders.
- Food Notebook and product links.
- Basic price comparison.
- Local export.

**Exit condition:** a user can rely on the app for a complete month without creating an account or using the internet.

## Phase 2: Useful intelligence

- Category budgets.
- Spending projection.
- Recurring purchase detection.
- Typical price range.
- Unit-price comparisons.
- Was It Worth Waiting.
- Improved Insights.
- Shopping trips and basket replay.

## Phase 3: Cloud backup and sync

- Supabase Auth.
- Account linking.
- RLS-secured cloud schema.
- Background synchronization.
- Multi-device conflict handling.
- Optional note-image backup.

## Phase 4: Product recognition

- Barcode scanner.
- Shared Algerian product catalog.
- Unknown-product creation.
- Community submissions and moderation.
- Multilingual aliases.

## Phase 5: Carefully scoped AI

- Natural-language entry draft.
- Ingredient explanation.
- Grounded product comparison.
- Personalized spending suggestions.

Do not begin Phase 5 until the app has sufficient reliable structured data and the core workflows are measurably fast.

---

## 24. Acceptance Criteria for the First Public MVP

The MVP is acceptable only when all statements below are true:

- A new user can add the first purchase without creating an account.
- A repeated product can be recorded in a few seconds.
- Purchases work with airplane mode enabled.
- Monthly totals remain correct after edits and deletes.
- Price comparison never compares incompatible units as if they were equivalent.
- Later Buy does not affect spending until converted to Bought.
- A Later Buy item can be converted without retyping the full product.
- Notes preserve their dates and product links.
- Calendar totals match purchase history.
- Local reminders survive application restart and device reboot where the platform permits.
- Arabic RTL screens remain usable and visually correct.
- Export produces readable user-owned data.
- Database migrations preserve existing test data.
- No private record can be accessed by another cloud test user.

---

## 25. Decisions That Must Be Confirmed Before Implementation

These choices are intentionally not invented in this blueprint:

- Final product name and logo.
- Initial interface languages and translation ownership.
- Whether the first release is Android-only or simultaneous Android and iOS.
- Whether household sharing is required or only individual multi-device sync.
- Whether note photos belong in the MVP.
- Which authentication method is reliable for Algerian users.
- Whether prices may include fractional dinars.
- Whether shopping lists ship in Phase 1 or Phase 2.
- Whether catalog contributions are anonymous, authenticated, or disabled at launch.
- Product information sources and their licenses.

Future agents should ask about these only when the answer affects their assigned work. They should not block an unrelated local feature on every unresolved product decision.

---

## 26. Instructions for Future AI Coding Agents

This section is an execution contract for any AI agent asked to create or modify the application.

### 26.1 First actions

Before changing code, the agent must:

1. Read this entire document.
2. Inspect the repository structure and all applicable `AGENTS.md`, README, architecture, and contribution files.
3. Inspect current dependencies, schema versions, migrations, tests, and uncommitted changes.
4. State the exact feature or phase being implemented.
5. Identify whether the requested behavior belongs to local core, sync, shared catalog, or optional AI.
6. Create a short implementation plan for work that spans multiple files.
7. Preserve unrelated user changes in a dirty worktree.

### 26.2 Non-negotiable architecture rules

- Flutter and Dart are the default application stack unless the project owner explicitly changes the decision.
- Core features must remain usable offline.
- UI widgets must not call Supabase, SQLite, notification plugins, or AI services directly.
- All money calculations must use safe integer or decimal representations, never binary floating point.
- All important business rules must be testable without a Flutter UI or live backend.
- Cloud tables containing private data must have verified RLS policies.
- AI must not be required to add, edit, view, or calculate purchases.
- Shared catalog data and private user data must remain logically separated.
- New schema fields require migrations and migration tests.
- Destructive data changes require explicit approval and a recovery plan.

### 26.3 Implementation behavior

For each feature, the agent should work vertically:

1. Define or update the domain model and rules.
2. Add local schema and migration if needed.
3. Implement repository behavior.
4. Add state providers or controllers.
5. Build accessible UI states.
6. Add unit, database, and widget tests.
7. Add synchronization mapping only when cloud sync is part of the requested phase.
8. Run formatter, analyzer, relevant tests, and a build smoke test.
9. Report changed files, verified behavior, remaining limitations, and any migration impact.

Avoid creating dozens of abstractions for a small feature. Architecture exists to preserve testability, data safety, and replaceable infrastructure, not to maximize file count.

### 26.4 UI implementation rules

- Use the shared design system and semantic tokens.
- Reuse established components before creating near-duplicates.
- Implement loading, empty, error, offline, and success states.
- Test both left-to-right and right-to-left layouts.
- Keep primary purchase entry fields visible and optional metadata collapsed.
- Never add a confirmation dialog to a frequent safe action unless undo cannot protect the user.
- Use undo for reversible deletion where practical.
- Preserve navigation and form state during common interruptions.

### 26.5 Data and sync rules

- Local writes complete before background network work.
- Related writes use database transactions.
- Sync operations are idempotent.
- Deletes synchronize through tombstones.
- Retried operations must not duplicate purchases, notes, or attachments.
- Never advance a sync cursor before a full batch commits.
- A merge conflict involving note text must not silently destroy either version.
- Store timestamps in UTC and preserve enough local timezone context for correct calendar grouping.

### 26.6 Smart feature rules

Before implementing any feature called smart or AI, classify it:

**Calculation:** implement as deterministic Dart logic.  
**Pattern detection:** implement with explainable statistics and confidence requirements.  
**External product lookup:** implement through a catalog service with sources and caching.  
**Generative interpretation:** use an AI service only if the first three categories cannot solve it well.

Every insight must be traceable to records and assumptions. Do not present estimates as facts.

### 26.7 Product catalog rules

- Never fabricate ingredients, nutrition, barcodes, brands, or package sizes.
- Preserve verification status and source dates.
- Require user confirmation when fuzzy matching could select the wrong product.
- Do not merge catalog products based on name alone.
- Keep personal aliases after linking to a canonical catalog product.

### 26.8 Security rules

- Do not commit secrets.
- Do not expose service-role keys or AI keys to the mobile client.
- Add RLS tests for every private cloud table.
- Sanitize logs and crash reports.
- Validate all server function input.
- Apply file size, MIME type, and rate restrictions to uploads.
- Treat notebook bodies and purchase histories as sensitive.

### 26.9 Quality gate

An agent must not call a feature complete merely because it renders. Completion requires:

- Correct behavior for the normal path.
- Validation and useful errors.
- Offline behavior where applicable.
- Empty state.
- Edit and delete behavior where relevant.
- Accessibility semantics.
- Tests for business rules and regression risks.
- Analyzer and test suite success.
- Documented limitations.

### 26.10 Prohibited shortcuts

- Do not replace the relational model with unstructured JSON blobs for convenience.
- Do not make network responses the direct UI source of truth.
- Do not perform money math in widgets.
- Do not compare packages without unit compatibility.
- Do not request every device permission during onboarding.
- Do not send full personal histories to AI by default.
- Do not create a separate calendar data store for each module.
- Do not duplicate products independently in Calculator, Later Buy, and Notebook.
- Do not hide incomplete work behind mock values in production paths.
- Do not silently alter or delete user data during migrations.

---

## 27. Reusable Prompt for a Future Build Agent

Copy the prompt below into a future coding session together with this file and the current repository.

```text
You are implementing the Algerian Grocery Companion mobile application.

Read Algerian_Grocery_Companion_Product_and_Engineering_Blueprint.md in full before taking action. Treat it as the current product and architecture source of truth unless a newer explicit decision from the project owner overrides it.

Your assigned scope is: [INSERT ONE FEATURE OR PHASE].

Before editing:
1. Inspect the repository, applicable AGENTS.md files, current architecture, local database schema, migrations, tests, and worktree changes.
2. Explain what already exists and identify the smallest coherent implementation slice.
3. List assumptions and ask only questions that materially block the assigned scope.
4. Produce a concise plan with verification steps.

Implementation requirements:
- Use Flutter and Dart with the established project conventions.
- Keep core behavior offline-first.
- Use Drift/SQLite through repositories, never directly from widgets.
- Keep deterministic smart logic in pure, tested Dart services.
- Store DZD safely as integers and quantities or normalized rates as decimals.
- Preserve original quantities and units.
- Reuse the unified Product, Calendar, Purchase, Later Buy, and Notebook models.
- Add migrations for schema changes and test those migrations.
- Add accessible loading, empty, error, offline, and success UI states.
- Support RTL and mixed Arabic/Latin content.
- Do not expose secrets or bypass Supabase RLS.
- Do not add generative AI where calculations, statistics, or catalog search are sufficient.
- Preserve unrelated existing changes.

Verification requirements:
- Format changed Dart files.
- Run static analysis.
- Run targeted tests and the relevant broader suite.
- Run a build smoke test when the environment permits.
- Inspect the final diff for accidental changes, secrets, placeholders, and untested schema modifications.

Final report:
- State the delivered behavior first.
- List key files changed.
- Report commands and tests run with results.
- Explain migrations or setup needed.
- State known limitations and the next smallest useful step.

Do not claim completion if the code only renders or if tests were not run. If blocked, preserve completed safe work and report the exact blocker with evidence.
```

---

## 28. Suggested First Repository Milestone

The first engineering milestone should prove the core architecture without building the entire product:

1. Flutter application shell with light, dark, and RTL-capable themes.
2. Home, Calendar, Add, Later Buy, and Notebook navigation placeholders.
3. Drift database with Product and Purchase tables plus tested first migration.
4. Product repository and Purchase repository.
5. Quick Add for a custom product and purchase.
6. Current-month total derived from local purchases.
7. Purchase shown on its Calendar date.
8. Edit and delete with correct total recalculation.
9. Unit tests for DZD totals and date grouping.
10. Widget or integration test covering first launch to first purchase.

This milestone deliberately excludes authentication, Supabase, barcode scanning, catalog data, and AI. If it is fast, reliable, and well tested, it establishes the foundation for every later feature.

---

## 29. Final Product Test

At every stage, evaluate the application with this scenario:

> A user is standing in a shop with weak internet. They previously bought Candia milk, 1 L, for 145 DA. Today it costs 165 DA. They want either to record the purchase immediately or postpone it, remember the observed price, and be reminded later. They should be able to do either action in seconds. The app should update the correct date, preserve the product history, explain the 20 DA increase, and function without a server response.

If a proposed architecture or feature makes this scenario slower, less reliable, or harder to understand, it needs strong justification.

