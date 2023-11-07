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
    
    function getTickets(uint256 _slotId) public returns (TicketStruct[] memory Ticket){
        uint256 available;
        for(uint i = 0; i <= _totalTickets.current(); i++{
            if(
            ticketBuild[i].ticket.slotId == _slotId && 
            !ticketBuild[i].ticket.refunded &&
            ) available++;
        }
        Tickets = new TicketStruct[](available);
        uint256 index;
        for(uint i = 0; i <= _totalTickets.current(); i++{
            if(
            ticketBuild[i].ticket.slotId == _slotId && 
            !ticketBuild[i].ticket.refunded &&
            ) Tickets[index++] = ticketBuild[i].ticket;
        }   
    }
    
    function getTicketHolder(uint256 _slotId) public returns (address[] memory Holders){
        uint256 available;
        for(uint i = 0; i <= _totalTickets.current(); i++{
            if(
            ticketBuild[i].ticket.slotId == _slotId && 
            !ticketBuild[i].ticket.refunded &&
            ) available++;
        }
        Holders = new address[](available);
        uint256 index;
        for(uint i = 0; i <= _totalTickets.current(); i++{
            if(
            ticketBuild[i].ticket.slotId == _slotId && 
            !ticketBuild[i].ticket.refunded &&
            ) Holders[index++] = ticketBuild[i].ticket.owner;
        }   
    }
    
    function withdrawTo(address to, uint256 amount) public onlyOwner {
        require(balance >= amount, "Insufficient fund");
        balance -= amount;
        payTo(to, amount);
    }
    
    function deleteTickets(uint256 _slotId) public onlyOwner {
        daapCinemas.deleteTimeSlot(_slotId);
        //Refund the money to the owners of tickets
        refundTicket(_slotId);
        emit Action("Tickets refunded");
    } 
    
    function completeTicket (uint256 _slotId) public onlyOwner {
        daapCinemas.deleteTimeSlot(_slotId);
        invalidateTickets(_slotId);
        emit Action("Tickets burnt");
    }
    
    
    function invalidateTickets() (uint256 _slotId) public onlyOwner { 
        require(daapCinemas.getTimeSlot(_slotId).id == _slotId, "Slot not found");
        for (uint i = 0; i < _totalTickets.current(); i++ ){
            if(
                ticketData.ticket.slotId = _slotId && 
                !ticketData.ticket.used
                )
                {
                ticketBuild[i].ticket.used = true;
                balance += ticketBuild[i].ticket.cost;
            }
        
        }
    
    }
    
    function refundTicket() (uint256 _slotId) public onlyOwner { 
        require(daapCinemas.getTimeSlot(_slotId).id == _slotId, "Slot not found");
        for (uint i = 0; i < _totalTickets.current(); i++ ){
            if(
                ticketData.ticket.slotId = _slotId && 
                !ticketData.ticket.used
                )
                {
                uint256 _tokenId = ticketBuild[i].ticket.id;
                uint256 amount = ticketBuild[i].ticket.cost;
                uint256 owner = ticketBuild[i].ticket.owner;
                
                ticketBuild[i].ticket.used = true;
                payTo(owner, amount);
                _burn(owner, _tokenID, 1);
            }
            
        
        }
    
    }
    
    function buyTickets(uint256 _slotId, uint256 _tickets) public payable returns(bool){
        TimeSlotStruct memory slot = daapCinemas.getTimSlot(_slotId);
        require(msg.value >= slot.ticketCost * _tickets, "Insufficient amount");
        require(slot.capacity >= slot.seats * _tickets, "Out of seating capacity");
        
        for(uint i = 0; i < _tickets; i ++) {
            _totalTickets.increment();
            TicketStruct memory ticket;
            ticket.id = _totalTickets.current();
            ticket.cost = slot.ticketCost;
            ticket.slotId = slot.id;
            ticket.owner = msg.sender;
            ticket.timestamp = currentTime();
            ticketHolders[_slotId].push(msg.sender);
        }
        
        slot.seat += _tickets;
        slot.balance += slot.ticketCost * _tickets;
        
        //mint nfts
        _mintBatch(_tickets);
        daapCinemas.setTimeSlot(slot);
        
        function mintBatch(uint256 _numOfTickets) internal {
        
            uint256[] memory ids = new uint256[](_numOfTickets);
            uint256[] memory amounts = new uint256[](_numOfTickets);
            uint256 _tokenId = _totalTickets.current() - _numOfTickets;
            
            for (uint i = 0; i < _numberOfTickets; i++){
                _tokenId++;
                string memory ticketNumber = Strings.toString(_tokenId);
                string memory ticketValue = string (
                    abi.encodePacked(symbol, " #", ticketNumber)
                );
                string memory description = "These NFTs are actually tickets for DaapCinemas.";
                ticketBuild[_tokenId].name = ticketValue;
                ticketBuild[_tokenId].description = description;
                ticketBuild[_tokenId].value = description;
                
                ticketBuild[_tokenId].bgHue = String.toString(randomNum(361, currentTime(), _tokenId));
                ticketBuild[_tokenId].textHue = String.toString(randomNum(361, block.timestamp, _tokenId));
                
                //uri() is a function came fro ERC1155
                _tokenURI[_tokenId] = uri(_tokenId);
                ids[i] = _tokenId;
                amounts[i] = 1;
            } 
            bytes memory defaultByteData = abi.encodePacked(ids, amounts);
            // msg.sender is the one who will hold all nft tokens
            _mintBatch(msg.sender, ids, amounts, defaultByteData);
            
        function uri(uint256 _tid) public view override returns (string memory) {
            return buildMetadata(_tid);
        }
            
        function buildImage(uint256 _tid) internal view returns (string memory){
                TicketBuildStruct memory ticket = ticketBuild[_tid];
                
                return 
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">',
                                '<rect height="500" width="500" fill="hsl(',
                                ticket.bgHue,
                                ', 50%, 25%)"/>'
                                '<text x="50%" y="50%" dominant-baseLine="middle" fill="hsl(',
                                ticket.textHue,
                                ', 100%, 80%)" text-anchor="middle" font-size="41">',
                                ticket.value,
                                '</text>',
                                '</svg>'
                                
                            )
                        )
                    );
            }
            
            function buildMetadata(uint256 _tid) internal view returns (string memory)  {
                TicketBuildStruct memory ticket = ticketBuild[_tid];
                
                return 
                    string(
                        abi.encodePacked(
                            "data: application/json;base64,",
                            Base64.encode(
                                bytes(
                                    abi.encodePacked(
                                        '{"name":"',
                                        ticket.name,
                                        '", "description":"',
                                        ticket.description,
                                        '", "image":"',
                                        "data:image/svg+xml;base64,",
                                        buildImage(ticket.id),
                                        '","attributes":[{"trait_type":"Background Hue", "value":"',
                                        ticket.bgHue,
                                        '"},{"trait_type":"Text Hue", "value":"',
                                        ticket.textHue,
                                        '"}]}'
                                        
                                    )
                                )
                            )
                            
                        
                        )
                    );
            }
            function randomNum(
                uint256 _mod, 
                uint256 _seed, 
                uint256 _salt
            ) internal view returns (uint256){
                uint256 num = uint256(
                    keccak256(
                        abi.encodePacked(block.timestamp, msg.sender, _seed, _salt)
                    )
                ) % _mod;   
                return num;
            }
        
        }
        
        
        
    
    }
    
    
   
   
   
   
   
   
   
   
   
   




}