var web3 = new Web3(Web3.givenProvider);
var contractInstance;


$(document).ready(function() {
    window.ethereum.enable(). then(function(accounts){
      contractInstance = new web3.eth.Contract(abi,"0x05B6D8942982D48220d71B2ABFDB00bb89c72aB0", {from:accounts[0]});
      console.log(contractInstance);
    });
    $("#add_data_button").click(inputBet);

    $("#widtrowlonlyowner_button").click(ownMoney);
    $("#get_contractballnace_button").click(cBalance);
    $("#add_filling_contract_button").click(toFill);
    $("#head_button").click(putHead);
    $("#tails_button").click(putTales);
    $("#add_deposit_contract_button").click(depositMoney);
    $("#refresh_button").click(seeMoney);





});





var aa;
function putHead(){
   aa =  $("#head_button").val();
   $("#ht_output").text("Head");
  console.log(aa);

}

function putTales(){
   aa =  $("#tails_button").val();
     $("#ht_output").text("Tails");
  console.log(aa);


}

function inputBet(){
  var size = $("#bet_input").val();



  contractInstance.methods.addBet(size,aa).send()
  .on("transactionHash", function(hash){
    console.log(hash);
    $('#coin').removeClass();

  })
  .on("conformation", function(conformationNr){
    console.log(conformationNr);


  })
  .on("receipt", function winwin(){
    contractInstance.methods.isItWinning().call().then(function(rea){
      console.log(rea);
      getAdress();
      if(rea === true){
        //setTimeout(() => { alert("You Win!"); }, 3000);
        setTimeout(() => { $("#name_output").text("You Win!"); }, 3000);
        setTimeout(() => { $("#nname_output").text("Money travelin to your address!"); }, 3000);
      }else {
        //setTimeout(() => { alert("You Lose!"); }, 3000);
        setTimeout(() => { $("#name_output").text(" You Lose!"); }, 3000);
        setTimeout(() => { $("#nname_output").text("Better Luck next Time!"); }, 3000);
      }
  })



  })
  .on("receipt", function isitwin(){
    contractInstance.methods.retRandom().call().then(function(rea){
      console.log(rea);

      if(rea == 0){

        $('#coin').addClass('heads');
        //setTimeout(() => { alert("You Win!"); }, 3000);


      }else{

        $('#coin').addClass('tails');
        //setTimeout(() => { alert("You Lose!"); }, 3000);


      }

    })


  })


}



function seeMoney(){
  contractInstance.methods.getMoney().call().then(function(res){
    console.log(res);
      $("#usermoney_output").text(res/1000000000000000000 + " ETH");



  })
}

function takeMoney(){
  contractInstance.methods.witrowpublicmoney().send();

}

function ownMoney(){
  contractInstance.methods.widtraulall().send();

}
function cBalance(){
  contractInstance.methods.ContractBallanse().call().then(function(ss){
    console.log(ss);
    $("#contactbalance_output").text(ss/1000000000000000000 + " ETH");
  })
}

function toFill(){
  var size = $("#fill_contract_input").val();
  var config ={
    value: web3.utils.toWei(size, "ether")
  }

  contractInstance.methods.insertBallance(size).send(config)
  .on("transactionHash", function(hash){
    console.log(hash);

  })
  .on("conformation", function(conformationNr){
    console.log(conformationNr);
  })
  .on("receipt", function(receipt){
    console.log(receipt);

  })
}

function getAdress(){
  contractInstance.methods.getAddress().call().then(function(dor){
    console.log(dor);
    $("#addresss_output").text(dor);
  })
}

function hort(){

}

function depositMoney(){
  var addedmoney = $("#adddeposit_contract_input").val();

  var config ={
    value: web3.utils.toWei(addedmoney, "ether")
  }

  contractInstance.methods.depositM(addedmoney).send(config)
  .on("transactionHash", function(hash){
    console.log(hash);


  })
  .on("conformation", function(conformationNr){
    console.log(conformationNr);

  })
  .on("receipt", function(conformationNr){
    console.log(conformationNr);
    seeMoney();

  })


}
