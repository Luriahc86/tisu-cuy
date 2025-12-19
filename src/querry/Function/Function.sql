DELIMITER $$

DROP FUNCTION IF EXISTS fn_get_total_transactions $$
CREATE FUNCTION fn_get_total_transactions()
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM activity_logs;
    RETURN v_total;
END $$

DROP FUNCTION IF EXISTS fn_get_total_transactions_by_action $$
CREATE FUNCTION fn_get_total_transactions_by_action(p_action_type VARCHAR(50))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM activity_logs
    WHERE action_type = p_action_type;
    RETURN v_total;
END $$

DROP FUNCTION IF EXISTS fn_get_total_transactions_by_user $$
CREATE FUNCTION fn_get_total_transactions_by_user(p_id_user INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM activity_logs
    WHERE id_user = p_id_user;
    RETURN v_total;
END $$

DROP FUNCTION IF EXISTS fn_get_total_transactions_by_table $$
CREATE FUNCTION fn_get_total_transactions_by_table(p_table_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total
    FROM activity_logs
    WHERE table_name = p_table_name;
    RETURN v_total;
END $$

DROP FUNCTION IF EXISTS fn_get_last_transaction_timestamp $$
CREATE FUNCTION fn_get_last_transaction_timestamp()
RETURNS DATETIME
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_timestamp DATETIME;
    SELECT MAX(timestamp) INTO v_timestamp
    FROM activity_logs;
    RETURN v_timestamp;
END $$

DROP FUNCTION IF EXISTS fn_get_last_transaction_by_user $$
CREATE FUNCTION fn_get_last_transaction_by_user(p_id_user INT)
RETURNS DATETIME
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_timestamp DATETIME;
    SELECT MAX(timestamp) INTO v_timestamp
    FROM activity_logs
    WHERE id_user = p_id_user;
    RETURN v_timestamp;
END $$

DROP FUNCTION IF EXISTS fn_get_user_by_transaction_id $$
CREATE FUNCTION fn_get_user_by_transaction_id(p_id_activity INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_username VARCHAR(100);
    SELECT username INTO v_username
    FROM activity_logs
    WHERE id_activity = p_id_activity;
    RETURN COALESCE(v_username, 'Unknown');
END $$

DROP FUNCTION IF EXISTS fn_get_action_type_by_transaction $$
CREATE FUNCTION fn_get_action_type_by_transaction(p_id_activity INT)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_action_type VARCHAR(50);
    SELECT action_type INTO v_action_type
    FROM activity_logs
    WHERE id_activity = p_id_activity;
    RETURN COALESCE(v_action_type, 'UNKNOWN');
END $$

DROP FUNCTION IF EXISTS fn_get_table_name_by_transaction $$
CREATE FUNCTION fn_get_table_name_by_transaction(p_id_activity INT)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_table_name VARCHAR(50);
    SELECT table_name INTO v_table_name
    FROM activity_logs
    WHERE id_activity = p_id_activity;
    RETURN COALESCE(v_table_name, 'UNKNOWN');
END $$

DROP FUNCTION IF EXISTS fn_get_operation_type_by_transaction $$
CREATE FUNCTION fn_get_operation_type_by_transaction(p_id_activity INT)
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_operation_type VARCHAR(50);
    SELECT operation_type INTO v_operation_type
    FROM activity_logs
    WHERE id_activity = p_id_activity;
    RETURN COALESCE(v_operation_type, 'UNKNOWN');
END $$

DROP FUNCTION IF EXISTS fn_get_record_id_by_transaction $$
CREATE FUNCTION fn_get_record_id_by_transaction(p_id_activity INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_record_id INT;
    SELECT record_id INTO v_record_id
    FROM activity_logs
    WHERE id_activity = p_id_activity;
    RETURN COALESCE(v_record_id, 0);
END $$

DROP FUNCTION IF EXISTS fn_get_description_by_transaction $$
CREATE FUNCTION fn_get_description_by_transaction(p_id_activity INT)
RETURNS VARCHAR(255)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_description VARCHAR(255);
    SELECT description INTO v_description
    FROM activity_logs
    WHERE id_activity = p_id_activity;
    RETURN COALESCE(v_description, 'No description');
END $$

DELIMITER ;