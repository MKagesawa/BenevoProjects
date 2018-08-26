# BenevoProjects Design Decisions

## Implementations
### EIP 918 Mineable Token Standard
Leveraging the security of Ethereum, building token on top of Ethereum instead of its own chain makes the 51% attack significantly harder.

### Initial balance in all BenevoToken accounts
Since web mining software is not implemented yet, all accounts are given initial balance so users can try the functionalities of BenevoToken. In the future users will start with a balance of zero and must obtain BenevoToken either through mining or exchanging with others.

### BenevoProject's ownerAddress and projectAddress
Since I am planning to add escrow functionality to each project in the future, releasing the tokens to the project owner only when certain criteria are met, I needed to separate projectAddress and ownerAddress. Because, otherwise, any donations made towards the projects could be withdrawn by the owner. I first thought to randomly generate projectAddress, but there would be a slight chance of colliding with another user's address. Therefore I decided to hash the msg.sender address with ripemd160, making an 20-byte output which equals the address type in solidity.

### _createProject return variables
Initially, I designed the _createProject function not returning anything. When I was making the tests for it, I tried to access the Project through projects mapping. However, when returning a struct from a mapping I was unable to save the struct for later assert equal tests. After some research, I discovered this is due to the way Solidity saves objects. Instead of using encoders and other tricks to make the code unnecessarily complicated, I decided to return all of the struct's variables, which is lengthy but clear and simple.

### testCreateProject split to two functions
When I had two of them together, I got "CompilerError: Stack too deep, try removing local variables".
I maxed the maximum number of local variables I could declare, so I split the test into two tests.

### releaseDonation function uses "pull over push"
To avoid the send call from errors due to the receiving address with a fallback function, project owners can withdraw funds instead of having the tokens sent to their address.

### BenevoToken tests
Since some functions are for mining and internal, they cannot be tested by solidity unit tests. They can only be tested with mining software to ensure smart contract behave as expected.

### Solidity Tests
On top of benefits of Javascript tests, including a clean-room environment per test suite, direct access to deployed contracts, and the ability to import any contract dependency, it also is able to be run against any Ethereum client and better reflect the production environment.

### Flattened contracts for Rinkeby Deployment
Since Etherscan verification does not support "import", all files that imports from other files have to be concatenated into one file.
I combined the files for Rinkeby deployment, but codes for local development are separated.

### Circuit Breaker in both BenevoProjects and BenevoToken
Implementing a circuit breaker in BenevoProjects is understandable. If the platform goes wrong, it gives the developers the tools to pause the platform and upgrade it. However, having a circuit breaker for a token contract may seem unreasonable as it gives excessive power to the developers. Nevertheless, I put a circuit breaker in place because what BenevoToken strive to achieve, a web mineable ERC20 Token is relatively new and prone to overlooked security flaws. After launching on the testnet and the contract has been robustly tested, I plan to remove the circuit breaker.

### Two TestBenevoProjects Files
I split them into two because I had "Error: VM Exception while processing transaction: out of gas" when they were one.

### BenevoToken transferAnyERC20Token function
In case any ERC20 token is accidentally sent to a BenevoToken address, the user can safely transfer those tokens out of the address. If such function is not implemented, those tokens would be lost

### IPFS
In order to make the dapp truly decentralized, all images used for front-end is published on IPFS. 
Take a look at projects.json or id="banner" on index.html file to check. 
Here are some example images:
QmZtBdDZPj8iLgMZymJSksA9dbTTQMR6kU8hoQsEY8p5mu ducksInOil.jpg
QmRYjkxiTVimLnQMpQZS6PXqW1C177237rpdmRyGrWGXVE forestAndCity.jpg

## Design Patterns Not Used

### JavaScript Tests
I chose to use Solidity tests instead of JavaScript tests because Solidity can test how contracts interact with each other, rather than only how the contract interact with the web3 frontend. 
As BenevoProject is dependent on BenevoTokens for donations and etc, I decided that at this stage Solidity tests are more important.

### Oraclize Solidity Tests
There are not tests for functions using Oracle such as getPollution() and __callback() because these functions require an external call to Oraclize and cannot be tested with Solidty tests.

### Ropsten Testnet
As deployment on the Rinkeby Testnet is required for the course, BenevoToken and Benevoprojects are deployed on it currently. However, as Rinkeby is PoA while Ropsten is PoW, Ropsten better reproduces the current production environment. As I plan to make BenevoToken a web mineable token, I will deploy on the Ropsten Testnet instead in the future.

## Future Improvements
- Finish implementing BenevoToken to make it web browser mineable ERC20 Token
- Use hashing algorithm other than keccak256 to make it GPU and ASICs resistant. The aim is for more people to become aware of the charitable projects and participate in 
- Work on front-end
- Publish the entire site on IPFS to make the dApp fully decentralized.