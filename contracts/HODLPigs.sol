// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Pigs is ERC721, Pausable, Ownable, ERC721Enumerable {
    using SafeMath for uint256;
    // Total ledger (from deposits, PigId -> eth)
    mapping(uint256 => uint256) public ledger;
    uint256 public totalLedger;
    // Price per pig
    uint256 public constant pigPrice = 0.001 ether; //0.001
    // Max pig purchased in one Tx
    uint256 public constant maxPerTx = 20;
    // Max Pig supply
    uint256 public constant ORIGINAL_PIG_SUPPLY = 2000;

    uint256 public mintIdx = 0;

    // Events
    event Deposit(address indexed from, uint256 indexed tokenId, uint256 value);
    event Cracked(
        address indexed owner,
        uint256 indexed tokenId,
        uint256 value
    );

    constructor() ERC721("TESTPIGS", "TESTPIG") {
        reservePigs();
        pause();
    }

    function drain() public onlyOwner {
        uint256 drainable = address(this).balance;

        drainable = drainable.sub(totalLedger);

        payable(msg.sender).transfer(drainable);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function deposit(uint256 tokenId) public payable {
        //check if pig exists
        require(_exists(tokenId), "Pig has been cracked or is not minted");

        ledger[tokenId] = ledger[tokenId].add(msg.value);
        totalLedger = totalLedger.add(msg.value);
        emit Deposit(msg.sender, tokenId, msg.value);
    }

    function crackPig(uint256 tokenId) public {
        // require that the sender owns the token
        require(
            ownerOf(tokenId) == msg.sender,
            "Only owner can crack open a pig"
        );
        require(ledger[tokenId] > 0, "Pig is empty");

        uint256 balance = ledger[tokenId];
        ledger[tokenId] = 0;
        totalLedger = totalLedger.sub(balance);
        

        // effect
        _burn(tokenId);
        payable(msg.sender).transfer(balance);
        emit Cracked(msg.sender, tokenId, balance);
    }

    function mintPig(uint256 numberOfTokens) public payable whenNotPaused {
        require(numberOfTokens <= maxPerTx, "Max of 10 tokens per transaction");
        require(
            mintIdx + numberOfTokens <= ORIGINAL_PIG_SUPPLY,
            "Purchase would exceed max supply"
        );
        require(
            msg.value >= numberOfTokens * pigPrice,
            "Insuficient Ether Provided"
        );

        for (uint256 i = 0; i < numberOfTokens; i++) {
            if (mintIdx < ORIGINAL_PIG_SUPPLY) {
                _safeMint(msg.sender, mintIdx);
                mintIdx += 1;
            }
        }
    }

    function reservePigs() public onlyOwner {
        require(mintIdx == 0, "can only reserve first 30 pigs");

        for (uint256 i = 0; i < 30; i++) {
            _safeMint(msg.sender, mintIdx);
            mintIdx += 1;
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
