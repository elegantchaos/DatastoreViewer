//
//  DocumentViewController.swift
//  DatastoreViewer
//
//  Created by Developer on 20/12/2019.
//  Copyright © 2019 Elegant Chaos. All rights reserved.
//

import UIKit
import Datastore
import DatastoreKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: InterchangeDocument?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let document = document else {
            documentNameLabel.text = "Missing Document"
            return
        }
        
        let name = document.fileURL.lastPathComponent
        self.documentNameLabel.text = name
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}

extension DocumentViewController: DatastoreViewContextSupplier {
    var viewDatastore: Datastore {
        return document!.store!
    }
}
