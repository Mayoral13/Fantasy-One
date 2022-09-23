pragma solidity ^0.8.11;
contract Signup{
    address[]private globalLeague;
    uint private totalPlayers;
     mapping(address => bool)private isPlayer;
     function SignUp()external{
    require(isPlayer[msg.sender] == false,"Already a player");
     globalLeague.push(msg.sender);
     totalPlayers++;
     isPlayer[msg.sender] = true; 
    }
    function IsPlayer()external view returns(bool){
        return isPlayer[msg.sender];
    }
    function TotalPlayers()external view returns(uint){
        return totalPlayers;
    }
    function Global()external view returns(address[]memory){
        return globalLeague;
    }
}