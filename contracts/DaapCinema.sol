// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./DaapShared.sol";
import "./base64.sol";


//can call TimeSlotStruct from DaapShared 
contract DaapCinema is DaapShared, AccessControl{
    using Counters for Counters.Counter;
    Counters.Counter private _totalMovies;
    Counters.Counter private _totalSlots;
    
     struct MovieStruct {
        uint256 id;
        string name;
        string banner;
        string imageUrl;
        string videoUrl;
        string genre;
        string description;
        string caption;
        string casts;
        string running;
        string released;
        uint256 timestamp;
        bool deleted;
     }
     
     mapping(uint256 => bool) movieExists;
     mapping(uint256 => MovieStruct) movies;
     mapping(uint256 => TimeSlotStruct) movieTimeSlot;
     
     //import ROLE 
     // keccak256: turn a string into a hash
     bytes32 public constant TICKET_ROLE = keccak256("TICKET_ROLE");
     address _current_controller;
     
     //function to grant access
     //daapTicket is a smart contract address
     function grantAccess(address _daapTicket) public onlyOwner {
         //_setupRole is a function from Access Control
        // grante TICKET_ROLE to _daapTicket smart contract
        _setupRole(TICKET_ROLE, _daapTicket);
        //revoke current user
        _revokeRole(TICKET_ROLE, _current_controller);
        //replace previous user to new user
        //so it has not role
        _current_controller = _daapTicket;
        
     }
     
     
     
     // onlyOwner comes from Ownable from DaapShared
     function addMovie(
        string memory _name,
        string memory _banner,
        string memory _imageUrl,
        string memory _videoUrl,
        string memory _genre,
        string memory _description,
        string memory _caption,
        string memory _casts,
        string memory _running,
        string memory _released
     ) public onlyOwner returns(MovieStruct memory){
        //make sure data is not empty
        //bytes turns string into a number
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_banner).length > 0, "Banner cannot be empty");
        require(bytes(_imageUrl).length > 0, "ImgUrl cannot be empty");
        require(bytes(_videoUrl).length > 0, "VideoUrl cannot be empty");
        require(bytes(_genre).length > 0, "Genre cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_caption).length > 0, "Caption cannot be empty");
        require(bytes(_running).length > 0, "Running cannot be empty");
        require(bytes(_released).length > 0, "Release cannot be empty");
     
        _totalMovies.increment();
        uint256 movieId = _totalMovies.current();
        
        MovieStruct memory movie;
        movie.id = movieId;
        movie.name = _name;
        movie.banner = _banner;
        movie.imageUrl = _imageUrl;
        movie.videoUrl = _videoUrl;
        movie.genre =  _genre;
        movie.description = _description;
        movie.caption = _caption;
        movie.casts = _casts;
        movie.running = _running;
        movie.released = _released;
        //get currentTime from DaapShared
        movie.timestamp = currentTime();
        //store movie in movies
        //assigning 
        movies[movieId] = movie;
        movieExists[movieId] = true;
        
        emit Action("Movie Added");
        
     }
     
     function updateMovie(
        uint256 _movieId,
        string memory _name,
        string memory _banner,
        string memory _imageUrl,
        string memory _videoUrl,
        string memory _genre,
        string memory _description,
        string memory _caption,
        string memory _casts,
        string memory _running,
        string memory _released
     ) public onlyOwner returns(MovieStruct memory){
        //make sure data is not empty
        //bytes turns string into a number
        require(movieExists[movieId], "Movie not found");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_banner).length > 0, "Banner cannot be empty");
        require(bytes(_imageUrl).length > 0, "ImgUrl cannot be empty");
        require(bytes(_videoUrl).length > 0, "VideoUrl cannot be empty");
        require(bytes(_genre).length > 0, "Genre cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_caption).length > 0, "Caption cannot be empty");
        require(bytes(_running).length > 0, "Running cannot be empty");
        require(bytes(_released).length > 0, "Release cannot be empty");
     
        movie[_movieId].id = movieId;
        movie[_movieId].name = _name;
        movie[_movieId].banner = _banner;
        movie[_movieId].imageUrl = _imageUrl;
        movie[_movieId].videoUrl = _videoUrl;
        movie[_movieId].genre =  _genre;
        movie[_movieId].description = _description;
        movie[_movieId].caption = _caption;
        movie[_movieId].casts = _casts;
        movie[_movieId].running = _running;
        movie[_movieId].released = _released;
        
        emit Action("Movie Updated Successfully");
        
     }
     function deleteMovie(uint256 _movieId) public onlyOwner returns(bool){
        require(movieExists[movieId], "Movie not found");
        
        movies[_movieId].deleted = true;
        movieExists[movieId] = false;
        
        emit Action("Movie Deleted Successfully");
     }
    
    function addTimeSlot(
        uint256 _movieId;
        uint256[] memory _ticketCosts,
        uint256[] memory _startTimes,
        uint256[] memory _endTimes,
        uint256[] memory _capacities,
        uint256[] memory _days,
    ) public onlyOwner {
        require(movieExists[movieId], "Movie not found");
        require(_ticketCosts.length > 0, "Ticket costs cannot be empty");
        require(_startTimes.length > 0, "Start times cannot be empty");
        require(_endTimes.length > 0, "End time cannot be empty");
        require(_capacities.length > 0, "Capacity cannot be empty");
        require(_days.length > 0, "Days cannot be empty");
        
        require(
            _ticketCosts.length == _startTimes.length &&
            _startTimes.length == _endtimes.length &&
            _endTimes.length == _capacities.length &&
            _days.length == _ticketCosts.length,
            "Unequal array members detected"
        )
        
        for (uint256 i = 0; i < _ticketCosts.length; i ++){
            _totalSlots.increment();
            uint256 slotId = _totalSlots.current();
            
            TimeSlotStruct memory slot;
            slot.id = slotId;
            slot.movieId = _movieId;
            slot.startTimes = _startTimes[i];
            slot.endTimes = endTimes[i];
            slot.ticketCosts = _ticketCosts[i];
            slot.day = _days[i];
            
            movieTimeSlot[slotId] = slot;
            emit Action("Timeslot created");
            
        }
        
        
    }
    
    function deleteTimeSlot(uint256 _slotId) public returns(bool){
        // check if caller has TICKET_ROLE
        //from AccessControl
        require(hasRole(TICKET_ROLE, msg.sender), "Caller is not a ticket contract");
        //next time to check timeslot
        //add condition deleted = false before getting the timeslot
        movieTimeSlot[_slotId].deleted = true;
        emit Action("Timeslot deleted");
    }
    function completeTimeSlot(uint256 _slotId) public returns(bool){
        // check if caller has TICKET_ROLE
        //from AccessControl
        require(hasRole(TICKET_ROLE, msg.sender), "Caller is not a ticket contract");
        //next time to check timeslot
        //add condition deleted = false before getting the timeslot
        movieTimeSlot[_slotId].completed = true;
        emit Action("Timeslot completed");
    }
    function setTimeSlot(TimeSlotStruct memory slot) public {
        require(hasRole(TICKET_ROLE, msg.sender), "Caller is not a ticket contract");
        
        movieTimeSlot[slot.id] = slot;
    }
    
    function getMovies() public view returns (MovieStruct[] memory Movies){
    //no need to restriction like Owneronly of TICKET_ROLE
        uint256 available;
        //count how many movies total
        for(uint256 i = 1; i <= _totalMovies.current(); i++){
            if(!movies[i].deleted] available++;
        }
        //new movie array with fixed amount of total movies
        Movies = new MovieStruct[](available);
        
        uint256 index; //start from 0
        // i starts from 1
        for(uint256 i = 1; i <= _totalMovies.current(); i++){
            //index start from 00, array Movies 
            //start from 1, mapping movies
            //first read current index
            //then next time loop through
            if(!movies[i].deleted) Movies[index++] = movies[i];
        }
        
        //by default it returns Movies
        //bc we specify it returns(MovieStruct[] memory Movies)
        //if not specify return Movies, it will not return Movies by default
    }
    
    function getMovie(uint256 _movieId) public view returns (MovieStruct memory){
        return movies[_movieId];
    }
    
    function getTimeSlotsByDay() public view returns (TimeSlotStruct[] memory Slots){
        uint256 available;
        for (uint i = 1; i <= _totalSlots.current(); i++){
            if(
            !movieTimeSlot[i].day == _day &&
            !movieTimeSlot[i].deleted
            ) available ++;
        }
        
        Slots = new TimeSlotStruct[](available);
        uint256 index;
        for (uint i = 1; i <= _totalSlots.current(); i++){
            if(
            !movieTimeSlot[i].day == _day &&
            !movieTimeSlot[i].deleted
            ) 
            {
                Slots[index].startTime = movieTimeSlot[i].startTime;
                Slots[index++].endTime = movieTimeSlot[i].endTime;
            }
        }
    
    }
    
    function getTimeSlot(uint256 _slotId) public view returns (TimeSlotStruct[] memory) {
        return movieTimeSlot[_slotId];
    }
    
    function getTimeSlotsByMovie(uint256 _movieId) public returns (TimeSlotStruct[] memory Slots){
        uint256 available;
        for(uint i = 0; i <= _totalTimeSlot.current(); i++{
            if(
            movieTimeSlot[_movieId] == _movideId && 
            !movieTimeSlot[_movieId].deleted &&
            !movieTimeSlot[_movieId].completed
            ) available++;
        }
        
        Slots = new TimeSlotStruct[];
        uint256 index;
        for(uint = 0; i <= _totalTimeSlot.current(); i++){
            if(!movies[_movieId].deleted){
              Slots[index++] = movies[i];  
            }
        
        }
        
        
    }
    
     
    
    
  





}