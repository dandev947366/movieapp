pragma solidity ^0.4.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./Session.sol";
contract Main {

    using Counters for Counters.Counter;
    Counters.Counter private _totalSessions;
    uint256 private capacity;

    struct Iparticipant{
        address participant,
        bool isParticipate,
        uint256 NoOfSession,
        uint256 deviation
    }

    mapping(uint => mapping(uint => adress) bidding;
    mapping(uint => Iparticipant[]) totalParticipants;
    mapping(uint => address) participantOf;
    enum Status {
        OPEN
        RUNNING
        END
    }
    event Action {
        uint256 itemId,
        uint256 noOfParticipants,
        Status status,
        string message
    }
    


    function Main() public {
        admin = msg.sender;
    }

    
    // Add a Session Contract addrexss into Main Contract. Use to link Session with Main
    function addSession(address session) public {
        // TODO
        
        
        
        emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Add session successfully"
        }
        
    }
    function updateSession(address session) public {
        // TODO
        
        emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Update session successfully"
        }
    }
    function deleteSession(address session) public {
        // TODO
        
        
         emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Delete session successfully"
        }
    }
    function getSession(address session) public {
        // TODO
        
        
         emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Get session successfully"
        }
    }
    function getAllSessions(address session) public {
        // TODO
        
        
        emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Get all sessions successfully"
        }
    }
    function getSessionsByParticipant(address session) public {
        // TODO
        
        
        
        emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Get sessions by participant successfully"
        }
    }
    function getSessionsByStatusession(address session) public {
        // TODO
        
        
        
        
        
        emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Get sessions by status successfully"
        }
    }



}
