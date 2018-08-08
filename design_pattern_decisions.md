# BenevoProjects Design Decisions

## Implementations
### EIP 918 Mineable Token Standard
Leveraging the security of Ethereum, building token on top of Ethereum instead of it's own chain makes the 51% attack significantly harder.

### BenevoProject's ownerAddress and projectAddress
Since I am planning to add escrow functionality to each project in the future, releasing the tokens to the project owner only when certain criteria are met, I needed to seperate projectAddress and ownerAddress. Because, otherwise, anydonation made towards the projects could be withdrew by the owner. I first thought to randomly generate projectAddress, but there would be a slight chance of colliding with another user's address. Therefore I decided to hash the msg.sender address with ripemd160, making an 20 byte output which equals the address type in solidity.

## Future Improvements
- directly mine BenevoToken for a project