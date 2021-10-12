//
//  CollectionType+NSIndexPath.swift
//  RxDelegateCells
//
//  Created by Suyeol Jeon on 6/30/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import Foundation


extension Collection where Index == Int, Element: Collection, Element.Index == Int {
    subscript(indexPath: NSIndexPath) -> Element.Element? {
        if self.indices.contains(indexPath.section) && self[indexPath.section].indices.contains(indexPath.row) {
            return self[indexPath.section][indexPath.row]
        }
        return nil
    }

}
