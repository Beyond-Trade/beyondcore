pragma solidity ^0.5.16;

import './StandardToken.sol';
import './Ownable.sol';

contract USDb is StandardToken, Ownable
{
    
    string public constant name = "Beyond USD";
    string public constant symbol = "USDb";
    uint8 public constant decimals = 18;
    
    address loanContract;
    address exchangeContract;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    modifier onlyContract{
        require(msg.sender == loanContract || msg.sender == exchangeContract,"Not Authorized address");
        _;
    }
    
    constructor() public Ownable(msg.sender){ 

        _totalSupply = 0;

    }
    
    function mint(uint256 _value, address _beneficiary) onlyContract external returns (bool){

        require(_value > 0);
        balances[_beneficiary] = balances[_beneficiary].add(_value);
        _totalSupply = _totalSupply.add(_value);
        
        emit Transfer(address(this),_beneficiary, _value);
        
    }
    
    function balanceCheck(address _beneficiary) public view returns(uint256){
        require(_beneficiary != address(0));
        return super.balanceOf(_beneficiary);
    }
    
    function burn(uint256 _value, address _beneficiary) onlyContract external {
        require(balanceCheck(_beneficiary) >= _value,"User does not have sufficient synths to burn");
        _totalSupply = _totalSupply.sub(_value);
        balances[_beneficiary] = balances[_beneficiary].sub(_value);
        
        emit Transfer(address(this),_beneficiary, _value);
    }
    
    function setLoanContract(address _address) onlyOwner public {
        loanContract = _address;
    }
    
    function setExchangeContract(address _address) onlyOwner public {
        exchangeContract = _address;
    }
}