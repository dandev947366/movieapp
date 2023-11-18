// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./Main.sol";
import "./Shared.sol";
//Interface of Main contract to call from Session contract
// contract Main {
//     function addSession(address session) public {}
// }

contract Session is Shared, Main{
    // Variable to hold Main Contract Address when create new Session Contract
    //address public mainContract;
    // Variable to hold Main Contract instance to call functions from Main
    Main private mainContract;

    using Counters for Counters.Counter;
    Counters.Counter private _totalItem;
    Counters.Counter private _NoOfParticipant;
    Counters.Counter private _NoOfSession;
    // list of participants for one session
    //mapping(uint => address[]) sessionParticipants;

    constructor(
        address _mainContract
    ){
        //to call Daapcinema functions
        mainContract = Main(_mainContract);

    }
    // constructor(address _mainContract)public {
    //     // Get Main Contract instance
    //     mainContract = _mainContract;
    //     MainContract = Main(_mainContract);
    //     MainContract.addSession(address(this));
    // }
    //create new session contract
    // function Session(address _mainContract) public {
    //     // Get Main Contract instance
    //     mainContract = _mainContract;
    //     MainContract = Main(_mainContract);
        
    //     // TODO: Init Session contract
        
    //     // Call Main Contract function to link current contract.
    //     MainContract.addSession(address(this));
    // }
    // function joinSession(uint256 _sessionId) public returns(uint256){
    //     //require(sessionExists[_sessionId], "Session not Exists");
    //     sessionOf[_sessionId].NoOfParticipant ++;
    //     sessionOf[_sessionId].participantList.push(msg.sender);
    //     require(!sessions[_sessionId].completed, "Session completed");
    //     _NoOfParticipant.increment();
    //     Iparticipant memory participant;
    //     participant.participantWallet = msg.sender;
    //     participant.isParticipate = true;
    //     participant.NoOfSession++;
    //    // participants[_sessionId].push(participant);
    //     return _sessionId;
    //     //emit Action ("Join session successfully");
    // }
 struct SessionStruct{
        uint256 itemId;
        uint256 sessionId;
        address[] participantList;
        Status status;
        bool deleted;
        bool existed;
        bool completed;
        uint256 NoOfParticipant;
    }
    function joinSession(uint256 _sessionId) public returns(Iparticipant memory){

        Session memory session =. mainContract.getSession(_sessionId);
        require(session.NoOfParticipant < 10, "Maximum amount of participants reached.");
        require(!session.completed,"Session completed.");
        require(!session.deleted,"Session deleted.");
        require(!session.existed,"Session not exist.");
        
        Iparticipant memory joiner;
        joiner.participantWallet = msg.sender;
        joiner.isParticipate = true;
        joiner.NoOfSession += 1;
        participantOf[_sessionId] = joiner;
        sessionParticipants[_sessionId].push(joiner);

        emit Action ("Join session successfully");
        return joiner;

    }






    // function startBidding(unint256 _sessionId, uint256 _itemId, uint256 _amount) public returns(bool){
    //     require(itemExists[_id], "Item not found");
    //     require(sessionExists[sessionId], "Session not Exists");
    //     require(msg.value >= _amount, "Insufficient balance");
    //     require(bids[_itemId][_sessionId] <= 10, "Maximum participant reached");
        
    //     bids[_itemId][_sessionId].push(_amount);
        
    //     Iparticipant memory participant;
    //     participant[msg.sender].NoOfBids++;
        
    //     Session memory session;
    //     session[_sessionId].participantList.push(msg.sender);
    //     session[_sessionId].status = RUNNING;
        
    //     emit Action ("Bid item successfully");
    // }
    
    
}
