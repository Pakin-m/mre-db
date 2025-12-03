-- schema/04_sample_data.sql
-- Sample data for the Modular Research Engine (MRE) database.

INSERT INTO users (name, username, email, password_hash)
VALUES
    ('Kalam Iwa',          'kalam_iwa',     'kalam.iwa@example.com',      'hashed_pw_1'),
    ('Indie Strategist',   'indie_ana',     'indie.ana@example.com',      'hashed_pw_2'),
    ('Market Hunter',      'mark_hunt',     'mark.hunt@example.com',      'hashed_pw_3'),
    ('Desk Research Pro',  'desk_pro',      'desk.pro@example.com',       'hashed_pw_4'),
    ('Insight Architect',  'insight_arc',   'insight.arc@example.com',    'hashed_pw_5'),
    ('Signal Hunter',      'signal_hunt',   'signal.hunt@example.com',    'hashed_pw_6'),
    ('Pattern Seeker',     'pattern_seek',  'pattern.seek@example.com',   'hashed_pw_7'),
    ('Noise Filter',       'noise_filter',  'noise.filter@example.com',   'hashed_pw_8'),
    ('Story Crafter',      'story_craft',   'story.craft@example.com',    'hashed_pw_9'),
    ('Retention Wizard',   'retention_wz',  'retention.wz@example.com',   'hashed_pw_10');

INSERT INTO workspaces (user_id, name)
VALUES
    (1, 'Indie Strategy Lab'),
    (1, 'Personal Learning Vault'),
    (2, 'Boutique Research Studio'),
    (3, 'Startup Landscape Tracker'),
    (1, 'Consumer Finance Deep Dives'),
    (1, 'Brand Positioning Experiments'),
    (2, 'SaaS Retention Benchmarks'),
    (2, 'E-commerce Playbooks'),
    (3, 'Fintech Radar APAC'),
    (3, 'Creator Economy Tracker');

INSERT INTO sources (workspace_id, title, type, content)
VALUES
    -- Workspace 1 (Indie Strategy Lab)
    (1, 'SEA e-commerce market report 2025', 'report',
     'Overview of Southeast Asia e-commerce growth, key players, and GMV trends.'),
    (1, 'DTC skincare competitors – summary', 'memo',
     'Summary of major DTC skincare brands, positioning, and pricing.'),
    (1, 'Customer interviews – Gen Z in Bangkok', 'transcript',
     'Interview notes with Gen Z online shoppers about habits and pain points.'),

    -- Workspace 2 (Personal Learning Vault)
    (2, 'Personal learning sources – econ & AI', 'note',
     'List of books, podcasts, and papers for long-term learning.'),

    -- Workspace 3 (Boutique Research Studio)
    (3, 'B2B SaaS pricing benchmarks Q3 2025', 'report',
     'Benchmarking of B2B SaaS pricing tiers, discounts, and value metrics.'),
    (3, 'Churn analysis – mid-market SaaS', 'analysis',
     'Analysis of churn drivers in mid-market SaaS accounts.'),

    -- Workspace 4 (Startup Landscape Tracker)
    (4, 'Thailand fintech investor newsletter – July 2025', 'newsletter',
     'Curated fintech deals, funding rounds, and regulatory changes in Thailand.'),

    -- Workspace 5 (Consumer Finance Deep Dives)
    (5, 'Consumer credit landscape – Thailand 2025', 'report',
     'Comparison of BNPL providers, credit cards, and personal loans in Thailand.'),

    -- Workspace 9 (Fintech Radar APAC)
    (9, 'SEA fintech competitive map', 'report',
     'Map of wallets, BNPL, and neobanks across Southeast Asia.'),

    -- Workspace 10 (Creator Economy Tracker)
    (10, 'Creator monetization trends 2025', 'report',
     'Overview of creator revenue streams across platforms like TikTok and YouTube.');


INSERT INTO fragments (source_id, fragment_index, text)
VALUES
    -- Source 1: SEA e-commerce market report 2025
    (1, 1, 'SEA e-commerce GMV grew 18% YoY in 2024, led by Indonesia and Vietnam.'),
    (1, 2, 'Thailand''s online fashion segment shows strongest growth among Gen Z.'),
    (1, 3, 'Top customer segments include price-sensitive students and young professionals.'),
    (1, 4, 'Conversion rate improves significantly when offering free shipping thresholds.'),

    -- Source 2: DTC skincare competitors – summary
    (2, 1, 'Brand A positions itself as premium clean beauty with higher price points.'),
    (2, 2, 'Brand B focuses on value-conscious customers with bundle discounts.'),
    (2, 3, 'Most competitors rely heavily on Instagram and TikTok as marketing channels.'),
    (2, 4, 'Average order value is highest when bundles include serums and moisturizers.'),

    -- Source 3: Customer interviews – Gen Z in Bangkok
    (3, 1, 'Gen Z shoppers often discover new brands via TikTok creators, not ads.'),
    (3, 2, 'They abandon carts when shipping fees are not clearly shown early.'),
    (3, 3, 'Loyalty is driven more by community and vibe than by pure discounts.'),
    (3, 4, 'Retention improves with fast replies to DMs and simple return policies.'),

    -- Source 4: Personal learning sources – econ & AI
    (4, 1, 'Books cover topics like economics, finance, and AI.'),
    (4, 2, 'Podcasts cover topics like business, finance, and data science.'),
    (4, 3, 'Papers cover topics like consumer behavior, finance, and AI.'),

    -- Source 5: B2B SaaS pricing benchmarks Q3 2025
    (5, 1, 'Most B2B SaaS tools use tiered pricing with 3–4 main plans.'),
    (5, 2, 'ARPU increases when usage-based add-ons are bundled into higher tiers.'),
    (5, 3, 'Annual contracts reduce churn compared to monthly billing.'),
    (5, 4, 'Mid-market customers are sensitive to onboarding and support quality.'),

    -- Source 6: Churn analysis – mid-market SaaS
    (6, 1, 'Churn spikes when customers do not reach first value within 14 days.'),
    (6, 2, 'High churn correlates with low product adoption among non-admin users.'),
    (6, 3, 'Retention improves when customer success runs quarterly business reviews.'),
    (6, 4, 'Pricing discounts alone rarely fix churn if product fit is weak.'),

    -- Source 7: Thailand fintech investor newsletter – July 2025
    (7, 1, 'Several Thai BNPL startups raised Series A rounds in 2025.'),
    (7, 2, 'Regulators signal stricter rules on consumer lending and interest caps.'),
    (7, 3, 'Investors are watching customer acquisition cost and payback periods closely.'),
    (7, 4, 'Partnerships with e-wallets help drive retention and cross-sell.');

INSERT INTO concepts (workspace_id, name, description)
VALUES
    -- Workspace 1 (Indie Strategy Lab)
    (1, 'customer_segments',    'Key groups of customers based on behavior or demographics.'),
    (1, 'conversion_rate',      'Percentage of visitors who complete the desired action.'),
    (1, 'average_order_value',  'Average revenue per order in e-commerce.'),
    (1, 'retention',            'How well we keep existing customers over time.'),
    (1, 'marketing_channel',    'Where traffic and awareness come from (TikTok, IG, etc.).'),
    (1, 'lifetime_value',       'Estimated long-term revenue from a single customer.'),

    -- Workspace 3 (Boutique Research Studio)
    (3, 'pricing_model',        'How a SaaS product charges customers (tiered, usage-based, etc.).'),
    (3, 'arpu',                 'Average revenue per user or account.'),
    (3, 'churn_rate',           'Rate at which customers cancel subscriptions.'),
    (3, 'onboarding_experience','Quality and speed of the first-time user journey.');

INSERT INTO fragment_concepts (fragment_id, concept_id)
VALUES
    -- Workspace 1: customer segments, conversion, AOV, retention, marketing channels
    (1,  1),  -- GMV growth relates to customer_segments
    (2,  1),  -- Gen Z fashion growth -> customer_segments
    (3,  1),  -- explicitly mentions customer segments
    (4,  2),  -- conversion rate and free shipping
    (5,  3),  -- premium pricing -> AOV
    (6,  1),  -- value-conscious customers -> segments
    (7,  5),  -- IG/TikTok -> marketing channels
    (8,  3),  -- bundles raise AOV
    (9,  5),  -- discover brands via TikTok -> channel
    (10, 2),  -- cart abandonment -> conversion
    (11, 4),  -- loyalty / community -> retention
    (12, 4),  -- retention via fast replies and returns

    -- Workspace 3: pricing model, ARPU, churn rate
    (16, 7),  -- tiered pricing
    (17, 8),  -- ARPU increasing with add-ons
    (18, 9),  -- annual contracts reduce churn
    (19, 9),  -- churn tied to onboarding/support
    (20, 9),  -- churn spike if no first value
    (21, 9),  -- churn and low adoption
    (22, 9),  -- QBRs reduce churn (retention effect) -> churn_rate
    (23, 7);  -- pricing discounts vs churn

INSERT INTO notes (workspace_id, title, body)
VALUES
    (1, 'Gen Z fashion insights',
     'Key takeaways: high TikTok influence, sensitivity to shipping fees, and strong preference for clear returns.'),
    (1, 'E-commerce growth summary',
     'SEA GMV grew 18% YoY. Thailand fashion segment is outperforming overall market.'),
    (1, 'Skincare positioning ideas',
     'Consider mid-premium positioning with strong community and educational content.'),
    (1, 'Marketing channel priorities',
     'Double down on TikTok creators and IG reels. Test YouTube shorts later.'),

    (3, 'Pricing strategy notes',
     'Use three main tiers, with usage-based add-ons reserved for the top plans.'),
    (3, 'Churn reduction plan',
     'Focus on time-to-first-value, onboarding, and QBRs. Pricing changes alone are not enough.'),
    (3, 'ARPU growth ideas',
     'Bundle popular add-ons and experiment with annual-only plans for certain tiers.'),

    (4, 'Fintech watchlist',
     'Track BNPL startups in Thailand and monitor regulatory changes on lending caps.'),
    (4, 'Investor talking points',
     'Highlight CAC payback, retention via wallets, and partnerships with e-commerce platforms.'),
    (4, 'Next research actions',
     'Interview 3–5 fintech founders about regulatory risks and cross-sell strategies.');
