# CSE 340 Service Network

Course project for **CSE 340: Web Backend Development** (BYU-Idaho). A site that
connects volunteers with service opportunities in their community, in the spirit
of JustServe.org.

Built with Node.js, Express, and EJS templates.

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

`.env` is not committed. Copy `.env.example` to `.env` to create it:

```
PORT=3000
NODE_ENV=development
```

On Render, `NODE_ENV` is set to `production` in the service settings.

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
├── src/views/         EJS templates, rendered through routes
│   ├── partials/      header.ejs and footer.ejs, used by every page
│   ├── home.ejs
│   ├── organizations.ejs
│   ├── projects.ejs
│   └── categories.ejs
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

## Deployment

Deployed to Render.com as a Node web service.

- Build command: `npm install`
- Start command: `npm start`
- Environment variable: `NODE_ENV=production`
- Auto deploy: on commit to `main`
