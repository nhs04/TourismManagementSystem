const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const hbs = require('hbs');

const app = express();
app.use(bodyParser.json());
app.set('view engine', 'hbs');
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

// MySQL connection setup
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'newpassword',
    database: 'TourismDB'
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to the MySQL server.');
});

// Basic route for home page
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

app.get('/query', (req, res) => {
    res.sendFile(__dirname + '/public/query.html');
});

// API routes
require('./routes/tourists')(app, db);
require('./routes/destinations')(app, db);
require('./routes/hotels')(app, db);
require('./routes/transportation')(app, db);

// Set up the server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
