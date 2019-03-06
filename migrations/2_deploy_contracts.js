let Pong = artifacts.require("./Pong.sol");

async function deploy(deployer) {
  await deployer.deploy(Pong, {gas: 2000000});
  let fs = require("fs");
  let jsonObject = {
      pong_address: Pong.address,
      pong_abi: Pong.abi
  };

  fs.writeFile("data.json", JSON.stringify(jsonObject), function (err) {
      if (err) {
          return console.log(err);
      }
  });

}

module.exports = deploy;
