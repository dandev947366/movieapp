// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contract/utils/Couters.sol";
import "@openzeppelin/contract/token/ERC721/ERC721.sol";
import "@openzeppelin/contract/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contract/security/ReentrancyGuard.sol";

contract Auction is ERC721URIStorage, ReentrancyGuard {

    using Counter for Counter.Counter;
    Counter.Counter private totalItems;
    
    //variables are private by default
    uint public royaltyFee;
    address public companyAcc;
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
    
    event AuctionItemCreated(
        uint indexed tokenId,
        address seller,
        address owner,
        uint price,
        bool sold
    );
    
    mapping(uint => AuctionStruct) auctionedItem;
    mapping(uint => bool) auctionedItemExist;
    mapping(uint => BidderStruct[]) biddersOf;
    
    constructor (uint _royaltyFee) ERC721("Sometoken", "STO"){
    
        royaltyFee =  ;
        companyAcc = msg.sender;
        
    }
        
        function mintToken(string memory tokenURI) internal returns (bool){
            totalItems.increment();
            uint tokenId = totalItems.current();
            _mint(msg.sender, tokenId);
            _setTokenURI(tokenId, tokenURI);
            return true;
        }
         
        function createAuction(
            string memory name,
            string memory description,
            string memory image,
            string memory tokenURI,
            uint price
        ) public payable nonReentrant {
            require(price > 0 ether, "Sale price must be greater than zero");
            require(msg.value >= listingPrice, "Price must be greater than the listing price");
            require(mintToken(tokenURI),"Could not mint token");
            require(bytes(name).length > 0, "Name cannot be empty");
            require(bytes(description).length > 0, "Description cannot be empty");
            require(bytes(image).length > 0, "Image cannot be empty");
            require(bytes(tokenURI).length > 0, "TokenURI cannot be empty");
            
            
            uint tokenId = totalItems.current(); 
            
            AuctionStruct memory item;
            item.tokenId = tokenId;
            item.name = name;
            item.description = description;
            item.image = image;
            item.tokenURI = tokenURI;
            item.price = price;
            item.duration = getTimestamp();
            item.seller = msg.sender;
            item.owner = msg.sender;
            
            auctionedItem[tokenId] = item;
            auctionedItemExist[tokenId] = true;
            
            payTo(companyAcc, msg.value);
            
            emit AuctionItemCreated(
                tokenId,
                msg.sender,
                address(0),
                price,
                false
            );
        }
        
        function offerAuction (
            uint tokenId,
            bool biddable,
            uint sec,
            uint min,
            uint hour,
            uint day
        )public{
            require(auctionedItem[tokenId].owner == msg.sender, "Unauthorized entity");
            require(auctionedItem[tokenId].bid == 0, "Winner should claim price first");
            
            if(!auctionedItem[tokenId].live){
                setApprovalForAll(address(this), true);
                IERC721(address(this)).transferFrom(
                    msg.sender,
                    address(this),
                    tokenId
                );
            }
            
            auctionedItem[tokenId].bid = 0;
            auctionedItem[tokenId].live = true;
            auctionedItem[tokenId].sold = false;
            auctionedItem[tokenId].biddable = biddable; //true?
            auctionedItem[tokenId].duration = getTimestamp(sec, min, hour, day);
        }
        
        function buyAuctionedItem(uint tokenId) public payable nonReentrant(){
            
            require(msg.value >= auctionedItem[tokenId].price, "Unsufficient balance");
            require(auctionedItem[tokenId].duration > getTimestamp(0,0,0,0), "Auctioned Item not available");
            require(!auctionedItem[tokenId].biddable, "Auction must not be biddable");
            address seller = AuctionedItem[tokenId].seller;
            address owner = AuctionedItem[tokenId].owner;
        
            uint royalty = (msg.value * royaltyFee) / 100;
            payTo(owner, (msg.value - royalty));
            payTo(seller, royalty);
            
            IERC721(address(this)).transferFrom(
                address(this),
                msg.sender,
                tokenId
            );
            
            AuctionedItem[tokenId].live = false;
            AuctionedItem[tokenId].sold = true;
            AuctionedItem[tokenId].bid = 0;
            AuctionedItem[tokenId].owner = msg.sender;
            AuctionedItem[tokenId].duration = getTimestamp(0,0,0,0);
        
        }
        
        function placeBid(uint tokenId, uint amount) public {
            require(msg.value >= auctionedItem[tokenId].price, "Unsufficient balance");
            require(auctionedItem[tokenId].duration > getTimestamp(0,0,0,0), "Auctioned Item not available");
            require(auctionedItem[tokenId].biddable, "Auction must be biddable");
            
            BiddableStruct memory bidder;
            bidder.bidder = msg.sender;
            bidder.price msg.value;
            bidder.timestamp = getTimestamp(0,0,0,0);
            
            //create mapping to hold bidders of this token
            //line 52
            biddersOf[tokenId].push(bidder);
            //increase number of bids by 1
            auctionedItem[tokenId].bids++;
            //increase price of token
            auctionedItem[tokenId].price += msg.value;
            //set current winner of highest bidder
            auctionedItem[tokenId].winner += msg.sender;
        }
        
        function claimPrice(uint tokenId, uint bid)public nonReentrant(){
            //the token is still live
            require(getTimestamp(0,0,0,0) > auctionedItem[tokenId].duration, "Auction still live");
            //winner is msg.sender
            require(auctionedItem[tokenId].winner == msg.sender, "You are not the winner");
            //array of bidders of this token
            //get that specific bidder
            //set it to true
            biddersOf[tokenId][bid].won = true;
            uint price = auctionedItem[tokenId].price;
            //get royalty to pay for marketplace
            uint royalty = (price * royaltyFee) / 100;
            //seller is the original creator of this token
            address seller = auctionedItem[tokenId].seller;
            //owner if the winner now
            address owner = auctionedItem[tokenId].owner;
            
            //pay owner of token
            payTo(owner, (price - royalty));
            //pay marketplace royalty fee
            payTo(seller, royalty);
            
            //transfer token
            IERC721(address(this)).transferFrom(
                //transfer from this smart contract address
                address(this),
                //to winner
                msg.sender,
                //token id
                tokenId
            );
            //refund to rest of bidders
            performRefund(tokenId);
            
            //set winner , live, sold, bid, duration, owner
            auctionedItem[tokenId].winner = address(0);
            auctionedItem[tokenId].live = false;
            auctionedItem[tokenId].sold = true;
            auctionedItem[tokenId].bid = 0;
            auctionedItem[tokenId].owner = msg.sender;
            auctionedItem[tokenId].duration = getTimestamp(0,0,0,0);
        }
        
        function perfomRefund(uint tokenId) internal {
            //loop through list of bidders
            //except winner
            for (uint i = 0; i < biddersOf[tokenId].length; i++){
                address bidder = biddersOf[tokenId][i];
                //show address of bidder
                //performRefund is called withing claimPrize
                //so msg.sender is the same
                //now exclude the winner from refund 
                //bc he/she has claimed prize already
                if(bidder.bidder != msg.sender){
                    //set refunded to true
                    bidder.refunded = true;
                    //send back what bidder has bidded
                    payTo(bidder.bidder, bidder.price);
                } else {
                    bidder.won = true;
                }
                bidder.timestamp = getTimestamp(0,0,0,0);
            }
            //delete bidders of this token Id
            //so they can get refund again
            delete biddersOf[tokenId];
        }
        
        function changePrice(uint tokenId, uint price) public {
            require(msg.value >= auctionedItem[tokenId].price, "Unsufficient balance");
            require(auctionedItem[tokenId].duration > getTimestamp(0,0,0,0), "Auctioned Item not available");
            require(price > 0, "Price must be greater than zero);
     
            auctionedItem[tokenId].price = price;
        }
        
        function setListingPrice(uint price) public {
            require(msg.sender == companyAcc, "Unauthorized entity);
            listingPrice = price;
        }
        
        function getListingPrice() public view returns(uint){
            return listingPrice;
        }
                
        function getAuction(uint tokenId) public view returns (AuctionStruct memory){
            return auctionedItem[tokenId];
        }
        
        function getUnsoldAuctions() public view returns (AuctionStruct memory){
            uint totalSpace;
            for(uint i = 0; i < Auctions.length; i++){
                if(!auctionedItem[i+1].sold) totalSpace++;
            }
            Auctions = new AuctionStruct[](totalSpace);
            
            uint index;
            for(uint i = 0; i < Auctions.length; i++){
            //if item is not sold
            //increament index
                if(!auctionedItem[i+1].sold) {
                    Auctions[index] = new auctionedItem[i+1];
                    index++;
                };
            }
            
            
        }
        function getAuctions() public view returns (AuctionStruct[] memory Auctions){
            Auctions = new AuctionStruct[](totalItems.current());
            for(uint i = 0; i < Auctions.length; i++){
                Auctions[i] = auctionedItem[i+1];
            }
        }
        
        function getSoldAuctions() public view returns (AuctionStruct memory){
            uint totalSpace;
            for(uint i = 0; i < Auctions.length; i++){
            //check if item is sold
                if(auctionedItem[i+1].sold) totalSpace++;
            }
            Auctions = new AuctionStruct[](totalSpace);
            
            uint index;
            for(uint i = 0; i < Auctions.length; i++){
            //if item is not sold
            //increament index
                if(auctionedItem[i+1].sold) {
                    Auctions[index] = new auctionedItem[i+1];
                    index++;
                };
            }
            
            
        }
        
        function getMyAuctions() public view returns (AuctionStruct memory){
            uint totalSpace;
            for(uint i = 0; i < Auctions.length; i++){
                //check duration for live auction
                if(uctionedItem[i+1].duration > getTimestamp(0,0,0,0)) totalSpace++;
            }
            Auctions = new AuctionStruct[](totalSpace);
            
            uint index;
            for(uint i = 0; i < Auctions.length; i++){
            //check duration for live auction
                if(auctionedItem[i+1].duration > getTimestamp(0,0,0,0)) {
                    Auctions[index] = new auctionedItem[i+1];
                    index++;
                };
            }
            
            
        }
        
        function getBidders(uint tokenId) public view returns (BiddableStruct[] memory){
            return biddersOf[tokenId];
        }

        function getTimestamp(
            uint sec,
            uint min,
            uint hour, 
            uint day
        ) internal returns (uint){
            return block.timestamp + 
                   (1 seconds * sec) +
                   (1 minutes * min) +
                   (1 hours * hour) +
                   (1 days * day);
  
        }
        
        function payTo(address to, uint amount) internal {
        
            (bool success, ) = payable(to).call{value: amount}("");
            require(success);
        
        }
    
}
    
        











}