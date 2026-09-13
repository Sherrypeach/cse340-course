import db from './db.js';

/**
 * Gets every service project along with the name of the organization
 * that sponsors it.
 *
 * The JOIN follows the foreign key from service_project.organization_id
 * back to organization.organization_id, which is what lets a single row
 * carry both the project details and the sponsoring organization's name.
 *
 * TO_CHAR formats the date in the database so the template receives a
 * ready-to-display string and does not have to deal with time zones.
 */
const getAllProjects = async() => {
    const query = `
        SELECT service_project.project_id,
               service_project.title,
               service_project.description,
               service_project.location,
               TO_CHAR(service_project.project_date, 'FMMonth FMDD, YYYY') AS project_date,
               organization.organization_id,
               organization.name AS organization_name
        FROM public.service_project
        JOIN public.organization
            ON service_project.organization_id = organization.organization_id
        ORDER BY service_project.project_date;
    `;

    const result = await db.query(query);

    return result.rows;
}

export { getAllProjects }
