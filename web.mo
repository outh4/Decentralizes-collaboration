actor DecentralizedDoc {
  type Document = {
    id: Nat;
    owner: Principal;
    ipfsHash: Text;
  };

  var documents: [Document] = [];

  public func addDocument(ipfsHash: Text): async Text {
    let document = {
      id = documents.size();
      owner = Principal.fromText("<insert your Principal ID>");
      ipfsHash = ipfsHash;
    };
    documents := documents # [document];
    return "Document added successfully";
  }

  public query func getDocuments(): async [Document] {
    return documents;
  }
};
