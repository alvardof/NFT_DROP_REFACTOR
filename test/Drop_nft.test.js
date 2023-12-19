const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  
  
  describe("Drop_nft", function () {

    async function deployDropNft() {
      
      
    
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();
    
        const Drop = await ethers.getContractFactory("Drop_nft");
        const drop = await Drop.deploy();

        const url = ['QmcbZn6kFDxBm5dwVRE7MxVisqkVvYtK1sJFkuXxoXGA6D','QmcbZn6kFDxBm5dwVRE7MxVisqkVvYtK1sJFkuXxoXGA6D']
    
        return {owner, otherAccount, drop, url};

    }

    describe("Deployment", function () {


      it("Pay 0.01 ether", async function () {

        const {owner, otherAccount, drop, url} = await loadFixture(deployDropNft);

        

        ethAmount = String(ethers.parseEther("0.01"))

        tx = await drop.connect(owner).safeMint([url[0]],{ value: ethAmount })
        expect(ethers.formatEther(tx.value)).to.be.equal("0.01");

        

      });



      it("Pay less 0.01 ether", async function () {

        

        const {owner, otherAccount, drop, url} = await loadFixture(deployDropNft);

        ethAmount = String(ethers.parseEther("0.001"))
          
        await expect(drop.connect(owner).safeMint([url[0]],{ value: ethAmount }))
        .to.be.revertedWith('Insufficient funds!');

        


      });




      it("Pay for more token", async function () {

        const {owner, otherAccount, drop, url} = await loadFixture(deployDropNft);

        
        ethAmount = String(ethers.parseEther("0.02"))

        tx = await drop.connect(owner).safeMint([url[0],url[1]],{ value: ethAmount })
        expect(ethers.formatEther(tx.value)).to.be.equal("0.02");


      });


      it("Hidden token", async function () {

        const {owner, otherAccount, drop, url} = await loadFixture(deployDropNft);

        const url_hiden = 'https://salmon-opposite-porcupine-429.mypinata.cloud/ipfs/QmS1NgXrU9NpNPFjMcZEDQAWBVckijXPjsPKGCRY7vrGCq';
        
        ethAmount = String(ethers.parseEther("0.01"))

        await drop.connect(owner).safeMint([url[0]],{ value: ethAmount })
        
        tx = await drop.connect(owner).tokenURI(0)
        expect(url_hiden).to.be.equal(tx); 

      });


      it("Revealing token", async function () {

        const {owner, otherAccount, drop, url} = await loadFixture(deployDropNft);

        const url_reveal = 'https://salmon-opposite-porcupine-429.mypinata.cloud/ipfs/QmcbZn6kFDxBm5dwVRE7MxVisqkVvYtK1sJFkuXxoXGA6D';
        
        ethAmount = String(ethers.parseEther("0.01"))

        await drop.connect(owner).safeMint([url[0]],{ value: ethAmount })

        await drop.connect(owner).setRevealed(true)

        tx = await drop.connect(owner).tokenURI(0)
        expect(url_reveal).to.be.equal(tx); 

      });



    });


  });




