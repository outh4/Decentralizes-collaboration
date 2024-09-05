// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedDocument {
    
    struct Document {
        string ipfsHash;
        address owner;
        mapping(address => bool) sharedWith;
    }

    mapping(uint => Document) public documents;
    uint public documentCount;

    // Event for when a document is created
    event DocumentCreated(uint documentId, string ipfsHash, address owner);

    // Event for sharing document
    event DocumentShared(uint documentId, address with);

    // Function to add a document (using IPFS for storage)
    function addDocument(string memory _ipfsHash) public {
        documentCount++;
        Document storage newDocument = documents[documentCount];
        newDocument.ipfsHash = _ipfsHash;
        newDocument.owner = msg.sender;
        emit DocumentCreated(documentCount, _ipfsHash, msg.sender);
    }

    // Function to share a document with another user
    function shareDocument(uint _documentId, address _user) public {
        require(documents[_documentId].owner == msg.sender, "Only owner can share the document");
        documents[_documentId].sharedWith[_user] = true;
        emit DocumentShared(_documentId, _user);
    }

    // Function to check if a user has access to a document
    function hasAccess(uint _documentId, address _user) public view returns (bool) {
        return documents[_documentId].owner == _user || documents[_documentId].sharedWith[_user];
    }
}
