//
//  RxTableViewHeightDelegateType.swift
//  SimpleTableViewController
//
//  Created by Suyeol Jeon on 6/29/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

public protocol RxTableViewDelegateType {
    
    var cellHeights: [[CGFloat]] { get set }
    var headerHeights: [CGFloat] { get set }
    var footerHeights: [CGFloat] { get set }
    var headerViews: [UIView?] { get set }
    var footerViews: [UIView?] { get set }
    
    func tableView(_ tableView: UITableView, observedCellHeights: [[CGFloat]])
    func tableView(_ tableView: UITableView, observedHeaderHeights: [CGFloat])
    func tableView(_ tableView: UITableView, observedFooterHeights: [CGFloat])
    func tableView(_ tableView: UITableView, observedHeaderViews: [UIView?])
    func tableView(_ tableView: UITableView, observedFooterViews: [UIView?])
}
