/* eslint-disable space-before-function-paren */
/* eslint-disable no-undef */
const hre = require('hardhat');
const { deployed } = require('./deployed');

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // Optionnel car l'account deployer est utilisé par défaut
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  // We get the contract to deploy
  const TXT = await hre.ethers.getContractFactory('TexToken');
  const txt = await TXT.deploy();

  // Attendre que le contrat soit réellement déployé, cad que la transaction de déploiement
  // soit incluse dans un bloc
  await txt.deployed();
  console.log(txt.interface.functions);

  // Create/update deployed.json and print usefull information on the console.
  await deployed('TexToken', hre.network.name, txt.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
