DELIMITER $$

CREATE OR REPLACE VIEW v_users AS
SELECT 
    id_user,
    username,
    role,
    full_name,
    email,
    phone,
    is_active,
    created_at,
    updated_at
FROM users
WHERE is_active = TRUE;

CREATE OR REPLACE VIEW v_locations AS
SELECT 
    id_location,
    location_name,
    description,
    address,
    created_at,
    updated_at
FROM locations;

CREATE OR REPLACE VIEW v_dispensers AS
SELECT 
    d.id_dispenser,
    d.dispenser_code,
    d.status,
    d.installation_date,
    d.last_maintenance_date,
    l.id_location,
    l.location_name,
    l.address,
    d.created_at,
    d.updated_at
FROM dispensers d
JOIN locations l ON d.id_location = l.id_location;

CREATE OR REPLACE VIEW v_replacement_reports AS
SELECT 
    rr.id_report,
    rr.id_dispenser,
    d.dispenser_code,
    l.location_name,
    rr.id_user,
    u.full_name AS staff_name,
    u.username AS staff_username,
    rr.tissue_quantity,
    rr.notes,
    rr.replacement_time
FROM replacement_reports rr
JOIN dispensers d ON rr.id_dispenser = d.id_dispenser
JOIN locations l ON d.id_location = l.id_location
JOIN users u ON rr.id_user = u.id_user;

CREATE OR REPLACE VIEW v_activity_logs AS
SELECT
    al.id_log,
    al.id_user,
    u.full_name,
    u.username,
    u.role,
    al.action,
    al.description,
    al.log_time
FROM activity_logs al
JOIN users u ON al.id_user = u.id_user
ORDER BY al.log_time DESC;

CREATE OR REPLACE VIEW v_dashboard_summary AS
SELECT
    (SELECT COUNT(*) FROM dispensers) AS total_dispensers,
    (SELECT COUNT(*) FROM dispensers WHERE status = 'ACTIVE') AS active_dispensers,
    (SELECT COUNT(*) FROM dispensers WHERE status = 'DAMAGED') AS damaged_dispensers,
    (SELECT COUNT(*) FROM dispensers WHERE status = 'MAINTENANCE') AS maintenance_dispensers,
    (SELECT COUNT(*) FROM locations) AS total_locations,
    (SELECT COUNT(*) FROM users WHERE role = 'ADMIN') AS total_admins,
    (SELECT COUNT(*) FROM users WHERE role = 'STAFF') AS total_staff,
    (SELECT COUNT(*) FROM replacement_reports WHERE DATE(replacement_time) = CURRENT_DATE) AS reports_today,
    (SELECT MAX(replacement_time) FROM replacement_reports) AS last_replacement_time;

CREATE OR REPLACE VIEW v_login_history AS
SELECT
    id_login,
    id_user,
    username,
    role,
    login_time
FROM login_history
ORDER BY login_time DESC;

DELIMITER ;
