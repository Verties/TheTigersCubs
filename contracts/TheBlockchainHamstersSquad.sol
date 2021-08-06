// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
import "./Ownable.sol";
import "./ERC721.sol";

/**
 * @dev Contract module defining the Blockchain Hamsters Squad Tiger's Guild ERC721 NFT Token.
 * There is a total supply of 8000 BHS to be minted, each tiger cost .01 ETH.
 * 500 of the BHS are reserved for presale and promo purposes.
 */
contract TheBlockchainHamstersSquad is ERC721, Ownable {
    using Strings for uint256;

    string _baseTokenURI;
    uint256 public _tigerPrice = 10000000000000000;   // .01 ETH
    bool public _saleIsActive = false;
    // Reserve 500 Tokens
    uint public _tigerReserve = 500;

    constructor(string memory baseURI) ERC721("TheBlockchainHamstersSquad", "BHS") {
        setBaseURI(baseURI);
    }
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }
    /** 
     * Mint a number of BHS straight in target wallet.
     * @param _to: The target wallet address, make sure it's the correct wallet.
     * @param _numberOfTokens: The number of tokens to mint.
     * @dev This function can only be called by the contract owner as it is a free mint.
     */
    function mintFreeTiger(address _to, uint _numberOfTokens) public onlyOwner {
        uint totalSupply = totalSupply();
        require(_numberOfTokens <= _tigerReserve, "Not enough BHS left in reserve");
        require(totalSupply + _numberOfTokens < 8001, "Purchase would exceed max supply of BHS");
        for(uint i = 0; i < _numberOfTokens; i++) {
            uint mintIndex = totalSupply + i;
            _safeMint(_to, mintIndex);
        }
        _tigerReserve -= _numberOfTokens;
    }
    /** 
     * Mint a number of BHS straight in the caller's wallet.
     * @param _numberOfTokens: The number of tokens to mint.
     */
    function mintTiger(uint _numberOfTokens) public payable {
        uint totalSupply = totalSupply();
        require(_saleIsActive, "Sale must be active to mint a Tiger");
        require(_numberOfTokens < 21, "Can only mint 20 tokens at a time");
        require(totalSupply + _numberOfTokens + _tigerReserve < 8001, "Purchase would exceed max supply of BHS");
        require(msg.value >= _tigerPrice * _numberOfTokens, "Ether value sent is not correct");
        for(uint i = 0; i < _numberOfTokens; i++) {
            uint mintIndex = totalSupply + i;
            _safeMint(msg.sender, mintIndex);
        }
    }
    function flipSaleState() public onlyOwner {
        _saleIsActive = !_saleIsActive;
    }
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
    // Might wanna adjust price later on.
    function setPrice(uint256 _newPrice) public onlyOwner() {
        _tigerPrice = _newPrice;
    }
    function getBaseURI() public view returns(string memory) {
        return _baseTokenURI;
    }
    function getPrice() public view returns(uint256){
        return _tigerPrice;
    }
    function tokenURI(uint256 tokenId) public override view returns(string memory) {
        return string(abi.encodePacked(_baseTokenURI, tokenId.toString()));
    }
    function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
        uint256 tokenCount = balanceOf(_owner);
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            for (uint i = 0; i < tokenCount; i++) {
                result[i] = tokenOfOwnerByIndex(_owner, i);
            }
            return result;
        }
    }
}