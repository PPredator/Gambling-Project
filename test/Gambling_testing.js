const Gambling = artifacts.require("Gambling");
const truffleAssert = require ("truffle-assertions");
contract("Gambling", async function(accounts){

let instance;

before(async function(){
  instance = await Gambling.deployed();
});

it("should be the ouwner", async function(){


await truffleAssert.passes(instance.widtraulall( {from:accounts[0]}),truffleAssert.ErrorType.REVERT);
});

it("should be the ouwner", async function(){


await truffleAssert.fails(instance.widtraulall( {from:accounts[3]}),truffleAssert.ErrorType.REVERT);
});

it("Can add balance to cotract only by the Owner", async function(){


await truffleAssert.passes(instance.insertBallance(1,{value:web3.utils.toWei("1", "ether") ,from:accounts[0]}),truffleAssert.ErrorType.REVERT);
});

it("Can add balance to cotract only by the Owner", async function(){


await truffleAssert.fails(instance.insertBallance(1,{value:web3.utils.toWei("1", "ether") ,from:accounts[5]}),truffleAssert.ErrorType.REVERT);
});

it("Should take any bet", async function(){


await truffleAssert.passes(instance.addBet(1,{value:web3.utils.toWei("1", "ether") ,from:accounts[5]}),truffleAssert.ErrorType.REVERT);
});

it("Should take any bet", async function(){


await truffleAssert.passes(instance.addBet(2,{value:web3.utils.toWei("2", "ether") ,from:accounts[9]}),truffleAssert.ErrorType.REVERT);
});

it("Should update the ballance ",async function(){

  await instance.addBet(1,{value:web3.utils.toWei("1", "ether") ,from:accounts[5]});
  await instance.addBet(1,{value:web3.utils.toWei("1", "ether") ,from:accounts[5]});


  let ballancebefore = parseFloat(await web3.eth.getBalance(accounts[0]));


  await instance.widtraulall();
  let ballanceAfter = parseFloat(await web3.eth.getBalance(accounts[0]));
  assert(ballanceAfter>ballancebefore);
  });

});
