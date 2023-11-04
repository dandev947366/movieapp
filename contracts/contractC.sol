// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract ContractC{

    function sendEth(uint256 _ignore) payable external returns (address){
        return msg.sender;
    }
    
    function caller() view external returns (address) {
        return msg.sender;
    }
    
    function withdraw() external {
        payable(address(this)).transfer(address(this).balance);
    
    }





}