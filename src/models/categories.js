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

export { getAllCategories }
