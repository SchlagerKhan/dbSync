//
//  helper.swift
//  dbSync
//
//  Created by Kalle Hansson on 2017-07-31.
//  Copyright © 2017 SchlagerKhan. All rights reserved.
//

import Foundation
import SwiftyJSON
import FileKit

class Helper: NSObject {
    func createFile(path : Path, isDir: Bool = false) {
        do {
            if (isDir) {
                try path.createDirectory();
            } else {
                try path.createFile();
            }
        } catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
        }
    }
}
