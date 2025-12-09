Database Setup Guide - Tisu CUY Management System

# EXECUTION ORDER:

1. Run: 01_tabel_optimized.sql

   - Creates all necessary tables with proper indexes
   - Tables: users, login_history, locations, dispensers, replacement_reports, activity_logs

2. Run: 02_procedures_optimized.sql

   - Creates all stored procedures for CRUD operations
   - Includes new procedures: sp_register_user, sp_login_user
   - All procedures include transaction management and error handling

3. Run: 03_views_optimized.sql

   - Creates views for easier data retrieval
   - Views with relationships and full details included

4. Run: 04_triggers_optimized.sql
   - Creates audit triggers for all table operations
   - Validation triggers to ensure data integrity
   - Auto-logging for compliance and tracking

# FEATURES IMPLEMENTED:

1. STORED PROCEDURES WITH TRANSACTIONS:

   - sp_register_user: Register new user with transaction + output parameters
   - sp_login_user: Login with transaction + auto-log to login_history
   - sp_create_user: Create user (admin only)
   - sp_update_user: Update user (admin only)
   - sp_delete_user: Delete user (admin only)
   - sp_create_location, sp_update_location, sp_delete_location
   - sp_create_dispenser, sp_update_dispenser, sp_delete_dispenser
   - sp_create_replacement_report, sp_delete_replacement_report

   Transaction Visibility Functions:

   - sp_get_transactions: Retrieve transactions with filtering and pagination
   - sp_get_transaction_by_id: Get detail of specific transaction
   - sp_get_activity_summary: Get summary of activities by date and action type

   Transaction Features:

   - START TRANSACTION / COMMIT / ROLLBACK
   - Error handling with EXIT HANDLER
   - Output parameters for status reporting
   - Role-based access control

2. TRIGGERS FOR AUDIT & VALIDATION:

   Audit Triggers (Auto-logging):

   - tr_users_insert: Log when user is created
   - tr_users_update: Log when user is updated
   - tr_users_delete: Log when user is deleted
   - tr_locations_insert/update/delete
   - tr_dispensers_insert/update/delete
   - tr_replacement_reports_insert/delete

   Validation Triggers (Data Integrity):

   - tr_validate_dispenser_insert: Check location exists, dispenser_code not empty
   - tr_validate_replacement_report_insert: Check dispenser/user exist, quantity > 0

3. VIEWS WITH RELATIONSHIPS:
   - v_users: Active users only
   - v_locations: All location details
   - v_dispensers: Dispensers with location details
   - v_replacement_reports: Full report details with user, dispenser, location
   - v_activity_logs: Activity with user information
   - v_dashboard_summary: Aggregate statistics
   - v_login_history: Login tracking

# API ENDPOINTS:

## Authentication:

**GET /api/auth/register** - View all registrations
Query Parameters:

- limit: 50 (default)
- offset: 0 (default)
- role: ADMIN|STAFF (optional)
- start_date: YYYY-MM-DD (optional)
- end_date: YYYY-MM-DD (optional)

Response:
{
"status": "success",
"data": [
{
"id_user": 1,
"username": "admin",
"role": "ADMIN",
"full_name": "Administrator",
"email": "admin@example.com",
"phone": "08123456789",
"is_active": true,
"created_at": "2025-12-01T10:00:00.000Z"
}
],
"pagination": {
"limit": 50,
"offset": 0,
"total": 1
},
"message": "Registrations retrieved successfully"
}

**POST /api/auth/register** - Register new user
Body:
{
"username": "newuser",
"password": "password123",
"role": "STAFF",
"full_name": "New User",
"email": "newuser@example.com",
"phone": "08987654321"
}

Response:
{
"status": "success",
"message": "User registered successfully",
"data": {
"id_user": 2
}
}

**GET /api/auth/login** - View login history
Query Parameters:

- limit: 50 (default)
- offset: 0 (default)
- user_id: 1 (optional)
- username: string (optional)
- role: ADMIN|STAFF (optional)
- start_date: YYYY-MM-DD (optional)
- end_date: YYYY-MM-DD (optional)

Response:
{
"status": "success",
"data": [
{
"id_login": 1,
"id_user": 1,
"username": "admin",
"role": "ADMIN",
"login_time": "2025-12-08T01:30:00.000Z"
}
],
"pagination": {
"limit": 50,
"offset": 0,
"total": 1
},
"message": "Login history retrieved successfully"
}

**POST /api/auth/login** - Login user
Body:
{
"username": "admin",
"password": "password123"
}

Response:
{
"status": "success",
"message": "Login successful",
"data": {
"id_user": 1,
"username": "admin",
"role": "ADMIN",
"full_name": "Administrator",
"email": "admin@example.com"
}
}

**POST /api/auth/logout** - Logout user
Response:
{
"status": "success",
"message": "Logout successful"
}

## Users Management (Admin Only):

**GET /api/users** - Get all users
Query Parameters: limit, offset

Response:
{
"status": "success",
"data": [
{
"id_user": 1,
"username": "admin",
"role": "ADMIN",
"full_name": "Administrator",
"email": "admin@example.com",
"phone": "08123456789",
"is_active": true
}
],
"message": "Users retrieved successfully"
}

**GET /api/users/:id** - Get user by ID
Response: Single user object

**POST /api/users** - Create new user (Admin only)
Body:
{
"id_user_creator": 1,
"username": "newstaff",
"password": "pass123",
"role": "STAFF",
"full_name": "New Staff",
"email": "staff@example.com",
"phone": "08123456789"
}

Response:
{
"status": "success",
"message": "User created successfully",
"data": { "id_user": 2 }
}

**PUT /api/users/:id** - Update user (Admin only)
Body:
{
"id_user_creator": 1,
"username": "updateduser",
"password": "newpass123",
"role": "STAFF",
"full_name": "Updated Name",
"email": "updated@example.com",
"phone": "08987654321"
}

Response:
{
"status": "success",
"message": "User updated successfully"
}

**DELETE /api/users/:id** - Delete user (Admin only)
Response:
{
"status": "success",
"message": "User deleted successfully"
}

## Locations:

**GET /api/locations** - Get all locations
Response:
{
"status": "success",
"data": [
{
"id_location": 1,
"location_name": "Kantor Pusat",
"description": "Lokasi kantor pusat",
"address": "Jl. Merdeka No. 1",
"created_at": "2025-12-01T10:00:00.000Z",
"updated_at": "2025-12-01T10:00:00.000Z"
}
],
"message": "Locations retrieved successfully"
}

**GET /api/locations/:id** - Get location by ID
Response: Single location object

**POST /api/locations** - Create location
Body:
{
"location_name": "Kantor Cabang",
"description": "Lokasi kantor cabang",
"address": "Jl. Sudirman No. 10"
}

Response:
{
"status": "success",
"message": "Location created successfully",
"data": { "id_location": 2 }
}

**PUT /api/locations/:id** - Update location
Body:
{
"location_name": "Kantor Cabang Updated",
"description": "Lokasi kantor cabang yang sudah diupdate",
"address": "Jl. Sudirman No. 15"
}

Response:
{
"status": "success",
"message": "Location updated successfully"
}

**DELETE /api/locations/:id** - Delete location
Response:
{
"status": "success",
"message": "Location deleted successfully"
}

## Dispensers:

**GET /api/dispensers** - Get all dispensers
Query Parameters: limit, offset

Response:
{
"status": "success",
"data": [
{
"id_dispenser": 1,
"dispenser_code": "DISP001",
"status": "ACTIVE",
"installation_date": "2025-11-01",
"last_maintenance_date": "2025-12-01",
"id_location": 1,
"location_name": "Kantor Pusat",
"address": "Jl. Merdeka No. 1",
"created_at": "2025-12-01T10:00:00.000Z",
"updated_at": "2025-12-01T10:00:00.000Z"
}
],
"message": "Dispensers retrieved successfully"
}

**GET /api/dispensers/:id** - Get dispenser by ID
Response: Single dispenser object

**GET /api/dispensers/location/:location_id** - Get dispensers by location
Response: Array of dispensers

**GET /api/dispensers/status/:status** - Get dispensers by status
Status: ACTIVE, DAMAGED, MAINTENANCE
Response: Array of dispensers

**POST /api/dispensers** - Create dispenser
Body:
{
"id_location": 1,
"dispenser_code": "DISP002",
"status": "ACTIVE",
"installation_date": "2025-12-08",
"last_maintenance_date": "2025-12-08"
}

Response:
{
"status": "success",
"message": "Dispenser created successfully",
"data": { "id_dispenser": 2 }
}

**PUT /api/dispensers/:id** - Update dispenser
Body:
{
"id_location": 1,
"dispenser_code": "DISP002",
"status": "MAINTENANCE",
"installation_date": "2025-12-08",
"last_maintenance_date": "2025-12-08"
}

Response:
{
"status": "success",
"message": "Dispenser updated successfully"
}

**DELETE /api/dispensers/:id** - Delete dispenser
Response:
{
"status": "success",
"message": "Dispenser deleted successfully"
}

## Replacement Reports:

**GET /api/reports** - Get all reports
Query Parameters: limit, offset

Response:
{
"status": "success",
"data": [
{
"id_report": 1,
"id_dispenser": 1,
"dispenser_code": "DISP001",
"location_name": "Kantor Pusat",
"id_user": 1,
"staff_name": "Administrator",
"staff_username": "admin",
"tissue_quantity": 5,
"notes": "Penggantian rutin",
"replacement_time": "2025-12-08T10:00:00.000Z",
"created_at": "2025-12-08T10:00:00.000Z"
}
],
"message": "Reports retrieved successfully"
}

**GET /api/reports/:id** - Get report by ID
Response: Single report object

**POST /api/reports** - Create replacement report
Body:
{
"id_dispenser": 1,
"id_user": 1,
"tissue_quantity": 5,
"notes": "Penggantian rutin"
}

Response:
{
"status": "success",
"message": "Report created successfully",
"data": { "id_report": 1 }
}

**PUT /api/reports/:id** - Update report
Body:
{
"id_dispenser": 1,
"id_user": 1,
"tissue_quantity": 6,
"notes": "Penggantian rutin updated"
}

Response:
{
"status": "success",
"message": "Report updated successfully"
}

**DELETE /api/reports/:id** - Delete report
Response:
{
"status": "success",
"message": "Report deleted successfully"
}

**GET /api/reports/dispenser/:dispenser_id** - Get reports by dispenser
Response: Array of reports

**GET /api/reports/user/:user_id** - Get reports by user
Response: Array of reports

**GET /api/reports/date-range?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD** - Get reports by date range
Response: Array of reports

## Dashboard:

**GET /api/dashboard/summary** - Get dashboard summary
Response:
{
"status": "success",
"data": {
"total_users": 2,
"total_admins": 1,
"total_staff": 1,
"total_locations": 1,
"total_dispensers": 2,
"active_dispensers": 1,
"damaged_dispensers": 0,
"maintenance_dispensers": 1,
"total_reports": 1,
"reports_today": 1,
"last_replacement_time": "2025-12-08T10:00:00.000Z"
},
"message": "Dashboard summary retrieved successfully"
}

**GET /api/dashboard/dispenser-status** - Get dispenser status overview
Response:
{
"status": "success",
"data": {
"total": 2,
"active": 1,
"damaged": 0,
"maintenance": 1
},
"message": "Dispenser status overview retrieved successfully"
}

**GET /api/dashboard/user-stats** - Get user statistics
Response:
{
"status": "success",
"data": {
"total_admins": 1,
"total_staff": 1
},
"message": "User statistics retrieved successfully"
}

**GET /api/dashboard/today-reports** - Get today's report summary
Response:
{
"status": "success",
"data": {
"reports_today": 1,
"last_replacement_time": "2025-12-08T10:00:00.000Z"
},
"message": "Today's report summary retrieved successfully"
}

**GET /api/dashboard/activity-logs** - Get activity logs
Query Parameters: limit, offset, action_type, resource_type, start_date, end_date, user_id

Response:
{
"status": "success",
"data": [
{
"id_activity": 1,
"id_user": 1,
"username": "admin",
"action_type": "INSERT",
"table_name": "users",
"operation_type": "INSERT",
"record_id": 2,
"description": "User created",
"timestamp": "2025-12-08T10:00:00.000Z",
"old_values": null,
"new_values": "{\"username\": \"newuser\", \"role\": \"STAFF\"}"
}
],
"pagination": { "limit": 50, "offset": 0, "total": 1 },
"message": "Activity logs retrieved successfully"
}

**GET /api/dashboard/transactions** - Get transactions with filtering
Query Parameters: limit, offset, action_type, resource_type, start_date, end_date, user_id

Response: Same as activity-logs

**GET /api/dashboard/transactions/:id** - Get transaction detail
Response: Single transaction object

**GET /api/dashboard/activity-summary** - Get activity summary
Query Parameters: days (default: 7)

Response:
{
"status": "success",
"data": [
{
"activity_date": "2025-12-08",
"action_type": "INSERT",
"total_activities": 5,
"unique_users": 2
}
],
"summary_period": "Last 7 days",
"message": "Activity summary retrieved successfully"
}

**GET /api/dashboard/login-history** - Get login history
Query Parameters: limit (default: 50)

Response:
{
"status": "success",
"data": [
{
"id_login": 1,
"id_user": 1,
"username": "admin",
"role": "ADMIN",
"login_time": "2025-12-08T01:30:00.000Z"
}
],
"message": "Login history retrieved successfully"
}

# DATABASE DESIGN FEATURES:

1. Transaction Management:

   - All write operations use START TRANSACTION
   - Automatic ROLLBACK on error
   - Consistent data state guaranteed

2. Audit Logging:

   - Every insert/update/delete automatically logged
   - Timestamps for all activities
   - Full change tracking in activity_logs table

3. Validation:

   - Foreign key constraints
   - Trigger-based validation
   - Enum types for status and roles
   - Unique constraints on username and location_name

4. Security:

   - Role-based access control
   - User status tracking (is_active)
   - Login history tracking
   - Password stored (NOTE: In production, use bcrypt/argon2)

5. Performance:
   - Indexes on frequently queried columns
   - Views for optimized complex queries
   - Proper foreign key relationships

# TABLE SCHEMAS:

users:

- id_user (PK)
- username (UNIQUE)
- password
- role (ENUM: ADMIN, STAFF)
- full_name, email, phone
- is_active
- created_at, updated_at

locations:

- id_location (PK)
- location_name (UNIQUE)
- description, address
- created_at, updated_at

dispensers:

- id_dispenser (PK)
- id_location (FK)
- dispenser_code (UNIQUE)
- status (ENUM: ACTIVE, DAMAGED, MAINTENANCE)
- installation_date, last_maintenance_date
- created_at, updated_at

replacement_reports:

- id_report (PK)
- id_dispenser (FK)
- id_user (FK)
- tissue_quantity
- notes
- replacement_time

activity_logs:

- id_log (PK)
- id_user (FK)
- action
- description
- log_time

login_history:

- id_login (PK)
- id_user (FK)
- username
- role
- login_time

# TESTING TIPS:

1. Test Register:
   curl -X POST http://localhost:3000/api/auth/register \
    -H "Content-Type: application/json" \
    -d '{"username":"testuser","password":"pass123","role":"STAFF","full_name":"Test User"}'

2. Test Login:
   curl -X POST http://localhost:3000/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"username":"testuser","password":"pass123"}'

3. Check Activity Logs (Basic):
   curl http://localhost:3000/api/dashboard/activity-logs

4. Check Transactions with Filters:
   curl "http://localhost:3000/api/dashboard/transactions?limit=100&action_type=INSERT&resource_type=users"
   curl "http://localhost:3000/api/dashboard/transactions?start_date=2025-12-01&end_date=2025-12-31"
   curl "http://localhost:3000/api/dashboard/transactions?user_id=1"

5. Check Transaction Detail:
   curl "http://localhost:3000/api/dashboard/transactions/1"

6. Check Activity Summary (Last 7 days):
   curl "http://localhost:3000/api/dashboard/activity-summary?days=7"

7. Check Login History:
   curl http://localhost:3000/api/dashboard/login-history

# TRANSACTION VISIBILITY IN ADMIN:

All system transactions and activities are automatically logged via database triggers:

1. **Activity Logs Endpoint**: `GET /api/dashboard/activity-logs`

   - Shows all system activities with basic info
   - Supports pagination with limit/offset
   - Supports filtering by: action_type, resource_type, date range, user_id

2. **Transactions Endpoint** (Enhanced): `GET /api/dashboard/transactions`

   - Detailed transaction view with before/after values
   - Shows: timestamp, user, action, resource_type, record_id, description
   - Supports pagination
   - Query parameters:
     - `limit`: Number of records (default: 100)
     - `offset`: Pagination offset (default: 0)
     - `action_type`: Filter by INSERT/UPDATE/DELETE
     - `resource_type`: Filter by table name (users, dispensers, etc)
     - `start_date`: Filter by date YYYY-MM-DD
     - `end_date`: Filter by date YYYY-MM-DD
     - `user_id`: Filter by user who performed action

3. **What Gets Logged**:
   - All CREATE operations on users, locations, dispensers, reports
   - All UPDATE operations
   - All DELETE operations
   - User login/logout
   - System errors and validations

# NOTES:

- All timestamps use CURRENT_TIMESTAMP
- UUIDs not used; standard auto-increment IDs
- Soft deletes not implemented; full deletes used
- Consider adding password hashing in production
- Consider adding JWT tokens for API security
- Consider adding rate limiting for API endpoints
- All transaction data stored in activity_logs table with complete audit trail

---

# COMPLETE REQUEST/RESPONSE EXAMPLES

## User Registration

**POST /api/auth/register**

```json
Request Body:
{
  "username": "newstaff",
  "password": "SecurePass123!",
  "role": "STAFF",
  "full_name": "Muhammad Rizki",
  "email": "rizki@example.com",
  "phone": "08812345678"
}

Response 201:
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "id_user": 3
  }
}
```

## User Login

**POST /api/auth/login**

```json
Request Body:
{
  "username": "admin",
  "password": "AdminPass123!"
}

Response 200:
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "id_user": 1,
    "username": "admin",
    "role": "ADMIN",
    "full_name": "Administrator",
    "email": "admin@example.com"
  }
}
```

## Create User (Admin Only)

**POST /api/users**

```json
Request Body:
{
  "id_user_creator": 1,
  "username": "newstaff",
  "password": "NewStaffPass123!",
  "role": "STAFF",
  "full_name": "Ahmad Wijaya",
  "email": "ahmad@example.com",
  "phone": "08876543210"
}

Response 201:
{
  "status": "success",
  "message": "User created successfully",
  "data": {
    "id_user": 3
  }
}
```

## Update User (Admin Only)

**PUT /api/users/2**

```json
Request Body:
{
  "id_user_creator": 1,
  "username": "updatedstaff",
  "password": "UpdatedPass123!",
  "role": "ADMIN",
  "full_name": "Ahmad Wijaya Updated",
  "email": "ahmad.updated@example.com",
  "phone": "08888888888"
}

Response 200:
{
  "status": "success",
  "message": "User updated successfully",
  "data": {
    "id_user": 2
  }
}
```

## Delete User (Admin Only)

**DELETE /api/users/2**

```json
Request Body:
{
  "id_user_creator": 1
}

Response 200:
{
  "status": "success",
  "message": "User deleted successfully"
}
```

## Create Location

**POST /api/locations**

```json
Request Body:
{
  "location_name": "Kantor Cabang Surabaya",
  "description": "Lokasi kantor cabang di kota Surabaya dengan fasilitas lengkap",
  "address": "Jl. Ahmad Yani No. 50, Surabaya, Jawa Timur"
}

Response 201:
{
  "status": "success",
  "message": "Location created successfully",
  "data": {
    "id_location": 3
  }
}
```

## Update Location

**PUT /api/locations/2**

```json
Request Body:
{
  "location_name": "Kantor Cabang Bandung - Updated",
  "description": "Lokasi kantor cabang Bandung dengan fasilitas baru",
  "address": "Jl. Sudirman No. 150, Bandung, Jawa Barat"
}

Response 200:
{
  "status": "success",
  "message": "Location updated successfully"
}
```

## Delete Location

**DELETE /api/locations/3**

```json
Response 200:
{
  "status": "success",
  "message": "Location deleted successfully"
}
```

## Create Dispenser

**POST /api/dispensers**

```json
Request Body:
{
  "id_location": 1,
  "dispenser_code": "DISP-JAK-003",
  "status": "ACTIVE",
  "installation_date": "2025-12-08",
  "last_maintenance_date": "2025-12-08"
}

Response 201:
{
  "status": "success",
  "message": "Dispenser created successfully",
  "data": {
    "id_dispenser": 3
  }
}
```

## Update Dispenser

**PUT /api/dispensers/2**

```json
Request Body:
{
  "id_location": 1,
  "dispenser_code": "DISP-JAK-002",
  "status": "MAINTENANCE",
  "installation_date": "2025-11-05",
  "last_maintenance_date": "2025-12-08"
}

Response 200:
{
  "status": "success",
  "message": "Dispenser updated successfully"
}
```

## Delete Dispenser

**DELETE /api/dispensers/3**

```json
Response 200:
{
  "status": "success",
  "message": "Dispenser deleted successfully"
}
```

## Create Replacement Report

**POST /api/reports**

```json
Request Body:
{
  "id_dispenser": 1,
  "id_user": 1,
  "tissue_quantity": 5,
  "notes": "Penggantian rutin - persiapan meeting penting"
}

Response 201:
{
  "status": "success",
  "message": "Report created successfully",
  "data": {
    "id_report": 3
  }
}
```

## Update Replacement Report

**PUT /api/reports/1**

```json
Request Body:
{
  "id_dispenser": 1,
  "id_user": 1,
  "tissue_quantity": 6,
  "notes": "Penggantian rutin - jumlah ditambah karena permintaan pimpinan"
}

Response 200:
{
  "status": "success",
  "message": "Report updated successfully"
}
```

## Delete Replacement Report

**DELETE /api/reports/3**

```json
Response 200:
{
  "status": "success",
  "message": "Report deleted successfully"
}
```

## Get All Users

**GET /api/users**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_user": 1,
      "username": "admin",
      "role": "ADMIN",
      "full_name": "Administrator",
      "email": "admin@example.com",
      "phone": "08123456789",
      "is_active": true
    },
    {
      "id_user": 2,
      "username": "staff1",
      "role": "STAFF",
      "full_name": "Staff One",
      "email": "staff1@example.com",
      "phone": "08987654321",
      "is_active": true
    }
  ],
  "message": "Users retrieved successfully"
}
```

## Get User by ID

**GET /api/users/1**

```json
Response 200:
{
  "status": "success",
  "data": {
    "id_user": 1,
    "username": "admin",
    "role": "ADMIN",
    "full_name": "Administrator",
    "email": "admin@example.com",
    "phone": "08123456789",
    "is_active": true
  },
  "message": "User retrieved successfully"
}
```

## Get All Registrations

**GET /api/auth/register?limit=50&offset=0&role=ADMIN**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_user": 1,
      "username": "admin",
      "role": "ADMIN",
      "full_name": "Administrator",
      "email": "admin@example.com",
      "phone": "08123456789",
      "is_active": true,
      "created_at": "2025-12-01T10:00:00.000Z"
    }
  ],
  "pagination": {
    "limit": 50,
    "offset": 0,
    "total": 1
  },
  "message": "Registrations retrieved successfully"
}
```

## Get Login History

**GET /api/auth/login?limit=50&offset=0&user_id=1**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_login": 5,
      "id_user": 1,
      "username": "admin",
      "role": "ADMIN",
      "login_time": "2025-12-08T15:45:32.000Z"
    }
  ],
  "pagination": {
    "limit": 50,
    "offset": 0,
    "total": 1
  },
  "message": "Login history retrieved successfully"
}
```

## Get All Locations

**GET /api/locations**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_location": 1,
      "location_name": "Kantor Pusat",
      "description": "Lokasi kantor pusat perusahaan",
      "address": "Jl. Merdeka No. 1, Jakarta",
      "created_at": "2025-12-01T10:00:00.000Z",
      "updated_at": "2025-12-01T10:00:00.000Z"
    }
  ],
  "message": "Locations retrieved successfully"
}
```

## Get Location by ID

**GET /api/locations/1**

```json
Response 200:
{
  "status": "success",
  "data": {
    "id_location": 1,
    "location_name": "Kantor Pusat",
    "description": "Lokasi kantor pusat perusahaan",
    "address": "Jl. Merdeka No. 1, Jakarta",
    "created_at": "2025-12-01T10:00:00.000Z",
    "updated_at": "2025-12-01T10:00:00.000Z"
  },
  "message": "Location retrieved successfully"
}
```

## Get All Dispensers

**GET /api/dispensers**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_dispenser": 1,
      "dispenser_code": "DISP-JAK-001",
      "status": "ACTIVE",
      "installation_date": "2025-11-01",
      "last_maintenance_date": "2025-12-01",
      "id_location": 1,
      "location_name": "Kantor Pusat",
      "address": "Jl. Merdeka No. 1, Jakarta"
    }
  ],
  "message": "Dispensers retrieved successfully"
}
```

## Get Dispenser by ID

**GET /api/dispensers/1**

```json
Response 200:
{
  "status": "success",
  "data": {
    "id_dispenser": 1,
    "dispenser_code": "DISP-JAK-001",
    "status": "ACTIVE",
    "installation_date": "2025-11-01",
    "last_maintenance_date": "2025-12-01",
    "id_location": 1,
    "location_name": "Kantor Pusat",
    "address": "Jl. Merdeka No. 1, Jakarta"
  },
  "message": "Dispenser retrieved successfully"
}
```

## Get Dispensers by Location

**GET /api/dispensers/location/1**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_dispenser": 1,
      "dispenser_code": "DISP-JAK-001",
      "status": "ACTIVE",
      "id_location": 1,
      "location_name": "Kantor Pusat"
    }
  ],
  "message": "Dispensers by location retrieved successfully"
}
```

## Get Dispensers by Status

**GET /api/dispensers/status/ACTIVE**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_dispenser": 1,
      "dispenser_code": "DISP-JAK-001",
      "status": "ACTIVE",
      "id_location": 1,
      "location_name": "Kantor Pusat"
    }
  ],
  "message": "Dispensers by status retrieved successfully"
}
```

## Get All Reports

**GET /api/reports**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_report": 1,
      "id_dispenser": 1,
      "dispenser_code": "DISP-JAK-001",
      "location_name": "Kantor Pusat",
      "id_user": 1,
      "staff_name": "Administrator",
      "staff_username": "admin",
      "tissue_quantity": 5,
      "notes": "Penggantian rutin pagi",
      "replacement_time": "2025-12-08T08:30:00.000Z"
    }
  ],
  "message": "Reports retrieved successfully"
}
```

## Get Report by ID

**GET /api/reports/1**

```json
Response 200:
{
  "status": "success",
  "data": {
    "id_report": 1,
    "id_dispenser": 1,
    "dispenser_code": "DISP-JAK-001",
    "location_name": "Kantor Pusat",
    "id_user": 1,
    "staff_name": "Administrator",
    "tissue_username": "admin",
    "tissue_quantity": 5,
    "notes": "Penggantian rutin pagi",
    "replacement_time": "2025-12-08T08:30:00.000Z"
  },
  "message": "Report retrieved successfully"
}
```

## Get Reports by Dispenser

**GET /api/reports/dispenser/1**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_report": 1,
      "id_dispenser": 1,
      "dispenser_code": "DISP-JAK-001",
      "tissue_quantity": 5,
      "notes": "Penggantian rutin pagi"
    }
  ],
  "message": "Reports by dispenser retrieved successfully"
}
```

## Get Reports by User

**GET /api/reports/user/1**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_report": 1,
      "id_dispenser": 1,
      "dispenser_code": "DISP-JAK-001",
      "tissue_quantity": 5,
      "notes": "Penggantian rutin pagi"
    }
  ],
  "message": "Reports by user retrieved successfully"
}
```

## Get Reports by Date Range

**GET /api/reports/date-range?start_date=2025-12-01&end_date=2025-12-08**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_report": 1,
      "id_dispenser": 1,
      "dispenser_code": "DISP-JAK-001",
      "tissue_quantity": 5,
      "replacement_time": "2025-12-08T08:30:00.000Z"
    }
  ],
  "message": "Reports by date range retrieved successfully"
}
```

## Get Dashboard Summary

**GET /api/dashboard/summary**

```json
Response 200:
{
  "status": "success",
  "data": {
    "total_users": 2,
    "total_admins": 1,
    "total_staff": 1,
    "total_locations": 1,
    "total_dispensers": 2,
    "active_dispensers": 1,
    "damaged_dispensers": 0,
    "maintenance_dispensers": 1,
    "total_reports": 2,
    "reports_today": 2,
    "last_replacement_time": "2025-12-08T16:45:00.000Z"
  },
  "message": "Dashboard summary retrieved successfully"
}
```

## Get Dispenser Status

**GET /api/dashboard/dispenser-status**

```json
Response 200:
{
  "status": "success",
  "data": {
    "total": 2,
    "active": 1,
    "damaged": 0,
    "maintenance": 1
  },
  "message": "Dispenser status overview retrieved successfully"
}
```

## Get User Statistics

**GET /api/dashboard/user-stats**

```json
Response 200:
{
  "status": "success",
  "data": {
    "total_admins": 1,
    "total_staff": 1
  },
  "message": "User statistics retrieved successfully"
}
```

## Get Today's Reports

**GET /api/dashboard/today-reports**

```json
Response 200:
{
  "status": "success",
  "data": {
    "reports_today": 2,
    "last_replacement_time": "2025-12-08T16:45:00.000Z"
  },
  "message": "Today's report summary retrieved successfully"
}
```

## Get Activity Logs

**GET /api/dashboard/activity-logs?limit=50&action_type=INSERT&user_id=1**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_activity": 1,
      "id_user": 1,
      "username": "admin",
      "action_type": "INSERT",
      "table_name": "users",
      "operation_type": "INSERT",
      "record_id": 2,
      "description": "User created",
      "timestamp": "2025-12-08T10:00:00.000Z",
      "old_values": null,
      "new_values": "{\"username\": \"staff1\", \"role\": \"STAFF\"}"
    }
  ],
  "pagination": {
    "limit": 50,
    "offset": 0,
    "total": 1
  },
  "message": "Activity logs retrieved successfully"
}
```

## Get Transactions

**GET /api/dashboard/transactions?limit=100&action_type=INSERT&resource_type=users**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_activity": 1,
      "id_user": 1,
      "username": "admin",
      "action_type": "INSERT",
      "table_name": "users",
      "operation_type": "INSERT",
      "record_id": 2,
      "description": "User created",
      "timestamp": "2025-12-08T10:00:00.000Z",
      "old_values": null,
      "new_values": "{\"username\": \"staff1\", \"role\": \"STAFF\"}"
    }
  ],
  "pagination": {
    "limit": 100,
    "offset": 0,
    "records_returned": 1
  },
  "message": "Transactions retrieved successfully"
}
```

## Get Transaction by ID

**GET /api/dashboard/transactions/1**

```json
Response 200:
{
  "status": "success",
  "data": {
    "id_activity": 1,
    "id_user": 1,
    "username": "admin",
    "action_type": "INSERT",
    "table_name": "users",
    "operation_type": "INSERT",
    "record_id": 2,
    "description": "User created",
    "timestamp": "2025-12-08T10:00:00.000Z",
    "old_values": null,
    "new_values": "{\"username\": \"staff1\", \"role\": \"STAFF\"}"
  },
  "message": "Transaction retrieved successfully"
}
```

## Get Activity Summary

**GET /api/dashboard/activity-summary?days=7**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "activity_date": "2025-12-08",
      "action_type": "INSERT",
      "total_activities": 5,
      "unique_users": 2
    },
    {
      "activity_date": "2025-12-08",
      "action_type": "UPDATE",
      "total_activities": 3,
      "unique_users": 1
    }
  ],
  "summary_period": "Last 7 days",
  "message": "Activity summary retrieved successfully"
}
```

## Get Login History

**GET /api/dashboard/login-history?limit=50**

```json
Response 200:
{
  "status": "success",
  "data": [
    {
      "id_login": 1,
      "id_user": 1,
      "username": "admin",
      "role": "ADMIN",
      "login_time": "2025-12-08T15:45:32.000Z"
    }
  ],
  "pagination": {
    "limit": 50,
    "offset": 0,
    "total": 1
  },
  "message": "Login history retrieved successfully"
}
```

---

**Last Updated:** December 8, 2025
**API Version:** 2.0.0
