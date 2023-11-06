// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "./DaapShared.sol";
import "./DaapCinema.sol";
import "./base64.sol";

//can call TimeSlotStruct from DaapShared 
contract DaapTickets is AccessControl, DaapShared, DaapCinema, ERC1155, ERC115Burnable{

    using Counters for Counters.Counter;
    Counters.Counter private _totalTickets;
    
    //to get all instances of DaapCinema
    DaapCinema private daapCinema;
    
    struct TicketStruct {
        uint256 id;
        uint256 movieId;
        uint256 slotId;
        address owner;
        uint256 cost;
        uint256 timestamp;
        uint256 day;
        bool used;
        bool refunded;
    }
    
    
   
   
   
   
   
   
   
   
   
   




}