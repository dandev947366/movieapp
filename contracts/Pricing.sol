// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contract/utils/Couters.sol";
import "@openzeppelin/contract/token/ERC721/ERC721.sol";
import "@openzeppelin/contract/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contract/security/ReentrancyGuard.sol";

contract Pricing is ERC721URIStorage, ReentrancyGuard {
    
    using Counter for Counter.Counter;
    Counter.Counter private totalItems;
    
   
    address public sessionContract;
    uint listingPrice = 0.02 ether;
    
    AuctionStruct {
        string name;
        string description;
        string image;
        string tokenId;
        uint price;
        address seller;
        address owner;
        address winner;
        bool live;
        bool biddable;
        uint bids;
        uint duration;
    }
    
    BiddableStruct{
    
        address bidder;
        uint price;
        uint timestamp;
        bool refunded;
        bool won;
    }
    
    
    
    
    
    
    
    
    
}