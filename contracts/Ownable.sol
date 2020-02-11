pragma solidity 0.5.12;

contract Ownable {

  address private owner;

  constructor() public{
      owner = msg.sender;
      }

      modifier onlyOwner(){
          require(owner == msg.sender );
          _;
      }
}
