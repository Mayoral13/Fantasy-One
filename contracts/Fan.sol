pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";
contract Fan is ERC20,Ownable{
    uint private Circulation;    
constructor()
ERC20("FAN-TOKEN","FAN"){
    _mint(address(this),100000);
}
    function ShowOwner()external view returns(address){
        return owner;
    }

    function RequestTokens(uint _amount)external returns(bool success){
        require(_amount < VendorBalance(),"Exceeded Limit");
        _transfer(address(this),msg.sender,_amount);
        Circulation = Circulation + (_amount);
        return true;
    }

    function TokeninCirculation()external view returns(uint){
        return Circulation;
    }
    function VendorBalance()public view returns(uint){
        return balanceOf(address(this));
    }
    function TokenBalance()public view returns(uint){
        return balanceOf(msg.sender);
    }
    function MintTokens(uint _amount)onlyOwner public{
        _mint(address(this),_amount);
    }
}