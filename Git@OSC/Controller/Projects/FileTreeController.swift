//
//  FileTreeController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/11.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FileTreeController: UIViewController, ItemsController {
    
    lazy var tableViewDelegate: RxTableViewSectionedReloadDelegate = .init(tableView: self.tableView)
    
    let cellInfo: [(String, RegisteredViewType)] = [("NormalTableViewCell", .class)]
    
    var isRefreshable: Bool = false
    
    var isPageable: Bool  = false
    
    let viewModel: ItemsViewModel<FilesStore>
    
    let disposeBag: DisposeBag = DisposeBag()
    
    let tableView: UITableView = .init()
    
    weak var delegate: PushableControllerDelegate?
    
    private var fileInfo: [String: String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentPath = fileInfo[File.currentPath] else { fatalError() }
        setupSubViews() { [weak self] indexPath in
            guard let self = self else { return }
            let file = self.viewModel.itemsValue[indexPath.row]
            //重新设置文件名和路径
            self.fileInfo[File.fileName] = file.name
            self.fileInfo[File.currentPath] = currentPath + file.name + "/"
            switch file.fileType {
            //文件
            case .blob:
                //代码或者图片
                switch (file.isCodeFile, file.isImageFile) {
                case (true, _):
                    self.delegate?.pushHtmlControllerWith(type: .code(info: self.fileInfo), navigation: self.navigationController)
                case (_, true):
                    self.delegate?.pushImageControllerWith(type: .image(info: self.fileInfo), navigation: self.navigationController)
                default:
                    Observable.just(String.Local.unsupportedFileType).bind(to: self.textHUD.rx.textShow).disposed(by: self.disposeBag)
                }
            //下一个路径
            case .tree: self.delegate?.pushItemsControllerWith(type: ItemsType.files(info: self.fileInfo), item: nil, navigation: self.navigationController)
            case .unknown: Observable.just(String.Local.unknownFileType).bind(to: self.textHUD.rx.textShow).disposed(by: self.disposeBag)
            }}
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    
    init(viewModel: ItemsViewModel<FilesStore>, fileInfo: [String: String], delegate: PushableControllerDelegate?) {
        self.viewModel = viewModel
        self.fileInfo = fileInfo
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        return "NormalTableViewCell"
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
