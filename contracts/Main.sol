// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./Session.sol";
import "./Shared.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";
contract Main is Shared{
   
    using Counters for Counters.Counter;
    Counters.Counter private _totalSessions;
    Counters.Counter private _totalItems;
    uint256 private capacity;
   
    // list of mapping based on sessionID
    mapping(uint => Item) items;
    mapping(uint => mapping(address => uint)) bidOf;
    mapping(uint => Iparticipant[]) totalParticipantsOf;
    mapping(uint => uint256[]) bids;
    mapping(uint => Iparticipant[]) sessionParticipants;
    
    constructor(){admin = msg.sender;}
    
    function createItem(
        string memory _name,
        string memory _description,
        string memory _imageURI
    ) public onlyOwner returns (Item memory){
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_imageURI).length > 0, "ImageURI cannot be empty");

        _totalItems.increment();
        uint256 itemId = _totalItems.current();
        Item memory item;
        item.id = itemId;
        item.name = _name;
        item.description = _description;
        item.owner = admin;
        item.imageURI = _imageURI;
        item.completed = false;
        items[itemId] = item;
        emit Action ("Create item successfully");
        return item;
    }

    function getItem(uint256 _itemId) public view returns(Item memory){
        require(_itemId > 0, "Item Id cannot be empty");
        return items[_itemId];
    }

    function updateItem(
        uint256 _itemId,
        string memory _name,
        string memory _description,
        string memory _imageURI
    ) public onlyOwner returns(Item memory){
        require(_itemId > 0, "Item Id cannot be empty");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_imageURI).length > 0, "ImageURI cannot be empty");
        items[_itemId].id = _itemId;
        items[_itemId].name = _name;
        items[_itemId].description = _description;
        items[_itemId].imageURI = _imageURI;
        items[_itemId].completed = false;
        emit Action ("Update Item successfully");
        return items[_itemId];

    }

    function deleteItem(uint256 _itemId) public onlyOwner {
        require(_itemId > 0, "Item Id cannot be empty");
        items[_itemId].deleted = true;
        emit Action("Item deleted successfully");
    }

    function completeItem(uint256 _itemId) public onlyOwner{
        require(_itemId > 0, "Item Id cannot be empty");
        items[_itemId].completed = true;
        emit Action("Item completed successfully");
    
    }

    function addSession(
        uint256 _itemId
    ) public onlyOwner returns(SessionStruct memory ){
        require(_itemId > 0, "Item Id cannot be empty");
        _totalSessions.increment();
        uint256 sessionId = _totalSessions.current();
        SessionStruct memory session;

        session.itemId = _itemId;
        session.sessionId = sessionId;
        session.status = Status.OPEN;
        session.existed = true;
        sessionOf[sessionId] = session;
        sessions.push(session);
        emit Action ("Add session successfully");
        
        return session;
    }
    function updateSession(
        uint256 _sessionId,
        Status _status
    ) public onlyOwner {
        require(_sessionId > 0, "Session Id cannot be empty");
        sessionOf[_sessionId].status = _status;
        emit Action ("Update session successfully");
    }

    function getSession(uint256 _sessionId) public view returns (SessionStruct memory){
        require(_sessionId > 0, "Session Id cannot be empty");
        return sessionOf[_sessionId];
    }

    function getAllSessions() public view returns (SessionStruct[] memory){
        return sessions;
    }
    function deleteSession(uint256 _sessionId) public onlyOwner{
       require(_sessionId > 0, "Session Id cannot be empty");
        sessionOf[_sessionId].deleted = true;
        sessionExists[_sessionId] = false;
        emit Action ("Delete session successfully");
    }
    function completeSession(uint256 _sessionId) public onlyOwner{
        require(_sessionId > 0, "Session Id cannot be empty");
        require(sessionExists[_sessionId], "Session not Exsists");
        sessionOf[_sessionId].status = Status.END;
        sessionOf[_sessionId].completed = true;
        emit Action ("Complete session successfully");
    }
    

}