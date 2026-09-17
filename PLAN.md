# Qoffa · قفة — Production Implementation Plan

## 1. Summary and Locked Product Decisions

Build a new Flutter application in `D:\My Works\Food Calculator`, preserving the existing [engineering blueprint](<D:/My Works/Food Calculator/Algerian_Grocery_Companion_Product_and_Engineering_Blueprint.md>) and reference attachments.

Locked decisions:

- Product name: **Qoffa** in Latin interfaces and **قفة** in Arabic.
- Application IDs: `dz.qoffa.app` on Android and iOS.
- Platforms: Android 23+ and iOS 13+.
- Initial release is fully functional but **local-only**:
  - No Supabase dependency, authentication, SQL migrations, RLS, Edge Functions, remote catalog, synchronization queue, or cloud storage.
  - Settings clearly identify the application as local-only.
  - Repository boundaries and portable UUID-based records make a later cloud migration possible, but no unfinished cloud controls will be presented as working.
  - Multi-device sync, accounts, product contributions, and remote barcode lookup are explicitly deferred and excluded from v1 acceptance claims.
- First launch begins with an Arabic, French, or English language chooser. It then offers optional budget setup and enters the app; notification permission is requested only when the first reminder is created.
- All normal product, purchase, budget, Later Buy, Notebook, calendar, shopping-list, product-history, insight, barcode, notification, export, and import features work without a network.
- No generative AI is required or enabled. Future AI entry points remain documented, and essential behavior remains deterministic.

## 2. Experience, Theme, and Navigation

### Visual system

Reproduce the structure, hierarchy, proportions, rounded shapes, illustrations, and tactile personality of the four screenshots, reinterpreting the blue reference palette as the selected grocery-green system:

- Brand green: `#0AA343`
- Accessible action green: `#087D34`
- Pressed/deep green: `#056629`
- Pale mint background: `#E8FFEE`
- Mint surface tint: `#DDF7E5`
- White surface: `#FFFFFF`
- Primary navy text: `#071936`
- Secondary sage text: `#6E857A`
- Soft border: `#CAE6D2`
- Coral warning/Later Buy: `#FF6264`
- Notebook yellow: `#FFB416`
- Purchase/event mint: `#22C98D`

Use the brighter green for accents and progress indicators; use the deeper green behind white button text to meet contrast requirements. Define light, dark, and system themes through semantic tokens rather than widget-level colors.

Token scales:

- Spacing: 4, 8, 12, 16, 20, 24, 32, 40 logical pixels.
- Radii: 12 for controls, 16 for fields, 22 for compact cards, 28 for major cards and sheets.
- Touch targets: minimum 48×48.
- Shadows: restrained navy-tinted shadows with 6–10% opacity.
- Background: static mint geometric circles, facets, and bottom silhouettes inspired by the screenshots and PRISM; they must remain quiet behind content.
- Icons: rounded filled Phosphor-style icons inside soft tinted containers.
- Product artwork: coherent flat/vector grocery illustrations; never reuse the supplied screenshots as production assets.

### Typography

- Hero Sandwich Pro Variable from the PRISM project for Latin display headings, large totals, and selected navigation labels.
- Alexandria for Arabic and for all body text, fields, captions, buttons, and mixed-script strings.
- Major heading range: 30–44sp, bold/extra-bold.
- Section heading range: 20–26sp.
- Body range: 14–18sp.
- Numerals use tabular figures where totals align.
- Bundle both fonts locally so the interface works offline. Include Alexandria’s license. Hero Sandwich may ship only after its redistribution rights are recorded; otherwise Alexandria ExtraBold becomes the deterministic display fallback.
- Test mixed direction strings such as `حليب Candia 1 L · 165 DA` using true RTL layout, bidi isolation, mirrored directional icons, and locale-correct alignment—not merely right-aligned LTR widgets.

### Motion

Adapt PRISM’s tactile feel without turning Qoffa into a game:

- Button press: 2–3px downward travel over 80ms with the lower shadow compressing.
- Page/sheet transition: 180ms fade and slight vertical movement.
- Card insertion: 240ms staggered reveal.
- Purchase confirmation: compact 420ms check animation followed by a non-blocking result banner.
- No looping decorative animation on transactional screens.
- Respect operating-system reduced-motion settings.

### Navigation

Use `GoRouter` with an indexed stateful shell:

1. Home
2. Calendar
3. Raised central Add action
4. Later Buy
5. Notebook

Home, Calendar, Later Buy, and Notebook are persistent shell branches with independent navigation stacks and scroll restoration. Add opens a root-level full-screen transaction route rather than becoming a disposable tab.

Secondary routes cover Products, Product Details, Purchase History, Insights, Shopping Lists, Stores, Settings, Notebook editor, barcode scanner, and data import/export. The same bottom navigation appears on all applicable root screens; the inconsistent navigation in the Calendar reference is not copied.

## 3. Architecture, Data Model, and Interfaces

### Project structure

Use the blueprint’s feature-first organization:

- `app`: bootstrap, router, localization, themes, environment configuration.
- `core`: database, money, units, search normalization, notifications, attachments, import/export, errors, logging, shared widgets.
- `features`: home, purchases, products, later_buy, notebook, calendar, insights, shopping_lists, stores, settings.
- `shared`: immutable models, Riverpod providers, common commands and results.

Each substantial feature separates data, domain, and presentation. Widgets call Riverpod controllers/use cases only. Drift, scanners, notifications, filesystem APIs, and future AI boundaries remain behind repositories or services.

Use:

- Riverpod generated providers for dependency injection and state.
- GoRouter for routes.
- Drift/SQLite as the operational source of truth.
- Dart sealed types and immutable models; code generation only where it removes meaningful boilerplate.
- Stream-backed screens so local commits immediately update the UI.

### Local schema

Create Drift schema version 1 with transactions, indexes, foreign keys, and migration tests for:

- Local profiles and preferences
- Categories and monthly/category budgets
- Stores
- Products and aliases
- Product-specific package conversions
- Purchases
- Shopping trips
- Later Buy items
- Notes, tags, and note-tag links
- Note-product and note-purchase links
- Local attachments
- Reminders
- Shopping lists and shopping-list items
- App diagnostics and import history

Common records use UUIDv7 text IDs, local owner ID, device ID, UTC creation/update timestamps, optional deletion timestamp, and local version. Cloud-only state and synchronization tables are not added in v1.

Important rules:

- Products are never automatically merged by similar name.
- Brand, variant, package amount, package unit, barcode, and category remain independent identity attributes.
- Barcode duplicates generate a review warning but do not silently merge records.
- Deletions are initially soft deletes so undo, history consistency, and export remain reliable.
- Notes use many-to-many links to products and purchases.
- Calendar content is derived from source records rather than stored as a second set of totals.
- Development seed data is available only in debug builds and is visibly labeled. Release builds start with no fabricated catalog.

### Money, quantity, and time

- DZD values are signed 64-bit whole dinars; binary floating point is forbidden.
- Quantities use fixed-scale integers with six decimal places.
- Preserve the entered quantity, unit, price mode, and price.
- Comparable base quantities normalize to grams, millilitres, or pieces.
- Derived rates use fixed-scale integer micro-DZD values.
- A per-unit calculation that produces fractional dinars is previewed and rounded half-up only when committing the final transaction total.
- `dozen` converts to 12 pieces. Pack, tray, bottle, can, and bag convert only through an explicit product-specific conversion.
- Incompatible dimensions return an explicit non-comparable result rather than zero or a misleading percentage.
- Store event timestamps in UTC plus the originating timezone and local calendar date. Calendar grouping uses the saved local date so travel does not move historical purchases to another day.

### Search and public domain contracts

Index normalized product names, localized names, aliases, brands, and Notebook content with SQLite FTS5. Normalization may apply Unicode normalization, Latin case folding, Arabic diacritic/tatweel removal, safe Alef/Ya normalization, and whitespace cleanup, while always preserving the original text.

Product ranking follows:

1. Exact/prefix personal alias or product match
2. Frequently purchased products
3. Recently purchased products
4. Other personal products
5. Locally cached or bundled verified records, when available

Remote results are absent in local-only v1. Manual creation always remains available.

Define explicit interfaces for:

- `PurchaseRepository`
- `ProductRepository`
- `LaterBuyRepository`
- `NotebookRepository`
- `CalendarRepository`
- `ShoppingListRepository`
- `BudgetRepository`
- `SettingsRepository`
- `NotificationScheduler`
- `BarcodeLookupService`
- `AttachmentStore`
- `ExportImportService`
- `InsightEngine`
- `PriceComparabilityService`
- `UnitConversionService`
- `Clock`

Key result types include:

- Comparable price / incompatible price with reason
- Later Buy outcome with source record IDs
- Insight with explanation, assumptions, and evidence IDs
- Import preview, validation errors, and commit result
- Search suggestion with source tier and ranking explanation

## 4. Feature Implementation Sequence

### Foundation

- Scaffold Flutter, localization ARB files, themes, typography, router, Riverpod container, Drift database, logging, and error boundaries.
- Create reusable screenshot-derived components: tactile action button, rounded information card, metric tile, segmented control, form field, empty state, timeline row, calendar marker, bottom navigation, and geometric background.
- Add a short first-run flow: language, optional monthly budget, privacy/local-only explanation.
- Add local redacted diagnostic logs without analytics or user-content logging.

### Products and rapid purchase entry

Implement Products and Add Purchase first because all other modules depend on them.

Add Purchase behavior:

- Product, quantity, unit, price, price mode, and date/time.
- Optional store, category, brand, variant, package size, barcode, note, expiry, and trip.
- Selecting a known product prefills usual quantity/unit, category, and last store while showing—but not inserting—the previous price.
- Bought, Buy Later, and Add to Shopping List execute transactional local commands.
- Save commits before any secondary calculation or notification scheduling.
- A compact banner shows previous-price difference, typical-range position, unit rate, and budget effect only when supported.
- Sequential entry resets the form without a dialog and retains useful session context such as trip/store.
- Provide five-second Undo for newly created records.

Barcode behavior:

- Scan using `mobile_scanner`.
- Search personal/local products.
- Prefill a known product or open Create Product with the barcode retained.
- Require confirmation before saving.
- Scanner failure or denied permission never blocks manual entry.

### Home, budgets, history, and product details

Home contains:

- Current month and locale-formatted DZD totals
- Remaining or exceeded budget
- Progress and projected month-end total
- Month-to-date comparison against the same number of days in the previous month
- Quick Add
- Recent purchases
- Important Later Buy reminders
- Expected recurring purchases
- Category summary
- No more than three high-value insight cards

Projection uses current spend divided by elapsed calendar days, multiplied by days in the month, and is always labeled as an estimate.

Product Details includes verified facts, aliases, purchase frequency, store history, price history chart, typical range, active Later Buy item, and linked notes. Ingredients and nutrition remain empty unless the user entered or verified them.

### Later Buy, shopping lists, and notifications

Later Buy supports Active, Bought, Skipped, Dismissed, and Expired states.

- Matching is based on the same product ID, never fuzzy names.
- Conversion to purchase runs as one transaction and preserves the link.
- “Was It Worth Waiting?” is shown only for comparable units/packages.
- Outcome reports days waited, observed price, final price, absolute and percentage difference, and saved/extra amount.
- Target-reached notices are non-blocking.

Shopping Lists support multiple lists, quantities, notes, completion state, Add Purchase prefilling, and Add Purchase’s third action. They remain separate from Later Buy.

Notifications support:

- Later Buy reminders
- Expected repurchases
- Budget and category thresholds
- Newly reached target prices
- Optional expiry reminders
- Default quiet hours of 22:00–08:00
- Per-category controls
- One notification per crossed budget threshold per month

Schedules are reconciled on app startup and after relevant edits. Request permissions only when the first reminder is created.

### Notebook and unified Calendar

Notebook supports Markdown-lite text, note types, tags, event date, linked products/purchases, search, filters, and local attachments.

- Copy attachments into private application storage and retain checksum, MIME type, byte size, and original display name.
- Show note links from both Note and Product/Purchase views.
- Deleting a source record does not silently destroy the note.

Calendar provides one unified month view and daily timeline:

- Purchase, Later Buy, Notebook, reminder, and shopping-trip markers.
- Daily spending and product count.
- Filter chips without separate calendars.
- Chronological event timeline.
- Totals generated from the same purchase query used by Home/history.
- Explicit selected-date state preserved during navigation.

### Deterministic insights and settings

Implement pure Dart services for:

- Projection and spending pace
- Category thresholds
- Comparable price changes
- Unit-price comparison
- Typical price range
- Recurring purchase detection
- Later Buy outcomes
- Store comparisons
- Personal grocery inflation
- Search suggestion confidence

Statistical policies:

- Typical price range requires at least three comparable observations and uses median plus quartiles.
- Outlier exclusion begins only at five observations and uses the 1.5×IQR rule.
- Recurrence requires at least three purchases and uses median interval plus median absolute deviation.
- Store comparison requires overlapping comparable products rather than comparing unrelated baskets.
- Personal inflation requires at least three product variants with comparable observations in both periods and uses a weighted median percentage change.
- Every insight links to supporting records and states its sample size and assumptions.

Settings includes language, light/dark/system theme, localized DA/DZD/دج formatting, first weekday, monthly/category budgets, household size, default unit/store, notifications, quiet hours, privacy, diagnostics, and local-only status.

Export/import:

- Versioned `.qoffa` ZIP containing a manifest, JSON records, checksums, and attachments.
- Optional purchase CSV export.
- Import preview before mutation.
- Validate schema and checksums, create a safety backup, then import in one transaction.
- Merge by UUID/update version; never merge products based only on text.
- Warn that exported files contain private information.

## 5. Verification, CI, and Acceptance

Use the locally installed Flutter 3.44.6/Dart 3.12.2 baseline. Initial verified packages include [Riverpod 3.4.3](https://pub.dev/packages/flutter_riverpod), [GoRouter 18.0.1](https://pub.dev/packages/go_router), [Drift 2.35.0](https://pub.dev/packages/drift), [Drift Flutter 0.3.1](https://pub.dev/packages/drift_flutter), [mobile_scanner 7.4.2](https://pub.dev/packages/mobile_scanner), [flutter_local_notifications 22.3.1](https://pub.dev/packages/flutter_local_notifications), [fl_chart 1.2.0](https://pub.dev/packages/fl_chart), [uuid 4.6.0](https://pub.dev/packages/uuid), and [decimal 3.2.6](https://pub.dev/packages/decimal). Resolve and lock all remaining compatible packages during scaffolding.

GitHub Actions must run:

- Formatting verification
- Static analysis with fatal warnings
- Localization completeness checks
- Drift schema and migration validation
- Unit, repository, widget, golden, and integration tests
- Android build
- Unsigned iOS build on macOS
- Coverage reporting with at least 85% for domain calculation services and 70% overall executable Dart code

Required test scenarios:

- Integer money and fixed-scale quantity calculations
- Every compatible and incompatible unit combination
- Total/per-unit rounding
- Search normalization across Arabic, French, English, and Latin Darja aliases
- Product ranking and duplicate warnings
- Transaction rollback for product/purchase creation and Later Buy conversion
- Add/edit/delete persistence after restart in airplane mode
- Calendar/Home/history total equality
- Later Buy outcomes and non-comparable cases
- Note/product/purchase bidirectional links
- Notification permission, quiet hours, rescheduling, and threshold deduplication
- Barcode found, unknown, denied permission, and scanner failure
- Export/import round trip including attachments and duplicate IDs
- Arabic RTL, French accents, mixed-script text, and 200% text scaling
- Golden coverage for the four reference screens at common Android and iPhone dimensions
- Accessibility semantics, 48dp targets, and WCAG AA contrast
- Performance with at least 2,000 products and 10,000 purchases

Release acceptance:

- A known product can normally be selected, priced, and saved in three to five seconds.
- Local purchase commits complete without network dependency and target under 250ms on a mid-range test device.
- No floating-point money operations exist.
- No feature invents product facts, ingredients, nutrition, package size, or barcode.
- All user-facing strings come from localization resources.
- All required local modules operate as one connected product.
- The interface visibly matches the attached screen language—bold rounded headings, spacious white cards, raised central Add action, soft geometric background, tactile controls—using the selected green reinterpretation.
- Cloud accounts, synchronization, shared catalog, moderation, RLS, and backend security are documented as a separate future milestone and are not represented as implemented in this local-only release.
