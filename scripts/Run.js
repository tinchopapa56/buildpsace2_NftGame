const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('Game');
    const gameContract = await gameContractFactory.deploy(
        ["Zeus", "loki", "poseidon"],
        ["https://blogs.infobae.com/grecia-aplicada/files/2012/11/Zeus_by_thegryph-203x300.jpg",
        "https://cdn.shopify.com/s/files/1/1879/3511/articles/canva-photo-editor5_1024x1024.png?v=1537154828",
        "https://ealvarezdecienfuegosibanez.files.wordpress.com/2016/09/img_7710.jpg?w=620"],
        [1000,500,250],
        [200,100,50],
        //BOSS
        "Elon Musk", 
        "https://i.imgur.com/AksR0tt.png",
        10000,
        5
    );
    await gameContract.deployed();
    console.log("Contract has BEEN deployed to:", gameContract.address);

    let txn;
      txn = await gameContract.mintCharacterNFT(2);
      await txn.wait();

      txn = await gameContract.attackBoss();
      await txn.wait();

      txn = await gameContract.attackBoss();
      await txn.wait();
    
    // Get the value of the NFT's URI.
    let returnedTokenUri = await gameContract.tokenURI(1);
    console.log("Token URI:", returnedTokenUri);

  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (err) {
      console.log(err);
      process.exit(1);
    }
  };
  
  runMain();