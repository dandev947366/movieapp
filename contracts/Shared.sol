// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract Shared{

    event Action (string actionType);
    
    Status public status;
    enum Status {
        OPEN,
        RUNNING,
        END
    }


    struct SessionStruct{
        uint256 itemId;
        uint256 sessionId;
        Status status;
        bool deleted;
        bool existed;
        bool completed;
        uint256 NoOfParticipant;
    }
    mapping(uint256 => bool) sessionExists;
    mapping(uint => SessionStruct) sessionOf;
    mapping(uint => Iparticipant[]) participantList;
    mapping(uint=> Iparticipant) participantOf;
    mapping(uint256 => mapping(address=>uint256[])) bidList;
    SessionStruct[] sessions;
    struct Iparticipant{
        address participantWallet;
        bool isParticipate;
        uint256 NoOfSession;
        uint256 NoOfBids;
        uint256 deviation;
    }
   

}