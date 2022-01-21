//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Registrum {
    uint256 public documentId = 0;
    address[] public owners;
    address admin;
    mapping(address => bool) whitelistedFirms;
    mapping(uint256 => string) public documents;
    mapping(uint256 => string) public proofs;

    event DocumentRegistered(
        uint256 indexed documentId,
        string documentHash,
        string proofHash
    );
    event DocumentTransferred(
        uint256 indexed documentId,
        string updatedProofHash
    );

    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "Registrum: Only admin can call this function"
        );
        _;
    }
    modifier onlyWhitelisted() {
        require(
            whitelistedFirms[msg.sender],
            "Registrum: Only whitelisted firms can call this function"
        );
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function transferDocument(
        uint256 _documentId,
        string memory updatedProofHash
    ) public onlyWhitelisted {
        proofs[_documentId] = updatedProofHash;
        emit DocumentTransferred(_documentId, updatedProofHash);
    }

    function registerDocument(
        string memory documentHash,
        string memory proofHash
    ) public onlyWhitelisted {
        documents[documentId] = documentHash;
        proofs[documentId] = proofHash;
        documentId++;
        emit DocumentRegistered(documentId, documentHash, proofHash);
    }

    function whitelistFirm() public {
        whitelistedFirms[msg.sender] = true;
    }
}
