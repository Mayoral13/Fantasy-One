pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";
contract Fan is ERC20,Ownable{
    uint private Circulation;
    uint private rate = 40000000000000;
    mapping(address => uint)Bought;
    mapping(address => uint)Sold;
    event rateSet(address indexed _from,uint _value);
    event ownerChange(address indexed _from,address indexed _to);
    event tokensBought(address indexed _from,uint _value);
    event tokensSold(address indexed _from,uint _value);
    event withdraw(address indexed _from,address indexed _to,uint _value);
    
constructor()
ERC20("FAN-TOKEN","FAN"){
    _mint(address(this),100000);
}
    function ShowRate()external view returns(uint){
        return rate;
    }
    function SetRate(uint _rate)external onlyOwner returns(bool success){
        require(_rate != 0,"Rate cannot be 0");
        rate = _rate;
        emit rateSet(msg.sender,_rate);
        return true;

    }
    function ShowOwner()external view returns(address){
        return owner;
    }

    function BuyTokens(uint _amount)external payable returns(bool success){
        require(rate != 0,"Rate has not been set");
        require(_amount == (msg.value/rate),"Must be Same");
        require(msg.value != 0,"You cannot send nothing");
        transfer(msg.sender,_amount);
        Circulation = Circulation + (_amount);
        emit tokensBought(msg.sender,_amount);
        return true;
    }

    function TokeninCirculation()external view returns(uint){
        return Circulation;
    }

    function WithdrawETH(address payable _to,uint amount)external onlyOwner payable returns(bool success){
        require(address(this).balance >= amount,"Insufficient Balance");
        _to.transfer(amount);
        emit withdraw(msg.sender,_to,amount);
        return true;
    }
    function TransferTokens(address _to,uint amount)external onlyOwner returns(bool success){
        require(VendorTokenBalance() >= amount,"Insufficient amount");
        transfer(_to,amount);
        return true;
    }
    function VendorTokenBalance()public view returns(uint){
        return balanceOf(address(this));
    }
    function TokenBalance()public view returns(uint){
        return balanceOf(msg.sender);
    }
    function MintTokens(uint _amount)onlyOwner public{
        _mint(address(this),_amount);
    }
}