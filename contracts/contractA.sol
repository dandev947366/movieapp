// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./contractC";
import "./interfaceA";


contract ContractA {

    function sendMoney (uint256 id, address _contract) payable external returns (address) {
    
        InterfaceA ia = InterfaceA(_contract);
        return ia.sendEth{value: msg.value}(id);
    }
    
    function sendMoneyToC(uint256 id, address _contract) payable external {
        ContractC cc= ContractC(_contract);
        return cc.sendEth{value: msg.value}(id);
    }
    
    function caller() external returns (address) {
        return msg.sender;
    }
    
    function getCCaller(address _contract) view external returns (address){
        ContractC cc = ContractC(_contract);
        return cc.caller();
        
    }



}