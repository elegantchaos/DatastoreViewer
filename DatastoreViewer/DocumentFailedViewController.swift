// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit

class DocumentFailedViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
        
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true)
    }
}
