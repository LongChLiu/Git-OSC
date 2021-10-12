//
//  MineController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/20.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

fileprivate let infoCellID = "MineInfoCell"
fileprivate let portraitCellID = "MinePortraitCell"

class MineController: UIViewController, BaseControllerType, TableViewPresentable {
    
    var disposeBag: DisposeBag = .init()
    
    weak var delegate: PushableControllerDelegate?
    
    var tableView: UITableView = .init(frame: .zero, style: .grouped)
    
    var cellInfo: [(String, RegisteredViewType)] = [(portraitCellID, .xib), (infoCellID, .class)]
    
    var tableViewDelegate: RxTableViewSectionedReloadDelegate
    
    var viewModel: MineViewModel = .init()
    
    let logoutButton: ThemeButton = .init()
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        if indexPath == IndexPath.init(row: 0, section: 0) {
            return portraitCellID
        }
        return infoCellID
    }
    
    func setupCell(_ cell: UITableViewCell, with indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        //reset Layout
        tableView.snp.remakeConstraints { (maker) in
            maker.bottom.top.equalToSuperview()
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().offset(-16)
        }
        
        view.backgroundColor = tableView.backgroundColor
        
        let footerSuperView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: .screenWidth - 32, height: 100)))
        
        footerSuperView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(40)
        }
        
        logoutButton.setTitle(String.Local.logout, for: .normal)
        
        logoutButton.rx.tap.bind(to: CurrentUserManger.logout()).disposed(by: disposeBag)

        viewModel.content.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        viewModel.content.asCellHeights().drive(tableView.rx.cellHeights(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        viewModel.content.map { $0.map{ _ in 20 } }.drive(tableView.rx.headerHeights(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        viewModel.content.map {_ in [0, 100] }.drive(tableView.rx.footerHeighs(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        viewModel.content.map { _ in [nil, footerSuperView] }.drive(tableView.rx.footerViews(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    init(delegate: PushableControllerDelegate?) {
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
