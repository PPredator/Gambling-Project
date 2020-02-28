pragma solidity 0.5.12;
import "./Ownable.sol";
import "./provableAPI.sol";

contract Gambling is Ownable, usingProvable {

  uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;

  uint256 public balance;


  event DepositSent( uint size);
  event LogNewProvableQuery (string queryRequested);
  event generatedRandomNumber(uint256 randomNumber);
  event flipResult (string result);


  constructor () public {
    provable_setProof(proofType_Ledger);
  }

    struct User {  //struct one
    bytes32 id;
    address playerAddress;
  }

     struct Bet{  //struct two
      address payable playerAddress;
      uint side;
      uint userBallance;
      uint size;
      bool inGame;
      bool isItWins;
      uint ranNubber;

  }


  mapping (address => Bet) public betting;
  mapping (bytes32 => User) public player;

    // Need size and side of the coin
   function flip (uint size, uint side) payable public  {
     require(size <= betting[msg.sender].userBallance);
     require (betting[msg.sender].inGame == false, "You can not bet now, you are in Game");
     betting[msg.sender].playerAddress = msg.sender;
     betting[msg.sender].side = side;
     betting[msg.sender].size = size;
     betting[msg.sender].inGame = true;
     betting[msg.sender].isItWins = false;
     betting[msg.sender].ranNubber = 0;



   update();
  }
    // Updating and waiting for query_id
    function update() payable public {

    uint256 QUERY_EXECUTION_DELAY = 0;
    uint256 GAS_FOR_CALLBACK =200000;
    bytes32 query_id = provable_newRandomDSQuery(QUERY_EXECUTION_DELAY, NUM_RANDOM_BYTES_REQUESTED, GAS_FOR_CALLBACK);

    player[query_id].id = query_id;
    player[query_id].playerAddress = msg.sender;

    emit LogNewProvableQuery (" waiting for the callback");
  }

    //waiting for callback
   function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
    if (
      provable_randomDS_proofVerify__returnCode(
                _queryId,
                _result,
                _proof
            ) != 0
        ) {
        } else {

    require (msg.sender == provable_cbAddress());
    uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result)))%2;

    verifyResult (randomNumber, _queryId);
    emit generatedRandomNumber (randomNumber);
    }
  }

    //Is it WIN or Lose
   function verifyResult (uint randomNumber, bytes32 _queryId) private {

        if(randomNumber == betting[player[_queryId].playerAddress].side){

             betting[player[_queryId].playerAddress].userBallance = betting[player[_queryId].playerAddress].userBallance +  betting[player[_queryId].playerAddress].size*1e16*2;
             balance -= betting[player[_queryId].playerAddress].size*1e16;
             betting[player[_queryId].playerAddress].isItWins = true;
             betting[player[_queryId].playerAddress].ranNubber = randomNumber;
             emit flipResult ("won");

            }else {
              betting[player[_queryId].playerAddress].userBallance -= betting[player[_queryId].playerAddress].size*1e16;
              balance += betting[player[_queryId].playerAddress].size*1e16;
              betting[player[_queryId].playerAddress].isItWins = false;
              betting[player[_queryId].playerAddress].ranNubber = randomNumber;
              emit flipResult ("lost");


       }



    betting[player[_queryId].playerAddress].inGame = false;
  }



     //Withdraw all money from the contract
    function withdrawAll() public onlyOwner payable returns(uint){
        //Should require that no bet is prozess! Should wait and disalow all new bets!
        msg.sender.transfer(address(this).balance);
        assert(address(this).balance == 0);
        return address(this).balance;
    }

    // Inset money in the Contract
    function fundContract(uint256 ss) public payable onlyOwner returns(uint){
        require(msg.value == ss*1e16);
      if(msg.value != ss*1e16) revert();
      balance = balance + (ss* 1e16);

    }

    // Insert money in the userBallance
   function depositM(uint256 addedmoney) public payable  {
        address creator = msg.sender;
        require(msg.value == addedmoney*1e16 );

        if(msg.value != addedmoney*1e16) revert();

        betting[creator].userBallance = betting[creator].userBallance + addedmoney*1e16;
        emit DepositSent(addedmoney);
    }

     // Returns the balance of the player
   function getMoney() public view returns (uint256){
       return( betting[msg.sender].userBallance);
   }

    // Withdraw money from the userBallance
   function witrowpublicmoney() public payable {
       address creator = msg.sender;
     uint publicBallace = betting[creator].userBallance;
     betting[creator].userBallance = 0;
      msg.sender.transfer(publicBallace);

   }

   // Bool is the player wins
   function isItWinning() public view returns (bool){
       return ( betting[msg.sender].isItWins);
   }

    // Check ContractBallanse
   function ContractBallanse()public view onlyOwner returns (uint){
      return (address(this).balance);
  }

   // Returns player address
  function getAddress() public view returns (address) {
     address creator = msg.sender;
     return betting[creator].playerAddress;

   }

   // withdraws 50% of the contract Only Owner
   function withdrawl50() public onlyOwner{
      uint allmoney = balance /2;
      balance = balance /2;
      msg.sender.transfer(allmoney);
    }

   //Destroy the contract
    function destToy()public onlyOwner{
        address payable reciever = msg.sender;

        selfdestruct(reciever);
    }

   //get randomNumber
   function getRndom () public view returns (uint256){
       address creator = msg.sender;
       return( betting[creator].ranNubber);
   }

}
