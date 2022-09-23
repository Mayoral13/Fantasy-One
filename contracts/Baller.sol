pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Baller is ERC20{
constructor()
ERC20("BALLER-TOKEN","BALL"){
    _mint(msg.sender,100000);
}
}