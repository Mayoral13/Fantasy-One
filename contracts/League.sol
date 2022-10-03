pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract League{
    
    struct league{
        address owner;
        string name;
        uint rewards;
        bytes32 key;
        uint members;
        uint rewardbalance;
    }
    struct LeaderBoard{
        address[]members;
        uint[]scores;
    }
    constructor(address _ifan){
        fan = _ifan;
    }
    modifier IsPlayer(){
        require(isPlayer[msg.sender] == true,"Signup First"); 
        _;
    }
    modifier IsAdmin(bytes32 _key){
       require(msg.sender == leagues[_key].owner,"You are not the admin");
       _; 
    }
    modifier IsMember(bytes32 _key){
        require(leagueMembers[msg.sender][_key] == true,"Not a Member");
        _;
    }
    //function ViewLeaderBoard(bytes32 _key)public view returns(address[]memory,uint[]memory){

   // } ///TO DO LEADERBOARD
    address public fan;
    uint8 private season = 1;
    uint private totalPlayers;
    address[]private globalLeague;
    mapping(address => bool)private isPlayer;
    mapping(bytes32 => league)private leagues;
    mapping(address => bytes32[])private leaguesIN;
    mapping(address => bytes32[])private leagueKeys;
    mapping(bytes32 => LeaderBoard)private leaderboards;
    mapping(uint => LeaderBoard)private globalLeaderboard;
    mapping(address => mapping(bytes32 => bool))private leagueMembers;
    mapping(address => mapping(string => bytes32))private leaguesOwned; 
    
    function CreateLeague(string memory _name,uint _rewards)IsPlayer public{ 
        bytes32 key;
        key = _generateKey(_name,msg.sender,block.timestamp);
        leagues[key].owner = msg.sender;
        leagues[key].name = _name;
        leagueKeys[msg.sender].push(key);
        leaguesOwned[msg.sender][_name] = key;
        leagues[key].key = key;
        leagueMembers[msg.sender][key] = true;
        leagues[key].rewards = _rewards;
        leagues[key].members++;
        leaderboards[key].members.push(msg.sender);
    }
       function ViewLeaderBoard(bytes32 _key)public view IsMember(_key)returns(LeaderBoard memory){
        return leaderboards[_key];
    }
    function SetLeagueReward(uint _rewards,bytes32 _key)IsPlayer IsAdmin(_key) public{/////APPROVE WITH TRANSFERFROM UI
        IERC20 ifan = IERC20(fan);
        require(ifan.balanceOf(msg.sender) >= _rewards,"Insufficient Balance");
        require(leagues[_key].rewards != 0,"Change rewards first");
        require(_rewards >= leagues[_key].rewards,"Rewards must be greater than set");
        ifan.transferFrom(msg.sender,address(this),_rewards);
        leagues[_key].rewardbalance += _rewards;
    }
    function ChangeLeagueReward(uint _rewards,bytes32 _key)IsPlayer IsAdmin(_key) public{
         leagues[_key].rewards = _rewards;
    }
    function ClaimRewards(bytes32 _key)IsPlayer IsMember(_key) public{ //////////////////////////UNFINISHED PUT LEADERBOARD BROOOOO
        require(leagues[_key].rewardbalance >= leagues[_key].rewards);
        IERC20 ifan = IERC20(fan);
        leagues[_key].rewardbalance -= leagues[_key].rewards;
        ifan.transfer(msg.sender,leagues[_key].rewards);
    } 
    function ViewLeagueKey()IsPlayer public view returns(bytes32[]memory){  
        require(leagueKeys[msg.sender].length != 0,"Empty");
        return leagueKeys[msg.sender];
    }
    function ViewSpecificKey(string memory name)IsPlayer public view returns(bytes32){  
        require(leaguesOwned[msg.sender][name] != 0,"Empty");
        return leaguesOwned[msg.sender][name];
    } 
    function JoinLeague(bytes32 _key)IsPlayer public{
     require(_key == leagues[_key].key);
     require(leagueMembers[msg.sender][_key] == false,"Already a Member");
     leagues[_key].members++;
     leagueMembers[msg.sender][_key] = true;
     leaguesIN[msg.sender].push(_key);
     leaderboards[_key].members.push(msg.sender);
    }
    function ViewLeague(bytes32 _key)IsPlayer IsMember(_key) public view returns(league memory){  
     return leagues[_key];
    }
    function LeaveLeague(bytes32 _key)IsPlayer IsMember(_key) public{   
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
     globalLeaderboard[season].members.push(msg.sender);
    }
    function TotalPlayers()public view returns(uint){
        return totalPlayers;
    }
    function Global()public view returns(address[]memory){
        return globalLeague;
    }
    function GlobalLeaderBoard()public view returns(LeaderBoard memory){
        return globalLeaderboard[season];
    }

  
 
   
}