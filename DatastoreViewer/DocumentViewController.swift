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
    
    var document: UIDocument?
    var store: Datastore?
    var types: [DatastoreType] = []
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
        indexController.filterTypes = types
        indexController.onSelect = { entity in
            self.show(entity: entity)
            return false
        }
        
        let noSelectionController = storyboard!.instantiateViewController(identifier: "NoSelection")

        splitController.indexController = indexController
        splitController.detailRootController = noSelectionController
        splitController.delegate = self
        
        contentStack.addArrangedSubview(splitController.view)
        addChild(splitController)

    }
    
    func show(entity: EntityReference) {
        if let store = store {
            store.get(allPropertiesOf: [entity]) { results in
                if let fetched = results[0].properties {
                let layout = DatastorePropertyLayout(with: fetched, from: store)
                DispatchQueue.main.async {
                    let detail = DatastorePropertyController(layout: layout)
                    self.splitController.showDetail(detail)
                }
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

extension DocumentViewController: DatastoreSupplier {
    var suppliedDatastore: Datastore {
        return store!
    }
}

extension DocumentViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            navigationController.isNavigationBarHidden = !splitController.isCollapsed
        }
    }
}

extension DocumentViewController: IndexDetailViewControllerDelegate {
    func indexDetailViewController(_ indexDetailViewController: IndexDetailViewController, willShowView viewController: UIViewController, ofType type: IndexDetailViewController.ViewType) {
        if type == .index {
            indexController?.clearSelection(animated: true)
        }
    }
}
