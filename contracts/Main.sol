pragma solidity ^0.4.17;

contract Main {

    // Structure to hold details of Bidder
    struct IParticipant {
        address public participant,
        string public email,
        bool public isParticipate,
        uint public sessions,
        Item public items,
        double public deviation
    }
    mapping(uint => address) public myItem;
    struct Item {
        uint public id,
        string public name
    }
    
    address public admin;


    function Main() public {
        admin = msg.sender;
    }


    // Add a Session Contract address into Main Contract. Use to link Session with Main
    function addSession(address session) public {
        // TODO
    }

   function getSessions()public view returns (Sessions[] sessions){
   
   
   }


}
