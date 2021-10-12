//
//  RxTableViewSectionedReloadHeightDelegate.swift
//  SimpleTableViewController
//
//  Created by Suyeol Jeon on 6/29/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

public class RxTableViewSectionedReloadDelegate: NSObject, UITableViewDelegate, RxTableViewDelegateType {
    
    init(tableView: UITableView?) {
        super.init()
        tableView?.delegate = self
    }
    
    public var cellHeights: [[CGFloat]] = []
    public var headerHeights: [CGFloat] = []
    public var footerHeights: [CGFloat] = []
    public var headerViews: [UIView?] = []
    public var footerViews: [UIView?] = []


    public func tableView(_ tableView: UITableView, observedCellHeights: [[CGFloat]]) {
        if cellHeights != observedCellHeights {
            self.cellHeights = observedCellHeights
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        
    }

    public func tableView(_ tableView: UITableView, observedHeaderHeights: [CGFloat]) {
        self.headerHeights = observedHeaderHeights
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }

     public func tableView(_ tableView: UITableView, observedFooterHeights: [CGFloat]) {
        self.footerHeights = observedFooterHeights
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, observedHeaderViews: [UIView?]) {
        headerViews = observedHeaderViews
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, observedFooterViews: [UIView?]) {
        footerViews = observedFooterViews
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    //MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //indexPath.section < cellHeights.count && indexPath.row < cellHeights[indexPath.section].count
        

        guard 0..<self.cellHeights.count ~= indexPath.section &&
            0..<self.cellHeights[indexPath.section].count ~= indexPath.row
            else { return 44 }
        return self.cellHeights[indexPath.section][indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if 0..<self.headerHeights.count ~= section {
            return headerHeights[section]
        }
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if 0..<self.headerViews.count ~= section {
            return headerViews[section]
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if 0..<self.footerHeights.count ~= section {
            return footerHeights[section]
        }
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if 0..<self.footerViews.count ~= section {
            return footerViews[section]
        }
        return nil
    }
    
    
    
    

    
}
