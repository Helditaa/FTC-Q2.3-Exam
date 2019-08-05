pragma solidity^0.5.0;

import "./CoToken.sol";

contract CoBonus {

    //creates the struct
    struct Shoe {
        address payable owner; //address of the owner
        string name; //name of owner
        string image; //url of the image
        bool sold;
    }

    // initializes the variables
    //Price is 1CO, so 1 Co Token
    uint256 shoesSold = 0;
    uint256 count = 0;

    // create the array
    Shoe[] public shoes;


    CoToken ownedToken;
    //creates constructor for 100 tokens, count is increased each time in case needs to be verified that count equals 100
    constructor(address _ownedTokenAddress) public {
        for (uint i = 1; i <= 100; i++) {
        shoes.push(Shoe(msg.sender, "","",false));
        count++;
        }
        ownedToken = CoToken(_ownedTokenAddress);
    }

    //function gets total number of tokens minted
    function getNumberofTokens() public view returns(uint counts) {
        return shoes.length;
    }

    address public ownerAddress;

    //function allows for buying shoe by specifying the name and image on it, as well as having the correct amount plus the shoe not have been sold already
    function buyShoe(string memory _name, string memory _image) public payable returns(uint){ //used to be external payable
        //ensure that not all shoes have been sold
        require(shoesSold < shoes.length, "exceeded number of shoes");
                
        //Check if the token owner has any tokens
        require(ownedToken.balanceOf(msg.sender) > 0, "No Tokens available");
        //Getting Owner Address
        ownerAddress = ownedToken.owner();
        
        //Once the tokens are available, then they can be transferred to new owner
        require(ownedToken.transferFrom(msg.sender, ownerAddress, 1), "Transfer failed");
          
        uint256 i = shoesSold + 1;
        require(shoes[i].sold == false,'shoe has been bought');
        
        //update the values of the next shoe
        shoes[i].owner = msg.sender;
        shoes[i].name = _name;
        shoes[i].image = _image;
        shoes[i].sold = true;
        shoesSold++; //increment count
        return shoesSold;
    }


    //function to return an array of bools of an array of all the purchases that are true
    function checkPurchases() external view returns (bool[] memory){
        bool[] memory checkPurchase;
        for (uint256 i = 0; i < shoes.length; i++){
            if (shoes[i].owner == msg.sender){
                checkPurchase[i] = true;
            }
        }
        return checkPurchase;
    }

}