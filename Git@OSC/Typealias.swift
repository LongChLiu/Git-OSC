//
//  Global.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/15.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

typealias Item = Object & Mappable & RenderableObject

typealias RenderableTableViewCell = UITableViewCell & RenderableCell

/// 所有TableViewCell的类型
typealias TableViewCell = UITableViewCell & RenderableCell & NightModeChangable & Bindable

/// 可以显示各种提示视图的ViewController
typealias HintViewsPresentable = TextHUDPresentable & IndicatorPresentable & ErrorViewPresentable









