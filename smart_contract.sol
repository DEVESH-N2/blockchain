//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

//EmployeeInfo is a smart contract to manage employee data.
contract EmployeeInfo{
    //The Ethereum address of the admin who manages the contract.
    address public admin;

    //Structure to represent employee information.
    struct Employee{
        string AadharCard;     //Aadhar card number
        string name;           //Employee's name
        uint age;              //Employee's age
        address WalletAddress; //Employee's Ethereum wallet address
        string passcode;       //Passcode to access employee details
    }

    //Mapping to associate employee addresses with their information.
    mapping(address=>Employee)public employees_map;

    //Events to log important actions for employee management.
    event EmployeeRegistered(address indexed EmployeeAddress,string AadharCard,string name, uint age,address WalletAddress);
    event EmployeeInfoUpdated(address indexed EmployeeAddress,string AadharCard,string name,uint age,address WalletAddress);

    //Constructor to set the admin as the deployer of the contract.
    constructor(){
        admin=msg.sender;
    }

    //Modifier to restrict access to only the admin.
    modifier adminaccess(){
        require(msg.sender==admin,"Only admin can have the access");
        _;
    }

    //Function to register employee details, accessible only by the admin.
    function registerEmployee(address EmployeeAddress,string memory AadharCard,string memory name,uint age,address WalletAddress,string memory passcode)public adminaccess{
        //Store employee details in the mapping.
        employees_map[EmployeeAddress]=Employee(AadharCard,name,age,WalletAddress,passcode);
        //Emit an event to log the registration.
        emit EmployeeRegistered(EmployeeAddress,AadharCard,name,age,WalletAddress);
    }

    //Function to retrieve employee details with a valid passcode.
    function getEmployeeInfo(address EmployeeAddress, string memory passcode) public view returns (string memory,string memory,uint,address){
        //Check if the provided passcode matches the stored passcode.
        require(keccak256(abi.encodePacked(passcode))==keccak256(abi.encodePacked(employees_map[EmployeeAddress].passcode)),"Incorrect passcode.");
        //Retrieve and return employee details.
        Employee storage employee=employees_map[EmployeeAddress];
        return(employee.AadharCard,employee.name,employee.age,employee.WalletAddress);
    }
}
