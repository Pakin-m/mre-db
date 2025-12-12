-- schema/05_dev_seed_test1.sql
-- DEV-ONLY seed data for the MRE database.
-- Purpose: Populate LOTS of demo content for the existing real user:
--   username = 'test1'  (password handled by your app, not in this script)
--
-- How to use:
--  1) Make sure you created/logged-in user "test1" via the app once.
--  2) Run this file in DataGrip against your LOCAL Docker Postgres DB.
--
-- Safe to re-run: YES (it deletes prior workspaces for test1 and reseeds).

BEGIN;

-- ===== Guard: ensure the user exists =====
DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'test1') THEN
            RAISE EXCEPTION 'Dev user "test1" does not exist. Create it via the app first.';
        END IF;
    END $$;

-- ===== Clean existing demo data for this user only =====
-- This will cascade-delete all dependent rows because of your FK constraints.
DELETE FROM workspaces
WHERE user_id = (SELECT id FROM users WHERE username = 'test1');

-- ===== Create a bunch of workspaces for test1 =====
WITH u AS (
    SELECT id AS user_id FROM users WHERE username = 'test1'
),
     ins AS (
         INSERT INTO workspaces (user_id, name)
             SELECT u.user_id, x.name
             FROM u
                      CROSS JOIN (
                 VALUES
                     ('Market Intelligence Hub'),
                     ('AI Research Playground'),
                     ('Competitor Tear-downs'),
                     ('Customer Interview Vault'),
                     ('Product Strategy Lab'),
                     ('Trend Signals Inbox'),
                     ('Idea Incubator'),
                     ('Operations & Checklists'),
                     ('Weekly Research Sprints'),
                     ('Bangkok Mobility Mini-Lab'),
                     ('Street Food Field Notes'),
                     ('Creator Economy Signal Room')
             ) AS x(name)
             RETURNING id, name
     )
SELECT 1;

-- ===== Add workspace_files (so your UI has uploads) =====
-- We attach a realistic mix: PDFs, images, audio, csv, pptx.
INSERT INTO workspace_files (
    workspace_id, file_key, file_name, content_type, size_bytes, public_url
)
SELECT w.id,
       f.file_key, f.file_name, f.content_type, f.size_bytes, f.public_url
FROM workspaces w
         JOIN (
    VALUES
        -- Market Intelligence Hub
        ('Market Intelligence Hub', 'workspace-mi/2025-sea-landscape.pdf', '2025-sea-landscape.pdf', 'application/pdf', 1542331, 'https://cdn.example.com/dev/2025-sea-landscape.pdf'),
        ('Market Intelligence Hub', 'workspace-mi/competitor-matrix.xlsx', 'competitor-matrix.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 188221, 'https://cdn.example.com/dev/competitor-matrix.xlsx'),
        ('Market Intelligence Hub', 'workspace-mi/notes-screenshot-01.png', 'notes-screenshot-01.png', 'image/png', 332110, 'https://cdn.example.com/dev/notes-screenshot-01.png'),

        -- AI Research Playground
        ('AI Research Playground', 'workspace-ai/prompt-library.md', 'prompt-library.md', 'text/markdown', 28411, 'https://cdn.example.com/dev/prompt-library.md'),
        ('AI Research Playground', 'workspace-ai/triage-flowchart.png', 'triage-flowchart.png', 'image/png', 211882, 'https://cdn.example.com/dev/triage-flowchart.png'),
        ('AI Research Playground', 'workspace-ai/eval-set-small.csv', 'eval-set-small.csv', 'text/csv', 94712, 'https://cdn.example.com/dev/eval-set-small.csv'),

        -- Competitor Tear-downs
        ('Competitor Tear-downs', 'workspace-comp/onboarding-recording.mp4', 'onboarding-recording.mp4', 'video/mp4', 12048811, 'https://cdn.example.com/dev/onboarding-recording.mp4'),
        ('Competitor Tear-downs', 'workspace-comp/pricing-pages.pdf', 'pricing-pages.pdf', 'application/pdf', 510233, 'https://cdn.example.com/dev/pricing-pages.pdf'),
        ('Competitor Tear-downs', 'workspace-comp/signup-flow.png', 'signup-flow.png', 'image/png', 701882, 'https://cdn.example.com/dev/signup-flow.png'),

        -- Customer Interview Vault
        ('Customer Interview Vault', 'workspace-int/interview-01.m4a', 'interview-01.m4a', 'audio/mp4', 9822112, 'https://cdn.example.com/dev/interview-01.m4a'),
        ('Customer Interview Vault', 'workspace-int/interview-02.m4a', 'interview-02.m4a', 'audio/mp4', 10112233, 'https://cdn.example.com/dev/interview-02.m4a'),
        ('Customer Interview Vault', 'workspace-int/transcripts-pack.pdf', 'transcripts-pack.pdf', 'application/pdf', 842201, 'https://cdn.example.com/dev/transcripts-pack.pdf'),

        -- Trend Signals Inbox
        ('Trend Signals Inbox', 'workspace-signal/signal-dump-week48.txt', 'signal-dump-week48.txt', 'text/plain', 12011, 'https://cdn.example.com/dev/signal-dump-week48.txt'),
        ('Trend Signals Inbox', 'workspace-signal/memes-board.jpg', 'memes-board.jpg', 'image/jpeg', 312440, 'https://cdn.example.com/dev/memes-board.jpg'),

        -- Product Strategy Lab
        ('Product Strategy Lab', 'workspace-strat/strategy-deck.pptx', 'strategy-deck.pptx', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 2049011, 'https://cdn.example.com/dev/strategy-deck.pptx'),
        ('Product Strategy Lab', 'workspace-strat/one-pager.pdf', 'one-pager.pdf', 'application/pdf', 622901, 'https://cdn.example.com/dev/one-pager.pdf'),

        -- Weekly Research Sprints
        ('Weekly Research Sprints', 'workspace-sprints/sprint-board.png', 'sprint-board.png', 'image/png', 455118, 'https://cdn.example.com/dev/sprint-board.png'),

        -- Bangkok Mobility Mini-Lab
        ('Bangkok Mobility Mini-Lab', 'workspace-bkk/mobility-survey-2025.pdf', 'mobility-survey-2025.pdf', 'application/pdf', 1842331, 'https://cdn.example.com/dev/mobility-survey-2025.pdf'),
        ('Bangkok Mobility Mini-Lab', 'workspace-bkk/flood-hotspots.png', 'flood-hotspots.png', 'image/png', 452118, 'https://cdn.example.com/dev/flood-hotspots.png'),

        -- Street Food Field Notes
        ('Street Food Field Notes', 'workspace-food/menu-scan.pdf', 'menu-scan.pdf', 'application/pdf', 412901, 'https://cdn.example.com/dev/menu-scan.pdf'),
        ('Street Food Field Notes', 'workspace-food/stall-photo.jpg', 'stall-photo.jpg', 'image/jpeg', 222440, 'https://cdn.example.com/dev/stall-photo.jpg'),

        -- Creator Economy Signal Room
        ('Creator Economy Signal Room', 'workspace-creator/platform-payouts-2025.pdf', 'platform-payouts-2025.pdf', 'application/pdf', 1338200, 'https://cdn.example.com/dev/platform-payouts-2025.pdf'),
        ('Creator Economy Signal Room', 'workspace-creator/brand-brief-deck.pptx', 'brand-brief-deck.pptx', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 1204901, 'https://cdn.example.com/dev/brand-brief-deck.pptx')
) AS f(workspace_name, file_key, file_name, content_type, size_bytes, public_url)
              ON f.workspace_name = w.name
WHERE w.user_id = (SELECT id FROM users WHERE username = 'test1');

-- ===== Sources (richer, more numerous) =====
INSERT INTO sources (workspace_id, title, type, url, content)
SELECT w.id, s.title, s.type, s.url, s.content
FROM workspaces w
         JOIN (
    VALUES
        ('Market Intelligence Hub', 'SEA startup landscape 2025 – highlights', 'report', NULL,
         'Highlights from a landscape PDF: funding patterns, distribution moats, and second-order effects across sectors.'),
        ('Market Intelligence Hub', 'Competitive matrix notes (xlsx)', 'analysis', NULL,
         'Observed clusters: same pricing pages, similar onboarding, and “feature parity” messaging fatigue.'),

        ('AI Research Playground', 'Prompt patterns that reduce hallucination', 'memo', NULL,
         'Tactics: force citations, ask for counterfactuals, require uncertainty, and split retrieval vs synthesis.'),
        ('AI Research Playground', 'Evaluation set: 30 Q/A pairs', 'dataset', NULL,
         'Small eval set to spot regressions. Emphasis: tricky edge cases, counterexamples, and partial evidence.'),

        ('Competitor Tear-downs', 'Onboarding teardown: competitor A', 'analysis', NULL,
         'First 60 seconds: unclear promise, too many choices, hidden pricing, and premature sign-up wall.'),
        ('Competitor Tear-downs', 'Pricing page comparison', 'report', NULL,
         'Summary of 6 pricing pages: anchors, discounts, feature gating, and copy patterns that reduce trust.'),

        ('Customer Interview Vault', 'Interview synthesis: early adopters (batch 1)', 'transcript', NULL,
         'Themes: speed > flexibility, trust cues matter, users prefer “just-enough structure”, and love quick wins.'),
        ('Customer Interview Vault', 'Interview synthesis: churned users (batch 2)', 'transcript', NULL,
         'Themes: confusing workspace setup, unclear value on day 1, and “I don’t know what to do next.”'),

        ('Product Strategy Lab', 'One-pager: MRE positioning draft', 'note', NULL,
         'Positioning: research OS for people who hate messy notes. Promise: evidence-first thinking with low friction.'),
        ('Product Strategy Lab', 'Strategy deck: Q1 roadmap', 'report', NULL,
         'Roadmap: speed up capture, improve retrieval, and make concepts feel alive via auto-linking.'),

        ('Trend Signals Inbox', 'Week 48 signal dump', 'inbox', NULL,
         'Loose links + observations: new tool launches, creator format shifts, and tiny UI trends worth testing.'),
        ('Trend Signals Inbox', 'Meme board analysis', 'note', NULL,
         'Memes are a leading indicator of which ideas are “sticky”. Track recurring templates and what they imply.'),

        ('Idea Incubator', 'Wild ideas: “evidence layers”', 'note', NULL,
         'Idea: show fragments → concepts → notes as layers, so thinking stays traceable and remixable.'),
        ('Operations & Checklists', 'Daily research checklist', 'memo', NULL,
         'Capture → tag → link → summarize → plan next action. Keep notes citation-first.'),

        ('Weekly Research Sprints', 'Sprint plan template', 'note', NULL,
         'Define a question, 5 sources, 20 fragments, 8 concepts, then ship a synthesis + next steps.'),

        ('Bangkok Mobility Mini-Lab', 'Mobility survey 2025 (PDF) – summary', 'report', NULL,
         'Heat stress + flooding disrupt access routes. WTP higher for shade + predictability than top speed.'),
        ('Bangkok Mobility Mini-Lab', 'Flood hotspot screenshot notes', 'memo', NULL,
         'Recurring flooding hotspots near canals. Suggest micro-detours and station access routing.'),

        ('Street Food Field Notes', 'Menu scan normalization', 'analysis', NULL,
         'Dish names encode technique; prices vary with foot-traffic. Queue signage changes perceived fairness.'),
        ('Street Food Field Notes', 'Field photo observations', 'note', NULL,
         'Prep workflow + queue dynamics. Peak hour patterns and what signage changes behavior.'),

        ('Creator Economy Signal Room', 'Platform payouts 2025 – highlights', 'report', NULL,
         'Lower thresholds increase experimentation but raise support load. KYC mismatch dominates friction.'),
        ('Creator Economy Signal Room', 'Brand brief: creator collab guardrails', 'memo', NULL,
         'Give constraints + examples, not scripts. Bundle deliverables for recall without fatigue.')
) AS s(workspace_name, title, type, url, content)
              ON s.workspace_name = w.name
WHERE w.user_id = (SELECT id FROM users WHERE username = 'test1');

-- ===== Fragments (tons, across many sources) =====
-- We generate fragments by joining on source title (stable) and using VALUES blocks.
-- This creates a “deep” dataset without needing IDs.
WITH src AS (
    SELECT id, title FROM sources
    WHERE workspace_id IN (SELECT id FROM workspaces WHERE user_id = (SELECT id FROM users WHERE username = 'test1'))
),
     frag(title, fragment_index, text) AS (
         VALUES
             -- SEA startup landscape 2025 – highlights
             ('SEA startup landscape 2025 – highlights', 1, 'Distribution partnerships are a stronger moat than feature breadth in crowded categories.'),
             ('SEA startup landscape 2025 – highlights', 2, 'Teams that narrow ICP early ship faster and waste less time on “edge-case” requests.'),
             ('SEA startup landscape 2025 – highlights', 3, 'Second-order: regulation changes user trust faster than marketing can repair it.'),
             ('SEA startup landscape 2025 – highlights', 4, 'Most “AI-first” pitches quietly rely on strong ops: data hygiene, labeling, and retrieval.'),

             -- Competitive matrix notes (xlsx)
             ('Competitive matrix notes (xlsx)', 1, 'Pricing pages converge: three tiers, one “best value” highlight, and ambiguous limits.'),
             ('Competitive matrix notes (xlsx)', 2, 'Onboarding flows hide the “core verb” until after account creation.'),
             ('Competitive matrix notes (xlsx)', 3, 'Trust cues (logos, case studies) appear before users understand what the product does.'),

             -- Prompt patterns that reduce hallucination
             ('Prompt patterns that reduce hallucination', 1, 'Counterfactual question: “What evidence would change your mind?” reduces overconfident claims.'),
             ('Prompt patterns that reduce hallucination', 2, 'Forcing citations per paragraph improves debuggability more than longer outputs.'),
             ('Prompt patterns that reduce hallucination', 3, 'Separating retrieval from synthesis reduces “smooth but wrong” summaries.'),
             ('Prompt patterns that reduce hallucination', 4, 'Asking for uncertainty bands makes teams less likely to ship fragile conclusions.'),

             -- Evaluation set: 30 Q/A pairs
             ('Evaluation set: 30 Q/A pairs', 1, 'Eval items should include ambiguous cases where the correct answer is “insufficient evidence.”'),
             ('Evaluation set: 30 Q/A pairs', 2, 'Regression tests catch prompt drift when templates evolve.'),
             ('Evaluation set: 30 Q/A pairs', 3, 'Short “gold” answers reduce subjective scoring variance.'),

             -- Onboarding teardown: competitor A
             ('Onboarding teardown: competitor A', 1, 'The first screen asks for project details before explaining the payoff.'),
             ('Onboarding teardown: competitor A', 2, 'Users face a sign-up wall before seeing an example output.'),
             ('Onboarding teardown: competitor A', 3, 'Too many choices in onboarding creates anxiety and slows time-to-first-value.'),
             ('Onboarding teardown: competitor A', 4, 'Copy focuses on “features” instead of the job-to-be-done.'),

             -- Pricing page comparison
             ('Pricing page comparison', 1, 'Hidden limits (seats, pages, exports) are the main trigger for buyer distrust.'),
             ('Pricing page comparison', 2, 'Annual discount callouts increase conversion, but only when “cancel anytime” is clear.'),
             ('Pricing page comparison', 3, 'Most pages fail to explain what happens at the plan boundary (hard stop vs soft limit).'),

             -- Interview synthesis: early adopters (batch 1)
             ('Interview synthesis: early adopters (batch 1)', 1, 'Users love quick capture, but want the system to suggest structure later.'),
             ('Interview synthesis: early adopters (batch 1)', 2, 'They judge trust by “can I find it again in 10 seconds?”'),
             ('Interview synthesis: early adopters (batch 1)', 3, 'People prefer templates that start minimal and expand only when needed.'),
             ('Interview synthesis: early adopters (batch 1)', 4, 'A single great example is more persuasive than a long feature list.'),

             -- Interview synthesis: churned users (batch 2)
             ('Interview synthesis: churned users (batch 2)', 1, 'Churn often happens when users do not reach first value within the first session.'),
             ('Interview synthesis: churned users (batch 2)', 2, 'Users get stuck deciding how to organize workspaces and tags.'),
             ('Interview synthesis: churned users (batch 2)', 3, 'They want “next best action” prompts after capture.'),
             ('Interview synthesis: churned users (batch 2)', 4, 'Confusion spikes when notes lack clear links back to evidence.'),

             -- One-pager: MRE positioning draft
             ('One-pager: MRE positioning draft', 1, 'Promise: evidence-first thinking without messy folders and endless tabs.'),
             ('One-pager: MRE positioning draft', 2, 'Differentiator: keep fragments, concepts, and notes connected by default.'),
             ('One-pager: MRE positioning draft', 3, 'Tone: calm, fast, and honest about uncertainty.'),

             -- Strategy deck: Q1 roadmap
             ('Strategy deck: Q1 roadmap', 1, 'Priority: reduce capture friction to under 10 seconds per item.'),
             ('Strategy deck: Q1 roadmap', 2, 'Make retrieval feel “inevitable”: strong search + concept suggestions.'),
             ('Strategy deck: Q1 roadmap', 3, 'Auto-link fragments to concepts, but always keep a manual override.'),
             ('Strategy deck: Q1 roadmap', 4, 'Ship weekly: small wins beat perfect systems.'),

             -- Week 48 signal dump
             ('Week 48 signal dump', 1, 'Signal: tools are shifting from “chat” to “workflow” with approvals and history.'),
             ('Week 48 signal dump', 2, 'Signal: creators move to short series formats for retention.'),
             ('Week 48 signal dump', 3, 'Signal: users demand transparency—pricing, limits, and data usage.'),

             -- Meme board analysis
             ('Meme board analysis', 1, 'Memes compress ideas into repeatable templates: they reveal what people remember.'),
             ('Meme board analysis', 2, 'When a meme repeats across niches, it signals an underlying shared pain point.'),

             -- Wild ideas: “evidence layers”
             ('Wild ideas: “evidence layers”', 1, 'Idea: show “layers” from raw fragments → concepts → notes → decisions.'),
             ('Wild ideas: “evidence layers”', 2, 'Make it easy to zoom from a claim down to the exact fragment that supports it.'),
             ('Wild ideas: “evidence layers”', 3, 'Treat notes like living documents with citations, not static summaries.'),

             -- Daily research checklist
             ('Daily research checklist', 1, 'Start with capture: collect messy inputs without judgment.'),
             ('Daily research checklist', 2, 'Tag lightly: 5–10 concepts beats 100 tags nobody uses.'),
             ('Daily research checklist', 3, 'Link evidence to concepts before writing conclusions.'),

             -- Sprint plan template
             ('Sprint plan template', 1, 'Each sprint starts with a single question that can be answered in 7 days.'),
             ('Sprint plan template', 2, 'Aim for 20 fragments and 8 concepts—enough structure without overfitting.'),
             ('Sprint plan template', 3, 'End with next steps: what to test, who to interview, what to read next.'),

             -- Mobility survey 2025 (PDF) – summary
             ('Mobility survey 2025 (PDF) – summary', 1, 'Heat stress is a top friction point during afternoon commutes.'),
             ('Mobility survey 2025 (PDF) – summary', 2, 'Flooding disrupts station access routes more than rail operations.'),
             ('Mobility survey 2025 (PDF) – summary', 3, 'Willingness-to-pay is higher for shade and reliability than for higher top speed.'),

             -- Flood hotspot screenshot notes
             ('Flood hotspot screenshot notes', 1, 'Three canal-adjacent corridors show repeat flooding after short heavy rain bursts.'),
             ('Flood hotspot screenshot notes', 2, 'Moving stops 100m uphill reduces exposure without changing route coverage.'),

             -- Menu scan normalization
             ('Menu scan normalization', 1, 'Dish names encode technique, which predicts prep time and queue speed.'),
             ('Menu scan normalization', 2, 'Prices vary more by foot-traffic than by ingredient cost for similar dishes.'),
             ('Menu scan normalization', 3, 'Clear “estimated wait time” signage reduces perceived unfairness.'),

             -- Field photo observations
             ('Field photo observations', 1, 'Pre-portioning garnishes increases throughput but slightly reduces perceived freshness.'),
             ('Field photo observations', 2, 'Queue length stabilizes when the stall shows wait time and a clear ordering rule.'),

             -- Platform payouts 2025 – highlights
             ('Platform payouts 2025 – highlights', 1, 'Lower payout thresholds increase creator experimentation but raise support load.'),
             ('Platform payouts 2025 – highlights', 2, 'Regional payout friction is dominated by KYC document mismatch.'),
             ('Platform payouts 2025 – highlights', 3, 'Creators prefer predictable payouts over occasional “bonus” volatility.'),

             -- Brand brief: creator collab guardrails
             ('Brand brief: creator collab guardrails', 1, 'Creators perform best with constraints and examples—not scripts.'),
             ('Brand brief: creator collab guardrails', 2, 'Bundles beat single-post deals for recall without audience fatigue.')
     )
INSERT INTO fragments (source_id, fragment_index, text)
SELECT s.id, f.fragment_index, f.text
FROM frag f
         JOIN src s ON s.title = f.title;

-- ===== Concepts =====
-- Create concepts per workspace to support search/autocomplete and graphing.
INSERT INTO concepts (workspace_id, name, description)
SELECT w.id, c.name, c.description
FROM workspaces w
         JOIN (
    VALUES
        ('Product Strategy Lab', 'time_to_first_value',      'How quickly a user reaches the first meaningful payoff.'),
        ('Product Strategy Lab', 'pricing_transparency',     'Clarity about pricing, limits, and plan boundaries.'),
        ('Product Strategy Lab', 'job_to_be_done',           'The underlying user “job” the product is hired to do.'),
        ('Product Strategy Lab', 'trust_cues',               'Signals that increase confidence (examples, logos, proof).'),
        ('Product Strategy Lab', 'next_best_action',         'Guidance that tells users what to do after capture.'),

        ('AI Research Playground', 'counterfactual_checks',  'Prompts that test what evidence would change a conclusion.'),
        ('AI Research Playground', 'citation_first_notes',   'Notes that preserve traceability to fragments and sources.'),
        ('AI Research Playground', 'retrieval_then_synthesis','Split retrieval from synthesis to reduce confident errors.'),
        ('AI Research Playground', 'latency_budget',         'How much delay a workflow can tolerate before users drop it.'),

        ('Market Intelligence Hub', 'distribution_moat',     'Defensibility built through channels/partnerships vs features.'),
        ('Market Intelligence Hub', 'icp_focus',             'Narrowing ideal customer profile to ship faster and learn.'),
        ('Market Intelligence Hub', 'regulation_risk',        'How regulatory shifts change trust and viability.'),

        ('Trend Signals Inbox', 'signal_vs_noise',           'Separating actionable insight from raw inputs.'),
        ('Trend Signals Inbox', 'format_shift',              'Changes in content formats that drive retention (series, etc.).'),

        ('Bangkok Mobility Mini-Lab', 'heat_stress',          'Heat friction that reduces willingness to commute.'),
        ('Bangkok Mobility Mini-Lab', 'flood_disruption',     'Flooding impact on access routes and last-mile travel.'),
        ('Bangkok Mobility Mini-Lab', 'willingness_to_pay',   'What commuters pay for comfort/reliability/time.'),

        ('Street Food Field Notes', 'queue_dynamics',        'How queues form and how signage affects behavior.'),
        ('Street Food Field Notes', 'price_discrimination',  'Location-based price variance for similar dishes.'),

        ('Creator Economy Signal Room', 'payout_threshold',   'Minimum threshold before creators can withdraw.'),
        ('Creator Economy Signal Room', 'creator_constraints','Constraints + examples that still allow authenticity.')
) AS c(workspace_name, name, description)
              ON c.workspace_name = w.name
WHERE w.user_id = (SELECT id FROM users WHERE username = 'test1');

-- ===== Fragment ↔ Concept links =====
-- Link by matching fragment text keywords to concept names (simple and effective for demo).
INSERT INTO fragment_concepts (fragment_id, concept_id)
SELECT f.id, c.id
FROM fragments f
         JOIN sources s   ON s.id = f.source_id
         JOIN concepts c  ON c.workspace_id = s.workspace_id
WHERE
    (c.name = 'time_to_first_value'       AND f.text ILIKE '%first value%')
   OR (c.name = 'pricing_transparency'  AND (f.text ILIKE '%pricing%' OR f.text ILIKE '%limits%' OR f.text ILIKE '%plan boundary%'))
   OR (c.name = 'trust_cues'            AND (f.text ILIKE '%trust%' OR f.text ILIKE '%example%'))
   OR (c.name = 'next_best_action'      AND f.text ILIKE '%next%action%')
   OR (c.name = 'counterfactual_checks' AND f.text ILIKE '%evidence would change%')
   OR (c.name = 'citation_first_notes'  AND (f.text ILIKE '%citations%' OR f.text ILIKE '%traceable%' OR f.text ILIKE '%fragment% supports%'))
   OR (c.name = 'retrieval_then_synthesis' AND (f.text ILIKE '%retrieval%' OR f.text ILIKE '%synthesis%'))
   OR (c.name = 'latency_budget'        AND f.text ILIKE '%latency%')
   OR (c.name = 'distribution_moat'     AND (f.text ILIKE '%distribution%' OR f.text ILIKE '%partnership%'))
   OR (c.name = 'icp_focus'             AND f.text ILIKE '%ICP%')
   OR (c.name = 'regulation_risk'       AND f.text ILIKE '%regulation%')
   OR (c.name = 'signal_vs_noise'       AND (f.text ILIKE '%signal%' OR f.text ILIKE '%noise%'))
   OR (c.name = 'format_shift'          AND f.text ILIKE '%series%')
   OR (c.name = 'heat_stress'           AND f.text ILIKE '%heat stress%')
   OR (c.name = 'flood_disruption'      AND f.text ILIKE '%flood%')
   OR (c.name = 'willingness_to_pay'    AND (f.text ILIKE '%willingness-to-pay%' OR f.text ILIKE '%WTP%'))
   OR (c.name = 'queue_dynamics'        AND f.text ILIKE '%queue%')
   OR (c.name = 'price_discrimination'  AND f.text ILIKE '%Prices vary%')
   OR (c.name = 'payout_threshold'      AND (f.text ILIKE '%threshold%' OR f.text ILIKE '%payout%'))
   OR (c.name = 'creator_constraints'   AND (f.text ILIKE '%constraints%' OR f.text ILIKE '%scripts%'))
ON CONFLICT DO NOTHING;

-- ===== Notes =====
INSERT INTO notes (workspace_id, title, body)
SELECT w.id, n.title, n.body
FROM workspaces w
         JOIN (
    VALUES
        ('Weekly Research Sprints', 'Sprint 1: “What makes a note system sticky?”',
         'Hypothesis: people stick when retrieval is instant + evidence is traceable. Goal: test “citation-first notes” + suggested concepts.'),

        ('Product Strategy Lab', 'Roadmap summary (Q1)',
         'Ship fast: reduce capture friction, improve search, and add concept suggestions with manual override. Measure time-to-first-value and weekly active usage.'),

        ('Product Strategy Lab', 'Pricing page principles',
         'Be honest about limits. Explain plan boundaries. Show examples before signup. Make annual discount optional, not pushy.'),

        ('AI Research Playground', 'Prompt hygiene checklist',
         'Always run: (1) counterfactual, (2) missing-data/bias check, (3) uncertainty band, (4) citations per paragraph.'),

        ('Market Intelligence Hub', 'Moats worth betting on',
         'Partnership distribution moats tend to survive feature parity. Narrow ICP early, avoid regulation-blind bets.'),

        ('Trend Signals Inbox', 'Signals to validate next',
         '1) workflow shift (approvals/history), 2) pricing transparency demand, 3) creator short-series formats.'),

        ('Bangkok Mobility Mini-Lab', 'Commute comfort experiments',
         'Try shade + predictable headways signage. Treat station access routes as the key constraint during floods.'),

        ('Street Food Field Notes', 'Queue experiments',
         'Test estimated wait time signage + clear ordering rules. Track throughput vs perceived freshness.'),

        ('Creator Economy Signal Room', 'Creator collab guardrails',
         'Give constraints + examples, not scripts. Bundle deliverables for recall without audience fatigue.')
) AS n(workspace_name, title, body)
              ON n.workspace_name = w.name
WHERE w.user_id = (SELECT id FROM users WHERE username = 'test1');

COMMIT;
