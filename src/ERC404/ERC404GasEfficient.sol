//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC404.sol";

abstract contract ERC404GasEfficient is ERC404{
    // Events
    event PreMintAdded(
        address indexed owner,
        uint256 quantity
    );
    event PreMintRemoved(
        address indexed owner,
        uint256 quantity
    );

    // Errors
    error UnsafeArithmetic();
    error InsufficientTokensReserved();

    // Modifiers
    modifier isSufficientReservedTokens(address from, uint256 quantity) virtual {
        if (reservedNftsPerOwner[from] < quantity) 
            revert InsufficientTokensReserved();
        _;
    }

    /// @dev Current reserved NFT counter, all the tokens awaiting to be minted.
    uint256 public reservedCount;

    /// @dev Number of reserved NFTs for a given owner
    mapping(address => uint256) public reservedNftsPerOwner;

    function mint(uint256 quantity) public isSufficientReservedTokens(msg.sender, quantity) returns (bool){
        for (uint256 i = 0; i < quantity; i++){
            _mint(msg.sender);
        }
        reservedNftsPerOwner[msg.sender] -= quantity;
        reservedCount -= quantity;

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override returns (bool) {
        uint256 unit = _getUnit();
        uint256 balanceBeforeSender = balanceOf[from];
        uint256 balanceBeforeReceiver = balanceOf[to];

        balanceOf[from] -= amount;

        unchecked {
            balanceOf[to] += amount;
        }

        // Skip burn for certain addresses to save gas
        if (!whitelist[from]) {
            uint256 tokens_to_burn = (balanceBeforeSender / unit) -
                (balanceOf[from] / unit);
            
            _burnBatch(from, tokens_to_burn);
            
        }

        // Skip minting for certain addresses to save gas
        if (!whitelist[to]) {
            uint256 tokens_to_mint = (balanceOf[to] / unit) -
                (balanceBeforeReceiver / unit); 

            _premint(to, tokens_to_mint);
            
        }

        emit ERC20Transfer(from, to, amount);
        return true;
    }

        function _premint(address to, uint256 ids) internal virtual {
        if (to == address(0)) {
            revert InvalidRecipient();
        }
        reservedNftsPerOwner[to] += ids;
        reservedCount += ids;

        emit PreMintAdded(to, ids);
    }

    function _burnBatch(address from, uint256 itterations) internal {
        uint256 reservedTokens = reservedNftsPerOwner[from] < itterations ? reservedNftsPerOwner[from] : itterations; 
        uint256 mintedTokens = itterations - reservedTokens;
        if (mintedTokens + reservedTokens != itterations)
            revert UnsafeArithmetic();

        if (reservedTokens > 0){
            reservedNftsPerOwner[from] -= reservedTokens;
            reservedCount -= reservedTokens;
            emit PreMintRemoved(from, reservedTokens);
        }

        for (uint256 i = 0; i < mintedTokens; i++){
            _burn(from);            
        }
        minted -= mintedTokens;

        
    }
    
}