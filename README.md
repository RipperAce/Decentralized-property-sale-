# Decentralized-property-sale-
Building a solidity app integrated with web interface to perform ownership transfer of property.

Abstract: Developed smart contract handles the property registration by the owner.
It features searching the given property by address as well as unique id.
It also features ownership transfer of property from one person to another.
Modification of the plot availability i.e whether the owner currently wants to sale his property or not is also available and based on the input given by the owner, the buyers can view the available properties for sale.
Upon entering the property records by the owner, the details are pushed onto the blockchain and a transaction is recorded.
Currently, we can facilitate this access to 5 accounts given by the JavaScript VM and if running on ganache we can facilitate up to 10 accounts.
To further scale the application, we are proving facility of handling more than one property owned by the owner.

Solidity Code: LandSale.sol (in the folder)

Instructions for deployment on Remix ide:
1.	Copy the code from the LandSale.sol source file.
2.	Open https://remix.ethereum.org/
3.	Create a new contract named LandSale.sol
4.	Paste the source code into the development env.
5.	Select the compiler : “version:0.4.25+commit.59dbf8f1.Emscripten.clang”
6.	Press Ctrl+S to compile
7.	Select the run option
8.	Choose JavaScriptVM Environment
9.	Deploy the contract
10.	 In the contract, you can access various functions of the contract.
11.	 “createOwner”: To add new owner for the current address.
12.	 “addPlot”: To add the owners property
13.	“modifyProperty”: To change the availability status of property
14.	 “propertDetails”: To view the property details of the property choosen
15.	 On selecting different account, you can add another owner (In this case consider the owner is a buyer of a property)
16.	 He can select “propertyTransfer” function to purchase the property owned b another owner
17.	 He can view the properties available using getProperties function.
