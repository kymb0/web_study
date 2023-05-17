// Create an empty object
let obj = {};

// Log the default toString method of the obj object
console.log(obj.toString); // [Function: toString]

// Modify the toString method of the Object.prototype
Object.prototype.toString = function() { return 'Prototype polluted!'; }

// Create another empty object
let newObj = {};

// Log the toString method of the newObj object
console.log(newObj.toString); // [Function]

// Invoke the toString method of the newObj object
console.log(newObj.toString()); // 'Prototype polluted!'
