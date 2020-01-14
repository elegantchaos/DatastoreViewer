//
//  DocumentBrowserViewController.swift
//  DatastoreViewer
//
//  Created by Sam Deane on 20/12/2019.
//  Copyright © 2019 Elegant Chaos. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        let url = UIApplication.newDocumentURL(withPathExtension: ".store-interchange")
        let document = InterchangeDocument(fileURL: url)
        
        document.save(to: url, for: .forCreating) { saveResult in
            guard saveResult else {
                importHandler(nil, .none)
                return
            }

            importHandler(url, .move)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let document = InterchangeDocument(fileURL: documentURL)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        document.open(completionHandler: { (success) in
            if success {
                let controller = storyboard.instantiateViewController(withIdentifier: "Document") as! DocumentViewController
                controller.document = document
                self.present(documentController: controller)
            } else {
                let controller = storyboard.instantiateViewController(withIdentifier: "DocumentFailed") as! DocumentFailedViewController
                self.present(documentController: controller)
            }
        })
    }
    
    func present(documentController controller: UIViewController) {
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}

