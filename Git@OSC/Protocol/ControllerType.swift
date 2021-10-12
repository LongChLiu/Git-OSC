//
//  Controller.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/4.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseControllerType: Bindable, HasDelegate where Delegate == PushableControllerDelegate, Self: UIViewController { }

protocol NetAccessableControllerType: BaseControllerType, NetAccessable {
    associatedtype V: BaseViewMoelType
    var viewModel: V { get }
}





