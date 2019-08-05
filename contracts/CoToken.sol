pragma solidity^0.5.0;


//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";


//imports all required contracts
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";

contract CoToken is Ownable, ERC20 {


    //initialize variables
    uint256 public _buyPrice;
    uint256 public _tokenSupply = 0;
    uint256 public _sellPrice;

    //functions that determines the buy price based on the number of tokens to be purchased
    function buyPrice(uint256 _buyTokens) public{
        _buyPrice = ((5*(10**15))*(_buyTokens)*(_buyTokens)) + ((2*10**17)*(_buyTokens)); //Price is already in wei

    }
    //functions that determines the sell price based on the number of tokens to be sold
    function sellPrice(uint256 _buyTokens) public{    
        _sellPrice = ((5*(10**15))*(_buyTokens)*(_buyTokens)) + ((2*10**17)*(_buyTokens)); //Price is already in wei
    }

    //mint tokens whenever the correct amount from buyprice function is added to the function which corresponds to the number of tokens to be minted
    function mint(uint256 _n) public payable {
        require(msg.value == _buyPrice, "Amount does not correspond to the price");
        _mint(msg.sender, _n);//inherited function
        _tokenSupply = _tokenSupply + _n; //increase number of tokens supplied in total
    }

    //burn tokens whenever the correct amount from sellprice function is added to the function which corresponds to the number of tokens to be burnt
    function burn(uint256 _x) onlyOwner public payable {
        require(msg.value == _sellPrice, "Insufficient funds");
        _burn(msg.sender, _x); //inherited function
        _tokenSupply = _tokenSupply - _x;//increase number of tokens supplied in total

    }

    //self destruct function
    function destroy() public onlyOwner {
        selfdestruct(msg.sender);
    }

}
