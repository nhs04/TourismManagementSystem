USE TourismDB;
DELETE FROM BookingActivities;
DELETE FROM Payments;
DELETE FROM Reviews;
DELETE FROM Bookings;
DELETE FROM Activities;
DELETE FROM Transportation;
DELETE FROM Packages;
DELETE FROM Guides;
DELETE FROM Hotels;
DELETE FROM Destinations;
DELETE FROM Tourists;

INSERT INTO Tourists (PassportNumber, FirstName, MiddleName, LastName, PhoneNumber, Email, VisaType, VisaExpiryDate, VisaIssuingCountry) VALUES
('X12345678', 'John', 'A.', 'Doe', '+1234567890', 'john.doe@example.com', 'Tourist', '2025-12-31', 'USA'),
('Y98765432', 'Jane', 'B.', 'Smith', '+0987654321', 'jane.smith@example.com', 'Business', '2024-11-30', 'Canada');

INSERT INTO Destinations (CityName, CountryName, Latitude, Longitude, AverageTemperature, Precipitation, ClimateData, LocalRegulations, RecommendedDurationStay, NearbyAttractions) VALUES
('Paris', 'France', 48.8566, 2.3522, 15.00, 50.00, 'Mild winters and hot summers', 'No smoking in public areas', 7, 'Eiffel Tower, Louvre Museum'),
('Tokyo', 'Japan', 35.6895, 139.6917, 16.00, 60.00, 'Humid subtropical with mild winters and hot humid summers', 'Public transportation must be used with care', 5, 'Shinjuku Gyoen, Tokyo Tower');

INSERT INTO Hotels (HotelName, City, StateProvince, PostalCode, Country, ContactNumber, Email, Website, PetPolicies, CheckInTime, CheckOutTime, DestinationID) VALUES
('Hotel Paris', 'Paris', 'Ile-de-France', '75001', 'France', '+33123456789', 'contact@hotelparis.com', 'www.hotelparis.com', 'Pets are not allowed', '15:00:00', '11:00:00', 1),
('Hotel Tokyo', 'Tokyo', 'Tokyo', '100-0001', 'Japan', '+81312345678', 'info@hoteltokyo.jp', 'www.hoteltokyo.jp', 'Pets allowed with conditions', '14:00:00', '12:00:00', 2);

INSERT INTO Transportation (VehicleType, SeatAvailability, ClassOptions, BaggageAllowances, PassengerRestrictions, DepartureTime, EstimatedArrivalTime, VisaRequirements) VALUES
('Airplane', 200, 'Economy, Business, First', '1 piece up to 23kg', 'No pets', '2024-05-01 10:00:00', '2024-05-01 14:00:00', 'Visa on arrival'),
('Train', 300, 'Standard, First', '2 pieces up to 20kg each', 'No smoking', '2024-05-01 08:00:00', '2024-05-01 12:00:00', 'No Visa required');

INSERT INTO Activities (ActivityName, Duration, DifficultyLevel, AgeRestrictions, SpecialInstructions, DestinationID) VALUES
('Louvre Museum Tour', 3, 'Easy', 'No age limit', 'Ticket includes entry to permanent exhibitions', 1),
('Mount Fuji Hiking', 8, 'Hard', 'Above 12 years', 'Bring water, hiking boots, and weather-appropriate clothing', 2);

INSERT INTO Guides (GuideName, Email, Phone, Availability) VALUES
('Alice Johnson', 'alice.j@example.com', '+15556667788', 'Weekdays'),
('Bob Williams', 'bob.w@example.com', '+14445556666', 'Weekends');

INSERT INTO Packages (PackageName, Price, DurationDays, Inclusions, Exclusions, TermsConditions) VALUES
('Week in Paris', 1599.99, 7, 'Hotel, Transportation, Two Activities', 'Meals, Personal Expenses', 'Cancellation policy applies'),
('Explore Tokyo', 1299.99, 5, 'Hotel, Transportation, Guide', 'Meals, Visa Fees', 'No refunds on cancellation within 30 days');

INSERT INTO Bookings (TouristID, DestinationID, HotelID, TransportationID, GuideID, PackageID, ActivityID, BookingStatus, PaymentStatus, CheckInDate, CheckOutDate, TotalCost) VALUES
('X12345678', 1, 1, 1, 1, 1, 1, 'Confirmed', 'Paid', '2024-06-01', '2024-06-08', 1800.00),
('Y98765432', 2, 2, 2, 2, 2, 2, 'Pending', 'Unpaid', '2024-07-01', '2024-07-06', 1300.00);

INSERT INTO BookingActivities (BookingID, ActivityID) VALUES
(1, 1),
(2, 2);

INSERT INTO Reviews (BookingID, TouristID, HotelID, ActivityID, PackageID, Rating, Comment, ReviewDate) VALUES
(1, 'X12345678', 1, 1, 1, 5, 'Fantastic experience with professional service.', '2024-06-09 12:00:00'),
(2, 'Y98765432', 2, 2, 2, 4, 'Great tour but a bit rushed.', '2024-07-07 12:00:00');

INSERT INTO Payments (BookingID, TouristID, TransactionID, PaymentMethod, Currency, Amount, PaymentDate, Taxes, PaymentStatus, ConfirmationNumber) VALUES
(1, 'X12345678', 'TXN12345', 'Credit Card', 'EUR', 1800.00, '2024-05-20', 'VAT at 20%', 'Completed', 'CN12345'),
(2, 'Y98765432', 'TXN67890', 'Bank Transfer', 'JPY', 1300.00, '2024-06-15', 'VAT at 10%', 'Pending', 'CN67890');
