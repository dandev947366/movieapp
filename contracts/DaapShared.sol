// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract DaapShared is Ownable{

    struct TimeSlotStruct {
        uint256 id;
        uint256 movieId;
        uint256 ticketCost;
        uint256 startTime;
        uint256 endTime;
        uint256 capacity;
        uint256 seats;
        bool deleted;
        bool completed;
        uint256 day;
        uint256 balance;
    }
    event Action (string actionType);
    
    //modief version of block.timestamp
    //block.timestamp return only 10 digit number
    //but javascript has 13 digits
    //so we make 13 digits
    function currentTime() interal view returns(uint256){
        return (block.timestamp * 1000) +1000;
     }

}