const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('Criptomines2');
    const gameContract = await gameContractFactory.deploy(
        ["Zeus", "loki", "poseidon"],
        ["https://blogs.infobae.com/grecia-aplicada/files/2012/11/Zeus_by_thegryph-203x300.jpg",
        "https://cdn.shopify.com/s/files/1/1879/3511/articles/canva-photo-editor5_1024x1024.png?v=1537154828",
        "https://ealvarezdecienfuegosibanez.files.wordpress.com/2016/09/img_7710.jpg?w=620"],
        [1000,250,500],
        [80,180,60],
        [5, 3, 2]
    );
    await gameContract.deployed();
    console.log("Contract has BEEN deployed to:", gameContract.address);
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