/*
    Testing the kill command ^abc, UTF-8 strings between subscripts and data
*/

var gtm = require("../mumps");
var db = new gtm.Gtm();

db.open();

console.log('\n---------------------------------\n');
console.log('Testing the get function, starting at: ' + Date());
  
  console.log('set ^abc("Ｉｔａｌｙ",1)="Ｒｏｍａ"');
  node = {global: 'abc', subscripts: [ escape('Ｉｔａｌｙ'), 1 ], data: escape('Ｒｏｍａ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);

  console.log('\n');
  var get = db.get( {global: 'abc', subscripts: [ escape('Ｉｔａｌｙ'), 1 ]} );
    get.subscripts = unescape(get.subscripts);
    console.log(get);

  console.log('\n');
  console.log('kill ^abc("Ｉｔａｌｙ" ');
  var kill = db.kill( {global: 'abc', subscripts: [ escape('Ｉｔａｌｙ') ]} );
    kill.subscripts = unescape(kill.subscripts);
    console.log(kill);

db.close()

console.log('Testing the set command, ending at: ' + Date());
console.log('\n---------------------------------\n');

