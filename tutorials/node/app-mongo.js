// Retrieve
var MongoClient = require('mongodb').MongoClient;
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
var url = "mongodb://mongo:27017/test";

function increment_and_return(res)
{
  MongoClient.connect(url, function(err, db) {
    if(!err) 
    {
      console.log("We are connected");

      var test = db.collection('test');
       
      test.update(
          // find record with name "MyServer"
          { name: "my_counter" },
          // increment it's property called "ran" by 1
          { $inc: { count: 1 } },
          function(err, count, results){
            if(JSON.parse(count).n == "0"){
              test.insert({"name":"my_counter","count":1}, 
                 function(err, result){
                   test.findOne({ name: "my_counter"},
                     function(err, item) {
                       res.end("This service has been used " + item.count + " times");
                       db.close();
                     });
              });
            }
            else
            {
              test.findOne({ name: "my_counter"},
                function(err, item) {
                  res.end("This service has been used " + item.count + " times");
                  db.close();
              });
            }
          });
    }
  });
}

app.get('/', function (req, res) {
  increment_and_return(res);
})

var server = app.listen(port, function () {
  console.log('Example app listening on port %s!', port)
})

module.exports = server;
