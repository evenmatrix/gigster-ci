var express = require('express')
var app = express()

app.get('/', function (req, res) {
  res.send('Hello great, grand world of Gigster!!')
})

var server = app.listen(3000, function () {
  var port = server.address().port;
  console.log('Example app listening on port %s!', port)
})

module.exports = server;
