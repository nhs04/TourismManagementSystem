module.exports = (app, db) => {
    app.post('/hotels', (req, res) => {
        const { HotelName, City, StateProvince, PostalCode, Country, ContactNumber, Email, Website, PetPolicies, CheckInTime, CheckOutTime, DestinationID } = req.body;
        const sql = `
            INSERT INTO Hotels 
            (HotelName, City, StateProvince, PostalCode, Country, ContactNumber, Email, Website, PetPolicies, CheckInTime, CheckOutTime, DestinationID) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        db.query(sql, [HotelName, City, StateProvince, PostalCode, Country, ContactNumber, Email, Website, PetPolicies, CheckInTime, CheckOutTime, DestinationID], (err, result) => {
            if (err) throw err;
            res.send('Hotel added successfully!');
        });
    });

    app.delete('/hotels/:id', (req, res) => {
        const sql = `DELETE FROM Hotels WHERE HotelID = ?`;
        db.query(sql, [req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Hotel deleted successfully!');
        });
    });

    app.put('/hotels/:id', (req, res) => {
        const { HotelName, City, StateProvince, PostalCode, Country, ContactNumber, Email, Website, PetPolicies, CheckInTime, CheckOutTime } = req.body;
        const sql = `
            UPDATE Hotels SET 
            HotelName = ?, City = ?, StateProvince = ?, PostalCode = ?, Country = ?, ContactNumber = ?, Email = ?, Website = ?, PetPolicies = ?, CheckInTime = ?, CheckOutTime = ? 
            WHERE HotelID = ?
        `;
        db.query(sql, [HotelName, City, StateProvince, PostalCode, Country, ContactNumber, Email, Website, PetPolicies, CheckInTime, CheckOutTime, req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Hotel updated successfully!');
        });
    });

    app.get('/hotels', (req, res) => {
        const sql = `SELECT * FROM Hotels`;
        db.query(sql, (err, result) => {
            if (err) throw err;
            res.json(result);
        });
    });
};
