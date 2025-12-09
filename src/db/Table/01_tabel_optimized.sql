DELIMITER $$

CREATE TABLE IF NOT EXISTS users (
  id_user INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('ADMIN', 'STAFF') NOT NULL,
  full_name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(15),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_role (role),
  INDEX idx_is_active (is_active)
);

CREATE TABLE IF NOT EXISTS login_history (
  id_login INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT NOT NULL,
  username VARCHAR(50) NOT NULL,
  role ENUM('ADMIN', 'STAFF') NOT NULL,
  login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_login_user FOREIGN KEY (id_user)
    REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_login_time (login_time),
  INDEX idx_id_user (id_user)
);

CREATE TABLE IF NOT EXISTS locations (
  id_location INT AUTO_INCREMENT PRIMARY KEY,
  location_name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  address VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_location_name (location_name)
);

CREATE TABLE IF NOT EXISTS dispensers (
  id_dispenser INT AUTO_INCREMENT PRIMARY KEY,
  id_location INT NOT NULL,
  dispenser_code VARCHAR(50) NOT NULL UNIQUE,
  status ENUM('ACTIVE', 'DAMAGED', 'MAINTENANCE') DEFAULT 'ACTIVE',
  installation_date DATE,
  last_maintenance_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_dispenser_location FOREIGN KEY (id_location)
    REFERENCES locations(id_location) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_status (status),
  INDEX idx_location (id_location),
  INDEX idx_dispenser_code (dispenser_code)
);

CREATE TABLE IF NOT EXISTS replacement_reports (
  id_report INT AUTO_INCREMENT PRIMARY KEY,
  id_dispenser INT NOT NULL,
  id_user INT NOT NULL,
  tissue_quantity INT NOT NULL,
  notes TEXT,
  replacement_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_report_dispenser FOREIGN KEY (id_dispenser)
    REFERENCES dispensers(id_dispenser) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_report_user FOREIGN KEY (id_user)
    REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_replacement_time (replacement_time),
  INDEX idx_id_user (id_user),
  INDEX idx_id_dispenser (id_dispenser)
);

CREATE TABLE IF NOT EXISTS activity_logs (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT NOT NULL,
  action VARCHAR(100) NOT NULL,
  description TEXT,
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_log_user FOREIGN KEY (id_user)
    REFERENCES users(id_user) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_log_time (log_time),
  INDEX idx_id_user (id_user),
  INDEX idx_action (action)
);

ALTER TABLE locations 
ADD COLUMN id_user INT NOT NULL;

DELIMITER ;