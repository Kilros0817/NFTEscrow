// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "./INFT.sol";

contract FirstNFT is Initializable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable {
    
    uint256 public allowTime; 
    address public SecondNFT;
    mapping(address => uint256[]) tokensByOwner;
    mapping(uint256 => uint256) tokenIndex;
    
    function initialize() public initializer {
        __ERC721_init("Second NFT", "SCT");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Ownable_init();
    }

    function mint() public payable {
        require(msg.value >= 0.01 ether, "Insufficient!");
        require(block.timestamp <= allowTime, "Can't mint anymore!");
        uint256 tokenID = totalSupply() + 1;
        tokensByOwner[msg.sender].push(tokenID);
        tokenIndex[tokenID] = tokensByOwner[msg.sender].length - 1;
        _safeMint(msg.sender, tokenID);
    }

    function setAllowLimit(uint256 time) public onlyOwner {
        allowTime = time;
    }

    function setSecondNFT(address secondNFT) public onlyOwner {
        SecondNFT = secondNFT;
    }

    function escrow(uint256 tokenId, address account) public {
        INFT(SecondNFT).escrowFirstNFT(tokenId, account);
        transferFrom(msg.sender, SecondNFT, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override(ERC721Upgradeable, IERC721Upgradeable) {
        require(ownerOf(tokenId) == from, "You are not the nft owner!");
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