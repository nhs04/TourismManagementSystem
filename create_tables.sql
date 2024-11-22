-- Active: 1713552176111@@127.0.0.1@3306@TourismDB
-- Ensure the database exists
CREATE DATABASE IF NOT EXISTS TourismDB;
USE TourismDB;

-- Disable foreign key checks to avoid drop errors
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables in the correct order to avoid foreign key conflicts
DROP TABLE IF EXISTS BookingActivities;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Activities;
DROP TABLE IF EXISTS Transportation;
DROP TABLE IF EXISTS Packages;
DROP TABLE IF EXISTS Guides;
DROP TABLE IF EXISTS Hotels;
DROP TABLE IF EXISTS Destinations;
DROP TABLE IF EXISTS Tourists;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Creating the Tourists table
CREATE TABLE Tourists (
    PassportNumber VARCHAR(9) PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    MiddleName VARCHAR(100),
    LastName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    VisaType VARCHAR(50),
    VisaExpiryDate DATE,
    VisaIssuingCountry VARCHAR(100)
);

-- Creating the Destinations table
CREATE TABLE Destinations (
    DestinationID INT AUTO_INCREMENT PRIMARY KEY,
    CityName VARCHAR(100),
    CountryName VARCHAR(100),
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    AverageTemperature DECIMAL(5,2),
    Precipitation DECIMAL(5,2),
    ClimateData TEXT,
    LocalRegulations TEXT,
    RecommendedDurationStay INT,
    NearbyAttractions TEXT
);

-- Creating the Hotels table
CREATE TABLE Hotels (
    HotelID INT AUTO_INCREMENT PRIMARY KEY,
    HotelName VARCHAR(100) UNIQUE,
    City VARCHAR(100),
    StateProvince VARCHAR(100),
    PostalCode VARCHAR(10),
    Country VARCHAR(100),
    ContactNumber VARCHAR(15),
    Email VARCHAR(100),
    Website VARCHAR(100),
    PetPolicies VARCHAR(255),
    CheckInTime TIME,
    CheckOutTime TIME,
    DestinationID INT,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE
);

-- Creating the Transportation table
CREATE TABLE Transportation (
    TransportationID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleType ENUM('Airplane', 'Train', 'Bus'),
    SeatAvailability INT,
    ClassOptions TEXT,
    BaggageAllowances VARCHAR(255),
    PassengerRestrictions VARCHAR(255),
    DepartureTime DATETIME,
    EstimatedArrivalTime DATETIME,
    VisaRequirements VARCHAR(255)
);

-- Creating the Activities table
CREATE TABLE Activities (
    ActivityID INT AUTO_INCREMENT PRIMARY KEY,
    ActivityName VARCHAR(100),
    Duration INT,
    DifficultyLevel ENUM('Easy', 'Moderate', 'Hard'),
    AgeRestrictions VARCHAR(50),
    SpecialInstructions TEXT,
    DestinationID INT,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE CASCADE
);

-- Creating the Guides table
CREATE TABLE Guides (
    GuideID INT AUTO_INCREMENT PRIMARY KEY,
    GuideName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Availability TEXT
);

-- Creating the Packages table
CREATE TABLE Packages (
    PackageID INT AUTO_INCREMENT PRIMARY KEY,
    PackageName VARCHAR(100),
    Price DECIMAL(10,2),
    DurationDays INT,
    Inclusions TEXT,
    Exclusions TEXT,
    TermsConditions TEXT
);

-- Creating the Bookings table
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    TouristID VARCHAR(9),
    DestinationID INT,
    HotelID INT,
    TransportationID INT,
    GuideID INT,
    PackageID INT,
    ActivityID INT,
    BookingStatus ENUM('Confirmed', 'Pending', 'Canceled'),
    PaymentStatus ENUM('Paid', 'Partially Paid', 'Unpaid'),
    CheckInDate DATE,
    CheckOutDate DATE,
    TotalCost DECIMAL(10,2),
    FOREIGN KEY (TouristID) REFERENCES Tourists(PassportNumber) ON DELETE CASCADE,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID) ON DELETE SET NULL,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID) ON DELETE SET NULL,
    FOREIGN KEY (TransportationID) REFERENCES Transportation(TransportationID) ON DELETE SET NULL,
    FOREIGN KEY (GuideID) REFERENCES Guides(GuideID) ON DELETE SET NULL,
    FOREIGN KEY (PackageID) REFERENCES Packages(PackageID) ON DELETE SET NULL,
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID) ON DELETE SET NULL
);

-- Creating a junction table for Bookings and Activities (N-M relationship)
CREATE TABLE BookingActivities (
    BookingID INT,
    ActivityID INT,
    PRIMARY KEY (BookingID, ActivityID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID) ON DELETE CASCADE
);

-- Creating the Reviews table
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT,
    TouristID VARCHAR(9),
    HotelID INT,
    ActivityID INT,
    PackageID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATETIME,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (TouristID) REFERENCES Tourists(PassportNumber) ON DELETE CASCADE,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID) ON DELETE CASCADE,
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID) ON DELETE CASCADE,
    FOREIGN KEY (PackageID) REFERENCES Packages(PackageID) ON DELETE CASCADE
);

-- Creating the Payments table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT,
    TouristID VARCHAR(9),
    TransactionID VARCHAR(100),
    PaymentMethod ENUM('Credit Card', 'PayPal', 'Bank Transfer'),
    Currency VARCHAR(50),
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    Taxes VARCHAR(255),
    PaymentStatus ENUM('Pending', 'Completed', 'Failed'),
    ConfirmationNumber VARCHAR(100),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (TouristID) REFERENCES Tourists(PassportNumber) ON DELETE CASCADE
);

-- Creating indices and views after all table creations to ensure all foreign keys and fields are available

-- Views
CREATE VIEW vw_PaymentDetails AS
SELECT p.PaymentID, p.BookingID, p.Amount, p.PaymentMethod, p.PaymentDate, p.TransactionID, b.TouristID
FROM Payments p
JOIN Bookings b ON p.BookingID = b.BookingID;

CREATE VIEW vw_FinancialStatus AS
SELECT b.BookingID, b.TouristID, COALESCE(SUM(p.Amount), 0) AS TotalPaid, b.TotalCost, (b.TotalCost - COALESCE(SUM(p.Amount), 0)) AS OutstandingBalance,
CASE
    WHEN b.TotalCost > COALESCE(SUM(p.Amount), 0) THEN 'Underpaid'
    WHEN b.TotalCost = COALESCE(SUM(p.Amount), 0) THEN 'Fully Paid'
    ELSE 'Overpaid'
END AS PaymentStatus
FROM Bookings b
LEFT JOIN Payments p ON b.BookingID = p.BookingID
GROUP BY b.BookingID;

CREATE VIEW vw_ReviewsByNationality AS
SELECT r.ReviewID, t.FirstName, t.LastName, t.VisaIssuingCountry AS Nationality, r.Rating, r.Comment, r.ReviewDate
FROM Reviews r
JOIN Tourists t ON r.TouristID = t.PassportNumber
ORDER BY r.ReviewDate DESC;

CREATE VIEW vw_HotelRatings AS
SELECT h.HotelID, h.HotelName, AVG(r.Rating) AS AverageRating, COUNT(*) AS NumberOfReviews
FROM Hotels h
JOIN Reviews r ON h.HotelID = r.HotelID
GROUP BY h.HotelID;

CREATE VIEW vw_ActivityRatings AS
SELECT a.ActivityID, a.ActivityName, d.CityName AS DestinationCity, AVG(r.Rating) AS AverageRating, COUNT(*) AS NumberOfReviews
FROM Activities a
JOIN Destinations d ON a.DestinationID = d.DestinationID
JOIN Reviews r ON a.ActivityID = r.ActivityID
GROUP BY a.ActivityID;

CREATE VIEW vw_GuideAvailability AS
SELECT g.GuideID, g.GuideName, g.Availability, COUNT(b.GuideID) AS NumberOfBookings
FROM Guides g
LEFT JOIN Bookings b ON g.GuideID = b.GuideID
GROUP BY g.GuideID;

-- Indices
CREATE INDEX idx_payment_bookingID ON Payments(BookingID);
CREATE INDEX idx_payment_transactionID ON Payments(TransactionID);
CREATE INDEX idx_payment_date ON Payments(PaymentDate);
CREATE INDEX idx_payment_status_date ON Payments(PaymentStatus, PaymentDate);

CREATE INDEX idx_booking_touristID ON Bookings(TouristID);
CREATE INDEX idx_booking_status ON Bookings(BookingStatus);
CREATE INDEX idx_booking_dates ON Bookings(CheckInDate, CheckOutDate);

CREATE INDEX idx_review_touristID ON Reviews(TouristID);
CREATE INDEX idx_review_hotelID ON Reviews(HotelID);
CREATE INDEX idx_review_activityID ON Reviews(ActivityID);
CREATE INDEX idx_review_date ON Reviews(ReviewDate);

CREATE INDEX idx_activities_destinationID ON Activities(DestinationID);
CREATE INDEX idx_hotels_destinationID ON Hotels(DestinationID);
CREATE INDEX idx_destinations_city_country ON Destinations(CityName, CountryName);

CREATE INDEX idx_booking_checkIn_checkOut ON Bookings(CheckInDate, CheckOutDate);

-- Additional Views for Reporting and Management
CREATE VIEW vw_PackagePopularity AS
SELECT p.PackageID, p.PackageName, COUNT(b.PackageID) AS NumberOfBookings, AVG(b.TotalCost) AS AverageBookingCost
FROM Packages p
LEFT JOIN Bookings b ON p.PackageID = b.PackageID
GROUP BY p.PackageID;

CREATE VIEW vw_GuidePerformance AS
SELECT 
    g.GuideID, 
    g.GuideName, 
    AVG(IFNULL(r.Rating, 0)) AS AverageRating,  -- Using IFNULL to handle cases where there are no ratings
    COUNT(r.ReviewID) AS NumberOfReviews  -- Counting reviews by ID to accurately tally entries, including those without ratings
FROM Guides g
LEFT JOIN Bookings b ON g.GuideID = b.GuideID
LEFT JOIN Reviews r ON b.BookingID = r.BookingID
GROUP BY g.GuideID, g.GuideName;

