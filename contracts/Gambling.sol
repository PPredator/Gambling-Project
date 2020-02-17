pragma solidity 0.5.12;
import "./Ownable.sol";

contract Gambling is Ownable{

   struct Bet{
       uint id;
       uint size;
       uint bol;
       bool isWinning ;
       address playerAddress;
       uint userBallance;

   }



   function destToy()public onlyOwner{
       address payable reciever = msg.sender;

       selfdestruct(reciever);
   }


   uint public balance = 0;






   uint public randommm=0;

   event BetMade(uint size, uint bol);

   mapping(address => Bet) private betting;

   modifier onlyBetOwner(){
      require(msg.sender == betting[msg.sender].playerAddress);
      _;
  }




   function random() public view returns (uint){

       return now %2;


   }



   function addBet(uint size, uint bol) public {
       address creator = msg.sender;
       require( size*1e18 <= betting[creator].userBallance);


       Bet memory newBet;
       newBet.size = size;
       newBet.bol = bol;
       newBet.playerAddress = msg.sender;





       random();


       if((random() == 0) && (bol == 0)){
            newBet.isWinning=true;
             newBet.userBallance = betting[creator].userBallance +  size*1e18*2;


           balance -= size*1e18;
         }else if((random() == 1) && (bol ==1)){
           newBet.isWinning=true;
            newBet.userBallance = betting[creator].userBallance +  size*1e18*2;
            balance -= size*1e18;





       }else {
        uint256  zz = betting[msg.sender].userBallance;
        newBet.userBallance = zz - size*1e18;
        balance += size*1e18;
        newBet.isWinning = false;
       }

       if(random() == 0){
         randommm=0;
           }else{
             randommm=1;

          }
        betting[creator] = newBet;
        emit BetMade(newBet.size, newBet.bol);

   }


   function widtraulall()public payable onlyOwner {
       uint allmoney = balance;
       balance = 0;
       msg.sender.transfer(allmoney);

   }

   function witrowpublicmoney() public payable onlyBetOwner {
       address creator = msg.sender;
     uint publicBallace = betting[creator].userBallance;
     betting[creator].userBallance = 0;
      msg.sender.transfer(publicBallace);

   }

   function getMoney() public view returns (uint){
     address creator = msg.sender;
     return (betting[creator].userBallance);
   }



   function isItWinning() public  view returns(bool){
   address creator = msg.sender;
   return(betting[creator].isWinning);

   }


  function insertBallance(uint adding) public payable {

      require(msg.value == adding*1e18);
      if(msg.value != adding*1e18) revert();
      balance = balance + (adding* 1e18);
  }



  function ContractBallanse()public view onlyOwner returns (uint){
      return (address(this).balance);
  }

   function retRandom() public view returns(uint){
     return (randommm);
   }

   function getAddress() public view returns (address) {
     address creator = msg.sender;
     return betting[creator].playerAddress;

   }

    function depositM(uint addedmoney) public payable  {
        address creator = msg.sender;
        require(msg.value == addedmoney*1e18 );

        if(msg.value != addedmoney*1e18) revert();

        betting[creator].userBallance = betting[creator].userBallance + addedmoney*1e18;
    }

}
