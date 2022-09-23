pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Squad is ERC20{
constructor()
ERC20("SQUAD-TOKEN","SQD"){
    _mint(msg.sender,100000);
}
}