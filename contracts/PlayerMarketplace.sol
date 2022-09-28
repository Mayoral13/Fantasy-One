pragma solidity ^0.8.11;
import "./ISquad.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";



 contract PlayerMarketplace is ERC721,ERC721URIStorage{
    address public SQUAD;
    uint8 public Classic = 1;
    uint8 public Weekend = 2;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenID;
    Player[]AllPlayers;
    Player[]Goalkeepers;
    Player[]Defenders;
    Player[]Midfielders;
    Player[]Fowards;
   uint[]goalkeepers;
   uint[]defenders;
   uint[]midfielders;
   uint[]fowards;
   mapping(uint => Player) public players;
   mapping(address => mapping(uint => uint))public GoalKeeperCount;
   mapping(address => mapping(uint => uint))public DefenderCount;
   mapping(address => mapping(uint => uint))public MidfielderCount;
   mapping(address => mapping(uint => uint))public FowardCount;
   mapping(address => mapping(uint => uint))public NetSpend;
   mapping(address => mapping(uint => uint[]))private MyTeam;
   mapping(address => mapping(uint => Player[]))private _MyTeam;
   

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
    function MintPlayers(uint8 _position,uint8 _price,string memory _tokenURI)public{
    require(_position == 0 || _position == 1 || _position == 2 || _position == 3);
    require(_price != 0,"Input a price");
    _tokenID.increment();
    uint256 id = _tokenID.current();
    if(_position == 0){
      Goalkeepers.push(Player(Positions.Goalkeeper,id,_price,_tokenURI));
      goalkeepers.push(id);
    }
    else if(_position == 1){
      Defenders.push(Player(Positions.Defender,id,_price,_tokenURI));
      defenders.push(id);
    }
    else if(_position == 2){
      Midfielders.push(Player(Positions.Midfielder,id,_price,_tokenURI));
      midfielders.push(id);
    }
    else if(_position == 3){
      Fowards.push(Player(Positions.Foward,id,_price,_tokenURI));
      fowards.push(id);
    }
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

 function SelectGoalkeeper(uint _id)public{
  require(GoalKeeperCount[msg.sender][Classic] <= 1,"Exceeded Limit");
    for(uint j = 0; j < MyTeam[msg.sender][Classic].length; j++){
  if(MyTeam[msg.sender][Classic][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < goalkeepers.length; i++){
    if(goalkeepers[i] == _id){
      MyTeam[msg.sender][Classic].push(_id);
      _MyTeam[msg.sender][Classic].push(Player(Positions.Goalkeeper,_id,players[_id].price,players[_id].metadata));
    }
  }
   GoalKeeperCount[msg.sender][Classic]++; 
 }
 function SelectDefender(uint _id)public{
  require(DefenderCount[msg.sender][Classic] <= 4,"Exceeded Limit");
     for(uint j = 0; j < MyTeam[msg.sender][Classic].length; j++){
  if(MyTeam[msg.sender][Classic][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < defenders.length; i++){
    if(defenders[i] == _id){
      MyTeam[msg.sender][Classic].push(_id);
      _MyTeam[msg.sender][Classic].push(Player(Positions.Defender,_id,players[_id].price,players[_id].metadata));
    }
  }
   DefenderCount[msg.sender][Classic]++;
 }
 function SelectMidfielder(uint _id)public{
  require(MidfielderCount[msg.sender][Classic] <= 4,"Exceeded Limit");
     for(uint j = 0; j < MyTeam[msg.sender][Classic].length; j++){
  if(MyTeam[msg.sender][Classic][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < midfielders.length; i++){
    if(midfielders[i] == _id){

      MyTeam[msg.sender][Classic].push(_id);
      _MyTeam[msg.sender][Classic].push(Player(Positions.Midfielder,_id,players[_id].price,players[_id].metadata));
    }
  }
  MidfielderCount[msg.sender][Classic]++;
 }
 function SelectFoward(uint _id)public{
  require(FowardCount[msg.sender][Classic] <= 2,"Exceeded Limit");
    for(uint j = 0; j < MyTeam[msg.sender][Classic].length; j++){
  if(MyTeam[msg.sender][Classic][j] == _id){
    revert("Already picked player");
  }
 }
  for(uint i = 0;i < fowards.length; i++){
    if(fowards[i] == _id){
      MyTeam[msg.sender][Classic].push(_id);
      _MyTeam[msg.sender][Classic].push(Player(Positions.Foward,_id,players[_id].price,players[_id].metadata));
    }
  }
     FowardCount[msg.sender][Classic]++;
 }
 function ViewClassicTeam()public view returns(Player[]memory){
  return _MyTeam[msg.sender][Classic];
 }
 

}