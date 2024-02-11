# ERC404GasEfficient
Ideas around the new experimentations about Native Fractionned NFTs (ERC-20 and ERC-721 mix).

This repo contains the base ERC404.sol abstract contract, an experiment idea made by the "Pandora" team. This contract come from other previous ideas who hitted Ethereum mainnet.
One default was the large amount of gas processing when transferring tokens. It was because of the minting process of the NFTs consumming between 50k to 80k each. 
If you had to mint 100 NFTs after one buy on Uniswap you had to pay several millions in gas. That is not effective.

My idea is simple, I focused more of the flaw designed of the initial ERC404 instead of optimizing the gas.
The "ERC404GasEfficient" child contrat override the "_transfer(address, address, uint256)" function: 

  - There is no minting process by default. If you happen to be eligible to mint NFTs, those are reserved for your address. When you want to mint, you just call the "mint(uint256) function.
  - By default, if you transfer your fungibles tokens and were eligible to mint NFTs, your reserved balance decrease. If you transfer more than your reserved balances, your NFTs balance decrease, burning them in the process. Since the burn mechanic does not consume a lot of gas, it's a reasonnable gas spend for most of the user base.
  - "minted" variable increase during minting process and decrease during burning process. It no longers tracks the total supply ever minted but the current supply of minted NFTs. I encourage teams who implement this to use generations of NFTs attributes only once, using randomness or not, avoiding users to mint and burn in a loop to generate favorable attributes for their NFTs. 