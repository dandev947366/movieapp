// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./Main.sol";
import "./Shared.sol";
//Interface of Main contract to call from Session contract
// contract Main {
//     function addSession(address session) public {}
// }

contract Session is Shared{
    // Variable to hold Main Contract Address when create new Session Contract
    //address public mainContract;
    // Variable to hold Main Contract instance to call functions from Main
    Main private mainContract;
    using Math for uint;

    using Counters for Counters.Counter;
    Counters.Counter private _totalItem;
    Counters.Counter private _NoOfParticipant;
    Counters.Counter private _NoOfSession;
    // list of participants for one session
    //mapping(uint => address[]) sessionParticipants;
    // mapping(uint=> Iparticipant) participantOf;
    // mapping(uint => Iparticipant[]) sessionParticipants;
    mapping(uint256 => mapping(address=>uint256)) bids;
    constructor(
        address _mainContract
    ){
        //to call Daapcinema functions
        mainContract = Main(_mainContract);
       
    }
    // constructor(address _mainContract)public {
    //     // Get Main Contract instance
    //     mainContract = _mainContract;
    //     MainContract = Main(_mainContract);
    //     MainContract.addSession(address(this));
    // }
    //create new session contract
    // function Session(address _mainContract) public {
    //     // Get Main Contract instance
    //     mainContract = _mainContract;
    //     MainContract = Main(_mainContract);
        
    //     // TODO: Init Session contract
        
    //     // Call Main Contract function to link current contract.
    //     MainContract.addSession(address(this));
    // }
    // function joinSession(uint256 _sessionId) public returns(uint256){
    //     //require(sessionExists[_sessionId], "Session not Exists");
    //     sessionOf[_sessionId].NoOfParticipant ++;
    //     sessionOf[_sessionId].participantList.push(msg.sender);
    //     require(!sessions[_sessionId].completed, "Session completed");
    //     _NoOfParticipant.increment();
    //     Iparticipant memory participant;
    //     participant.participantWallet = msg.sender;
    //     participant.isParticipate = true;
    //     participant.NoOfSession++;
    //    // participants[_sessionId].push(participant);
    //     return _sessionId;
    //     //emit Action ("Join session successfully");
    // }

    function joinSession(uint256 _sessionId) public returns(Iparticipant memory){

        SessionStruct memory session =  mainContract.getSession(_sessionId);
        require(session.NoOfParticipant < 10, "Maximum amount of participants reached.");
        require(!session.completed,"Session completed.");
        require(!session.deleted,"Session deleted.");
        //require(!session.existed,"Session not exist.");
        
        Iparticipant memory joiner;
        joiner.participantWallet = msg.sender;
        joiner.isParticipate = true;
        joiner.NoOfSession += 1;
        participantOf[_sessionId] = joiner;
        participantList[_sessionId].push(joiner);

        emit Action ("Join session successfully");
        return joiner;

    }

    function getParticipants(uint256 _sessionId) public view returns(Iparticipant[] memory){
         return participantList[_sessionId];
    }

    function startPricing(uint256 _sessionId, uint256 _itemId, uint256 _amount) public {
        //require(itemExists[_id], "Item not found");
        //require(sessionExists[sessionId], "Session not Exists");
        //require(msg.value >= _amount, "Insufficient balance");
        require(participantOf[_sessionId].participantWallet == msg.sender, "Invalid participant.");
        Item memory item;
        item.id = _itemId;
        item.status = Status.RUNNING;
        bids[_sessionId][msg.sender] = _amount;
        participantOf[_sessionId].NoOfBids++; 
        participantOf[_sessionId].NoOfBids++;
        participantOf[_sessionId].isParticipate = true;
        participantOf[_sessionId].participantWallet = msg.sender;
        int sId = castUintToInt(_sessionId);
        int amount = castUintToInt(_amount);
        bidListCal[sId][msg.sender].push(amount);
        bidList[_sessionId][msg.sender].push(_amount);
        emit Action ("Bid item successfully");
    
    }
    function castUintToInt(uint256 value) public pure returns (int256) {
    require(value <= uint256(int256(-1)), "Value exceeds int256 range");
    return int256(value);
    }
    function castIntToUint(int256 value) public pure returns (uint256) {
    require(value >= 0, "Value is negative"); // Check if the value is non-negative
    return uint256(value);
    }

    function getBidList(uint256 _sessionId, address _participant) public view returns(uint256[] memory){

        return bidList[_sessionId][_participant];
    }
    function getTotalBids(uint256 _sessionId, address _participant) public view returns (uint256) {
        uint256[] memory totalBids = getBidList(_sessionId, _participant);
        return totalBids.length;
    }
    function calcDeviation(address _participant, uint256 _sessionId) public view returns (int256) {
    //uint256[] memory totalBids = getBidList(_sessionId, _participant);
    int sId = castUintToInt(_sessionId);
    uint256 total = getTotalBids(_sessionId, _participant);
    int256 totalNew = castUintToInt(total);
    int256[] memory totalBids = bidListCal[sId][msg.sender];
    int256 sum;
    int256 average;
    int256 variantSum;
    int256 v;
    int256 deviation;
    //int256 total = totalBids.length;
    // Calculate the sum of bids
    for(uint256 i = 0; i < totalBids.length; i++) {
        sum += totalBids[i];
    }
    
    // Calculate the average
    average = sum / totalNew;

    // Calculate the sum of squared differences
    for(uint256 i = 0; i < totalBids.length; i++) {
        v = totalBids[i] - average;
        v = v * v;
        variantSum += v;
    }

    // Calculate variance
    variantSum = variantSum / totalNew;

    // Calculate standard deviation (square root of variance)
    deviation = sqrt(variantSum);

    return deviation;
}


function sqrt(int256 x) internal pure returns (int256 y) {
    int256 z = (x + 1) / 2;
    y = x;
    while (z < y) {
        y = z;
        z = (x / z + z) / 2;
    }
}

    // function calcDeviation(address _participant, uint256 _sessionId) public returns(uint256){

        /**
            Source: https://vietnambiz.vn/do-lech-chuan-standard-deviation-la-gi-cong-thuc-tinh-do-lech-chuan-2019110216112891.htm
            Giả sử chúng ta có các quan sát 5, 7, 3 và 7, tổng cộng 22. Sau đó, bạn sẽ chia 22 cho số quan sát, trong trường hợp này là 4 được 5,5. Ta có trung bình là: x̄ = 5,5 và N = 4.

            Phương sai được xác định bằng cách trừ mỗi quan sát cho giá trị trung bình, ta được lần lượt các kết quả là -0,5, 1,5, -2,5 và 1,5. Mỗi giá trị này sau đó được bình phương, bằng 0,25, 2,25, 6,25 và 2,25. Công các giá trị bình phương sau đó chia cho giá trị N trừ 1, bằng 3, cho kêt quả phương sai xấp xỉ 3,67.

            Căn bậc hai của phương sai có độ lệch chuẩn là khoảng 1.915.

        **/
    //    uint256[] memory totalBids = getBidList(_sessionId, _participant);

    //    for(uint256 i = 0; i < totalBids.length; i++){
    //         sum += totalBids[i];
    //         total ++;
    //    }
    //    average = sum / total;
    //    for(uint256 i = 0; i < totalBids.length; i++){
        
    //         v = totalBids[i] - average;
    //         v = v**2;
    //         variantSum += v;
        
    //    }
    //    variantSum = variantSum/(total-1);
    //    deviation = sqrt(variantSum);
    //    return variantSum;

    // }


    

    }





  






    
    
    

