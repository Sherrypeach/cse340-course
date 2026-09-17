// Import any needed model functions
import { getUpcomingProjects, getProjectDetails } from '../models/projects.js';
import { getCategoriesByProjectId } from '../models/categories.js';

// How many upcoming projects the main projects page lists
const NUMBER_OF_UPCOMING_PROJECTS = 5;

// Define any controller functions
const showProjectsPage = async (req, res) => {
    const projects = await getUpcomingProjects(NUMBER_OF_UPCOMING_PROJECTS);
    const title = 'Upcoming Service Projects';

    res.render('projects', { title, projects });
};

const showProjectDetailsPage = async (req, res, next) => {
    const projectId = req.params.id;
    const projectDetails = await getProjectDetails(projectId);

    // An id that matches no project is a missing page, not a server fault
    if (!projectDetails) {
        const err = new Error('Service Project Not Found');
        err.status = 404;
        return next(err);
    }

    const categories = await getCategoriesByProjectId(projectId);
    const title = 'Service Project Details';

    res.render('project', { title, projectDetails, categories });
};

// Export any controller functions
export { showProjectsPage, showProjectDetailsPage };
