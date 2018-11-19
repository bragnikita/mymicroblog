const update = require('immutability-helper');

const collection = [ { a: 1 }, { a: 2 }];

console.log(update(collection, {0: {a : {$set: 3}}}));