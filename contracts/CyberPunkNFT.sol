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
    
    require(_exists(tokenId_), 'Token does not exist');
    return string(abi.encodePacked(baseTokenUri, String.toString(tokenId_),".json"));
    }
    
    function withdraw() external onlyOwner{
    (bool success,) = withdrawWallet.call{value: address(this).balance}('');
    require(success, 'withdraw failed');
    }
   function mint(uint256 quantity_) public payable {
    require(isPublicMintEnabled, 'minting not enabled');
    require(msg.value == quantity(_ * mintPrice, 'wrong int value');
    require(totalSupply + quantity_ <= maxSupply, 'sold out');
    require(walletmint(msg.sender) + quantity_ <= maxWallet, 'exceed max wallet');
    
    for(uint256 i = 0; i< quantity_ ; i++){
    
        uint256 newTokenId = totalSupply +1;
        totalSupply ++;
        _safeMint(msg.senfer, newTokenId);
    }
}



}