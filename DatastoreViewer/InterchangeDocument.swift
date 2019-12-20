//
//  Document.swift
//  DatastoreViewer
//
//  Created by Developer on 20/12/2019.
//  Copyright © 2019 Elegant Chaos. All rights reserved.
//

import UIKit

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

    static let sampleJSON = """
{
  "entities" : [
    {
      "name" : "Test",
      "identifier" : "C41DB873-323D-4026-95D1-603120B9ADF6",
      "type" : "person",
      "foo" : "bar",
    },
  ]
}
"""
    
    var json = InterchangeDocument.sampleJSON
    
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

