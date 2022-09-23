pragma solidity ^0.8.11;
import "./ISignup.sol";
contract League{
    struct league{
        address owner;
        string name;
        uint rewards;
        bytes32 key;
        uint members;
    }
    ISignup public isignup;
    constructor(address _signup){
    isignup = ISignup(_signup);
    }
    mapping(bytes32 => league)private leagues;
    mapping(address => mapping(bytes32 => uint))private points;
    mapping(address => bytes32[])private leaguesIN;
    mapping(address => bytes32[])private leagueKeys;
    mapping(address => mapping(bytes32 => bool))private leagueMembers;
    mapping(address => mapping(string => bytes32))private leaguesOwned; 
    
    function CreateLeague(string memory _name,uint _rewards)public{
        require(isignup.IsPlayer() == true,"Signup First");
        bytes32 key;
        key = _generateKey(_name,msg.sender,block.timestamp);
        leagues[key].owner = msg.sender;
        leagues[key].name = _name;
        leagueKeys[msg.sender].push(key);
        leaguesOwned[msg.sender][_name] = key;
        leagues[key].key = key;
        leagues[key].rewards = _rewards;
        leagueMembers[msg.sender][key] = true;
        leagues[key].members++;
    }
    function ViewLeagueKey()public view returns(bytes32[]memory){
         require(isignup.IsPlayer() == true,"Signup First");
        require(leagueKeys[msg.sender].length != 0,"Empty");
        return leagueKeys[msg.sender];
    }
    function ViewSpecificKey(string memory name)public view returns(bytes32){
         require(isignup.IsPlayer() == true,"Signup First");
        require(leaguesOwned[msg.sender][name] != 0,"Empty");
        return leaguesOwned[msg.sender][name];
    } 
    function JoinLeague(bytes32 _key)public{
    require(isignup.IsPlayer() == true,"Signup First");
     require(_key == leagues[_key].key);
     require(leagueMembers[msg.sender][_key] == false,"Already a Member");
     leagues[_key].members++;
     leagueMembers[msg.sender][_key] = true;
     leaguesIN[msg.sender].push(_key);
    }
    function ViewLeague(bytes32 _key)public view returns(league memory){
    require(isignup.IsPlayer() == true,"Signup First");
     require(leagueMembers[msg.sender][_key] == true,"Not a Member");
     return leagues[_key];
    }
    function LeaveLeague(bytes32 _key)public{
     require(isignup.IsPlayer() == true,"Signup First");    
    require(leagueMembers[msg.sender][_key] == true,"Not a Member");
        for(uint j = 0; j < leaguesIN[msg.sender].length; j++){
            if(leaguesIN[msg.sender][j] == _key){
              leaguesIN[msg.sender].pop();
            }
        }
    leagueMembers[msg.sender][_key] = false;
    leagues[_key].members--;
    }
    
    function _generateKey(string memory _name,address _owner,uint _time)private pure returns(bytes32){
    return bytes32(keccak256(abi.encodePacked(_name,_owner,_time)));
    }
   
}