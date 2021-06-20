const express = require('express');
const app = express();

const behavior = require('../../behavior.js');

let NFT_name;
let NFT_id;
let NFT_owner;

app.get('/createNFT/:name', async function(req, res) {
    await behavior.createNFT(req.params.name);
    NFT_id = await behavior.latestNFTId();
    res.json({Name : req.params.name, ID : NFT_id});
});

app.get('/addOwner/:id/:name', async function(req, res) {
    await behavior.addOwner(req.params.id, req.params.name);
    res.json({ID : req.params.id, OwnerName : req.params.name});
});

app.get('/changeOwner/:id/:name', async function(req, res) {
    await behavior.changeOwner(req.params.id, req.params.name);
    res.json({ID : req.params.id, OwnerName : req.params.name});
});

app.get('/getNFTInfo/:id', async function(req, res) {
    NFT_name = await behavior.printNFT(req.params.id);
    NFT_owner = await behavior.printOwner(req.params.id);
    res.json({Name : NFT_name, ID : req.params.id, Owner : NFT_owner});
});

module.exports = app;

