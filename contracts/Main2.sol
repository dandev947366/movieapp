// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./Session.sol";
import "./Shared.sol";
//import "@openzeppelin/contracts/access/AccessControl.sol";
contract Main is Shared, Session{
   
    using Counters for Counters.Counter;
    Counters.Counter private _totalSessions;
    Counters.Counter private _totalItems;
    uint256 private capacity;
    address admin;
    //bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    struct Item {
        uint256 id;
        string name;
        string description;
        address owner;
        string imageURI;
        bool completed;
        bool deleted;
        uint256 initialPrice;
        uint256 finalPrice;
    }
    // list of items based on sessionID
    mapping(uint => Item) items;
    // sessionStruct with unique ID
    //mapping(uint => Session) sessions;
    // amount of bid from participant's address, for session ID
    mapping(uint => mapping(address => uint)) bidOf;
    // list of participants based on session ID
    mapping(uint => Iparticipant[]) totalParticipantsOf;
    // participant's address of session ID
    mapping(uint => address) participantOf;
    // Session ID, check if session is exists
    mapping(uint256 => bool) sessionExists;
    // Item ID, check if item is exists
    mapping(uint256 => bool) itemExists;
    // array of bids , based on session ID
    mapping(uint => uint256[]) bids;
    
    
    modifier onlyOwner{
        require(msg.sender == admin, "Only owner can execute this function");
        _;
    }
   
    constructor(){admin = msg.sender;}
    //function Main() public {admin = msg.sender;}
    
    // Add a Session Contract address into Main Contract. Use to link Session with Main
    function createItem(
        string memory _name,
        string memory _description,
        string memory _imageURI,
        uint256 _initialPrice
    ) public onlyOwner returns (Item memory){
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_imageURI).length > 0, "ImageURI cannot be empty");
        //require(_initialPrice > 0, "Initial price cannot be empty");
        _totalItems.increment();
        uint256 itemId = _totalItems.current();
        Item memory item;
        item.id = itemId;
        item.name = _name;
        item.description = _description;
        item.owner = admin;
        item.imageURI = _imageURI;
        item.completed = false;
        item.initialPrice = _initialPrice;
        items[itemId] = item;
        itemExists[_totalItems.current()] = true;
        emit Action ("Create item successfully");
        return item;
    }

    function getItem(uint256 itemId) public view returns(Item memory){
        return items[itemId];
    }

    function updateItem(
        uint256 _itemId,
        string memory _name,
        string memory _description,
        string memory _imageURI,
        uint256 _initialPrice
    ) public onlyOwner returns(Item memory){
        require(_itemId > 0, "Id cannot be empty");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_imageURI).length > 0, "ImageURI cannot be empty");
        require(_initialPrice > 0, "Price cannot be empty");
        items[_itemId].id = _itemId;
        items[_itemId].name = _name;
        items[_itemId].description = _description;
        items[_itemId].imageURI = _imageURI;
        items[_itemId].initialPrice = _initialPrice;
        //items[_itemId].owner = admin;
        items[_itemId].completed = false;
        //itemExists[_itemId] = true;
        emit Action ("Update Item successfully");
        return items[_itemId];

    }

    function deleteItem(uint256 _itemId) public {
        require(itemExists[_itemId], "Item not found");
        //require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a session contract");
        
        items[_itemId].deleted = true;
        itemExists[_itemId] = false;
        emit Action("Item deleted successfully");
    }

    function completeItem(uint256 _id) public {
        //require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a session contract");
        
        items[_id].completed = true;
        emit Action("Item completed successfully");
    
    }

    function addSession(
        address _sessionContract,
        uint256 _sessionId
    ) public onlyOwner returns(SessionStruct memory){
        require(_sessionId > 0, "Item ID cannot be empty");
        _totalSessions.increment();
        SessionStruct memory session;
        session.contractAddress = _sessionContract;
        session.sessionId = _sessionId;
        session.status = Status.OPEN;
        sessionExists[_totalSessions.current()] = true;
        sessionOf[_sessionId] = session;
        sessionExists[_sessionId] = true;
        sessions.push(session);
        emit Action ("Add session successfully");
        return session;
        
    }
    function updateSession(
        uint256 _sessionId,
        Status _status
    ) public onlyOwner {
        require(sessionExists[_sessionId], "Session not found");
        sessionOf[_sessionId].status = _status;
        emit Action ("Update session successfully");
    }

    function getSession(uint256 _sessionId) public view returns (SessionStruct memory){
        return sessionOf[_sessionId];
    }

    function getAllSessions() public view returns (SessionStruct[] memory){
        return sessions;
    }
    function deleteSession(uint256 _sessionId) public onlyOwner{
        require(sessionExists[_sessionId], "Session not Exsists");
        
        sessionOf[_sessionId].deleted = true;
        sessionExists[_sessionId] = false;
        emit Action ("Delete session successfully");
    }
    function completeSession(uint256 _sessionId) public onlyOwner{
        require(sessionExists[_sessionId], "Session not Exsists");
        
        sessionOf[_sessionId].completed = true;
        emit Action ("Complete session successfully");
    }
    

}