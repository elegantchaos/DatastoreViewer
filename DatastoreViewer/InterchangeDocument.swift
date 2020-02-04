// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/12/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit
import Datastore
import ApplicationExtensions

enum DocumentError: Error {
  case unrecognizedContent
  case corruptDocument
  case archivingFailure
  
  var localizedDescription: String {
    switch self {
      
    case .unrecognizedContent:
      return NSLocalizedString("File is an unrecognised format", comment: "")
    case .corruptDocument:
      return NSLocalizedString("File could not be read", comment: "")
    case .archivingFailure:
      return NSLocalizedString("File could not be saved", comment: "")
    }
  }
}

class InterchangeDocument: UIDocument {
    static let filenameExtension = "store-interchange"

    static var sampleJSON: String {
        Bundle.main.stringResource(named: "SampleData", withExtension: "json")
    }
    
    var json = InterchangeDocument.sampleJSON
    var store: Datastore? = nil
    var types: [DatastoreType] = []
    
    override func open(completionHandler: ((Bool) -> Void)? = nil) {
        super.open() { result in
            if (result) {
                Datastore.load(name: self.fileURL.lastPathComponent, json: self.json) { result in
                    switch result {
                        case .failure:
                            completionHandler?(false)
                        
                        case .success(let store):
                            store.getAllEntityTypes() { types in
                                self.store = store
                                self.types = types
                                DispatchQueue.main.async {
                                    completionHandler?(true)
                                }
                            }
                    }
                    
                }
            }
        }
    }
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        guard let data = json.data(using: .utf8) else {
            throw DocumentError.archivingFailure
        }
        
        return data
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data else {
          throw DocumentError.unrecognizedContent
        }
        
        guard let text = String(data: data, encoding: .utf8) else {
            throw DocumentError.corruptDocument
        }
        
        json = text
    }
}

