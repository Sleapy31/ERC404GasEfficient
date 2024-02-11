//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC404/ERC404GasEfficient.sol";

contract Your404Implementation is ERC404GasEfficient {
    string public dataURI;
    string public baseTokenURI;

    constructor(
        address _owner, bool _isOwnerWhitelist
    ) ERC404("Test", "TEST", 18, 10000, _owner) {
        balanceOf[_owner] = 10000 * 10 ** 18;
        if (_isOwnerWhitelist) setWhitelist(_owner, true);
        else{
            reservedNftsPerOwner[_owner] += 10000;
            reservedCount += 10000;
        }
    }

    function setDataURI(string memory _dataURI) public onlyOwner {
        dataURI = _dataURI;
    }

    function setTokenURI(string memory _tokenURI) public onlyOwner {
        baseTokenURI = _tokenURI;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        // Your implementation
    }
    
}
