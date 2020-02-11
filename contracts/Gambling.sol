pragma solidity 0.5.12;
import "./Ownable.sol";

contract Gambling is Ownable{

   struct Bet{
       uint id;
       uint size;
       uint bol;
       bool isWinning ;
       address playerAddress;

   }



   function destToy()public onlyOwner{
       address payable reciever = msg.sender;

       selfdestruct(reciever);
   }


   uint public balance = 0;

   uint public money = 0;

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



   function addBet(uint size, uint bol) public payable{
       require(msg.value >= size);

       address creator = msg.sender;
       Bet memory newBet;
       newBet.size = size;
       newBet.bol = bol;
       newBet.playerAddress = msg.sender;
       betting[creator] = newBet;




       random();



       if((random() == 0) && (bol == 0)){
            newBet.isWinning=true;
            money += msg.value*2;
            witrowpublicmoney();

           balance -= msg.value;
         }else if((random() == 1) && (bol ==1)){
           newBet.isWinning=true;
           money += msg.value*2;
           witrowpublicmoney();




       }else {
         money += 0;
        balance += msg.value;
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
     uint publicBallace = money;
     money = 0;
      msg.sender.transfer(publicBallace);

   }

   function getMoney() public view returns (uint){
     return (money);
   }



   function isItWinning() public  view returns(bool){
   address creator = msg.sender;
   return(betting[creator].isWinning);

   }


  function insertBallance(uint adding) public payable onlyOwner{

      require(msg.value == adding*1e18);
      if(msg.value != adding*1e18) revert();
      balance = balance + (adding* 1e18);
  }

  function CasinoProfit()public view onlyOwner returns(uint256){
      return(balance - money);
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


}
