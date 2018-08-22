# How common attacks are avoided

### Race Conditions
For all functions dealing with token transfer, the token sender's balance is always subtracted before the receiver's balance is added. 
For the withdrawToken() function, the project's currentBalance is set to 0 before any token is sent to the project owner.
This prevent any malicious user from taking advantage of calling the function repeatedly before it finishes executing.

### Emergency Stop
Circuit breaker is implemented in both BenevoToken and BenevoProjects for functions that change states. This will give the developers sufficient time to react in the event of being hacked. For view functions that will not change the Ethereum state, they are accessible even when circuit breaker is implemented to help with debugging.

### Avoid Ether Handling & Cannot Forcibly send Ether
Both BenevoToken and BenevoProjects has an ETH payable fallback function to prevent any ETH to be sent to either of these contracts. The lack of ETH being stored in these contracts gives the hackers less financial incentive to hack these contracts.

### Integer Overflow & Underflow
For functions dealing with token transfer, both overflow and underflow are checked before any addition or subtraction to the balance.

### Pull instead of Push design for Token withdraw
Token release from BenevoProject use pull over push design. releaseDonation() function must be called first for the donations to the withdrawable, then the project owner must call withdrawToken() function to withdraw the tokens. This can migigate both the receiving address triggering a fallback function that throws an exception, and running out of gas.
