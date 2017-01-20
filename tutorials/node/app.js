var express = require('express');
var app = express();

/*--- SECTION BELOW IS FOR HEROKU DEPLOYMENT---
*
*  Heroku sets the environment variable PORT in the dyno
*  your docker image is running on.
*
*  You need to run your service on PORT to forward requests
*  externally over port 80. Services cannot be directly exposed
*  over other ports on Heroku.
*/

// sets variable PORT to environment variable PORT, and if undefined to port 3000
var port = process.env.PORT || 3000;

app.get('/', function (req, res) {
  res.send('Hello Gigster!! now on Heroku and kubernetes part 7')
})

var server = app.listen(port, function () {
  console.log('Example app listening on port %s!', port)
})

module.exports = server;
