import db from './db.js';

/**
 * The columns every project query returns, so that each project object has
 * the same shape no matter which function produced it.
 *
 * TO_CHAR formats the date in the database, which avoids the time zone shift
 * that happens when a DATE column is converted to a JavaScript Date.
 */
const projectColumns = `
    service_project.project_id,
    service_project.title,
    service_project.description,
    service_project.location,
    TO_CHAR(service_project.project_date, 'FMMonth FMDD, YYYY') AS project_date,
    organization.organization_id,
    organization.name AS organization_name
`;

/**
 * Gets every service project along with the name of its sponsoring organization.
 */
const getAllProjects = async() => {
    const query = `
        SELECT ${projectColumns}
        FROM public.service_project
        JOIN public.organization
            ON service_project.organization_id = organization.organization_id
        ORDER BY service_project.project_date;
    `;

    const result = await db.query(query);

    return result.rows;
}

/**
 * Gets the next upcoming service projects, soonest first.
 *
 * Projects that have already happened are excluded by comparing the project
 * date to CURRENT_DATE, and the LIMIT keeps the list to the requested size.
 */
const getUpcomingProjects = async(numberOfProjects) => {
    const query = `
        SELECT ${projectColumns}
        FROM public.service_project
        JOIN public.organization
            ON service_project.organization_id = organization.organization_id
        WHERE service_project.project_date >= CURRENT_DATE
        ORDER BY service_project.project_date
        LIMIT $1;
    `;

    const queryParams = [numberOfProjects];
    const result = await db.query(query, queryParams);

    return result.rows;
}

/**
 * Gets the details of a single service project.
 */
const getProjectDetails = async(projectId) => {
    const query = `
        SELECT ${projectColumns}
        FROM public.service_project
        JOIN public.organization
            ON service_project.organization_id = organization.organization_id
        WHERE service_project.project_id = $1;
    `;

    const queryParams = [projectId];
    const result = await db.query(query, queryParams);

    // Return the first row of the result set, or null if no rows are found
    return result.rows.length > 0 ? result.rows[0] : null;
}

/**
 * Gets every service project sponsored by one organization.
 */
const getProjectsByOrganizationId = async(organizationId) => {
    const query = `
        SELECT ${projectColumns}
        FROM public.service_project
        JOIN public.organization
            ON service_project.organization_id = organization.organization_id
        WHERE service_project.organization_id = $1
        ORDER BY service_project.project_date;
    `;

    const queryParams = [organizationId];
    const result = await db.query(query, queryParams);

    return result.rows;
}

/**
 * Gets every service project that belongs to one category.
 *
 * This needs an extra JOIN through project_category, the junction table that
 * models the many-to-many relationship between projects and categories.
 */
const getProjectsByCategoryId = async(categoryId) => {
    const query = `
        SELECT ${projectColumns}
        FROM public.service_project
        JOIN public.organization
            ON service_project.organization_id = organization.organization_id
        JOIN public.project_category
            ON service_project.project_id = project_category.project_id
        WHERE project_category.category_id = $1
        ORDER BY service_project.project_date;
    `;

    const queryParams = [categoryId];
    const result = await db.query(query, queryParams);

    return result.rows;
}

// Export the model functions
export {
    getAllProjects,
    getUpcomingProjects,
    getProjectDetails,
    getProjectsByOrganizationId,
    getProjectsByCategoryId
}
