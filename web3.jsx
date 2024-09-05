import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import DecentralizedDocument from './abis/DecentralizedDocument.json';
import { create } from 'ipfs-http-client';

const ipfs = create({ url: 'https://ipfs.infura.io:5001/api/v0' });

function App() {
  const [account, setAccount] = useState('');
  const [contract, setContract] = useState(null);
  const [documentHash, setDocumentHash] = useState('');
  const [documents, setDocuments] = useState([]);

  useEffect(() => {
    const loadBlockchainData = async () => {
      const web3 = new Web3(Web3.givenProvider || 'http://localhost:8545');
      const accounts = await web3.eth.requestAccounts();
      setAccount(accounts[0]);

      const networkId = await web3.eth.net.getId();
      const networkData = DecentralizedDocument.networks[networkId];
      if (networkData) {
        const contractInstance = new web3.eth.Contract(DecentralizedDocument.abi, networkData.address);
        setContract(contractInstance);
      } else {
        window.alert('Smart contract not deployed to detected network.');
      }
    };

    loadBlockchainData();
  }, []);

  const uploadDocument = async (event) => {
    event.preventDefault();
    const file = event.target.files[0];
    const result = await ipfs.add(file);
    const ipfsHash = result.path;
    await contract.methods.addDocument(ipfsHash).send({ from: account });
    setDocumentHash(ipfsHash);
  };

  return (
    <div>
      <h1>Decentralized Document Collaboration</h1>
      <p>Your Account: {account}</p>
      <input type="file" onChange={uploadDocument} />
      <p>Uploaded IPFS Hash: {documentHash}</p>
    </div>
  );
}

export default App;
