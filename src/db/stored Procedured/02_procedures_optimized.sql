DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_user $$
CREATE PROCEDURE sp_register_user (
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_role ENUM('ADMIN', 'STAFF'),
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    OUT p_status VARCHAR(100),
    OUT p_id_user INT
)
BEGIN
    DECLARE v_user_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
        SET p_status = CONCAT('ERROR: ', @err_msg);
        ROLLBACK;
    END;

    SELECT COUNT(*) INTO v_user_exists FROM users WHERE username = p_username;
    
    IF v_user_exists > 0 THEN
        SET p_status = 'ERROR: Username already exists';
    ELSE
        START TRANSACTION;
        INSERT INTO users (username, password, role, full_name, email, phone, is_active)
        VALUES (p_username, p_password, p_role, p_full_name, p_email, p_phone, TRUE);
        SET p_id_user = LAST_INSERT_ID();
        SET p_status = 'SUCCESS: User registered successfully';
        COMMIT;
    END IF;
END $$

DROP PROCEDURE IF EXISTS sp_login_user $$
CREATE PROCEDURE sp_login_user (
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    OUT p_status VARCHAR(100),
    OUT p_id_user INT,
    OUT p_role VARCHAR(50),
    OUT p_full_name VARCHAR(100),
    OUT p_email VARCHAR(100)
)
BEGIN
    DECLARE v_user_count INT;
    DECLARE v_stored_password VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
        SET p_status = CONCAT('ERROR: ', @err_msg);
        ROLLBACK;
    END;

    SELECT COUNT(*) INTO v_user_count FROM users WHERE username = p_username AND is_active = TRUE;
    
    IF v_user_count = 0 THEN
        SET p_status = 'ERROR: Invalid username or password';
    ELSE
        SELECT password INTO v_stored_password FROM users WHERE username = p_username AND is_active = TRUE;
        
        IF v_stored_password != p_password THEN
            SET p_status = 'ERROR: Invalid username or password';
        ELSE
            START TRANSACTION;
            SELECT id_user, role, full_name, email INTO p_id_user, p_role, p_full_name, p_email
            FROM users WHERE username = p_username AND is_active = TRUE;
            
            INSERT INTO login_history (id_user, username, role)
            VALUES (p_id_user, p_username, p_role);
            
            SET p_status = 'SUCCESS: Login successful';
            COMMIT;
        END IF;
    END IF;
END $$

DROP PROCEDURE IF EXISTS sp_create_user $$
CREATE PROCEDURE sp_create_user (
    IN p_id_user_creator INT,
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_role ENUM('ADMIN', 'STAFF'),
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15)
)
BEGIN
    DECLARE v_creator_role VARCHAR(50);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @err_msg;
    END;

    SELECT role INTO v_creator_role FROM users WHERE id_user = p_id_user_creator;
    
    IF v_creator_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Hanya ADMIN yang dapat menambah user!';
    END IF;

    START TRANSACTION;
    INSERT INTO users (username, password, role, full_name, email, phone)
    VALUES (p_username, p_password, p_role, p_full_name, p_email, p_phone);
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_update_user $$
CREATE PROCEDURE sp_update_user (
    IN p_id_user_creator INT,
    IN p_id_user_target INT,
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_role ENUM('ADMIN', 'STAFF'),
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15)
)
BEGIN
    DECLARE v_creator_role VARCHAR(50);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @err_msg;
    END;

    SELECT role INTO v_creator_role FROM users WHERE id_user = p_id_user_creator;
    
    IF v_creator_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Hanya ADMIN yang dapat mengedit user!';
    END IF;

    START TRANSACTION;
    UPDATE users
    SET username = p_username,
        password = p_password,
        role = p_role,
        full_name = p_full_name,
        email = p_email,
        phone = p_phone
    WHERE id_user = p_id_user_target;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_delete_user $$
CREATE PROCEDURE sp_delete_user (
    IN p_id_user_creator INT,
    IN p_id_user_target INT
)
BEGIN
    DECLARE v_creator_role VARCHAR(50);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @err_msg = MESSAGE_TEXT;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @err_msg;
    END;

    SELECT role INTO v_creator_role FROM users WHERE id_user = p_id_user_creator;
    
    IF v_creator_role != 'ADMIN' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Hanya ADMIN yang dapat menghapus user!';
    END IF;

    START TRANSACTION;
    DELETE FROM users WHERE id_user = p_id_user_target;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_create_location $$
CREATE PROCEDURE sp_create_location (
    IN p_id_user INT,
    IN p_location_name VARCHAR(100),
    IN p_description TEXT,
    IN p_address VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    INSERT INTO locations (id_user, location_name, description, address)
    VALUES (p_location_name, p_description, p_address);
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_update_location $$
CREATE PROCEDURE sp_update_location (
    IN p_id_location INT,
    IN p_location_name VARCHAR(100),
    IN p_description TEXT,
    IN p_address VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    UPDATE locations
    SET location_name = p_location_name,
        description = p_description,
        address = p_address
    WHERE id_location = p_id_location;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_delete_location $$
CREATE PROCEDURE sp_delete_location (
    IN p_id_location INT
)
BEGIN
    START TRANSACTION;
    DELETE FROM locations WHERE id_location = p_id_location;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_create_dispenser $$
CREATE PROCEDURE sp_create_dispenser (
    IN p_id_location INT,
    IN p_dispenser_code VARCHAR(50),
    IN p_status ENUM('ACTIVE', 'DAMAGED', 'MAINTENANCE'),
    IN p_installation_date DATE
)
BEGIN
    START TRANSACTION;
    INSERT INTO dispensers (id_location, dispenser_code, status, installation_date)
    VALUES (p_id_location, p_dispenser_code, p_status, p_installation_date);
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_update_dispenser $$
CREATE PROCEDURE sp_update_dispenser (
    IN p_id_dispenser INT,
    IN p_id_location INT,
    IN p_dispenser_code VARCHAR(50),
    IN p_status ENUM('ACTIVE', 'DAMAGED', 'MAINTENANCE'),
    IN p_installation_date DATE
)
BEGIN
    START TRANSACTION;
    UPDATE dispensers
    SET id_location = p_id_location,
        dispenser_code = p_dispenser_code,
        status = p_status,
        installation_date = p_installation_date
    WHERE id_dispenser = p_id_dispenser;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_delete_dispenser $$
CREATE PROCEDURE sp_delete_dispenser (
    IN p_id_dispenser INT
)
BEGIN
    START TRANSACTION;
    DELETE FROM dispensers WHERE id_dispenser = p_id_dispenser;
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_create_replacement_report $$
CREATE PROCEDURE sp_create_replacement_report (
    IN p_id_user INT,
    IN p_id_dispenser INT,
    IN p_tissue_quantity INT,
    IN p_notes TEXT
)
BEGIN
    DECLARE v_user_role VARCHAR(50);

    SELECT role INTO v_user_role FROM users WHERE id_user = p_id_user;
    
    IF v_user_role NOT IN ('ADMIN', 'STAFF') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User role invalid for report';
    END IF;

    START TRANSACTION;
    INSERT INTO replacement_reports (id_dispenser, id_user, tissue_quantity, notes)
    VALUES (p_id_dispenser, p_id_user, p_tissue_quantity, p_notes);
    COMMIT;
END $$

DROP PROCEDURE IF EXISTS sp_get_transactions $$
CREATE PROCEDURE sp_get_transactions (
    IN p_limit INT,
    IN p_offset INT,
    IN p_action_type VARCHAR(50),
    IN p_resource_type VARCHAR(50),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_user_id INT
)
BEGIN
    DECLARE v_query VARCHAR(2000);
    
    SELECT 
        id_activity,
        id_user,
        username,
        action_type,
        table_name AS resource_type,
        operation_type,
        record_id,
        description,
        timestamp,
        old_values,
        new_values
    FROM v_activity_logs
    WHERE 
        (p_action_type IS NULL OR action_type = p_action_type)
        AND (p_resource_type IS NULL OR table_name = p_resource_type)
        AND (p_start_date IS NULL OR DATE(timestamp) >= p_start_date)
        AND (p_end_date IS NULL OR DATE(timestamp) <= p_end_date)
        AND (p_user_id IS NULL OR id_user = p_user_id)
    ORDER BY timestamp DESC
    LIMIT p_limit OFFSET p_offset;
END $$

DROP PROCEDURE IF EXISTS sp_get_transaction_by_id $$
CREATE PROCEDURE sp_get_transaction_by_id (
    IN p_id_activity INT
)
BEGIN
    SELECT 
        id_activity,
        id_user,
        username,
        action_type,
        table_name AS resource_type,
        operation_type,
        record_id,
        description,
        timestamp,
        old_values,
        new_values
    FROM v_activity_logs
    WHERE id_activity = p_id_activity;
END $$

DROP PROCEDURE IF EXISTS sp_get_activity_summary $$
CREATE PROCEDURE sp_get_activity_summary (
    IN p_days INT
)
BEGIN
    SELECT 
        DATE(timestamp) AS activity_date,
        action_type,
        COUNT(*) AS total_activities,
        COUNT(DISTINCT id_user) AS unique_users
    FROM activity_logs
    WHERE timestamp >= DATE_SUB(CURDATE(), INTERVAL COALESCE(p_days, 7) DAY)
    GROUP BY DATE(timestamp), action_type
    ORDER BY activity_date DESC, action_type;
END $$

DELIMITER $$