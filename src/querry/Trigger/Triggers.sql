DELIMITER $$

DROP TRIGGER IF EXISTS tr_users_insert $$
CREATE TRIGGER tr_users_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (NEW.id_user, 'USER_CREATED', CONCAT('User created: ', NEW.username, ' (', NEW.role, ')'));
END $$

DROP TRIGGER IF EXISTS tr_users_update $$
CREATE TRIGGER tr_users_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (NEW.id_user, 'USER_UPDATED', CONCAT('User updated: ', NEW.username));
END $$

DROP TRIGGER IF EXISTS tr_users_delete $$
CREATE TRIGGER tr_users_delete
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (OLD.id_user, 'USER_DELETED', CONCAT('User deleted: ', OLD.username));
END $$

DROP TRIGGER IF EXISTS tr_locations_insert $$
CREATE TRIGGER tr_locations_insert
AFTER INSERT ON locations
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (1, 'LOCATION_CREATED', CONCAT('Location created: ', NEW.location_name));
END $$

DROP TRIGGER IF EXISTS tr_locations_update $$
CREATE TRIGGER tr_locations_update
AFTER UPDATE ON locations
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (1, 'LOCATION_UPDATED', CONCAT('Location updated: ', NEW.location_name));
END $$

DROP TRIGGER IF EXISTS tr_locations_delete $$
CREATE TRIGGER tr_locations_delete
BEFORE DELETE ON locations
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (1, 'LOCATION_DELETED', CONCAT('Location deleted: ', OLD.location_name));
END $$

DROP TRIGGER IF EXISTS tr_dispensers_insert $$
CREATE TRIGGER tr_dispensers_insert
AFTER INSERT ON dispensers
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (1, 'DISPENSER_CREATED', CONCAT('Dispenser created: ', NEW.dispenser_code, ' at location ', NEW.id_location));
END $$

DROP TRIGGER IF EXISTS tr_dispensers_update $$
CREATE TRIGGER tr_dispensers_update
AFTER UPDATE ON dispensers
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (1, 'DISPENSER_UPDATED', CONCAT('Dispenser updated: ', NEW.dispenser_code, ' status: ', NEW.status));
END $$

DROP TRIGGER IF EXISTS tr_dispensers_delete $$
CREATE TRIGGER tr_dispensers_delete
BEFORE DELETE ON dispensers
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (1, 'DISPENSER_DELETED', CONCAT('Dispenser deleted: ', OLD.dispenser_code));
END $$

DROP TRIGGER IF EXISTS tr_replacement_reports_insert $$
CREATE TRIGGER tr_replacement_reports_insert
AFTER INSERT ON replacement_reports
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (NEW.id_user, 'REPORT_CREATED', CONCAT('Replacement report created for dispenser ', NEW.id_dispenser, ': ', NEW.tissue_quantity, ' units'));
END $$

DROP TRIGGER IF EXISTS tr_replacement_reports_delete $$
CREATE TRIGGER tr_replacement_reports_delete
BEFORE DELETE ON replacement_reports
FOR EACH ROW
BEGIN
    INSERT INTO activity_logs (id_user, action, description)
    VALUES (OLD.id_user, 'REPORT_DELETED', CONCAT('Replacement report deleted: ', OLD.id_report));
END $$

DROP TRIGGER IF EXISTS tr_validate_dispenser_insert $$
CREATE TRIGGER tr_validate_dispenser_insert
BEFORE INSERT ON dispensers
FOR EACH ROW
BEGIN
    DECLARE v_location_exists INT;
    
    SELECT COUNT(*) INTO v_location_exists FROM locations WHERE id_location = NEW.id_location;
    
    IF v_location_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Location does not exist';
    END IF;
    
    IF NEW.dispenser_code IS NULL OR NEW.dispenser_code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Dispenser code cannot be empty';
    END IF;
END $$

DROP TRIGGER IF EXISTS tr_validate_replacement_report_insert $$
CREATE TRIGGER tr_validate_replacement_report_insert
BEFORE INSERT ON replacement_reports
FOR EACH ROW
BEGIN
    DECLARE v_dispenser_exists INT;
    DECLARE v_user_exists INT;
    
    SELECT COUNT(*) INTO v_dispenser_exists FROM dispensers WHERE id_dispenser = NEW.id_dispenser;
    SELECT COUNT(*) INTO v_user_exists FROM users WHERE id_user = NEW.id_user;
    
    IF v_dispenser_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Dispenser does not exist';
    END IF;
    
    IF v_user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: User does not exist';
    END IF;
    
    IF NEW.tissue_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Tissue quantity must be greater than 0';
    END IF;
END $$

DELIMITER ;
