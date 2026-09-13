# CSE 340 Service Network

Course project for **CSE 340: Web Backend Development** (BYU-Idaho). A site that
connects volunteers with service opportunities in their community, in the spirit
of JustServe.org.

Built with Node.js, Express, EJS templates, and PostgreSQL.

## Running it locally

```bash
npm install
npm run dev
```

Then open <http://127.0.0.1:3000>.

`npm run dev` uses nodemon and passes `.env` to Node, so the server restarts
whenever a `.js`, `.css`, `.ejs`, or `.env` file changes. `npm start` runs the
server once in production mode, which is what Render uses.

## Environment variables

`.env` is not committed. Copy `.env.example` to `.env` and fill in the values:

```
PORT=3000
NODE_ENV=development
DB_URL=postgresql://user:password@host:port/database
ENABLE_SQL_LOGGING=true
```

`DB_URL` is the **External Database URL** from the Render Postgres dashboard when
running locally. On Render itself, set `DB_URL` to the **Internal Database URL**,
`ENABLE_SQL_LOGGING` to `true`, and `NODE_ENV` to `production`.

Query logging only turns on when `NODE_ENV=development` *and*
`ENABLE_SQL_LOGGING=true`, so production never pays the logging cost.

## Database

`src/setup.sql` re-creates the whole database from scratch: it drops the existing
tables in reverse dependency order, creates them again, and inserts the sample
data. Run it in the pgAdmin Query Tool against the course database.

The schema has four tables:

| Table | Purpose |
| --- | --- |
| `organization` | The groups that sponsor projects |
| `service_project` | Projects, each with a foreign key to its sponsoring organization |
| `category` | The kinds of work a project can involve |
| `project_category` | Junction table pairing projects with categories |

A project belongs to one organization (one-to-many), but a project can be in many
categories and a category can hold many projects (many-to-many), which is why
`project_category` exists as its own table with a composite primary key.

## Pages

| Route            | View                | Title variable              |
| ---------------- | ------------------- | --------------------------- |
| `/`              | `home.ejs`          | Home                        |
| `/organizations` | `organizations.ejs` | Our Partner Organizations   |
| `/projects`      | `projects.ejs`      | Service Projects            |
| `/categories`    | `categories.ejs`    | Service Project Categories  |

## Project structure

```
.
├── public/            Static files served at the site root
│   ├── css/main.css
│   └── images/
├── src/
│   ├── setup.sql      Re-creates the database and its sample data
│   ├── models/        All database access lives here
│   │   ├── db.js              Connection pool and testConnection
│   │   ├── organizations.js   getAllOrganizations
│   │   ├── projects.js        getAllProjects (joins organization)
│   │   └── categories.js      getAllCategories
│   └── views/         EJS templates, rendered through routes
│       ├── partials/  header.ejs and footer.ejs, used by every page
│       ├── home.ejs
│       ├── organizations.ejs
│       ├── projects.ejs
│       └── categories.ejs
├── nodemon.json
├── package.json
└── server.js
```

Anything in `public/` is served directly by `express.static`, so
`public/css/main.css` is available at `/css/main.css`. Templates in `src/views/`
are only reachable through a route, which leaves room to add logic and checks
before a page is sent.

## Code conventions

- ESM `import` / `export` syntax (`"type": "module"` in package.json)
- `const` wherever a value is not reassigned
- camelCase variable names
- Arrow functions for all route handlers and middleware
- `async` / `await` rather than promises or callbacks
- `<%= %>` for all data in templates; `<%- %>` only for including partials
- All database queries live in `src/models/`, never in `server.js`
- Queries name their columns explicitly instead of using `SELECT *`

## Deployment

Deployed to Render.com as a Node web service.

- Build command: `npm install`
- Start command: `npm start`
- Environment variable: `NODE_ENV=production`
- Auto deploy: on commit to `main`
