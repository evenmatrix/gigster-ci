var express = require('express')
var app = express()

app.get('/', function (req, res) {
  res.send('Hello Gigster!"')
})

app.listen(80, function () {
  console.log('Example app listening on port 80!')
})
