//
//  Section.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/3.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

///自定义Section
struct Section {
    var items: [RenderableObject]
}

extension Section : SectionModelType {
    init(original: Section, items: [RenderableObject]) {
        self = original
        self.items = items
    }
}

extension SharedSequenceConvertibleType where Element == [Section] {
    func asCellHeights() -> Driver<[[CGFloat]]> {
        return self.flatMapLatest { Driver.just($0.map({ $0.items.map { $0.contentHeight } }))} }
    func asCellHeightsWith(constant: CGFloat) -> Driver<[[CGFloat]]> {
        return self.flatMapLatest { Driver.just($0.map({ $0.items.map { _ in constant } }))} }
}

extension ObservableType where Element == [Section] {
    func asCellHeights() -> Observable<[[CGFloat]]> {
         return self.flatMapLatest { Observable.just($0.map({ $0.items.map { $0.contentHeight } }))} }
    
    func asCellHeightsWith(constant: CGFloat) -> Observable<[[CGFloat]]> {
        return self.flatMapLatest { Observable.just($0.map({ $0.items.map { _ in constant } }))} }
    }



