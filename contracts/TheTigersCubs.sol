// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
import "./Ownable.sol";
import "./ERC721.sol";


contract TheTigersGuild {
    function ownerOf(uint256 tokenId) public view virtual override returns (address);
}


contract TheTigersCubs is ERC721, Ownable {
    using Strings for uint256;

    string _baseMetadataUri;
    address _tigersAddress;
    bool public _saleIsActive = false;
    uint public _cubsSupply = 4444;
    mapping(uint => uint) _adoptedCubs;

    constructor(string memory baseMetadataUri, string memory tigersAddress) ERC721("TheTigersCubs", "TTC") {
        setTigersAddress(tigersAddress);
        setBaseMetadataUri(baseMetadataUri);
    }

    function setTigersAddress(address memory tigersAddress) public onlyOwner {
        _tigersAddress = tigersAddress;
    }

    function getTigersAddress() public view returns (address memory) {
        return _tigersAddress;
    }

    function setBaseMetadataUri(string memory baseMetadataUri) public onlyOwner {
        _baseMetadataUri = baseMetadataUri;
    }

    function getBaseMetadataUri() public view returns (string memory) {
        return _baseMetadataUri;
    }

    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        return string(abi.encodePacked(_baseMetadataUri, tokenId.toString()));
    }

    function flipSaleState() public onlyOwner {
        _saleIsActive = !_saleIsActive;
    }

    function getCubIdByTigetId(tigerId) public view returns (uint memory) {
        return _adoptedCubs[tigerId];
    }
    
    function adopt(uint tigerId) public {
        // 1. Проверка на то, открыта ли продажа
        require(_saleIsActive, "Sale must be active to adpot a cub");
        
        // 2. Проверка на то, является ли msg.sender, владельцем тигра с id tigerId
        TheTigersGuild theTigersGuildContract = TheTigersGuild(_tigersAddress);
        require(msg.sender == theTigersGuildContract.ownerOf(tigerId), "msg.sender is not the owner of tiger with id tigerId");

        // 3. Проверка на то, связан ли тигр с id tigerId с тигрёнком
        require(_adoptedCubs[tigerId] == 0, "Cub for tiger with id tigerId is already adopted");

        // 4. Проверка на то, не распроданы ли все тигрята
        uint totalSupply = totalSupply();
        require(totalSupply <= _cubsSupply - 1, "Purchase would exceed max supply of cubs");

        uint cubId = totalSupply + 1;
        _safeMint(msg.sender, cubId);
        _adoptedCubs[tigerId] = cubId;
    }

    function tokensOfOwner(address _owner) external view returns (uint256[] memory ) {
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