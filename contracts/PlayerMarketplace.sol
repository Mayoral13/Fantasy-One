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

    enum Positions{
        Goalkeeper,
        Defender,
        Midfielder,
        Foward
    }
  struct Player{
    Positions position;
    uint tokenID;
    uint price;
    string metadata;
  }
    struct Team{
        uint8 leagueMode;
        string GameMode;
        uint[] playersID;
    }
    constructor()
    ERC721("Fantasy-One","F1"){
    }
  mapping(uint => Player) public players;

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
    function MintPlayers(uint8 _position,uint _price,string memory _tokenURI)public{
    require(_position == 0 || _position == 1 || _position == 2 || _position == 3);
    require(_price != 0,"Input a price");
    _tokenID.increment();
    uint256 id = _tokenID.current();
    if(_position == 0){
      Goalkeepers.push(Player(Positions.Goalkeeper,id,_price,_tokenURI));
    }
    else if(_position == 1){
      Defenders.push(Player(Positions.Defender,id,_price,_tokenURI));
    }
    else if(_position == 2){
      Midfielders.push(Player(Positions.Midfielder,id,_price,_tokenURI));
    }
    else if(_position == 3){
      Fowards.push(Player(Positions.Foward,id,_price,_tokenURI));
    }
   _safeMint(address(this),id);
   _setTokenURI(id,_tokenURI);
   AllPlayers.push(Player(Positions(_position),id,_price,_tokenURI));
    }

     function ViewPlayers()public view returns(Player[]memory){
     return AllPlayers;
 }
 function ViewPlayerByID(uint _ID)public view returns(Player memory){
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
 
 

}