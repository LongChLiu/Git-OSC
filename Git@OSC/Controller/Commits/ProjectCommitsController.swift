//
//  ProjectCommitsController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/22.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class ProjectCommitsController: UIViewController, ItemsController {
    
    let tableViewDelegate: RxTableViewSectionedReloadDelegate
    
    var tableView: UITableView = .init()
    
    var disposeBag: DisposeBag = .init()
    
    weak var delegate: PushableControllerDelegate?
    
    var viewModel: ItemsViewModel<ProjectCommitsStore>
    
    var cellInfo: [(String, RegisteredViewType)] = [("CommitsCell", .xib)]
    
    var isRefreshable: Bool = true
    
    var isPageable: Bool = true
    
    private let dropdownView = HCDropdownView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews() { [weak self] indexPath in
            guard let commit = self?.viewModel.itemsValue[indexPath.row], let projectId = commit.projectId.value else { return }
            self?.delegate?.pushItemsControllerWith(type: .commitsDetails(proId: projectId, comId: commit.id), item: commit, navigation: self?.navigationController)
        }
        
        
        let currentBranch = Observable.merge([viewModel.dataSource.map { $0.first?.branches.first ?? "" }.asObservable(), dropdownView.rx.itemSelected.asObservable()]).filter {$0 != "" }.share(replay: 1)
        
        currentBranch.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        
        //更改branch后更改网络请求参数
        currentBranch.bind(onNext: { [weak self] in
            self?.viewModel.reset(requestParam: ["page": 1, "ref_name": $0])
        }).disposed(by: disposeBag)
        
        dropdownView.rx.itemSelected.bind { [weak self] (_) in
            self?.tableView.mj_header!.beginRefreshing()
            self?.tableView.mj_footer!.state = .idle
        }.disposed(by: disposeBag)
        

    
        //首次请求到branch列表
        viewModel.dataSource.map { $0.first?.branches.toArray(limited: nil) ?? [] }.filter { [weak self] in $0 != self?.dropdownView.dropTitles && $0 != [] }.drive(dropdownView.rx.contents).disposed(by: disposeBag)
        
        
        let navigationBtn = UIBarButtonItem(title: String.Local.branch, style: .done, target: nil, action: nil)
        navigationBtn.rx.tap.bind { [weak self ] _ in
            guard let self = self else { return }
            if self.dropdownView.isOpen {
                self.dropdownView.hide()
                return
            }
            self.dropdownView.show(from: self.navigationController, menuTabelViewOrigin: CGPoint(x: CGFloat.screenWidth/2, y: 0))
        }.disposed(by: disposeBag)
        navigationItem.setRightBarButton(navigationBtn, animated: true)
        
        dropdownView.contentBackgroundColor = .normalBackgroud
        dropdownView.titleTextColor = .normalText
        
        // Do any additional setup after loading the view.
    }
    
    init(viewModel: ItemsViewModel<ProjectCommitsStore>, delegate: PushableControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.tableViewDelegate = .init(tableView: self.tableView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    func didSelectItem(atRow row: Int) {
//        let currentBranch = dropdownView.dropTitles[row]
//        if viewModel.requestParam?["ref_name"] as? String == currentBranch  { return }
//        let newParam: [String: Any] = ["page": 1, "ref_name": currentBranch]
//        viewModel.reset(requestParam: newParam)
//        tableView.mj_header.beginRefreshing()
//        tableView.mj_footer.state = .idle
//    }
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        return "CommitsCell"
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
