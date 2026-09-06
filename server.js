import express from 'express';
import { fileURLToPath } from 'url';
import path from 'path';

// Define the application environment
const NODE_ENV = process.env.NODE_ENV?.toLowerCase() || 'production';

// Define the port number the server will listen on
const PORT = process.env.PORT || 3000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

/**
 * Configure Express middleware
 */

// Serve static files from the public directory
app.use(express.static(path.join(__dirname, 'public')));

// Set EJS as the templating engine
app.set('view engine', 'ejs');

// Tell Express where to find your templates
app.set('views', path.join(__dirname, 'src/views'));

// Make the requested path available to every template so the header partial
// can mark the current page in the navigation bar
app.use((req, res, next) => {
    res.locals.currentPath = req.path;
    next();
});

/**
 * Routes
 */
app.get('/', async (req, res) => {
    const title = 'Home';
    res.render('home', { title });
});

app.get('/organizations', async (req, res) => {
    const title = 'Our Partner Organizations';

    const organizations = [
        {
            name: 'BrightFuture Builders',
            email: 'info@brightfuture.org',
            logo: '/images/brightfuture-logo.png',
            description: 'Repairs and builds housing for families in need.'
        },
        {
            name: 'GreenHarvest Growers',
            email: 'contact@greenharvest.org',
            logo: '/images/greenharvest-logo.png',
            description: 'Runs community gardens that supply local food banks.'
        },
        {
            name: 'UnityServe Volunteers',
            email: 'hello@unityserve.org',
            logo: '/images/unityserve-logo.png',
            description: 'Matches neighbors with one-day projects close to home.'
        }
    ];

    res.render('organizations', { title, organizations });
});

app.get('/projects', async (req, res) => {
    const title = 'Service Projects';

    const projects = [
        {
            name: 'Park Cleanup',
            description: 'Join us to clean up local parks and make them beautiful!'
        },
        {
            name: 'Food Drive',
            description: 'Help collect and distribute food to those in need.'
        },
        {
            name: 'Community Tutoring',
            description: 'Volunteer to tutor students in various subjects.'
        }
    ];

    res.render('projects', { title, projects });
});

app.get('/categories', async (req, res) => {
    const title = 'Service Project Categories';

    const categories = [
        {
            name: 'Environmental',
            description: 'Cleanups, tree planting, trail work, and recycling drives.'
        },
        {
            name: 'Educational',
            description: 'Tutoring, reading buddies, and after-school programs.'
        },
        {
            name: 'Community Service',
            description: 'Food drives, home repairs, and neighborhood improvement.'
        },
        {
            name: 'Health and Wellness',
            description: 'Blood drives, meal delivery, and senior companionship.'
        }
    ];

    res.render('categories', { title, categories });
});

app.listen(PORT, () => {
    console.log(`Server is running at http://127.0.0.1:${PORT}`);
    console.log(`Environment: ${NODE_ENV}`);
});
