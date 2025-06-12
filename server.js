'use strict';

const express = require('express');

// Constants
const PORT = process.env.PORT || 3000;

// App
const app = express();
app.get('/', function (req, res) {
  res.send('WELCOME TO THE 2025 NEW WORLD\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
