//
//  Deleagte.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/22.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation

protocol PushableControllerDelegate: class {
    func pushUserControllerWith(userId: Int64, userName: String, navigation: UINavigationController?)
    func pushItemsControllerWith(type: ItemsType, item: Item?, navigation: UINavigationController?)
    func pushItemControllerWith(type: ItemType, item: Item?, navigation: UINavigationController?)
    
    func pushImageControllerWith(type: BlobFileType, navigation: UINavigationController?)
    func pushHtmlControllerWith(type: BlobFileType, navigation: UINavigationController?)
    
    func pushLoginControllerWith(navigation: UINavigationController?)
    
    
    func pushProjectsSearchControllerWith(navigation: UINavigationController?)
    
    func pushSettingControlelrWith(navigation: UINavigationController?)
    
    func pushMineControllerWith(navigation: UINavigationController?)
    
    func pushIssueCreateControllerWith(projectID: Int64?, navigation: UINavigationController?)
}

