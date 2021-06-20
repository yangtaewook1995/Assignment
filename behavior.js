const Caver = require('caver-js')
const caver = new Caver('https://api.baobab.klaytn.net:8651/')
const web3 = require('web3');
const { expect } = require('chai');
const { constants, expectEvent, expectRevert, BN, ether, time } = require('@openzeppelin/test-helpers');

const contractAddress = "0xcC2365eB017B786c6Deaf1e2d41d2353cc61e7E6";

const contractABI = require('./build/contracts/Contents.json').abi;

const owner = "0xc1d5ee1d09b3b1c7d6c1f9a8323d7650ae4d1874";
const privateKey_Owner = '0x87a62328d3268940415fc85a45f4f8bfc1e454f9c33bd78a38d1f3dfefb6f9fc';

const contract = new caver.contract(contractABI,contractAddress);

async function createNFT(tokenName) {
    await contract.methods.createContent(tokenName).send({from:owner, gas:'0x4bfd200'});
}

async function addOwner(tokenId, name){
    await contract.methods.addHolders(tokenId, name).send({from:owner, gas:'0x4bfd200'});
}

async function printOwner(tokenId) {
    console.log("Owner info of (tokenId = " + tokenId, ")");
    const ownerInfo = await contract.methods.getHolderInfo(tokenId).call();
    console.log("\tHolder : " + ownerInfo);
    return(ownerInfo);
}

async function printNFT(tokenId) {
    console.log("NFT info of (tokenId = " + tokenId + ")");
    const contentInfo = await contract.methods.getContentInfo(tokenId).call();
    console.log("\tName : " + contentInfo.name);
    console.log("\tID : " + contentInfo.tokenId);
    return(contentInfo.name);
}

async function changeOwner(tokenId, name){
    await contract.methods.updateHolders(tokenId, name).send({from:owner, gas:'0x4bfd200'});
}

async function latestNFTId() {
    const tokenId = ((new BN(await contract.methods.contentCounter().call())).subn(1)).toNumber();
    console.log("Latest NFT ID : ", tokenId);
    return tokenId;
}

const keyring = caver.wallet.keyring.createFromPrivateKey(privateKey_Owner);
caver.wallet.add(keyring);


module.exports = {
    createNFT,
    changeOwner,
    addOwner,
    printOwner,
    printNFT,
    latestNFTId
};



