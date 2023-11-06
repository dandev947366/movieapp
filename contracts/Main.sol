pragma solidity ^0.4.17;

contract Main {

    // Structure to hold details of Bidder
    struct IParticipant {
        address participant,
        bool isParticipate,
        uint sessions,
        Item items,
        double deviation
    }
    mapping(uint => address) public item;
    mapping(address => Item[]) public ownerOf;
    struct Item {
        uint256 id,
        string name,
        address owner,
        uint256 _tokenId,
        uint256 initialPrice,
        address previousBidder,
        uint256 lastBid,
        address lastBidder,
        uint256 startTime,
        uint256 endTime,
        bool completed,
        bool active,
        uint256 auctionId
    }
    
    address public admin;
    mapping(uint => IParticipant[]) public participantList;
    
    

    function Main() public {
        admin = msg.sender;
    }

    
    // Add a Session Contract addrexss into Main Contract. Use to link Session with Main
    function addSession(address session) public {
        // TODO
    }

   function getSessions()public view returns (Sessions[] sessions){
   
   
   }


}
