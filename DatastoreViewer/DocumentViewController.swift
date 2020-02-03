// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/12/2019.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit
import Datastore
import DatastoreKit
import IndexDetailViewController
import Logger
import ViewExtensions

let documentViewChannel = Channel("DocumentView")

class DocumentViewController: UIViewController {
    
    // TODO: is there any advantage in just making this the split view controller?
    
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: InterchangeDocument?
    var splitController: IndexDetailViewController!
    var indexController: DatastoreIndexController!
    var skipDefault = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let document = document else {
            documentNameLabel.text = "Missing Document"
            return
        }
        
        let name = document.fileURL.deletingPathExtension().lastPathComponent
        self.documentNameLabel.text = name

        splitController = IndexDetailViewController()

        indexController = DatastoreIndexController()
        let noSelectionController = storyboard!.instantiateViewController(identifier: "NoSelection")

        splitController.indexController = indexController
        splitController.detailRootController = noSelectionController
        
        contentStack.addArrangedSubview(splitController.view)
        addChild(splitController)

        indexController.filterTypes = document.types
        indexController.onSelect = { entity in self.show(entity: entity) }
    }
    
    func show(entity: EntityReference) {
        if let store = document?.store {
            store.get(allPropertiesOf: [entity]) { results in
                let fetched = results[0]
                let keys = Array(fetched.keys)
                let sections = [keys]
                DispatchQueue.main.async {
                    let detail = DatastorePropertyController(for: fetched, sections: sections, store: store)
                    self.splitController.showDetail(detail)
                }
            }
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

extension DocumentViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            navigationController.isNavigationBarHidden = !splitController.isCollapsed
        }
    }
}
