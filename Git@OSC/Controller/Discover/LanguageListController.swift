//
//  LanguageListController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/21.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

fileprivate let cellID = "NormalTableViewCell"

class LanguageListController: UIViewController, ItemsController {
    
    weak var delegate: PushableControllerDelegate?
    
    var disposeBag: DisposeBag = .init()
    
    var isRefreshable: Bool = false
    
    var isPageable: Bool = false
    
    var tableView: UITableView = .init(frame: .zero)
    
    var cellInfo: [(String, RegisteredViewType)] = [(cellID, .class)]
    
    var tableViewDelegate: RxTableViewSectionedReloadDelegate
    
    var viewModel: ItemsViewModel<LanguagesStore>
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        return cellID
    }
    func setupCell(_ cell: UITableViewCell, with indexPath: IndexPath) {
        cell.accessoryType = .disclosureIndicator
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()        
        setupSubViews { [weak self] (indxPath) in
            guard let self = self else { return }
            let item = self.viewModel.itemsValue[indxPath.row]
            self.delegate?.pushItemsControllerWith(type: .languagedProjs(id: item.id, language: item.name), item: nil, navigation: self.navigationController)
        }

        
        
        let searchButton = UIBarButtonItem.init(barButtonSystemItem: .search, target: nil, action: nil)
        searchButton.rx.tap.bind { [weak self] (_) in
            self?.delegate?.pushProjectsSearchControllerWith(navigation: self?.navigationController)
            }.disposed(by: disposeBag)
        navigationItem.setRightBarButton(searchButton, animated: true)

        // Do any additional setup after loading the view.
    }
    
    init(viewModel: ItemsViewModel<LanguagesStore>, delegate: PushableControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.tableViewDelegate = .init(tableView: tableView)
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
