// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract Shared{

    event Action (string actionType);
    Status public status;
    address admin;
    enum Status {
        OPEN,
        RUNNING,
        END
    }
    modifier onlyOwner{
        require(msg.sender == admin, "Only owner can execute this function");
        _;
    }
    struct Item {
        uint256 id;
        string name;
        Status status;
        string description;
        address owner;
        string imageURI;
        bool completed;
        bool deleted;
        uint256 finalPrice;
    }

    struct SessionStruct{
        uint256 itemId;
        uint256 sessionId;
        Status status;
        bool deleted;
        bool existed;
        bool completed;
        address winner;
        uint256 NoOfParticipant;
    }
    mapping(uint256 => bool) sessionExists;
    mapping(uint => SessionStruct) sessionOf;
    mapping(uint => Iparticipant[]) participantList;
    mapping(uint=> Iparticipant) participantOf;
    mapping(uint256 => mapping(address=>uint256[])) bidList;
    mapping(int256 => mapping(address=>int256[])) bidListCal;
    mapping(uint256 => mapping(address => uint256)) bidAverages;
    
    SessionStruct[] sessions;
    struct Iparticipant{
        address participantWallet;
        bool isParticipate;
        uint256 NoOfSession;
        uint256 NoOfBids;
        uint256 deviation;
    }
   

}