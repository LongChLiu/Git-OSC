//
//  UITableView+RxCellHeight.swift
//  SimpleTableViewController
//
//  Created by Suyeol Jeon on 6/29/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {
    public func cellHeights<Delegate: RxTableViewDelegateType & UITableViewDelegate, O: ObservableType>(delegate: Delegate) -> (_ source: O) -> Disposable where O.Element == [[CGFloat]] {
        return { source in
//            return source
//                // converts `Driver<[[Observable<CGFloat>]]>` to `Driver<[[CGFloat]]>`
//                .flatMap { sections -> Driver<[[CGFloat]]> in
//                    Driver.combineLatest(sections.map { rows in
//                        Driver.combineLatest(rows)
//                    })
//                }
                return source.distinctUntilChanged().subscribeForObject { delegate.tableView(self.base, observedCellHeights: $0) }
//                .subscribeProxyDelegateForObject(object: self.base, delegate: delegate, retainDelegate: false) {
//                    (_: RxTableViewDelegateProxy, cellHeights) -> Void in
//                    delegate.tableView(self.base, observedCellHeights: cellHeights)
//            }
        }
    }
    
    public func headerHeights<Delegate: RxTableViewDelegateType & UITableViewDelegate, O: ObservableType>(delegate: Delegate) -> (_ source: O) -> Disposable where O.Element == [CGFloat] {
        return { source in
//            return source
//                .flatMap { sections -> Driver<[CGFloat]> in
//                    Driver.combineLatest(sections)
//                }
                return source.distinctUntilChanged().subscribeForObject { delegate.tableView(self.base, observedHeaderHeights: $0) }
            }
        }
    
    public func footerHeighs<Delegate: RxTableViewDelegateType & UITableViewDelegate, O: ObservableType>(delegate: Delegate) -> (_ source: O) -> Disposable where O.Element == [CGFloat] {
        return { source in
            return source.distinctUntilChanged().subscribeForObject { delegate.tableView(self.base, observedFooterHeights: $0) }
            }
        }
    
    public func headerViews<Delegate: RxTableViewDelegateType & UITableViewDelegate, O: ObservableType>(delegate: Delegate) -> (_ source: O) -> Disposable where O.Element == [UIView?] {
        return { source in
            return source.distinctUntilChanged().subscribeForObject { delegate.tableView(self.base, observedHeaderViews: $0) }
        }
    }
    
    public func footerViews<Delegate: RxTableViewDelegateType & UITableViewDelegate, O: ObservableType>(delegate: Delegate) -> (_ source: O) -> Disposable where O.Element == [UIView?] {
        return { source in
            return source.distinctUntilChanged().subscribeForObject { delegate.tableView(self.base, observedFooterViews: $0) }
        }
    }

}
