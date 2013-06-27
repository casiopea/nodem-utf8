/*
    Testing the set command ^abc, UTF-8 strings between subscripts and data
*/

var gtm = require("../mumps");
var db = new gtm.Gtm();

db.open();

var node;
var ret;
console.log('\n---------------------------------\n');
console.log('Testing the set command, starting at: ' + Date());

  node = {global: 'abc', subscripts: [ escape('Ｊａｐａｎ'), 1 ], data: escape('Ｔｏｋｙｏ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);
  node = {global: 'abc', subscripts: [ escape('Ｊａｐａｎ'), 2 ], data: escape('Ｏｓａｋａ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);
  node = {global: 'abc', subscripts: [ escape('Ｊａｐａｎ'), 3 ], data: escape('Ｎａｇｏｙａ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);
  node = {global: 'abc', subscripts: [ escape('Ｊａｐａｎ'), 4 ], data: escape('Ｆｕｋｕｏｋａ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);

  node = {global: 'abc', subscripts: [ escape('Ｂｒｉｔｉｓｈ'), 1 ], data: escape('Ｌｏｎｄｏｎ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);
  node = {global: 'abc', subscripts: [ escape('ＵＳＡ'), 1 ], data: escape('Ｎｅｗ　Ｙｏｒｋ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);
  node = {global: 'abc', subscripts: [ escape('ＵＳＡ'), 2 ], data: escape('Ｌｏｓ　Ａｎｇｅｌｅｓ') };
    ret = db.set(node);
    ret.subscripts = unescape(ret.subscripts);
    console.log(ret);
  node = {global: 'abc', subscripts: [ escape('Ｇｅｒｍａｎ'), 1 ], data: escape('Ｂｅｌｒｉｎ') };
    ret = db.set(node);

db.close()

console.log('Testing the set command, ending at: ' + Date());
console.log('\n---------------------------------\n');

