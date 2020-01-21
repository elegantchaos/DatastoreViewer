// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/12/2019.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit
import Datastore
import DatastoreKit
import ViewExtensions

class DocumentViewController: UIViewController {
    
    // TODO: is there any advantage in just making this the split view controller?
    
    @IBOutlet weak var documentNameLabel: UILabel!
    @IBOutlet weak var indexView: UIView!
    
    var document: InterchangeDocument?
    var splitController: UISplitViewController!
    var indexController: DatastoreIndexController!
    var detailNavigationController: UINavigationController!
    
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
        let indexNavigationController = UINavigationController(rootViewController: indexController)
        indexNavigationController.title = "Master"
        indexNavigationController.isNavigationBarHidden = true
        
        let noSelectionController = storyboard!.instantiateViewController(identifier: "NoSelection")
        detailNavigationController = UINavigationController(rootViewController: noSelectionController)
        detailNavigationController.title = "Detail"
        detailNavigationController.isNavigationBarHidden = true
        detailNavigationController.delegate = self
        splitController.viewControllers = [indexNavigationController, detailNavigationController]

        indexController.filterTypes = ["person", "book"]
        indexController.onSelect = { entity in self.show(entity: entity) }
    }
    
    func show(entity: EntityReference) {
        let detail = DatastoreEntityController()
        detailNavigationController.pushViewController(detail, animated: true)
        detailNavigationController.isNavigationBarHidden = false
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
            navigationController.isNavigationBarHidden = true
        }
    }
}
