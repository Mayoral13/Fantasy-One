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
    struct LeaderBoard{
        address[]leagueMembers;
        uint[]leagueScores;
        bytes32 key;
    }
    //function ViewLeaderBoard(bytes32 _key)public view returns(address[]memory,uint[]memory){

   // } ///TO DO LEADERBOARD

    uint private totalPlayers;
    address[]private globalLeague;
    mapping(address => bool)private isPlayer;
    mapping(bytes32 => league)private leagues;
    mapping(address => bytes32[])private leaguesIN;
    mapping(address => bytes32[])private leagueKeys;
    mapping(bytes32 => LeaderBoard)private leaderboards;
    mapping(address => mapping(bytes32 => bool))private leagueMembers;
    mapping(address => mapping(string => bytes32))private leaguesOwned; 
    
    function CreateLeague(string memory _name,uint _rewards)public{
        require(isPlayer[msg.sender] == true,"Signup First");  
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
    function SetLeagueReward(uint _rewards,bytes32 _key)public{
        require(msg.sender == leagues[_key].owner,"You are not the admin");
        leagues[_key].rewards = _rewards;
    } 
    function ViewLeagueKey()public view returns(bytes32[]memory){
        require(isPlayer[msg.sender] == true,"Signup First");  
        require(leagueKeys[msg.sender].length != 0,"Empty");
        return leagueKeys[msg.sender];
    }
    function ViewSpecificKey(string memory name)public view returns(bytes32){
        require(isPlayer[msg.sender] == true,"Signup First");  
        require(leaguesOwned[msg.sender][name] != 0,"Empty");
        return leaguesOwned[msg.sender][name];
    } 
    function JoinLeague(bytes32 _key)public{
    require(isPlayer[msg.sender] == true,"Signup First");  
     require(_key == leagues[_key].key);
     require(leagueMembers[msg.sender][_key] == false,"Already a Member");
     leagues[_key].members++;
     leagueMembers[msg.sender][_key] = true;
     leaguesIN[msg.sender].push(_key);
    }
    function ViewLeague(bytes32 _key)public view returns(league memory){
    require(isPlayer[msg.sender] == true,"Signup First");  
     require(leagueMembers[msg.sender][_key] == true,"Not a Member");
     return leagues[_key];
    }
    function LeaveLeague(bytes32 _key)public{
     require(isPlayer[msg.sender] == true,"Signup First");    
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
     function SignUp()public{
    require(isPlayer[msg.sender] == false,"Already a player");
     globalLeague.push(msg.sender);
     totalPlayers++;
     isPlayer[msg.sender] = true; 
    }
    function IsPlayer()public view returns(bool){
        return isPlayer[msg.sender];
    }
    function TotalPlayers()public view returns(uint){
        return totalPlayers;
    }
    function Global()public view returns(address[]memory){
        return globalLeague;
    }
   
}