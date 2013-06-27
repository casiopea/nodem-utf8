/*
    Testing the version & $zchset function from GT.M, UTF-8 strings between subscripts and data
*/

var gtm = require("../mumps");
var db = new gtm.Gtm();

db.open();

var node;
var ret;
console.log('\n---------------------------------\n');
console.log('Testing etc., starting at: ' + Date());

  var version = db.function({function: 'version^node'});
    version.result = unescape(version.result);
    console.log(version);

  var zchset = db.function({function: 'zchset^node'});
    console.log(zchset);

db.close()

console.log('Testing the etc, ending at: ' + Date());
console.log('\n---------------------------------\n');

