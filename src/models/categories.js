import db from './db.js';

/**
 * Gets every service project category in the database.
 */
const getAllCategories = async() => {
    const query = `
        SELECT category_id, name
        FROM public.category
        ORDER BY name;
    `;

    const result = await db.query(query);

    return result.rows;
}

/**
 * Gets the details of a single category.
 */
const getCategoryDetails = async(categoryId) => {
    const query = `
        SELECT category_id, name
        FROM public.category
        WHERE category_id = $1;
    `;

    const queryParams = [categoryId];
    const result = await db.query(query, queryParams);

    // Return the first row of the result set, or null if no rows are found
    return result.rows.length > 0 ? result.rows[0] : null;
}

/**
 * Gets every category that one service project belongs to.
 *
 * Like the matching function in the projects model, this joins through the
 * project_category junction table.
 */
const getCategoriesByProjectId = async(projectId) => {
    const query = `
        SELECT category.category_id, category.name
        FROM public.category
        JOIN public.project_category
            ON category.category_id = project_category.category_id
        WHERE project_category.project_id = $1
        ORDER BY category.name;
    `;

    const queryParams = [projectId];
    const result = await db.query(query, queryParams);

    return result.rows;
}

// Export the model functions
export { getAllCategories, getCategoryDetails, getCategoriesByProjectId }
