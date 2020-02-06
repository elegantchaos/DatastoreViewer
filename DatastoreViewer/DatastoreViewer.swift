// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/12/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit
import ApplicationExtensions

@UIApplicationMain class DatastoreViewer: BasicApplication {
    class var sampleJSON: String {
        Bundle.main.stringResource(named: "SampleData", withExtension: "json")
    }

    override func open(file url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        // Reveal / import the document at the URL
        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else { return false }

        documentBrowserViewController.revealDocument(at: url, importIfNeeded: true) { (revealedDocumentURL, error) in
            if let error = error {
                // Handle the error appropriately
                print("Failed to reveal the document at URL \(url) with error: '\(error)'")
                return
            }
            
            // Present the Document View Controller for the revealed URL
            documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
        }

        return true
    }
}
