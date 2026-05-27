# Career Principles — Reference

Source-of-truth for the 11 principles used by `self-assessment` and `self-assessment-li`. Structure follows L → E → C. Both skills read this before scoring.

**Every principle has an "Impact looks like:" line.** Use these outcome categories to keep self-review narrative impact-focused, not capability-focused.

---

## Leadership (L) — the group's work

> **Leadership = direction + alignment + standards + people growth.**
> Focus on **WHAT** leadership rather than HOW.
> Leadership is not a title — it is the ability to make a group more effective than it would be without you.

### L1. Direction Setting

**What it proves:** You turned ambiguity into a coherent technical path — for the team, not just yourself.

**Impact looks like:**
- Multiple teams aligned on one path instead of optimizing separately
- Ambiguity collapsed into a concrete plan others could execute
- Standard adopted across teams (review process, design pattern, metric definition)
- Recurring re-debate cycles eliminated
- Downstream consumers stopped re-asking the same question

**Look for in the artifact:**
- Drove a design or architecture decision that others now follow
- Set technical direction, culture, or best practice
- Navigated ambiguity *for the team*
- Influenced how others do their work, not just what you built yourself

**BAD → GOOD:**

- BAD: *"The dashboard is wrong; data infra needs to fix it."*
- GOOD: *"Defined the semantic differences between reporting, billing, and experiment metrics; established the source of truth for each decision and aligned product, DS, and infra on it — eliminating the weekly metric-disagreement thread."*

- BAD: *"I designed a new pipeline architecture."*
- GOOD: *"Led the architecture decision between streaming and micro-batch for the conversion pipeline, aligning data infra, modeling, and product on one path — collapsing three weeks of recurring design debate into one signed-off doc."*

---

### L2. Ownership Beyond Scope

**What it proves:** You went beyond your assigned ticket — picked up unowned problems and drove outcomes the team needed.

**Impact looks like:**
- Gap closed before it became an incident
- Team capability gained (lineage, runbook, dashboard) that outlasts the project
- Work shipped that wasn't on anyone's roadmap but the team needed
- Downstream consumers no longer blocked by an orphaned issue
- You became the de facto owner of a previously unowned area

**Look for in the artifact:**
- Spotted gaps proactively, no one asked
- Took responsibility for cross-project improvements
- Drove outcomes that benefited the broader team or the business, not just your immediate scope
- Followed through after launch (monitoring, post-launch improvements)

**BAD → GOOD:**

- BAD: *"That's not my team's responsibility."*
- GOOD: *"No team owned the reconciliation between billing and reporting; created the lineage and validation contract, then handed it to the natural long-term owner — eliminating a recurring source of advertiser-facing discrepancies."*

- BAD: *"The bug is in another team's code, so I'll file a ticket."*
- GOOD: *"Identified the upstream identity drift causing my pipeline's failures; root-caused and submitted the fix to the identity team's repo — eliminating a recurring class of incidents instead of working around them in my code."*

---

### L3. Influencing Without Authority

**What it proves:** You aligned people without title or escalation.

**Impact looks like:**
- Stakeholder decision unblocked without escalating to a manager
- Cross-team consensus reached on a contested trade-off
- Partners adopted your framing of a problem
- Conflict converted into a concrete decision with named owners
- Re-litigation of the same disagreement stopped

**Look for in the artifact:**
- Built consensus instead of pulling rank
- Articulated trade-offs clearly so others could choose
- Unblocked decisions where reasonable people disagreed
- Influenced cross-functional partners (PM, DS, infra, privacy, ops)

**BAD → GOOD:**

- BAD: *"Product wants speed, DS wants rigor, so we are blocked."*
- GOOD: *"Framed the speed-vs-rigor trade-off as two metric tiers (fast directional vs. slow verified) and aligned product and DS on shipping both — unblocking the launch without escalation."*

- BAD: *"DS rejected the modeling approach, so we're stuck."*
- GOOD: *"Reframed the modeling-vs-attribution dispute as a coverage-vs-causality trade-off, presented both with data costs, and aligned DS and product on a sequenced plan — unblocking the launch."*

---

### Strong Leadership Signals

- You made an ambiguous problem **legible** for the team.
- You changed the **quality of the decision**, not just the amount of code shipped.
- You aligned product, engineering, data, infra, and operations around a shared direction.
- You improved a **repeatable team practice**, not just one project.
- You helped someone else operate at a higher level.

---

## Execution (E) — your own work

> **Execution = decision quality + delivery quality + operational follow-through.**
> Focus on **WHY** execution rather than WHAT.

### E1. Technical Complexity & Problem Solving

**What it proves:** You solved a hard problem and made the hard part tractable.

**Impact looks like:**
- Latency/throughput improved by quantified X (X% cut, Y× throughput)
- Correctness restored across affected segments
- System property unlocked (idempotency, fault tolerance, ordering guarantee, recoverability)
- The next blocked project became unblockable
- Recurring incident class eliminated by an architectural change

**Look for in the artifact:**
- Ambiguous or underspecified problem framed clearly
- Cross-system or cross-team complexity navigated
- Scale, latency, or correctness constraints handled
- Key design decisions explicit (not just "I built X")

**BAD → GOOD:**

- BAD: *"I built the ETL job for conversions."*
- GOOD: *"Improved conversion measurement reliability by defining event semantics, handling late arrivals, and validating dashboard, bidding, and billing consistency — cutting reconciliation tickets by 60%."*

- BAD: *"I optimized the join."*
- GOOD: *"Replaced the broadcast join with sort-merge + range partitioning to handle the 100× skew in user-level events, cutting nightly runtime from 6h to 45min and stopping recurring midnight pages."*

---

### E2. Planning & Timeline Management

**What it proves:** You delivered on time by sequencing well and adjusting when reality changed.

**Impact looks like:**
- Shipped on time despite scope or requirements change
- Dependent teams unblocked N weeks earlier than the naïve plan
- Timeline reduced by deferring non-essential work without losing core value
- Checkpoints surfaced risk before it became a delay
- Re-planning happened *before* the deadline slipped, not after

**Look for in the artifact:**
- Milestones with checkpoints, owners, and explicit decision points
- Dependencies and sequencing called out
- Trade-offs made to meet a deadline (scope, timeline, or quality dial)
- Plan adjustments when requirements evolved

**BAD → GOOD:**

- BAD: *"We finished the migration in Q1."*
- GOOD: *"Sequenced the migration into shadow validation, segment-level deltas, controlled rollout, and post-launch monitoring; cut the original 8-week scope to 5 weeks by deferring two non-blocking sub-features."*

- BAD: *"We delayed by two weeks because of unexpected complexity."*
- GOOD: *"When the privacy-API change extended the integration spike from 1 to 3 weeks, deferred the analytics dashboard to phase 2 and shipped the critical pipeline on the original date — preserving the launch commitment to advertisers."*

---

### E3. Risk Identification & Mitigation

**What it proves:** You see production, dependency, migration, quality, and people risks early — and reduce blast radius.

**Impact looks like:**
- Incident prevented that would have caused [outage / billing variance / data loss]
- Rollback path validated before launch (not improvised at 2am)
- Blast radius bounded to one segment instead of all
- Late-event / double-counting / identity drift caught before production
- Risk surfaced early to the right owner instead of escalated late

**Look for in the artifact:**
- Risks named early (tech, data, dependency, org)
- Failure modes anticipated, fallback plans defined
- Mitigation owners assigned
- Incidents or delays prevented

**BAD → GOOD:**

- BAD: *"We shipped attribution v2 and will watch for issues."*
- GOOD: *"Ran shadow mode, compared deltas by advertiser segment, set alert thresholds, and staged rollout with rollback criteria — preventing double-counting and billing drift across N segments."*

- BAD: *"If it breaks, we'll roll back."*
- GOOD: *"Defined the rollback trigger (>5% advertiser delta vs baseline), automated the canary comparison, and ran the rollback playbook once in staging — turning rollback from a fire drill into a 10-minute operation."*

---

## Craftsmanship (C) — engineering quality and leverage

> **Craftsmanship = elegant code + reuse + craft processes + reviewing + metrics-driven improvement.**
> Apps IC4: uphold a high quality bar in code, reuse, testing/monitoring, code review, and metrics-driven improvement.

### C1. Elegant, Simple, Maintainable Code

**What it proves:** You uphold a high quality bar — your code is elegant, simple, and maintainable.

**Impact looks like:**
- Reduced bug rate or regression frequency
- Faster onboarding for new contributors
- Smaller diff to make non-trivial changes (the code stays bend-able)
- Review comments shifted from "what does this do" to substantive questions
- Refactoring sustained across multiple PRs without breaking callers

**Look for in the artifact:**
- Clear naming, structure, comments where they add real signal
- Refactor-as-you-go rather than accumulating debt
- Simplest abstraction that fits — no premature generalization
- Code readable by someone unfamiliar with the feature

**BAD → GOOD:**

- BAD: *"I added the new feature."*
- GOOD: *"Implemented the new event-tracker behind a clean event-source abstraction; reduced the touched-call-site count from 12 in the original draft to 1, making the next two planned features additive instead of branching."*

- BAD: *"Refactored some code."*
- GOOD: *"Extracted the conversion-validation logic into a single tested module replacing three near-duplicate implementations; cut the bug-fix patch size from ~150 LOC to ~30 LOC for the most recent two incidents."*

---

### C2. Reuse-First Mindset

**What it proves:** You design services/products for reuse — built once, leveraged by many.

**Impact looks like:**
- N teams adopted the shared component instead of building their own
- M duplicate implementations eliminated
- Common pattern published so future features start from it instead of from scratch
- Bootstrap time for new features reduced by quantified X%
- One-off turned into a platform capability used across teams

**Look for in the artifact:**
- Designed with multiple consumers in mind from the start
- Surface area shaped by what callers need, not by what you needed yesterday
- Generalization at the right level — not premature, not ad-hoc
- Documentation and example so others can adopt without asking

**BAD → GOOD:**

- BAD: *"Built the metric validator for my pipeline."*
- GOOD: *"Built the metric-validator as a shared utility now used by 3 downstream pipelines; eliminated 2 duplicate implementations and standardized the validation-failure error format across teams."*

- BAD: *"I wrote a script to backfill data."*
- GOOD: *"Generalized the backfill script into a reusable framework with idempotency and progress-reporting; used by 4 subsequent backfills without modification, reducing per-backfill setup from ~2 days to ~2 hours."*

---

### C3. Craft Processes & Mature Testing/Monitoring

**What it proves:** You set clear craft processes/standards and mature testing/monitoring.

**Impact looks like:**
- Test coverage gates merged into CI; regressions caught before merge
- Alert noise reduced (fewer false pages, faster signal)
- Mean time to detect (MTTD) and mean time to recover (MTTR) reduced
- Runbook used during oncall; oncall load decreased
- New code merges no longer regress reliability metrics

**Look for in the artifact:**
- Tests cover failure modes, not just happy path
- Alerting tied to user-visible impact, not just internal counters
- Runbooks present and tested
- Quality gates explicit in PR template or CI

**BAD → GOOD:**

- BAD: *"Added some tests."*
- GOOD: *"Added late-event and double-counting test cases to the conversion-validation suite; caught two pre-launch regressions in the next 4 PRs that would have caused billing variance."*

- BAD: *"Set up monitoring."*
- GOOD: *"Defined freshness, completeness, and reconciliation SLAs for the pipeline; built dashboards and alerts tied to advertiser-facing decisions — MTTD dropped from ~hours to ~minutes for the affected metric."*

---

### C4. Reviewing Others' Work

**What it proves:** You review others' work and proactively find and fix issues — multiplying your impact through others.

**Impact looks like:**
- Bugs caught in review prevented production issues
- Design improved before commit (cheaper than fixing post-launch)
- Mentee made independent decisions after the review pattern was shown
- Review feedback applied across multiple PRs from the same author
- Team-wide patterns shifted by repeated targeted feedback

**Look for in the artifact:**
- Substantive review comments (correctness, design, edge cases), not just style nits
- Design reviews catch issues at design phase, not at PR phase
- Coaching tone — explains why, not just what to change
- Pattern-level feedback that compounds across future PRs

**BAD → GOOD:**

- BAD: *"Reviewed N PRs this quarter."*
- GOOD: *"Reviewed 40 PRs this quarter; caught a recurring race-condition pattern in event-handler code and led a team RFC that eliminated the class across the codebase."*

- BAD: *"Gave feedback on the design doc."*
- GOOD: *"Surfaced two failure modes (late-event handling, identity drift) in design review that the team hadn't considered; both became explicit design decisions before implementation, preventing a likely post-launch incident."*

---

### C5. Metrics-Driven Improvement

**What it proves:** You use metrics/insights to drive improvements and best practices.

**Impact looks like:**
- Metric drove a refactor that reduced cost/latency/error rate by X%
- Dashboard exposed a long-standing inefficiency
- Best-practice adoption tracked and improved across team
- Before/after numbers attached to engineering changes
- Decisions backed by data instead of intuition

**Look for in the artifact:**
- Quantified before/after for engineering changes
- Metrics defined to track quality (not just feature adoption)
- Insights drove a process or tooling improvement
- Best-practice adoption measured and reported

**BAD → GOOD:**

- BAD: *"Improved CI."*
- GOOD: *"Profiled CI runtimes across 4 weeks; identified the top-5 slowest tests (90% of runtime), parallelized them, and cut median CI from 18min → 6min — saving the team ~15 hours/week of wait time."*

- BAD: *"Adopted the new linter."*
- GOOD: *"Tracked lint-warning count across the codebase over 2 months as the team adopted the new linter; reduced warnings from ~800 → ~50 and gated new warnings in CI to prevent regression."*

---

## Impact & Outcomes — the measure across L, E, and C

Every L and E sentence must surface a quantified result. This is what makes the narrative impact-focused.

Use these categories:
- **Business:** revenue, cost, efficiency
- **Product:** latency, accuracy, reliability, adoption
- **Engineering:** maintainability, reusability, downstream teams unblocked
- **Risk reduction:** incidents prevented, blast radius shrunk
- **People:** decisions unblocked, recurring debates eliminated

Use rough numbers if exact ones aren't available. Insert `[quantify: <metric>]` placeholders when the source artifact has no numbers — do not invent.

**No success criteria → success criteria:**
- BAD: *"The dashboard is live."*
- GOOD: *"Dashboard live with freshness SLA, reconciliation checks, adoption tracking, and a named owner for metric-quality incidents."*

---

## Self-Review Checkpoints

Run these at end-of-week and end-of-project. Each ✓/⚠/✗ should be backed by a concrete artifact.

**Leadership:**
- L1: Did I make the problem legible enough that others could align on one path?
- L2: Did I take ownership of something that wasn't in my ticket?
- L3: Did I expose a trade-off that unblocked a stakeholder decision?

**Execution:**
- E1: Did I name *why this was hard* and the key design decisions, not just what I built?
- E2: Did I sequence the work, expose dependencies, and adjust when requirements moved?
- E3: Did I identify risks early and reduce blast radius before launch?

**Craftsmanship:**
- C1: Did my code stay simple, readable, and bend-able after this change?
- C2: Did I design for reuse — is there leverage beyond this one feature?
- C3: Did I strengthen test coverage, monitoring, or operability for this code path?
- C4: Did my reviews of others catch real issues or coach a pattern?
- C5: Did I use metrics to drive an engineering improvement this week?

**Impact:** Did I prove change with numbers (latency, cost, reliability, adoption, risk-reduction, decisions-unblocked, reuse, MTTR)?

---

## Anti-patterns (catch these in your own writing)

- Describing work as an **ETL job** instead of a measurement reliability / decision problem.
- Launching dashboards or pipelines without freshness, reconciliation, adoption, and ownership checks.
- Treating disagreement as "the other team is wrong" instead of clarifying semantics.
- Using external constraints (privacy, deadline, scope) as an excuse instead of a forcing function for clearer trade-offs.
- "We shipped X" — without naming what changed for users, business, or operations.
- Capability framing ("I am good at debugging") instead of impact framing ("I cut MTTR by X%").
