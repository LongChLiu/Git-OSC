//
//  IssueNotesController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/4/25.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let DescriptionCellId = "IssueDescriptionCell"

fileprivate let NoteCellId = "IssueNoteCell"

final class IssueNotesController: UIViewController, ItemsController {
    
    var tableView: UITableView = .init(frame: .zero, style: .grouped)
    
    var cellInfo: [(String, RegisteredViewType)] = [(DescriptionCellId, .class), (NoteCellId, .xib)]
    
    var tableViewDelegate: RxTableViewSectionedReloadDelegate
    
    var disposeBag: DisposeBag = .init()
    
    weak var delegate: PushableControllerDelegate?
    
    var viewModel: IssueNotesViewModel
    
    var isRefreshable: Bool = true
    
    var isPageable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews(itemSelected: { _ in })

        //sectionTitleViews
        viewModel.contents.map { [nil, SectionTextView(text: "\($0[1].items.count)条评论")] }.drive(tableView.rx.headerViews(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        //sectionTitleViewsHeight
        viewModel.contents.map { _ in [0.1, CGFloat.sectionHeight] }.drive(tableView.rx.headerHeights(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        
        
        if let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? IssueDescriptionCell {
            //js获取高度
            cell.wkViewDidLoad.drive(cell.handleHtml(withViewHeightHandler: { [weak self] (wkWebVieHeight) in
                guard let self = self else { return }
                //更新cell高度
                let issusHeight = [self.viewModel.issue.contentHeight + wkWebVieHeight]
                let notesHeights = self.viewModel.itemsValue.map { $0.contentHeight }
                Driver.just([issusHeight, notesHeights]).drive(self.tableView.rx.cellHeights(delegate: self.tableViewDelegate)).disposed(by: self.disposeBag)
            })).disposed(by: disposeBag)
        }
        // Do any additional setup after loading the view.
    }
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return DescriptionCellId
        default: return NoteCellId
        }
    }
    
    init(viewModel: IssueNotesViewModel, delegate: PushableControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.tableViewDelegate = RxTableViewSectionedReloadDelegate(tableView: tableView)
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
