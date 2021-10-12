//
//  EventsController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/1/11.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift



class EventsController: UIViewController, ItemsController {
    
    lazy var tableViewDelegate: RxTableViewSectionedReloadDelegate = .init(tableView: self.tableView)

    let cellInfo: [(String, RegisteredViewType)] = [("EventsCell", .xib)]
    
    let isRefreshable: Bool = true
    let isPageable: Bool = true
    let tableView: UITableView       = .init()
    
    let disposeBag: DisposeBag       = DisposeBag()
    
    weak var delegate: PushableControllerDelegate?
    
    var viewModel: ItemsViewModel<EventsStore>
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews() { [weak self] indexPath in
            
            guard let event = self?.viewModel.itemsValue[indexPath.row] else {
                return
            }
            
            self?.delegate?.pushItemControllerWith(type: .projsDetails(event.projectId) as ItemType, item: nil as Item?, navigation: self?.navigationController);
            
        }

        CurrentUserManger.isNightMode.bind { [weak self] (_) in
            
            self?.request()
            
        }.disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    }
    
    required init(viewModel: ItemsViewModel<EventsStore>, delegate: PushableControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        return "EventsCell"
    }
    
    deinit {
        print("EventsController deinit")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
