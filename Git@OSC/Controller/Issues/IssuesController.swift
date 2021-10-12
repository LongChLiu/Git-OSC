//
//  IssuesController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

fileprivate let cellID = "IssueCell"

class IssuesController: UIViewController, ItemsController {
    
    var isRefreshable: Bool = true
    
    var isPageable: Bool = true

    var tableView: UITableView = .init()
    
    var cellInfo: [(String, RegisteredViewType)] = [(cellID, .xib)]
    
    var tableViewDelegate: RxTableViewSectionedReloadDelegate
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: ItemsViewModel<IssuesStore>
    
    var delegate: PushableControllerDelegate?
    
    private var projectID: Int64? {
        switch self.viewModel.store.targetType {
        case .projectIssues(let id): return id
        default: return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews { [weak self] (indexPath) in
            guard let issue = self?.viewModel.itemsValue[indexPath.row] else { return }
            self?.delegate?.pushItemsControllerWith(type: .issueNotes(proId: issue.projectId, issueId: issue.id), item: issue, navigation: self?.navigationController)
        }

        // Do any additional setup after loading the view.
        //rightButton
        let rightButtonItem = UIBarButtonItem(title: "Issue", style: .done, target: nil, action: nil)
        navigationItem.setRightBarButton(rightButtonItem, animated: true)
        rightButtonItem.rx.tap.bind {[weak self] (_) in

            self?.delegate?.pushIssueCreateControllerWith(projectID: self?.projectID, navigation: self?.navigationController)
        }.disposed(by: disposeBag)
    }
    
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        return cellID
    }
    
    init(viewModel: ItemsViewModel<IssuesStore>, delegate: PushableControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.tableViewDelegate = RxTableViewSectionedReloadDelegate.init(tableView: tableView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
