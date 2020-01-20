// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/12/2019.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit
import Datastore
import DatastoreKit
import ViewExtensions

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    @IBOutlet weak var indexView: UIView!
    
    var document: InterchangeDocument?
    var splitController: UISplitViewController!
    var indexController: DatastoreIndexController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let document = document else {
            documentNameLabel.text = "Missing Document"
            return
        }
        
        let name = document.fileURL.deletingPathExtension().lastPathComponent
        self.documentNameLabel.text = name

        splitController = indexView!.subviews[0].findViewController() as? UISplitViewController
        indexController = DatastoreIndexController()
        let masterNav = UINavigationController(rootViewController: indexController)
        masterNav.title = "Master"
        masterNav.isNavigationBarHidden = true
        let detail = DatastoreEntityController()
        let detailNav = UINavigationController(rootViewController: detail)
        detailNav.title = "Detail"
        detailNav.isNavigationBarHidden = true
        splitController.viewControllers = [masterNav, detailNav]

        indexController.filterTypes = ["person", "book"]
        indexController.onSelect = { entity in
            print("Selected \(entity)")
        }
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
