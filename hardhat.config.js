require("@nomicfoundation/hardhat-toolbox");


require("@nomicfoundation/hardhat-ethers");

/** @type import('hardhat/config').HardhatUserConfig */

const ALCHEMY_API_KEY = "PNw9ea3Pj9E2AOrD-LaqWyqHU97f6h5j";


const SEPOLIA_PRIVATE_KEY = "212fa8af1ef4af523de60179c5e7614e9cdd9adfc5df367e608fdfbbb47a645d";


module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY]
    }
  }
};
//0x621C262b21879d51BB98cc674d750c2a207D9E88

/*
Deploying contracts with the account: 0x728BfdEfb4b69f69C38DD09f54915eDa66907C01
Token address: 0x8Cb0048aBAA0Ca3d9a3C83744fa033c249907331
*/