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
