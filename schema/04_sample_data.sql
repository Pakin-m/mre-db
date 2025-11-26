-- schema/04_sample_data.sql
-- Sample data for the Modular Research Engine (MRE) database.

INSERT INTO users (name, username, email, password_hash)
VALUES
    ('Kalam Iwa', 'kalam_iwa',   'kalam.iwa@example.com',   'hashed_pw_1'),
    ('Indie Strategist', 'indie_ana', 'indie.ana@example.com',  'hashed_pw_2'),
    ('Market Hunter',    'mark_hunt', 'mark.hunt@example.com',  'hashed_pw_3');

INSERT INTO workspaces (user_id, name)
VALUES
    (1, 'Indie Strategy Lab'),
    (1, 'Personal Learning Vault'),
    (2, 'Boutique Research Studio'),
    (3, 'Startup Landscape Tracker');

INSERT INTO sources (workspace_id, title, type, content)
VALUES
    -- Workspace 1 (Indie Strategy Lab)
    (1, 'SEA e-commerce market report 2025', 'report',
     'Overview of Southeast Asia e-commerce growth, key players, and GMV trends.'),
    (1, 'DTC skincare competitors – summary', 'memo',
     'Summary of major DTC skincare brands, positioning, and pricing.'),
    (1, 'Customer interviews – Gen Z in Bangkok', 'transcript',
     'Interview notes with Gen Z online shoppers about habits and pain points.'),

    -- Workspace 3 (Boutique Research Studio)
    (3, 'B2B SaaS pricing benchmarks Q3 2025', 'report',
     'Benchmarking of B2B SaaS pricing tiers, discounts, and value metrics.'),
    (3, 'Churn analysis – mid-market SaaS', 'analysis',
     'Analysis of churn drivers in mid-market SaaS accounts.'),

    -- Workspace 4 (Startup Landscape Tracker)
    (4, 'Thailand fintech investor newsletter – July 2025', 'newsletter',
     'Curated fintech deals, funding rounds, and regulatory changes in Thailand.');

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

    -- Source 4: B2B SaaS pricing benchmarks Q3 2025
    (4, 1, 'Most B2B SaaS tools use tiered pricing with 3–4 main plans.'),
    (4, 2, 'ARPU increases when usage-based add-ons are bundled into higher tiers.'),
    (4, 3, 'Annual contracts reduce churn compared to monthly billing.'),
    (4, 4, 'Mid-market customers are sensitive to onboarding and support quality.'),

    -- Source 5: Churn analysis – mid-market SaaS
    (5, 1, 'Churn spikes when customers do not reach first value within 14 days.'),
    (5, 2, 'High churn correlates with low product adoption among non-admin users.'),
    (5, 3, 'Retention improves when customer success runs quarterly business reviews.'),
    (5, 4, 'Pricing discounts alone rarely fix churn if product fit is weak.'),

    -- Source 6: Thailand fintech investor newsletter – July 2025
    (6, 1, 'Several Thai BNPL startups raised Series A rounds in 2025.'),
    (6, 2, 'Regulators signal stricter rules on consumer lending and interest caps.'),
    (6, 3, 'Investors are watching customer acquisition cost and payback periods closely.'),
    (6, 4, 'Partnerships with e-wallets help drive retention and cross-sell.');

INSERT INTO concepts (workspace_id, name, description)
VALUES
    -- Workspace 1 (Indie Strategy Lab)
    (1, 'customer_segments', 'Key groups of customers based on behavior or demographics.'),
    (1, 'conversion_rate',   'Percentage of visitors who complete the desired action.'),
    (1, 'average_order_value', 'Average revenue per order in e-commerce.'),
    (1, 'retention',         'How well we keep existing customers over time.'),
    (1, 'marketing_channel', 'Where traffic and awareness come from (TikTok, IG, etc.).'),

    -- Workspace 3 (Boutique Research Studio)
    (3, 'pricing_model', 'How a SaaS product charges customers (tiered, usage-based, etc.).'),
    (3, 'arpu',          'Average revenue per user or account.'),
    (3, 'churn_rate',    'Rate at which customers cancel subscriptions.');
