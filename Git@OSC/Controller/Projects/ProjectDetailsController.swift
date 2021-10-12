//
//  ProjectDetailsController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/3.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxDataSources
import MonkeyKing
import RxSwift
import RxCocoa

fileprivate let nameCellID = "ProjectNameCell"
fileprivate let descriptionCellID = "ProjectDescriptionCell"
fileprivate let bascInfoCellID = "ProjectBasicInfoCell"
fileprivate let normalCellID = "NormalTableViewCell"

class ProjectDetailsController: UIViewController, NetAccessableControllerType, TableViewPresentable, HintViewsPresentable, UITableViewDelegate {
    
    enum ButtonType {
        case star
        case watch
    }
    
    lazy var tableViewDelegate: RxTableViewSectionedReloadDelegate = .init(tableView: self.tableView)
    
    var cellInfo: [(String, RegisteredViewType)] = [(nameCellID, .xib), (descriptionCellID, .xib), (bascInfoCellID, .xib), (normalCellID, .class)]
    
    weak var delegate: PushableControllerDelegate?
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let disposeBag = DisposeBag()
    
    let viewModel: ProjectDetailsViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        setupTableView()
        tableView.rx.itemSelected.bind {[weak self] (indexPath) in
            //不添加会引起循环引用
            guard let self = self, let project = self.viewModel.itemValue else { return }
            switch(indexPath.section, indexPath.row) {
            case (1, 1): self.delegate?.pushUserControllerWith(userId: project.owner?.id ?? 0, userName: project.owner?.name ?? "", navigation: self.navigationController)
            case (1, 2): self.delegate?.pushHtmlControllerWith(type: BlobFileType.readme(id: project.id), navigation: self.navigationController)
            case (1, 3):
                //fileinfo
                let fileInfo = [File.fileName: project.name ?? "", File.currentPath: "", File.namespace: project.namespace ?? "", File.language: project.language ?? "", File.projectId: String(project.id)]
                self.delegate?.pushItemsControllerWith(type: ItemsType.files(info: fileInfo), item: nil, navigation: self.navigationController)
            case (1, 4): self.delegate?.pushItemsControllerWith(type: .projectIssues(id: project.id), item: nil, navigation: self.navigationController)
            case (1, 5): self.delegate?.pushItemsControllerWith(type: .projectCommits(id: project.id), item: nil, navigation: self.navigationController)
            default: break
            }
        }.disposed(by: disposeBag)
        setupIndicatorWith(backgroundStyle: .clear, showNow: true)
        setupTextHUD()
        setupErrorView()
        
        request()

        //dataSource
        viewModel.contents.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //导航栏标题
        viewModel.navigationTitle.drive(navigationItem.rx.title).disposed(by: disposeBag)
        
        //导航栏右侧按钮
        Observable.just(viewModel.initItem.value).concat(viewModel.changeObservable).bind(to: setupRightButtonItem()).disposed(by: disposeBag)
        
        //star&watch
        if let descriptionCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as? ProjectDescriptionCell {
            descriptionCell.starButton.rx.tap.bind(to: tapActionWith(button: descriptionCell.starButton, label: descriptionCell.starLabel, type: .star)).disposed(by: disposeBag)
            descriptionCell.watchButton.rx.tap.bind(to: tapActionWith(button: descriptionCell.watchButton, label: descriptionCell.watchLabel, type: .watch)).disposed(by: disposeBag)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func setupRightButtonItem<O: ObservableType>() -> (_ source: O) -> Disposable where O.Element == Project? {
        return { source in
            return source.bind(onNext: { [weak self] (project) in
                //防止重复调用
                guard let self = self, let project = project, self.navigationItem.rightBarButtonItem == nil else {
                    return
                }
                let moreButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "projectDetails_more"), style: .done, target: nil, action: nil)
                self.navigationItem.setRightBarButton(moreButton, animated: true)
                //点击事件
                moreButton.rx.tap.bind {[weak self] (_) in
                    guard let self = self else { return }
                    let shareView = ShareView.shared
                    shareView.set(contentBackgroundColor: .normalBackgroud, textColor: .normalText)
                    let projectURL = String(format: "https://git.oschina.net/%@", project.namespace ?? "")
                    let description = String(format: "我在关注%@的项目%@，你也来瞧瞧呗！%@", project.owner?.name ?? "", project.name ?? "", projectURL)
                    //info
                    let info: MonkeyKing.Info = (
                            title: project.name!,
                            description: description,
                            thumbnail: self.view.asImage(),
                            media: .url(URL(string: projectURL)!)
                    )
                    shareView.set(shareInfo: info) { mainWindow?.show(text: $0) }
                    shareView.addToMainWindow()
                }.disposed(by: self.disposeBag)
            })
        }
    }
    
    private func tapActionWith<O: ObservableType>(button: UIButton, label: UILabel, type: ButtonType) -> (_ source: O) -> Disposable where O.Element == () {
        return { source in
            return source.bind(onNext: { [weak self] (_) in
                guard let self = self else { return  }
                if !CurrentUserManger.isLogin.value {
                    self.delegate?.pushLoginControllerWith(navigation: self.navigationController)
                    return
                }
                var request: Observable<String>
                guard let nameSpace = self.viewModel.itemValue?.namespace?.replacingOccurrences(of: "/", with: "%2F") else { fatalError("Unexpected namespace") }
                Observable.just(()).bind(to: self.indicator.rx.show).disposed(by: self.disposeBag)
                //获取网络请求数据流
                switch type {
                case .star:
                    let api: ActionAPI = button.isSelected ? .unstarProject(nameSpace) : .starProject(nameSpace)
                    request = self.viewModel.actionRequestWith(api: api)!.share(replay: 1)
                case .watch:
                    let api: ActionAPI = button.isSelected ? .unwatchProject(nameSpace) : .watchProject(nameSpace)
                    request = self.viewModel.actionRequestWith(api: api)!.share(replay: 1)
                }
                //binding
                request.map { _ in }.bind(to: self.indicator.rx.hide).disposed(by: self.disposeBag)
                request.asTextHUDConfig(hideIn: nil).drive(self.textHUD.rx.textConfig).disposed(by: self.disposeBag)
                request.map { _ in !button.isSelected }.asDriver(onErrorJustReturn: button.isSelected).drive(button.rx.isSelected).disposed(by: self.disposeBag)
                request.asDriver(onErrorJustReturn: label.text!).map({ (count) in
                    switch type {
                    case .star: return count + "starts"
                    case .watch: return count + "watchs"
                    }
                }).drive(label.rx.text).disposed(by: self.disposeBag)
            })
        }

    }
    
    func request() {
        bindRequestViews()
    }
    
    func setupCell(_ cell: UITableViewCell, with indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row != 0 {
            cell.accessoryType = .disclosureIndicator
        }
    }
    
    init(viewModel: ProjectDetailsViewModel, delegate: Delegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        switch(indexPath.section, indexPath.row) {
        case (0, 0): return nameCellID
        case (0, 1): return descriptionCellID
        case (1, 0): return bascInfoCellID
        case (1, _): return normalCellID
        default: fatalError("Unexpected IndexPath")
        }
    }
    


    //MARK:- Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let project = viewModel.itemValue  else { return 0 }
        switch(indexPath.section, indexPath.row) {
        case (0, 0): return project.nameCellHeight
        case (0, 1): return project.descriptionCellHeight
        case (1, 0): return project.basicInfoCellHeight
        case (1, _): return viewModel.normalItems[indexPath.row - 1].contentHeight
        default: fatalError("Unexpected IndexPath")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0.1
        default: return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return nil
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    deinit {
        print("ProjectDetailsController deinit")
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
