// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Escrow is ReentrancyGuard{

   
    address public escAcc; //account of the platform
    uint public escBal; //balance of the Escrow acc
    uint public escAvailBal; //balance of transaction acc
    uint public escFee; //Escrow fee
    uint public totalItems;
    uint public totalConfirm;
    uint public totalDisputed;

    mapping(uint => ItemStruct) items; //default is private
    mapping(address => ItemStruct[]) itemsOf; //list of items belong to a seller
    mapping(address => mapping(uint => bool)) public requested; //nested mapping. item id that you are resquesting for, return true or false
    mapping(uint => address) public ownerOf; // paste in item id, return the owner of item
    mapping(uint => Available) public isAvailable; // check if item is available

            //index: 0   1
    enum Available {NO, YES}

    // status of item
    enum Status {
        OPEN,
        PENDING,
        DELIVERY,
        CONFIRMED,
        DISPUTED,
        REFUNDED,
        WITHDRAWED
    }

    struct ItemStruct {
        uint itemId;
        string purpose;
        uint amount;
        uint timestamp; //when item is created
        address owner;
        address buyer;
        bool provided; // is item sold or not
        Status status;
        bool confirmed;
    }

    event Action (
        uint itemId,
        string actiontype, //listed or not
        Status status,
        address indexed executor
    );

    constructor(uint _escFee){
        escAcc = msg.sender;
        escFee = _escFee;
    }


    //create Item
    function createItem (string memory purpose) public payable returns (bool){
        require(bytes(purpose).length > 0, "Purpose cannot be empty");
        require(msg.value > 0 ether, "Amount cannot be zero");

        uint itemId = totalItems++; //id of item is current total items
        ItemStruct storage item = items[itemId];
        item.itemId = itemId;
        item.purpose = purpose;
        item.amount = msg.value;
        item.timestamp = block.timestamp; //when item is created
        item.owner = msg.sender;
        item.status = Status.OPEN;
        itemsOf[msg.sender].push(item);
        ownerOf[itemId] = msg.sender;
        isAvailable[itemId] = Available.YES;

        emit Action (
            itemId,
            "ITEM CREATED",
            Status.OPEN, 
            msg.sender
        );
        return true;
    } 

    // get items
    //return all items with name: props
    function getItems() public view returns(ItemStruct[] memory props){
        props = new ItemStruct[](totalItems);
        for(uint i = 0; i < totalItems ; i++) {
            props[i] = items[i];
        }
    }

    function getItem(uint itemId) public view returns(ItemStruct memory){
        return items[itemId];
    }

    function myItems() public view returns (ItemStruct[] memory props){
        return itemsOf[msg.sender];
    }

    function requestItem(uint itemId) public returns (bool){
        require(msg.sender != ownerOf[itemId], "Must not be owner");
        require(isAvailable[itemId] == Available.YES, "Item not available");
        requested[msg.sender][itemId] = true;

        emit Action (
            itemId,
            "ITEM REQUESTED",
            Status.OPEN, 
            msg.sender
        );
        return true;
    }

    function approveRequest(uint itemId, address buyer) public returns (bool){
        require(msg.sender == ownerOf[itemId], "Only owner allowed");
        require(isAvailable[itemId] == Available.YES, "Item not available");
        require(requested[buyer][itemId], "Buyer not on the list");
        items[itemId].buyer = buyer;
        items[itemId].status = Status.PENDING;
        isAvailable[itemId] = Available.NO;

        emit Action (
            itemId,
            "ITEM APPROVED",
            Status.PENDING, 
            msg.sender
        );

        return true;

    }

    function performDevliery(uint itemId) public returns(bool) {
        require(msg.sender == items[itemId].buyer, "You are not the approved buyer");
        require(items[itemId].provided 



    }














}