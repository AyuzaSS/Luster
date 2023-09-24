// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ToDoList{

    uint public idUser;
    address public ownerOfContract;

    address[] public creators;
    string[] public message;
    uint[] public messageID;

    struct ToDoListApp{
        address account;
        uint userId;
        string message;
        bool completed;
    }

    event ToDoEvent(
        address indexed account,
        uint indexed userId,
        string message,
        bool completed
    );

    mapping (address => ToDoListApp) public todolistApps;

    constructor(){
        ownerOfContract = msg.sender;
    }

    function inc()  internal{
        idUser ++;
    }

    function createList (string calldata _message) external{
        
        inc();

        uint idNumber = idUser;
        
        ToDoListApp storage toDo = todolistApps[msg.sender];
        
        toDo.account = msg.sender;
        toDo.message = _message;
        toDo.completed = false;
        toDo.userId = idNumber;

        creators.push(msg.sender);
        message.push(_message);
        messageID.push(idNumber);

        emit ToDoEvent (msg.sender, toDo.userId, _message, toDo.completed);

    }

    function getCreatorData(address _address) public view returns (address, uint, string memory, bool){
        ToDoListApp memory singleUserData = todolistApps[_address];

        return (
            singleUserData.account,
            singleUserData.userId,
            singleUserData.message,
            singleUserData.completed
        );

    }

    function getAddress() external view returns (address[] memory){
        return creators;
    
    }

    function getMessage() external view returns (string[] memory){
        return message;
    
    }

    function toggle(address _creator) public{
        ToDoListApp storage singleUserData = todolistApps[_creator];
        singleUserData.completed = !singleUserData.completed;
    }

}