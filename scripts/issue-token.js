const TokenFarm = artifacts.require('TokenFarm')


// truffle exec scripts/issue-token.js
module.exports = async function(callback) {

  let tokenFarm = await TokenFarm.deployed()
  await tokenFarm.issueTokens()

  console.log("Tokens issued!")

  callback()
}