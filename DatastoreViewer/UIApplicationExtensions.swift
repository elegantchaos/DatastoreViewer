// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 20/12/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import UIKit

extension UIApplication {
    static func cacheDirectory() -> URL {
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("unable to get system cache directory - serious problems")
        }
        
        return cacheURL
    }
    
    static func documentsDirectory() -> URL {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("unable to get system docs directory - serious problems")
        }
        
        return documentsURL
    }
    
    static func newDocumentURL(withPathExtension pathExtension: String) -> URL {
        let directory = cacheDirectory()
        
        let fm = FileManager.default
        var name = "Untitled"
        var count = 1
        repeat {
            let url = directory.appendingPathComponent(name).appendingPathExtension(pathExtension)
            if !fm.fileExists(atPath: url.path) {
                return url
            }
            count += 1
            name = "Untitled \(count)"
        } while true
    }
    
}
