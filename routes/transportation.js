module.exports = (app, db) => {
    app.post('/transportation', (req, res) => {
        const { VehicleType, SeatAvailability, ClassOptions, BaggageAllowances, PassengerRestrictions, DepartureTime, EstimatedArrivalTime, VisaRequirements } = req.body;
        const sql = `
            INSERT INTO Transportation 
            (VehicleType, SeatAvailability, ClassOptions, BaggageAllowances, PassengerRestrictions, DepartureTime, EstimatedArrivalTime, VisaRequirements) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `;
        db.query(sql, [VehicleType, SeatAvailability, ClassOptions, BaggageAllowances, PassengerRestrictions, DepartureTime, EstimatedArrivalTime, VisaRequirements], (err, result) => {
            if (err) throw err;
            res.send('Transportation added successfully!');
        });
    });

    app.delete('/transportation/:id', (req, res) => {
        const sql = `DELETE FROM Transportation WHERE TransportationID = ?`;
        db.query(sql, [req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Transportation deleted successfully!');
        });
    });

    app.put('/transportation/:id', (req, res) => {
        const { SeatAvailability, ClassOptions, BaggageAllowances, PassengerRestrictions, DepartureTime, EstimatedArrivalTime, VisaRequirements } = req.body;
        const sql = `
            UPDATE Transportation SET 
            SeatAvailability = ?, ClassOptions = ?, BaggageAllowances = ?, PassengerRestrictions = ?, DepartureTime = ?, EstimatedArrivalTime = ?, VisaRequirements = ? 
            WHERE TransportationID = ?
        `;
        db.query(sql, [SeatAvailability, ClassOptions, BaggageAllowances, PassengerRestrictions, DepartureTime, EstimatedArrivalTime, VisaRequirements, req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Transportation updated successfully!');
        });
    });

    app.get('/transportation', (req, res) => {
        const sql = `SELECT * FROM Transportation`;
        db.query(sql, (err, result) => {
            if (err) throw err;
            res.json(result);
        });
    });
};
