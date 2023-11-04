// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaceA";


contract ContractB is InterfaceA {

    mapping (uint256 => uint256) public donations;
    mapping (address => uint256) public donors;
    
    function sendEth(uint256 id) payable external returns (address) {
        donations[id] += msg.value;
        donors[msg.sender] += msg.value;
        return msg.sender;
    
    }
    
    function caller() view external returns (address) {
        return msg.sender;
    }

}