const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('TgNft');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);
    let TotalSupply=1000;
  
    // Call the function.
    for(let i=0;i<TotalSupply;i++){
    let txn = await nftContract.makeAnRicettaNft()
    // Wait for it to be mined.
    await txn.wait()
    console.log("Minted NFT #")
    console.log(i)
    }
  
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