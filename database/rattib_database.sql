-- =====================================================
-- Rattib Mashawerak Database Schema
-- Database Name: softvysc_rattib
-- Created: December 2025
-- =====================================================

-- Create Database (if running locally, uncomment the following lines)
-- CREATE DATABASE IF NOT EXISTS softvysc_rattib CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE softvysc_rattib;

-- =====================================================
-- Table: Users
-- Description: Stores user authentication and profile information
-- =====================================================
CREATE TABLE IF NOT EXISTS Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    JoinDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: Administrator
-- Description: Stores administrator user information
-- =====================================================
CREATE TABLE IF NOT EXISTS Administrator (
    AdminID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role VARCHAR(50) NOT NULL DEFAULT 'admin',
    INDEX idx_admin_email (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: Task
-- Description: Stores user tasks with categories and due dates
-- =====================================================
CREATE TABLE IF NOT EXISTS Task (
    TaskID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Description TEXT,
    Status VARCHAR(50) DEFAULT 'pending',
    DueDate DATE,
    UserID INT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    INDEX idx_user_task (UserID),
    INDEX idx_status (Status),
    INDEX idx_due_date (DueDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: Trip
-- Description: Stores user trip information
-- =====================================================
CREATE TABLE IF NOT EXISTS Trip (
    TripID INT PRIMARY KEY AUTO_INCREMENT,
    Destination VARCHAR(200) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    UserID INT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    INDEX idx_user_trip (UserID),
    INDEX idx_trip_dates (StartDate, EndDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: AIRouteOptimization
-- Description: Stores AI-generated route optimization data (placeholder for future use)
-- =====================================================
CREATE TABLE IF NOT EXISTS AIRouteOptimization (
    RouteID INT PRIMARY KEY AUTO_INCREMENT,
    RouteDetails TEXT,
    EstimatedTime TIME,
    TripID INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TripID) REFERENCES Trip(TripID) ON DELETE CASCADE,
    INDEX idx_trip_route (TripID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: Badge
-- Description: Stores available badge types and descriptions
-- =====================================================
CREATE TABLE IF NOT EXISTS Badge (
    BadgeID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Description TEXT,
    IconUrl VARCHAR(255),
    RequiredCount INT DEFAULT 1,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: UserBadges
-- Description: Junction table for many-to-many relationship between users and badges
-- =====================================================
CREATE TABLE IF NOT EXISTS UserBadges (
    UserID INT NOT NULL,
    BadgeID INT NOT NULL,
    EarnedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, BadgeID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BadgeID) REFERENCES Badge(BadgeID) ON DELETE CASCADE,
    INDEX idx_user_badges (UserID),
    INDEX idx_badge_users (BadgeID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: Inquiry
-- Description: Stores user inquiries and support tickets
-- =====================================================
CREATE TABLE IF NOT EXISTS Inquiry (
    InquiryID INT PRIMARY KEY AUTO_INCREMENT,
    Subject VARCHAR(150) NOT NULL,
    Message TEXT NOT NULL,
    SubmitDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(50) DEFAULT 'pending',
    Response TEXT,
    UserID INT NOT NULL,
    AdminID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (AdminID) REFERENCES Administrator(AdminID) ON DELETE SET NULL,
    INDEX idx_user_inquiry (UserID),
    INDEX idx_admin_inquiry (AdminID),
    INDEX idx_inquiry_status (Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Table: Address
-- Description: Stores saved addresses for users
-- =====================================================
CREATE TABLE IF NOT EXISTS Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    AddressType VARCHAR(50) NOT NULL, -- Home, Work, Restaurants, Grocery, Shopping, etc.
    AddressLine VARCHAR(255) NOT NULL,
    Latitude DECIMAL(10, 8),
    Longitude DECIMAL(11, 8),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    INDEX idx_user_address (UserID),
    INDEX idx_address_type (AddressType)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- Insert Sample Badges
-- =====================================================
INSERT INTO Badge (Title, Description, RequiredCount) VALUES
('First Steps', 'Complete your first task', 1),
('Getting Started', 'Complete 5 tasks', 5),
('Task Master', 'Complete 10 tasks', 10),
('Super Achiever', 'Complete 25 tasks', 25),
('Trip Explorer', 'Complete your first trip', 1),
('Adventure Seeker', 'Complete 5 trips', 5),
('World Traveler', 'Complete 10 trips', 10),
('Journey Champion', 'Complete 25 trips', 25);

-- =====================================================
-- Sample Administrator (Optional - for testing)
-- Password: admin123 (hashed using PHP password_hash)
-- =====================================================
INSERT INTO Administrator (Name, Email, Role) VALUES
('System Admin', 'admin@rattibmashawerak.com', 'super_admin');

-- =====================================================
-- End of Schema
-- =====================================================
