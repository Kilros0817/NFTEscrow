// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "./INFT.sol";

contract SecondNFT is Initializable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable {
    
    address public FirstNFT;
    mapping (uint256 => uint256) public tokenMap;  //second tokenID -> first tokenID
    mapping (address => uint256[]) public tokensByOwner;
    mapping (uint256 => uint256) tokenIndex;
    
    function initialize() public initializer {
        __ERC721_init("First NFT", "FST");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Ownable_init();
    }

    function setFirstNFT(address firstNFT) public onlyOwner {
        FirstNFT = firstNFT;
    }

    function escrowFristNFT(uint256 tokenID, address account) public {
        require(msg.sender == FirstNFT, "You are not firstnft contract!");
        uint256 tokenId = totalSupply() + 1;
        tokenMap[tokenId] = tokenID;
        mint(account, tokenId);
    }

    function mint(address account, uint256 tokenId) public{
        tokensByOwner[account].push(tokenId);
        tokenIndex[tokenId] = tokensByOwner[account].length - 1;
        _safeMint(msg.sender, tokenId);
    }

    function swap(uint256 tokenID) public {
        require(msg.sender == ownerOf(tokenID), "You are not the token owner!");
        INFT(FirstNFT).transferFrom(address(this), msg.sender, tokenMap[tokenID]);
        delete tokenMap[tokenID];
        _burn(tokenID);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override(ERC721Upgradeable, IERC721Upgradeable) {
        tokenIndex[tokensByOwner[from][tokensByOwner[from].length - 1]] = tokenIndex[tokenId];
        tokensByOwner[from][tokenIndex[tokenId]] = tokensByOwner[from][tokensByOwner[from].length - 1];
        tokensByOwner[from].pop();
        tokensByOwner[to].push(tokenId);
        tokenIndex[tokenId] = tokensByOwner[to].length - 1;
        super.transferFrom(from, to , tokenId);
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) 
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        tokenIndex[tokensByOwner[msg.sender][tokensByOwner[msg.sender].length - 1]] = tokenIndex[tokenId];
        tokensByOwner[msg.sender][tokenIndex[tokenId]] = tokensByOwner[msg.sender][tokensByOwner[msg.sender].length - 1];
        tokensByOwner[msg.sender].pop();
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool) 
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}