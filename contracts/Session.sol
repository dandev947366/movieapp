pragma solidity ^0.4.17;


import "@openzeppelin/contracts/utils/Counters.sol";
import "./Main.sol";
// Interface of Main contract to call from Session contract
contract Main {
    function addSession(address session) public {}
}

contract Session {
    // Variable to hold Main Contract Address when create new Session Contract
    address public mainContract;
    // Variable to hold Main Contract instance to call functions from Main
    Main private MainContract;

    using Counters for Counters.Counter;
    Counters.Counter private _totalItem;
    Counters.Counter private _NoOfParticipant;
    
    struct Session{
        address contractAddress,
        uint256 id,
        uint256 itemId,
        Iparticipant[] participantList,
        Status status,
        bool deleted,
        bool completed
    }
    //create new session contract
    function Session(address _mainContract
        mainContract = _mainContract;
    ) public {
        // Get Main Contract instance
        mainContract = _mainContract;
        MainContract = Main(_mainContract);
        
        // TODO: Init Session contract
        
        // Call Main Contract function to link current contract.
        MainContract.addSession(address(this));
    }
    
    function joinSession(unint256 _sessionId) public returns(bool){
        require(sessionExists[sessionId], "Session not Exists");
        require(!sessions[_sessionId].completed, "Session completed");
        _NoOfParticipant++;
        Iparticipant memory participant;
        participant[msg.sender].participantWallet = msg.sender;
        participant[msg.sender].isParticipate = true;
        participant[msg.sender].NoOfSession++;
        
        emit Action ("Join session successfully");
    }

    function startBidding(unint256 _sessionId, uint256 _itemId, uint256 _amount) public returns(bool){
        require(itemExists[_id], "Item not found");
        require(sessionExists[sessionId], "Session not Exists");
        require(msg.value >= _amount, "Insufficient balance");
        require(bids[_itemId][_sessionId] <= 10, "Maximum participant reached");
        
        bids[_itemId][_sessionId].push(_amount)
        
        Iparticipant memory participant;
        participant[msg.sender].NoOfBids++;
        
        Session memory session;
        session[_sessionId].participantList.push(msg.sender);
        session[_sessionId].status = RUNNING;
        
        emit Action ("Bid item successfully");
    }
    
    
}
