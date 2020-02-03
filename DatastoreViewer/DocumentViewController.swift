// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/12/2019.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit
import Datastore
import DatastoreKit
import ViewExtensions
import Logger

let documentViewChannel = Channel("DocumentView")

class DocumentViewController: UIViewController {
    
    // TODO: is there any advantage in just making this the split view controller?
    
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: InterchangeDocument?
    var splitController: UISplitViewController!
    var indexController: DatastoreIndexController!
    var detailNavigationController: UINavigationController!
    var skipDefault = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let document = document else {
            documentNameLabel.text = "Missing Document"
            return
        }
        
        let name = document.fileURL.deletingPathExtension().lastPathComponent
        self.documentNameLabel.text = name

        splitController = UISplitViewController()
        splitController.delegate = self
        splitController.preferredDisplayMode = .allVisible

        indexController = DatastoreIndexController()
        let indexNavigationController = UINavigationController(rootViewController: indexController)
        indexNavigationController.title = "Master"
        indexNavigationController.isNavigationBarHidden = false
        
        let noSelectionController = storyboard!.instantiateViewController(identifier: "NoSelection")
        noSelectionController.navigationItem.leftBarButtonItem = splitController.displayModeButtonItem

        detailNavigationController = UINavigationController(rootViewController: noSelectionController)
        detailNavigationController.title = "Detail"
        detailNavigationController.delegate = self
        
        splitController.viewControllers = [indexNavigationController, detailNavigationController]
        contentStack.addArrangedSubview(splitController.view)
        addChild(splitController)

        indexController.filterTypes = document.types
        indexController.onSelect = { entity in self.show(entity: entity) }
    }
    
    func show(entity: EntityReference) {
        if let store = document?.store, let navigation = splitController.viewControllers.last as? UINavigationController {
            let isCollapsed = splitController.isCollapsed
            store.get(allPropertiesOf: [entity]) { results in
                let fetched = results[0]
                let keys = Array(fetched.keys)
                let sections = [keys]
                DispatchQueue.main.async {
                    let detail = DatastorePropertyController(for: fetched, sections: sections, store: store)
                    navigation.popToRootViewController(animated: false)
                    navigation.pushViewController(detail, animated: isCollapsed)
                    navigation.isNavigationBarHidden = !isCollapsed
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

extension DocumentViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        documentViewChannel.log("changing to \(displayMode)")
        switch displayMode {
            case .allVisible:
                detailNavigationController.isNavigationBarHidden = !svc.isCollapsed && (detailNavigationController.viewControllers.count == 1)
            case .primaryHidden:
                detailNavigationController.isNavigationBarHidden = false
            default:
                break
        }
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        print("collapsing \(secondaryViewController) onto \(primaryViewController)")
        guard let nav = primaryViewController as? UINavigationController, let _ = nav.topViewController as? DatastoreIndexController else {
            return true
        }

        documentViewChannel.log("collapsing")
        let shouldSkipDefaultBehaviour = skipDefault
        skipDefault = false
        return shouldSkipDefaultBehaviour
    }
}
