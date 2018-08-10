# BenevoProjects Design Decisions

## Implementations
### EIP 918 Mineable Token Standard
Leveraging the security of Ethereum, building token on top of Ethereum instead of it's own chain makes the 51% attack significantly harder.

### BenevoProject's ownerAddress and projectAddress
Since I am planning to add escrow functionality to each project in the future, releasing the tokens to the project owner only when certain criteria are met, I needed to seperate projectAddress and ownerAddress. Because, otherwise, anydonation made towards the projects could be withdrew by the owner. I first thought to randomly generate projectAddress, but there would be a slight chance of colliding with another user's address. Therefore I decided to hash the msg.sender address with ripemd160, making an 20 byte output which equals the address type in solidity.

### _createProject return variables
Initially, I designed the _createProject function not returning anything. When I was making the tests for it, I tried to access the Project through projects mapping. However when returning a struct from a mapping I was unable to save the struct for later assert equal tests. After some research I discover this is due to the way Solidity saves objects. Instead of using encoders and other tricks to make the code unneccesarily complicated, I decided to return all of the struct's variables, which is lengthy but clear and simple.

### testCreateProject split to two functions
When I had two of them together, I got "CompilerError: Stack too deep, try removing local variables".
I maxed the maximum number of local variables I could declare, so I split the test into two tests.

### releaseDonation function uses "pull over push"
To avoid the send call from errors due to the receiving address with a fallback function, project owners can withdraw funds instead of having the tokens sent to their address.

## Future Improvements
- directly mine BenevoToken for a project