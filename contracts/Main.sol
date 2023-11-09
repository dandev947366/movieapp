pragma solidity ^0.4.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Session.sol";
contract Main is AccessControl {

    using Counters for Counters.Counter;
    Counters.Counter private _totalSessions;
    Counters.Counter private _totalItems;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    uint256 private capacity;

    struct Iparticipant{
        address participantWallet,
        bool isParticipate,
        uint256 NoOfSession,
        uint256 NoOfBids,
        uint256 deviation
    }
    
    struct Item {
        uint256 id,
        string name,
        string description,
        address owner,
        string imageURI,
        bool completed,
        uint256 initialPrice,
        uint256 finalPrice
    }
    mapping(uint => Item) items;
    mapping(uint => Session) sessions;
    mapping(uint => mapping(uint => adress) bidding;
    mapping(uint => Iparticipant[]) totalParticipants;
    mapping(uint => address) participantOf;
    mapping(uint256 => bool) sessionExists;
    mapping(uint256 => bool) itemExists;
    
    mapping(uint => mapping(uint => uint256[]) bids;
    
    enum Status {
        OPEN
        RUNNING
        END
    }
    event Action {
        uint256 itemId,
        uint256 noOfParticipants,
        Status status,
        string message
    }

    function Main() public {
        admin = msg.sender;
    }

    
    // Add a Session Contract addrexss into Main Contract. Use to link Session with Main
    function createItem(
        string memory _name,
        string memory _description,
        string memory _imageURI,
        uint256 _initialPrice
    ) public onlyOwner returns (Item memory){
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_imageURI).length > 0, "ImageURI cannot be empty");
        require(_initialPrice > 0, "Initial price cannot be empty");
        _totalItems.increment();
        Item memory item;
        item.id = _totalItems.current();
        item.name = _name;
        item.description = _description;
        item.owner = admin;
        item.imageURI = _imageURI;
        item.initialPrice = __initialPrice;
        itemExists[_totalItems.current()] = true;
        items.push(item);
        emit Action {"Create item successfully"};
    }
    
    function addSession(
        address _session
    ) public onlyOwner returns(Session memory){
        require(_itemId > 0, "Item ID cannot be empty");
        require(bytes(_session).length > 0, "Session address cannot be empty");
        
        address sessionContract = _sessionContract;
        _totalSessions.increment();
        
        Session memory session;
        session.contractAddress = _session;
        session.id = _totalSessions.current();
        session.itemId = _itemId;
        session.participant = Iparticipant[](10);
        session.status = status.OPEN;
        sessionExists[_totalSessions] = true;
        sessions.push(session);
        
        emit Action {
            sessionId,
            noOfParticipants,
            status,
            "Add session successfully"
        }
        
    }
    
    function updateSession(
        uint256 _id,
        Status status,
        bool completed
        bool deleted,

    ) public onlyOnwer returns (bool){
        require(sessionExists[_id], "Session not found");
        require(bytes(status).length > 0, "Status cannot be empty");
        
        sessions[_id].id = id;
        sessions[_id].status = status;
        sessions[_id].completed = completed;
        sessions[_id].deleted = ideleted;
        emit Action {"Update session successfully"}
    }
    function deleteSession(uint256 sessionId) public onlyOwner{
        require(sessionExists[sessionId], "Session not Exsists");
        
        sessions[sessionId].deleted = true;
        sessionExists[sessionId] = false;
        emit Action {"Delete session successfully"}
    }
    function getSession(uint256 sessionId) public view returns(Session memory) {
        return sessions[sessionId];
    }
    function getAllSessions() public view returns (Item[] memory){
        uint256 available;
        
        for(uint256 i = 1; i <= _totalSessions.current(); i++){
            if(!sessions[i].deleted] available++;
        }
       
        Session = new Session[](available);
        
        uint256 index; 
        for(uint256 i = 1; i <= _totalMovies.current(); i++){
           
            if(!sessions[i].deleted) Session[index++] = sessions[i];
        }
        
    }
    function closeSession(uint256 _sessionId) public onlyOwner returns(bool){
        require(sessionExists[sessionId], "Session not Exsists");
        require(!sessions[sessionId].completed, "Session completed");
        
        Session memory session;
        session[_sessionId].completed = true;
    
    }
    
    function getItem(uint256 itemId) public view returns(Item memory){
        return items[itemId];
    }
    
    function updateItem(
        uint256 _id,
        string memory _name,
        string memory _description,
        string memory _imageURI,
        uint256 _initialPrice,
    ) public onlyOwner returns(bool){
        require(_id > 0, "Id cannot be empty");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_imageURI).length > 0, "ImageURI cannot be empty");
        require(_initialPrice > 0, "Price cannot be empty"));
        items[id].id = _id;
        items[id].name = _name;
        items[id].description = _description;
        items[id].imageURI = _imageURIid;
        items[id] = _id;
        items[id].initialPrice = _initialPrice;
        emit Action {"Update Item successfully"};
        
    }
    
    function deleteItem(uint256 _id) public returns(bool){
        require(itemExists[_id], "Item not found");
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a session contract");
        
        items[_id].deleted = true;
        itemExists[_id] = false;
        
        emit Action("Item deleted successfully");
    
    }
    
    function completeItem(uint256 _id) public returns(bool){
        require(itemExists[_id], "Item not found");
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a session contract");
        
        items[_id].completed = true;
        emit Action("Item completed successfully");
    
    }



}
