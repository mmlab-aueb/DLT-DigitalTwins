// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;
import "./ERC20DT.sol";

contract DigitalTwin is ERC20DT{

    using SafeMath for uint;

    struct Actions {
        string actionName;
        string[] parameters;
        uint price;
    }

    Actions[] public actionsList;

    event PerformActuation (
        string actionName,
        string[] parameters,
        address client
    );

    function getActions() public view returns (Actions[] memory) {
        return actionsList;
    }

    function getActionByIndex(uint actionIndex) public view returns (Actions memory) {
        return actionsList[actionIndex];
    }

    function addAction(string memory actionName, string[] memory parameters, uint price) public {
        Actions memory action = Actions(actionName, parameters, price);
        actionsList.push(action);
    }

    function deleteAction(uint actionIndex) public {
        require(msg.sender == owner);

        for (uint i=actionIndex; i<actionsList.length-1; i++) {
            actionsList[i] = actionsList[i+1];
        }

        delete actionsList[actionsList.length-1];
    }

    function modifyAction(uint actionIndex, string[] memory parameters, uint price) public {
        require(msg.sender == owner);

        Actions storage action = actionsList[actionIndex];
        action.parameters = parameters;
        action.price = price;
    }

    function performActuation(uint actionIndex, string[] memory parameters) public {
        require(actionIndex < actionsList.length);
        Actions memory action = actionsList[actionIndex];
        require(balances[msg.sender] > action.price);
        require(parameters.length == action.parameters.length);

        balances[msg.sender] = balances[msg.sender].sub(action.price);
        balances[address(this)] = balances[address(this)].add(action.price);

        emit PerformActuation(action.actionName, action.parameters, msg.sender);
    }

    function endOfAction(uint actionIndex, address client, bool success) public {
        require(msg.sender == owner);

        Actions memory action = actionsList[actionIndex];
        if (success) {
            balances[owner] = balances[owner].add(action.price);
            balances[address(this)] = balances[address(this)].sub(action.price);
        }
        else {
            balances[client] = balances[client].add(action.price);
            balances[address(this)] = balances[address(this)].sub(action.price);
        }
    }

}