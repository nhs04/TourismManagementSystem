module.exports = (app, db) => {
    app.post('/destinations', (req, res) => {
        const { CityName, CountryName, Latitude, Longitude, AverageTemperature, Precipitation, ClimateData, LocalRegulations, RecommendedDurationStay, NearbyAttractions } = req.body;
        const sql = `
            INSERT INTO Destinations 
            (CityName, CountryName, Latitude, Longitude, AverageTemperature, Precipitation, ClimateData, LocalRegulations, RecommendedDurationStay, NearbyAttractions) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        db.query(sql, [CityName, CountryName, Latitude, Longitude, AverageTemperature, Precipitation, ClimateData, LocalRegulations, RecommendedDurationStay, NearbyAttractions], (err, result) => {
            if (err) throw err;
            res.send('Destination added successfully!');
        });
    });

    app.delete('/destinations/:id', (req, res) => {
        const sql = `DELETE FROM Destinations WHERE DestinationID = ?`;
        db.query(sql, [req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Destination deleted successfully!');
        });
    });

    app.put('/destinations/:id', (req, res) => {
        const { CityName, CountryName, Latitude, Longitude, AverageTemperature, Precipitation, ClimateData, LocalRegulations, RecommendedDurationStay, NearbyAttractions } = req.body;
        const sql = `
            UPDATE Destinations SET 
            CityName = ?, CountryName = ?, Latitude = ?, Longitude = ?, AverageTemperature = ?, Precipitation = ?, ClimateData = ?, LocalRegulations = ?, RecommendedDurationStay = ?, NearbyAttractions = ? 
            WHERE DestinationID = ?
        `;
        db.query(sql, [CityName, CountryName, Latitude, Longitude, AverageTemperature, Precipitation, ClimateData, LocalRegulations, RecommendedDurationStay, NearbyAttractions, req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Destination updated successfully!');
        });
    });

    app.get('/destinations', (req, res) => {
        const sql = `SELECT * FROM Destinations`;
        db.query(sql, (err, result) => {
            if (err) throw err;
            res.json(result);
        });
    });
};
