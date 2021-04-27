# Bounty Hunter

This project aims to provide a platform to connect project owners and programmers, allowing the first, and potential other users, to create a bounty and associate
it to an issue. Solving that issue sucessfully allows the owner to send the bounty to the programmer that resolved it.

### Pricing
 We do not have a pricing plan, but each bounty claimed incurs a 10% tax for maintenance and to allow lower-end bounties to more effectively use the platform.
 
### Usage
 To create and manage an issue, one must first use the createUser method, sending your own github username as parameter. This allows us to identify your address and
 make sure that any action is from the owner. Then, createIssue() allows the owner to create and add value to that issue, identifying himself as the maintainer.
 Developers wanting to join the issue must use the joinIssue() method.
 
 After an issue is solved, the maintainer, and only him, can use the closeIssue() method, passing the gituser of the solver. This triggers the payment of the bounty.
 
 Users (or the owner) wanting to increase the bounty can use boostIssue() to send any value to be associated to the issude. This does not grant any kind of ownership
 to the user.
