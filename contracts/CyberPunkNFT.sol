// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
contract CyberPunkNFT is ERC721, Ownable{

    uint256 public mintPrice;
    uint256 public totalSupply;
    unit256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping(address => uint256) public walletMints;
    constructor() payable ERC721 ('CyberPunks', 'RP'){
        mintPrice = 0.2 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }
        //withdraw wallet
        
        function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner{
        
        isPublicMintEnabled = isPublicMintEnabled_;

    }
    
    function setBaseTokenUri(string calldata passTokenUri_) external onlyOwner{
    
    setBaseTokenUri = setBaseTokenUri_;

    }
    
    function tokenUri(uint256 tokenId_) public view oeverride returns (string memory){
    
    
    }





}