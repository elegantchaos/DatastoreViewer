//// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
////  Created by Developer on 06/02/2020.
////  All code (c) 2020 - present day, Elegant Chaos Limited.
//// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Datastore
import DatastoreKit
import UIKit

class StoreDocument: DatastoreDocument {
    static let pathExtension = "store"
    
    override func save(to url: URL, for saveOperation: UIDocument.SaveOperation, completionHandler: ((Bool) -> Void)? = nil) {
        guard saveOperation == .forCreating else {
            super.save(to: url, for: saveOperation, completionHandler: completionHandler)
            return
        }

        // if we're creating, import some sample data
        let store = Datastore(context: managedObjectContext)
        store.decode(json: DatastoreViewer.sampleJSON) { result in
            switch result {
                case .failure:
                    completionHandler?(false)
                
                case .success:
                    super.save(to: url, for: saveOperation, completionHandler: completionHandler)
            }
        }
    }
}
