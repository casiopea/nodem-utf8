/*
    Testing the get function ^abc, UTF-8 strings between subscripts and data
*/

var gtm = require("../mumps");
var db = new gtm.Gtm();

db.open();

console.log('\n---------------------------------\n');
console.log('Testing the get function, starting at: ' + Date());

  var get = db.get( {global: 'abc', subscripts: [ escape('Ｊａｐａｎ'), 1 ]} );
    get.subscripts = unescape(get.subscripts);
    console.log(get);

  var get = db.get( {global: 'abc', subscripts: [ escape('Ｂｒｉｔｉｓｈ'), 1 ]} );
    get.subscripts = unescape(get.subscripts);
    console.log(get);

db.close()

console.log('Testing the set command, ending at: ' + Date());
console.log('\n---------------------------------\n');

