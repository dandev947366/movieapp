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
    
    //metadata structure
    
    struct TicketBuildStruct {
        string name;
        string description;
        string bgHue;
        string textHue;
        string value;
        TicketStruct ticket;
    }
    
    uint256 public balance;
    // name and symbol are not defined
    // in ERC1155 
    // so we need to declare them
    uint256 public name;
    uint256 public symbol;
    
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => TicketBuildStruct) public ticketBuild;
    // all holders (address type) of this 
    // particular slot (uint type)
    mapping(uint256 => address[]) ticketHolders;
    
    constructor(
        address _daapCinemas,
        string memory _name,
        string memory _symbol
    ){
        //to call Daapcinema functions
        daapCinema = DaapCinema(_daapCinemas);
        name = _name;
        symbol = _symbol;
    }
    
    
    
    
   
   
   
   
   
   
   
   
   
   




}