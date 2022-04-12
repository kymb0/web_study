
Solidity's code is encapsulated in contracts. A contract is the fundamental building block of Ethereum applications — all variables and functions belong to a contract, and this will be the starting point of all your projects.

State variables are permanently stored in contract storage. This means they're written to the Ethereum blockchain. Think of them like writing to a DB.
Note: In Solidity, uint is actually an alias for uint256, a 256-bit unsigned integer. You can declare uints with less bits — uint8, uint16, uint32, etc.. But in general you want to simply use uint except in specific cases, which we'll talk about in later lessons.

Math in Solidity is pretty straightforward. The following operations are the same as in most programming languages:

Addition: x + y
Subtraction: x - y,
Multiplication: x * y
Division: x / y
Modulus / remainder: x % y (for example, 13 % 5 is 3, because if you divide 5 into 13, 3 is the remainder)
Solidity also supports an exponential operator (i.e. "x to the power of y", x^y):

uint x = 5 ** 2; // equal to 5^2 = 25


When you want a collection of something, you can use an array. There are two types of arrays in Solidity: fixed arrays and dynamic arrays:

// Array with a fixed length of 2 elements:
uint[2] fixedArray;
// another fixed Array, can contain 5 strings:
string[5] stringArray;
// a dynamic Array - has no fixed size, can keep growing:
uint[] dynamicArray;

Remember that state variables are stored permanently in the blockchain? So creating a dynamic array of structs like this can be useful for storing structured data in your contract, kind of like a database.

Public Arrays
You can declare an array as public, and Solidity will automatically create a getter method for it. The syntax looks like:

Person[] public people;
Other contracts would then be able to read from, but not write to, this array. So this is a useful pattern for storing public data in your contract.

function eatHamburgers(string memory _name, uint _amount) public {

}
This is a function named eatHamburgers that takes 2 parameters: a string and a uint. For now the body of the function is empty. Note that we're specifying the function visibility as public. We're also providing instructions about where the _name variable should be stored- in memory. This is required for all reference types such as arrays, structs, mappings, and strings.

In Solidity, functions are public by default. This means anyone (or any other contract) can call your contract's function and execute its code.

Obviously this isn't always desirable, and can make your contract vulnerable to attacks. Thus it's good practice to mark your functions as private by default, and then only make public the functions you want to expose to the world.

Let's look at how to declare a private function:

uint[] numbers;

function _addToArray(uint _number) private {
  numbers.push(_number);
}
This means only other functions within our contract will be able to call this function and add to the numbers array.

As you can see, we use the keyword private after the function name. And as with function parameters, it's convention to start private function names with an underscore (_).

string greeting = "What's up dog";

function sayHello() public returns (string memory) {
  return greeting;
}
In Solidity, the function declaration contains the type of the return value (in this case string).

Function modifiers
The above function doesn't actually change state in Solidity — e.g. it doesn't change any values or write anything.

So in this case we could declare it as a view function, meaning it's only viewing the data but not modifying it:

function sayHello() public view returns (string memory) {
Solidity also contains pure functions, which means you're not even accessing any data in the app. Consider the following:

function _multiply(uint a, uint b) private pure returns (uint) {
  return a * b;
}
This function doesn't even read from the state of the app — its return value depends only on its function parameters. So in this case we would declare the function as pure.

Note: It may be hard to remember when to mark functions as pure/view. Luckily the Solidity compiler is good about issuing warnings to let you know when you should use one of these modifiers.

Ethereum has the hash function keccak256 built in, which is a version of SHA3. A hash function basically maps an input into a random 256-bit hexadecimal number. A slight change in the input will cause a large change in the hash.

It's useful for many purposes in Ethereum, but for right now we're just going to use it for pseudo-random number generation.

Also important, keccak256 expects a single parameter of type bytes. This means that we have to "pack" any parameters before calling keccak256:

    Events are a way for your contract to communicate that something happened on the blockchain to your app front-end, which can be 'listening' for certain events and take action when they happen.

Example:

// declare the event
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public returns (uint) {
  uint result = _x + _y;
  // fire an event to let the app know the function was called:
  emit IntegersAdded(_x, _y, result);
  return result;
}
Your app front-end could then listen for the event. A javascript implementation would look something like:

YourContract.IntegersAdded(function(error, result) {
  // do something with result



  event NewZombie(uint zombieId, string name, uint dna); // declare our event here
  uint id = zombies.push(Zombie(_name, _dna)) - 1; // and fire it here
  emit NewZombie(id, _name, _dna);
})

```
pragma solidity >=0.5.0 <0.6.0; //set compiler to any version within this range

contract ZombieFactory {

    uint dnaDigits = 16; //state variable will be stroed permanently in the blockchain
    uint dnaModulus = 10 ** dnaDigits; //set a uint which will always 10^16, allowing us to shorten an integer to 16 digits with %

    event NewZombie(uint zombieId, string name, uint dna); //declare an event to push to our front-end when a zombie made

    struct Zombie { //create a zombie struct, allowing us to create complex little minions
        string name;
        uint dna;
    }

    Zombie[] public zombies; //an array containing an array of created zombies and their dna sequence to dictate what they look like

    mapping (uint => address) public zombieToOwner; //map how many zombies tied to an address
    mapping (address => uint) ownerZombieCount; //map an address to a uint, determining how many times the createzombie function has been ran

    function _createZombie (string memory _name, uint _dna) private { //here we create our zombies in a PRIVATE function
        //zombies.push(Zombie(_name, _dna)); //create a function that pushes a zombie struct containing our args onto the zombies array - this line is redundant after we added below line
        uint id = zombies.push(Zombie(_name, _dna)) - 1; //we obtain the id of the new zombie by getting the last value in the array
        zombieToOwner[id] = msg.sender; // map the value of id to the message sender address
        ownerZombieCount[msg.sender]++; // increase the value (starting at 0) of zombie count
        emit NewZombie(id, _name, _dna); //fire the even we declared earlier after a zombie is made
    }

    function _generateRandomDna(string memory _str) private view returns (uint) { //create "helper" function
        uint rand = uint(keccak256(abi.encodePacked(_str))); //we take the keccak256 hash and store it as a uint after typecasting it
        return rand % dnaModulus; //we make sure the value is maximum 16 digits
    }

    function createRandomZombie(string memory _name) public { //tie everything together in a public function
        require(ownerZombieCount[msg.sender] == 0); //make sure that the address has not created any zombies yet
        uint randDna = _generateRandomDna(_name); //declare a variable holding the returned value of _generateRandomDna
        _createZombie(_name, randDna);

}


import "./zombiefactory.sol";
contract ZombieFeeding is ZombieFactory { //create a subcontract inheriting from zombie factory

    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]); // make sure the current address is equal to this zombies owner
        Zombie storage myZombie = zombies[_zombieId]; //declare myZombie as a storage pointer (this is due to a requirement by solidity)

  }
}
```
