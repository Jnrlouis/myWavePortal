const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
      value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();
    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by: ", owner.address);

    let contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    let waveCount;
    waveCount = await waveContract.getTotalWaves();

    let waveTxn;
    waveTxn = await waveContract.wave("Hi there!");
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();


    waveTxn = await waveContract.connect(randomPerson).wave('Hello from the other side!');
    await waveTxn.wait(); // Wait for the transaction to be mined
  
    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    waveTxn = await waveContract.connect(randomPerson).wave('Hello from the other side Again!');
    await waveTxn.wait();
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );
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