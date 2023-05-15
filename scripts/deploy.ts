import { ethers } from "hardhat";

async function main() {

  // const PEPE = await ethers.getContractFactory("PEPE");
  // const pepe = await PEPE.deploy();

  // await pepe.deployed();

  // console.log("Pepe deployed to:", pepe.address);

  const royalty = 500;
  const royaltyReciever = "0xe2b8651bF50913057fF47FC4f02A8e12146083B8";
  const baseURI = "https://rifjhrnwkpuzt3mchc5r7pgeqsrzpzuexpzagvjb76ppfd2f7bpa.arweave.net/igqTxbZT6Zntgji7H7zEhKOX5oS78gNVIf-e8o9F-F4";
  const holderURI = "https://awhm7x5ihbanlmu7mf2glokqa2tltnlzf44xi6tqd4fppnejn4ha.arweave.net/BY7P36g4QNWyn2F0ZblQBqa5tXkvOXR6cB8K97SJbw4";
  const whaleURI = "https://fcihlwvyn37myzsbpov3acmynihsm7cmbauk7inmkqrtgp67tq7a.arweave.net/KJB12rhu_sxmQXursAmYag8mfEwIKK-hrFQjMz_fnD4";
  // Declare pepeAddress as an address
  //const pepeAddress: any = pepe.address;
  const pepeAddress = "0xa403a316186438Fa9A5B4fa022Acf414C43f9fd9";

  const PEPENFT = await ethers.getContractFactory("PepeNFT");
  const pepenft = await PEPENFT.deploy(royalty, royaltyReciever, baseURI, holderURI, whaleURI, pepeAddress);

  await pepenft.deployed();

  console.log("pepenft deployed to:", pepenft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
