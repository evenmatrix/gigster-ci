var request = require('request');
var assert = require('assert');
var base_url = "http://localhost:3000/";

describe('loading express', function () {
  describe("GET /", function() {
    it('responds to /', function testSlash(done) {
      request.get(base_url, function(error, response, body) {
        assert.equal(200, response.statusCode);
        done();
      });
     });

    it('404 everything else', function testPath(done) {
      request.get(base_url+ "/foo/bar", function(error, response, body) {
        assert.equal(404, response.statusCode);
        done();
      });
    });
  });
});
