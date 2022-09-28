pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
 contract PlayerMarketplace is ERC721,ERC721URIStorage{
    address public SQUAD;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenID;
    Player[]AllPlayers;
    Player[]Goalkeepers;
    Player[]Defenders;
    Player[]Midfielders;
    Player[]Fowards;
   mapping(uint => Player) public players;
   mapping(uint => uint)public playerPrice;
   mapping(uint => uint)public playerPosition;
   mapping(address => uint)public GoalKeeperCount;
   mapping(address => uint)public DefenderCount;
   mapping(address => uint)public MidfielderCount;
   mapping(address => uint)public FowardCount;
   mapping(address => uint)public NetSpend;
   mapping(address => uint[])private MyTeam;
   mapping(address => Player[])private _MyTeam;
   

    enum Positions{
        Goalkeeper,
        Defender,
        Midfielder,
        Foward
    }
  struct Player{
    Positions position;
    uint tokenID;
    uint8 price;
    string metadata;
  }
  
    constructor(address _squad)
    ERC721("Fantasy-One","F1"){
      SQUAD = _squad;
    }

     function _burn(uint256 _tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(_tokenId);
    }

  //Without this an error will be flagged

    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(_tokenId);
    }
    modifier NotExist(uint _id){
       require(playerPrice[_id] != 0,"Not Exist");
       _;
    }
    function MintPlayers(uint8 _position,uint8 _price,string memory _tokenURI)public{
    require(_position == 0 || _position == 1 || _position == 2 || _position == 3);
    require(_price != 0,"Input a price");
    _tokenID.increment();
    uint256 id = _tokenID.current();
    if(_position == 0){
      Goalkeepers.push(Player(Positions.Goalkeeper,id,_price,_tokenURI));
      playerPosition[id] = 0;
    }
    else if(_position == 1){
      Defenders.push(Player(Positions.Defender,id,_price,_tokenURI));
      playerPosition[id] = 1;
    }
    else if(_position == 2){
      Midfielders.push(Player(Positions.Midfielder,id,_price,_tokenURI));
      playerPosition[id] = 2;
    }
    else if(_position == 3){
      Fowards.push(Player(Positions.Foward,id,_price,_tokenURI));
      playerPosition[id] = 3;
    }
    playerPrice[id] = _price;
   _mint(address(this),id);
   players[id] = Player(Positions(_position),id,_price,_tokenURI);
   _setTokenURI(id,_tokenURI);
   AllPlayers.push(Player(Positions(_position),id,_price,_tokenURI));
    }

     function ViewPlayers()public view returns(Player[]memory){
     return AllPlayers;
 }
 function ViewPlayerByID(uint8 _ID)public view returns(Player memory){
  require(players[_ID].price != 0,"Does not exist");
  return players[_ID];
 }
 function ViewAllGoalKeepers()public view returns(Player[]memory){
  return Goalkeepers;
 }
 function ViewAllDefenders()public view returns(Player[]memory){
  return Defenders;
 }
 function ViewAllMidfielders()public view returns(Player[]memory){
  return Midfielders;
 }
 function ViewAllFowards()public view returns(Player[]memory){
  return Fowards;
 }
 modifier Expensive(){
  require(NetSpend[msg.sender] <= 100,"Remove a player");
  _;
 }
 modifier InSufficient(uint _id){
  require(IERC20(SQUAD).balanceOf(msg.sender) >= playerPrice[_id],"Insufficient Balance");
  _;
 }

 function SelectGoalkeeper(uint _id)public NotExist(_id) Expensive InSufficient(_id){
  require(playerPosition[_id] == 0 ,"Not a Goalkeeper");
  require(GoalKeeperCount[msg.sender] <= 1,"Exceeded Limit");
    for(uint j = 0; j < MyTeam[msg.sender].length; j++){
  if(MyTeam[msg.sender][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < Goalkeepers.length; i++){
   if(Goalkeepers[i].tokenID == _id){
    NetSpend[msg.sender] += playerPrice[_id];
      IERC20(SQUAD).transferFrom(msg.sender,address(this),playerPrice[_id]);
      MyTeam[msg.sender].push(_id);
      _MyTeam[msg.sender].push(Player(Positions.Goalkeeper,_id,players[_id].price,players[_id].metadata));
    }
  }
   GoalKeeperCount[msg.sender]++; 
 }
 function SelectDefender(uint _id)public NotExist(_id) Expensive InSufficient(_id){
  require(playerPosition[_id] == 1,"Not a Defender");
  require(DefenderCount[msg.sender] <= 4,"Exceeded Limit");
     for(uint j = 0; j < MyTeam[msg.sender].length; j++){
  if(MyTeam[msg.sender][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < Defenders.length; i++){
     if(Defenders[i].tokenID == _id){
      NetSpend[msg.sender] += playerPrice[_id];
      IERC20(SQUAD).transferFrom(msg.sender,address(this),playerPrice[_id]);
      MyTeam[msg.sender].push(_id);
      _MyTeam[msg.sender].push(Player(Positions.Defender,_id,players[_id].price,players[_id].metadata));
    }
  }
   DefenderCount[msg.sender]++;
 }
 function SelectMidfielder(uint _id)public NotExist(_id) Expensive InSufficient(_id){
  require(playerPosition[_id] == 2,"Not a Midfielder");
  require(MidfielderCount[msg.sender] <= 4,"Exceeded Limit");
     for(uint j = 0; j < MyTeam[msg.sender].length; j++){
  if(MyTeam[msg.sender][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < Midfielders.length; i++){
     if(Midfielders[i].tokenID == _id){
      NetSpend[msg.sender] += playerPrice[_id];
      IERC20(SQUAD).transferFrom(msg.sender,address(this),playerPrice[_id]);
      MyTeam[msg.sender].push(_id);
      _MyTeam[msg.sender].push(Player(Positions.Midfielder,_id,players[_id].price,players[_id].metadata));
    }
  }
  MidfielderCount[msg.sender]++;
 }
 function SelectFoward(uint _id)public NotExist(_id) Expensive InSufficient(_id){
  require(playerPosition[_id] == 3,"Not a Foward");
  require(FowardCount[msg.sender] <= 2,"Exceeded Limit");
    for(uint j = 0; j < MyTeam[msg.sender].length; j++){
  if(MyTeam[msg.sender][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < Fowards.length; i++){
     if(Fowards[i].tokenID == _id){
      NetSpend[msg.sender] += playerPrice[_id];
      IERC20(SQUAD).transferFrom(msg.sender,address(this),playerPrice[_id]);
      MyTeam[msg.sender].push(_id);
      _MyTeam[msg.sender].push(Player(Positions.Foward,_id,players[_id].price,players[_id].metadata));
    }
  }
     FowardCount[msg.sender]++;
 }
 function ViewTeam()public view returns(Player[]memory){
  return _MyTeam[msg.sender];
 }
 function RemovePlayer(uint _id) public NotExist(_id)returns(bool){
 for(uint j = 0; j < MyTeam[msg.sender].length; j++){
  if(MyTeam[msg.sender][j] == _id){
   MyTeam[msg.sender].pop();
   _MyTeam[msg.sender].pop();
  }
 }
  if(playerPosition[_id] == 0){
    NetSpend[msg.sender] -= playerPrice[_id];
    GoalKeeperCount[msg.sender]--;
  }
  else if(playerPosition[_id] == 1){
    NetSpend[msg.sender] -= playerPrice[_id];
    DefenderCount[msg.sender]--;
 }
 else if(playerPosition[_id] == 2){
    NetSpend[msg.sender] -= playerPrice[_id];
    MidfielderCount[msg.sender]--;
 }
 else if(playerPosition[_id] == 3){
    NetSpend[msg.sender] -= playerPrice[_id];
    FowardCount[msg.sender]--;
 }
 return true;
}
 }