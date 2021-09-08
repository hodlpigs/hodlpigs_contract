// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract HODLPigs is
    ERC721,
    Pausable,
    Ownable,
    ERC721Burnable,
    ERC721Enumerable
{
    // Total ledger (from deposits)
    mapping(uint256 => uint256) public ledger;
    // Total sales (for withdraw
    uint256 public saleLedger = 0;
    // Price per pig
    uint256 public constant pigPrice = 25000000000000000; //0.025
    // Max pig purchased in one Tx
    uint256 public constant maxPerTx = 20;
    // Max Pig supply
    uint256 public constant pigSupply = 30;

    uint256 public mintIdx = 0;

    // Events
    event Deposit(address indexed from, uint256 indexed tokenId, uint256 value);
    event Cracked(
        address indexed owner,
        uint256 indexed tokenId,
        uint256 value
    );

    constructor() ERC721("HODLPIGS", "HDPIG") {
        pause();
    }

    function withdraw() public onlyOwner {
        uint256 balance = saleLedger;
        saleLedger = 0;
        payable(msg.sender).transfer(balance);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function deposit(uint256 tokenId) public payable {
        // require that the sender owns the token
        require(ownerOf(tokenId) == msg.sender);
        ledger[tokenId] += msg.value;
        emit Deposit(msg.sender, tokenId, msg.value);
    }

    function crackPig(uint256 tokenId) public {
        // require that the sender owns the token
        require(ownerOf(tokenId) == msg.sender);

        uint256 balance = ledger[tokenId];
        ledger[tokenId] = 0;

        // effect
        burn(tokenId);
        payable(msg.sender).transfer(balance);
        emit Cracked(msg.sender, tokenId, balance);
    }

    function mintPig(uint256 numberOfTokens) public payable whenNotPaused {
        require(numberOfTokens <= maxPerTx, "Max of 20 Tokens");
        require(
            mintIdx + numberOfTokens <= pigSupply,
            "Purchase would exceed supply"
        );
        require(msg.value >= numberOfTokens * pigPrice, "Insuficient Ether");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 mintIdx = totalSupply();
            if (mintIdx < pigSupply) {
                _safeMint(msg.sender, mintIdx);
                mintIdx += 2;
                saleLedger += pigPrice;
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
