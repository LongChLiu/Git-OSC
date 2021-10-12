//
//  ProjectCommitDetailsController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/2/24.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class ProjectCommitDetailsController: UIViewController, ItemsController {
    
    let tableViewDelegate: RxTableViewSectionedReloadDelegate
    
    var disposeBag: DisposeBag = .init()
    
    var tableView: UITableView = .init()
    
    var cellInfo: [(String, RegisteredViewType)] = [("CommitsCell", .xib), ("CommitDetailsCell", .xib)]
    
    var viewModel: CommitDetailsViewModel
    
    let isRefreshable: Bool =  false
    
    let isPageable: Bool = false
    
    weak var delegate: PushableControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews() { [weak self] indexPath in
            guard let self = self else { return }
            //seciton1才有点击事件
            if indexPath.section == 1 {
                let commitDetail = self.viewModel.itemsValue[indexPath.row]
                if commitDetail.diff == "不支持预览该文件" { return }
                let fileName = commitDetail.pathNew.pathFileName
                let type: BlobFileType = .commitChanged(commit: self.viewModel.commit, path: commitDetail.pathNew)
                switch (fileName.isCodeFileName, fileName.isImageFileName) {
                case (true, _):
                    self.delegate?.pushHtmlControllerWith(type: type, navigation: self.navigationController)
                case (_, true):
                    self.delegate?.pushImageControllerWith(type: type, navigation: self.navigationController)
                    
                default:
                    Observable.just(String.Local.unsupportedFileType).bind(to: self.textHUD.rx.textShow).disposed(by: self.disposeBag)
                }
                
                
//                self.delegate?.pushFileControllerWith(type: .commitChanged(commit: self.viewModel.commit, path: commitDetail.pathNew), navigation: self.navigationController)
                
            }
        }
        //sectionHeaderView
        viewModel.contents.map { [nil, SectionTextView(text: "\(String($0[1].items.count))个文件发生了改变")] }.drive(tableView.rx.headerViews(delegate: tableViewDelegate)).disposed(by: disposeBag)
        //headerHeight
        viewModel.contents.map { _ in [0, .sectionHeight] }.drive(tableView.rx.headerHeights(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
    }
    
    init(viewModel: CommitDetailsViewModel, delegate: PushableControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.tableViewDelegate = .init(tableView: tableView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return "CommitsCell"
        default: return "CommitDetailsCell"
        }
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
