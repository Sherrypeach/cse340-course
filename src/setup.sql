-- =====================================================================
-- CSE 340 Service Network - database setup script
--
-- Running this file from top to bottom re-creates the entire database
-- from scratch. The DROP statements run in reverse dependency order so
-- that no foreign key is left pointing at a table that no longer exists.
-- =====================================================================

DROP TABLE IF EXISTS project_category;
DROP TABLE IF EXISTS service_project;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS organization;

-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- ========================================
-- Service Project Table
--
-- Every service project is sponsored by exactly one organization, so
-- organization_id is a foreign key referencing organization. The
-- constraint is what stops a project from being saved with an
-- organization_id that does not match a real organization.
-- ========================================
CREATE TABLE service_project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    project_date DATE NOT NULL,
    CONSTRAINT fk_service_project_organization
        FOREIGN KEY (organization_id)
        REFERENCES organization (organization_id)
        ON DELETE CASCADE
);

-- ========================================
-- Category Table
--
-- Names are UNIQUE so the same category cannot be entered twice.
-- ========================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- ========================================
-- Project / Category Junction Table
--
-- A project can belong to many categories and a category can contain
-- many projects, which is a many-to-many relationship. A relational
-- database models that with a third table holding one row per pairing.
--
-- The primary key is the combination of both columns, which guarantees
-- the same project cannot be added to the same category twice.
-- ========================================
CREATE TABLE project_category (
    project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    CONSTRAINT pk_project_category
        PRIMARY KEY (project_id, category_id),
    CONSTRAINT fk_project_category_project
        FOREIGN KEY (project_id)
        REFERENCES service_project (project_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_project_category_category
        FOREIGN KEY (category_id)
        REFERENCES category (category_id)
        ON DELETE CASCADE
);

-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- ========================================
-- Insert sample data: Categories
-- ========================================
INSERT INTO category (name)
VALUES
('Environmental'),
('Educational'),
('Community Service'),
('Health and Wellness');

-- ========================================
-- Insert sample data: Service Projects
--
-- The subquery looks up each organization by name instead of hardcoding
-- an id. That way the inserts still work if the SERIAL values differ.
-- ========================================
INSERT INTO service_project (organization_id, title, description, location, project_date)
VALUES
-- BrightFuture Builders
((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'),
 'Wheelchair Ramp Build', 'Build and install two wheelchair ramps for residents with limited mobility.', 'Maple Street, Rexburg, ID', '2026-09-19'),
((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'),
 'Porch Repair Day', 'Replace rotted decking and railings on three homes owned by seniors.', 'Cedar Heights, Rexburg, ID', '2026-09-26'),
((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'),
 'Playground Restoration', 'Sand, repaint, and re-mulch the playground at Riverside Park.', 'Riverside Park, Rexburg, ID', '2026-10-03'),
((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'),
 'Winter Weatherization', 'Install insulation and weather stripping for low-income households.', 'Northside Neighborhood, Rexburg, ID', '2026-10-17'),
((SELECT organization_id FROM organization WHERE name = 'BrightFuture Builders'),
 'Community Center Painting', 'Repaint the interior of the neighborhood community center.', 'Fifth Ward Community Center, Rexburg, ID', '2026-10-24'),

-- GreenHarvest Growers
((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'),
 'Fall Garden Harvest', 'Harvest the community garden and deliver produce to the local food bank.', 'Elm Street Community Garden, Rexburg, ID', '2026-09-20'),
((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'),
 'School Garden Workshop', 'Teach elementary students how to plant and care for a raised bed.', 'Lincoln Elementary School, Rexburg, ID', '2026-09-27'),
((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'),
 'Compost Program Launch', 'Set up neighborhood compost bins and train residents to use them.', 'Willow Park, Rexburg, ID', '2026-10-04'),
((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'),
 'Tree Planting Morning', 'Plant forty native saplings along the riverside trail.', 'Riverside Trail, Rexburg, ID', '2026-10-11'),
((SELECT organization_id FROM organization WHERE name = 'GreenHarvest Growers'),
 'Cooking From The Garden', 'Free class on preparing simple meals from seasonal vegetables.', 'Elm Street Community Garden, Rexburg, ID', '2026-11-07'),

-- UnityServe Volunteers
((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'),
 'Thanksgiving Food Drive', 'Collect, sort, and box donated food for holiday meal baskets.', 'Rexburg Food Pantry, Rexburg, ID', '2026-11-14'),
((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'),
 'Reading Buddies', 'Read one-on-one with second graders who need extra practice.', 'Lincoln Elementary School, Rexburg, ID', '2026-09-24'),
((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'),
 'Senior Center Visits', 'Spend an afternoon visiting and playing games with residents.', 'Golden Years Senior Center, Rexburg, ID', '2026-10-08'),
((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'),
 'Community Blood Drive', 'Register donors and staff the refreshment table at the blood drive.', 'Rexburg City Hall, Rexburg, ID', '2026-10-22'),
((SELECT organization_id FROM organization WHERE name = 'UnityServe Volunteers'),
 'Warm Coat Collection', 'Sort and distribute donated winter coats to families in need.', 'Rexburg Food Pantry, Rexburg, ID', '2026-11-21');

-- ========================================
-- Insert sample data: Project / Category pairings
--
-- Every project is placed in at least one category, and several belong
-- to more than one, which is the whole point of the junction table.
-- ========================================
INSERT INTO project_category (project_id, category_id)
VALUES
-- Wheelchair Ramp Build
((SELECT project_id FROM service_project WHERE title = 'Wheelchair Ramp Build'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),
((SELECT project_id FROM service_project WHERE title = 'Wheelchair Ramp Build'),
 (SELECT category_id FROM category WHERE name = 'Health and Wellness')),

-- Porch Repair Day
((SELECT project_id FROM service_project WHERE title = 'Porch Repair Day'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),

-- Playground Restoration
((SELECT project_id FROM service_project WHERE title = 'Playground Restoration'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),
((SELECT project_id FROM service_project WHERE title = 'Playground Restoration'),
 (SELECT category_id FROM category WHERE name = 'Environmental')),

-- Winter Weatherization
((SELECT project_id FROM service_project WHERE title = 'Winter Weatherization'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),
((SELECT project_id FROM service_project WHERE title = 'Winter Weatherization'),
 (SELECT category_id FROM category WHERE name = 'Environmental')),

-- Community Center Painting
((SELECT project_id FROM service_project WHERE title = 'Community Center Painting'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),

-- Fall Garden Harvest
((SELECT project_id FROM service_project WHERE title = 'Fall Garden Harvest'),
 (SELECT category_id FROM category WHERE name = 'Environmental')),
((SELECT project_id FROM service_project WHERE title = 'Fall Garden Harvest'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),

-- School Garden Workshop
((SELECT project_id FROM service_project WHERE title = 'School Garden Workshop'),
 (SELECT category_id FROM category WHERE name = 'Educational')),
((SELECT project_id FROM service_project WHERE title = 'School Garden Workshop'),
 (SELECT category_id FROM category WHERE name = 'Environmental')),

-- Compost Program Launch
((SELECT project_id FROM service_project WHERE title = 'Compost Program Launch'),
 (SELECT category_id FROM category WHERE name = 'Environmental')),

-- Tree Planting Morning
((SELECT project_id FROM service_project WHERE title = 'Tree Planting Morning'),
 (SELECT category_id FROM category WHERE name = 'Environmental')),

-- Cooking From The Garden
((SELECT project_id FROM service_project WHERE title = 'Cooking From The Garden'),
 (SELECT category_id FROM category WHERE name = 'Educational')),
((SELECT project_id FROM service_project WHERE title = 'Cooking From The Garden'),
 (SELECT category_id FROM category WHERE name = 'Health and Wellness')),

-- Thanksgiving Food Drive
((SELECT project_id FROM service_project WHERE title = 'Thanksgiving Food Drive'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),

-- Reading Buddies
((SELECT project_id FROM service_project WHERE title = 'Reading Buddies'),
 (SELECT category_id FROM category WHERE name = 'Educational')),

-- Senior Center Visits
((SELECT project_id FROM service_project WHERE title = 'Senior Center Visits'),
 (SELECT category_id FROM category WHERE name = 'Health and Wellness')),
((SELECT project_id FROM service_project WHERE title = 'Senior Center Visits'),
 (SELECT category_id FROM category WHERE name = 'Community Service')),

-- Community Blood Drive
((SELECT project_id FROM service_project WHERE title = 'Community Blood Drive'),
 (SELECT category_id FROM category WHERE name = 'Health and Wellness')),

-- Warm Coat Collection
((SELECT project_id FROM service_project WHERE title = 'Warm Coat Collection'),
 (SELECT category_id FROM category WHERE name = 'Community Service'));

-- ========================================
-- Verification queries
-- ========================================
-- SELECT * FROM organization;
-- SELECT * FROM service_project;
-- SELECT * FROM category;
-- SELECT * FROM project_category;
