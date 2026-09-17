import db from './db.js';

/**
 * Gets every organization in the database.
 */
const getAllOrganizations = async() => {
    const query = `
        SELECT organization_id, name, description, contact_email, logo_filename
        FROM public.organization
        ORDER BY name;
    `;

    const result = await db.query(query);

    return result.rows;
}

/**
 * Gets the details of a single organization.
 *
 * The $1 placeholder is a parameterized query. The value is sent to Postgres
 * separately from the SQL text, so a malicious id can never be executed as
 * part of the statement.
 */
const getOrganizationDetails = async(organizationId) => {
    const query = `
        SELECT organization_id, name, description, contact_email, logo_filename
        FROM public.organization
        WHERE organization_id = $1;
    `;

    const queryParams = [organizationId];
    const result = await db.query(query, queryParams);

    // Return the first row of the result set, or null if no rows are found
    return result.rows.length > 0 ? result.rows[0] : null;
}

// Export the model functions
export { getAllOrganizations, getOrganizationDetails }
