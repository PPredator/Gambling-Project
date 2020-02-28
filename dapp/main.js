var web3 = new Web3(Web3.givenProvider);
var contractInstance;



$(document).ready(function() {
    window.ethereum.enable(). then(function(accounts){
      contractInstance = new web3.eth.Contract(abi,"0xF62122121980a1bFC3B31b28356205E089fA0302", {from:accounts[0]});
      console.log(contractInstance);
      seeMoney();
    });
    $("#add_data_button").click(inputBet);

    $("#widtrowlonlyowner_button").click(ownMoney);
    $("#get_contractballnace_button").click(cBalance);
    $("#add_filling_contract_button").click(toFill);
    $("#head_button").click(putHead);
    $("#tails_button").click(putTales);
    $("#add_deposit_contract_button").click(depositMoney);
    $("#refresh_button").click(seeMoney);
    $("#widtrowlmoney_button").click(takeMoney);




});
 /*contractInstance.getPastEvents(['allEvents'],
                             {fromBlock: 'latest', toBlock: 'latest'},
                             async (err, events) => {
                                  console.log(err);
                             });*/

                             contractInstance.getPastEvents('generatedRandomNumber', {
       filter: {myIndexedParam: [20,23], myOtherIndexedParam: '0xF62122121980a1bFC3B31b28356205E089fA0302'}, // Using an array means OR: e.g. 20 or 23
       fromBlock: 0,
       toBlock: 'latest'
   }, function(error, events){ console.log(events); })
   .then(function(events){
       console.log(events) // same results as the optional callback above
   });

             // event output example
                             /*contractInstance.generatedRandomNumber({}, { fromBlock: 0, toBlock: 'latest' }).get((error, eventResult) => {
                               if (error)
                                 console.log('Error in myEvent event handler: ' + error);
                               else
                                 console.log('myEvent: ' + JSON.stringify(eventResult.args));
                             });*/


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



  contractInstance.methods.flip(size,aa).send()
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
        setTimeout(() => { seeMoney();}, 3000);
        setTimeout(() => { $("#name_output").text("You Win!"); }, 3000);
        setTimeout(() => { $("#nname_output").text("Money travelin to your address!"); }, 3000);
      }else {
        //setTimeout(() => { alert("You Lose!"); }, 3000);
        setTimeout(() => { $("#name_output").text(" You Lose!"); }, 3000);
        setTimeout(() => { $("#nname_output").text("Better Luck next Time!"); }, 3000);
        setTimeout(() => { seeMoney();}, 3000);
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
      $("#usermoney_output").text(res/10000000000000000 + " miniETH");



  })
}

function takeMoney(){
  contractInstance.methods.witrowpublicmoney().send();
  seeMoney();

}

function ownMoney(){
  contractInstance.methods.withdrawAll().send();

}
function cBalance(){
  contractInstance.methods.ContractBallanse().call().then(function(ss){
    console.log(ss);
    $("#contactbalance_output").text(ss/10000000000000000 + " miniETH");
  })
}

function toFill(){
  var size = $("#fill_contract_input").val();
  var config ={
    value: (web3.utils.toWei(size, "ether")/100)
  }

  contractInstance.methods.fundContract(size).send(config)
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
    value: (web3.utils.toWei(addedmoney, "ether")/100)
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
