module.exports = (app, db) => {
    app.delete('/tourists/:id', (req, res) => {
        const sql = `DELETE FROM Tourists WHERE PassportNumber = ?`;
        db.query(sql, [req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Tourist deleted successfully!');
        });
    });

    app.put('/tourists/:id', (req, res) => {
        const { FirstName, LastName, Email } = req.body;
        const sql = `UPDATE Tourists SET FirstName = ?, LastName = ?, Email = ? WHERE PassportNumber = ?`;
        db.query(sql, [FirstName, LastName, Email, req.params.id], (err, result) => {
            if (err) throw err;
            res.send('Tourist updated successfully!');
        });
    });

    app.post('/tourists', (req, res) => {
            var sql = req.body.query;

            //Make it lowercase
            sql = sql.toLowerCase();

            if (req.body.query.includes("reviews")) {
                db.query(sql, (err, result) => {
                    if (err){
                        res.send(err);
                        return;
                    }
                console.log(result);
            //If the query does not include a select, re-select * from Tourists
            if (sql.includes("select") == false) {
                sql = `select * FROM reviews`;
            }
            db.query(sql, (err, result) => {
                if (err){
                    res.send(err);
                    return;
                }
                    res.render('reviews', { reviews: result });
                    return;
            });
                });
                return;
        }
        db.query(sql, (err, result) => {
            if (err){
                res.send(err);
                return;
            }
            console.log(result);
            //If the query does not include a select, re-select * from Tourists
            if (sql.includes("select") == false) {
                sql = `select * FROM Tourists`;
            }
            db.query(sql, (err, result) => {
                if (err){
                    res.send(err);
                    return;
                }
            res.render('tourists', { tourists: result });
            });
        });
    
    });

    app.post('/touristspayments', (req, res) => {
        const sql = req.body.query;
        //if the query contains "reviews" then we need to join with the reviews table
        if (sql.includes("reviews")) {
            db.query(sql, (err, result) => {
                if (err){
                    res.send(err);
                    return;
                }
                res.render('touristsreviews', { touristspayments: result });
                return;
            });
        }

        db.query(sql, (err, result) => {
            if (err){
                res.send(err);
                return;
            }
            
            console.log(result);
            res.render('touristspayments', { touristspayments: result });
        });
    });
    
    app.get('/tourists', (req, res) => {
        var sql = `SELECT * FROM Tourists`;
        db.query(sql, (err, result) => {
            if (err){
                res.send(err);
                return;
            }
            res.render('tourists', { tourists: result });
        });
    });


    app.post('/reviews', (req, res) => {
        var sql = `SELECT * FROM reviews`;
        if (req.body.query) {
            sql = req.body.query;
        }
        db.query(sql, (err, result) => {
            if (err){
                res.send(err);
                return;
            }
            console.log(result);
            //If the query does not include a select, re-select * from Tourists
            if (sql.includes("SELECT") == false) {
                sql = `SELECT * FROM reviews`;
            }
            db.query(sql, (err, result) => {
                if (err){
                    res.send(err);
                    return;
                }
            res.render('reviews', { reviews: result });
            });
        });
    });

    app.get('/reviews', (req, res) => {
        var sql = `SELECT * FROM reviews`;
        db.query(sql, (err, result) => {
            if (err){
                res.send(err);
                return;
            }
            res.render('reviews', { reviews: result });
        });
    });
};
