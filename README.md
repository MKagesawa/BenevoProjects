# BenevoProjects

![logo](https://s22.postimg.cc/5slfs834x/Screen_Shot_2018-08-26_at_8.25.56_PM.png 'BenevoProjects')

## Overview
Biggest reasons why people do not donate or volunteer are 

1. No Money
2. No Time
3. Lack of confidence in what their donations are actually used for.

BenevoProjects strive to becomes a platform where anyone can create projects to raise fund or donate their computer's processing power to mine BenevoToken (An ERC-20 Web Browser Mineable Token currently under development) for the project of their choice. With just a little time and electricity cost, anyone can make an impact and be confident what their donations are used for.

Currently, there are some websites which users can mine Monero for a good cause.
However, the lack of transparency of Monero leaves the miners wondering where their donations actually go to.

Checkout:
- [design_pattern_decisions.md](design_pattern_decisions.md) for details about design decisions
- [avoiding_common_attacks.md](avoiding_common_attacks.md) for how the contracts strive for high security
- [deployed_addresses.txt](deployed_addresses.txt) to view deployed smart contracts on Rinkeby Testnet

## Set up a local server
- Install the following dependencies
    - [Ganache-cli](https://github.com/trufflesuite/ganache-cli)

        ```npm install -g ganache-cli```
    - [Truffle](https://truffleframework.com/docs/truffle/getting-started/installation)

        ```npm install -g truffle```
    - [MetaMask](https://metamask.io/)

    - [NodeJS](https://nodejs.org/en/download/)

    - For more details on installing Truffle on Ubuntu 16.04 check [here](http://www.techtonet.com/how-to-install-and-execute-truffle-on-an-ubuntu-16-04/)

- Start Ganache by running `ganache-cli`
- To compile the smart contracts, run `truffle compile` on another terminal window
- To deploy contracts to ganache locally, run `truffle migrate`
- To run all solidity tests in the test folder, run `truffle test`
- To install all npm dependencies needed, run `npm install`
- Run `npm run dev` to fire up a local server on `http://localhost:3000/`

  If you see error `/usr/bin/env: node: No such file or directory`, then try running `ln -s /usr/bin/nodejs /usr/bin/node`.
- Log in your Ganache account on MetaMask by choosing `Private Network` and you're set!



## Big Picture
When the society adopts Blockchain-Based Token Economy, goods and services will be tokenized onto the blockchain where everyone can verify all transactions. BenevoProjects hope to integrate with those blockchains and serve as an escrow service releasing donations to the project owners only when they have both proved they have used the donations for and delivered the results they have promised on the blockchain.

Example Scenario:
Bob promises to provide food to children in country A and creates a BenevoProject asking for 1000 BenevoToken donations. 100 people use BenevoProjects website to mine BenevoToken for Bob. The first 100 BenevoTokens are released to Bob and he uses a decentralized exchange to buy other cryptocurrencies with his Benevotokens. He uses the cryptocurrency to buy food from Store B and ship it to country A using Courier C. Store B tokenizes its product and Courier C tokenizes its service with public chains such as [everiToken](https://everitoken.io/). When Alice from country A receives Bob's benevolent gift, she signs it with [uPort](https://www.uport.me/) providing proof that she has received it. After BenevoProjects verifies the transactions on the decentralized exchange, everiToken, and uPort it releases the next 300 BenevoTokens to Bob. If donors would like even more security that Bob would not run away with the donations, a smart contract could be made to ensure that the BenevoTokens Bob receive can only be spent on certain goods/services.

If you also believe in this vision, feel free to contribute!