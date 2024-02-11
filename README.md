# ERC404GasEfficient
Ideas around the new experimentations about Native Fractionned NFTs (ERC-20 and ERC-721 mix).

This repo contains the base [ERC404.sol)(src/ERC404/ERC404.sol) abstract contract, an experiment contract made by the "Pandora" team. This contract come from other previous ideas who hitted Ethereum mainnet.
One default was the large amount of gas processing when transferring tokens. It was because of the minting process of the NFTs consumming between 50k to 80k each. 
If you had to mint 100 NFTs after one buy on Uniswap you had to pay several millions in gas. That is not effective.

My idea is simple, I focused more in the flaw designed of the initial ERC404 instead of optimizing the gas.
The [ERC404GasEfficient](src/ERC404/ERC404GasEfficient.sol) child contrat override the [_transfer(address, address, uint256)](src/ERC404/ERC404GasEfficient.sol#L44) function and add few ones:

  - There is no minting process by default. If you happen to be eligible to mint NFTs, those are reserved for your address. When you want to mint, you just call the [mint(uint256)](src/ERC404/ERC404GasEfficient.sol#L34) function. The user then chose the quantity to mint and he has full control of the gas price he wants to pay (no gas war for minting).
  - By default, if you transfer your fungibles tokens and were eligible to mint NFTs, your reserved balance decrease. If you transfer more than your reserved balances, your NFTs balance decrease, burning them in the process. Since the burn mechanic does not consume a lot of gas, it's a reasonnable gas spend for most of the user base.
  - "minted" variable increase during minting process and decrease during burning process. It no longers tracks the total supply ever minted but the current supply of minted NFTs. I encourage teams who implement this to use generations of NFTs attributes only once, using randomness or not, avoiding users to mint and burn in a loop to generate favorable attributes for their NFTs. (_see this in [_burnBatch(address, uint256)](src/ERC404/ERC404GasEfficient.sol#L91)_
  - I encourage teams to still whitelist the pools contracts when they want to list the tokens. A whitelisted address won't add values to the [reserved NFTs counter](src/ERC404/ERC404GasEfficient.sol#L29). It might be better for a good user experience.

It is obvious that the [Your404Implementation.sol](src/Your404Implementation.sol) contract is just here as an example and should not be use as is.


**This repo is theorical, no _deep_ tests have been made.**
**USE AT YOUR OWN RISKS !**
