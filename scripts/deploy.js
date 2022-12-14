const main = async () => {
    const CHAIN_CONTRACT = await hre.ethers.getContractFactory("VRFv2Consumer");
    const chainContract = await CHAIN_CONTRACT.deploy(7665) //my sucbscirtion id
    
    console.log("Chain Contract deployed to:", chainContract.address);
    

    const gameContractFactory = await hre.ethers.getContractFactory('Game');
    const gameContract = await gameContractFactory.deploy(                 
        ["Zeus", "loki", "poseidon"],
        ["https://blogs.infobae.com/grecia-aplicada/files/2012/11/Zeus_by_thegryph-203x300.jpg",
        "https://cdn.shopify.com/s/files/1/1879/3511/articles/canva-photo-editor5_1024x1024.png?v=1537154828",
        "https://ealvarezdecienfuegosibanez.files.wordpress.com/2016/09/img_7710.jpg?w=620"],
        [1000,500,250],
        [200,100,50],                      
    );
    await gameContract.deployed();
    console.log("Game Contract deployed to:", gameContract.address);
  
    
    let txn;
    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #1");
  
    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #2");
  
    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();
    console.log("Minted NFT #3");
  
    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #4");
  
    console.log("Done deploying and minting!");
  
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();