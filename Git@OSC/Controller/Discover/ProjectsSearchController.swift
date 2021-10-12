//
//  ProjectsSearchController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/22.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit

class ProjectsSearchController: UIViewController, UISearchBarDelegate {
    
    private let projectsController: ProjectsController
    private let searchBar: UISearchBar = .init()
    private let line: UILabel = .init()
    private var isFirstSearch: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        view.backgroundColor = .deepBackgroud
        
        line.backgroundColor = .normalText
        view.addSubview(line)
        line.snp.makeConstraints { (maker) in
            maker.top.equalTo(searchBar.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(0.5)
        }
        navigationItem.title = String.Local.projectsSearch
        


        // Do any additional setup after loading the view.
    }
    
    func setupSearchBar() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.frame = searchBar.bounds
            textField.backgroundColor = .normalBackgroud
            //设置为直角
            textField.borderStyle = .none
            if let leftView = textField.leftView as? UIImageView {
                //更改与放大镜的间隔
                leftView.contentMode = .center
                leftView.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
            }
            textField.textColor = .normalText
            textField.tintColor = .normalText
        }
        
        view.addSubview(searchBar)
        //更改背景颜色
        let backgroundImg = UIImage.imageWithColor(.normalBackgroud, andSize: .init(width: 1, height: 1))
        searchBar.setBackgroundImage(backgroundImg, for: .any, barMetrics: .default)
        searchBar.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }
        searchBar.becomeFirstResponder()
        
        searchBar.delegate = self
        searchBar.backgroundColor = .clear
        //光标颜色
        searchBar.tintColor = .theme
    }
    
    func setupResultView() {
        view.addSubview(projectsController.view)
        addChild(projectsController)
        projectsController.tableView.keyboardDismissMode = .onDrag
        projectsController.view.snp.makeConstraints { [weak self] (maker) in
            guard let self = self else { return }
            maker.top.equalTo(line.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            if #available(iOS 11, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
            else {
                maker.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            }
            
        }
    }
    
    func searchWith(text: String?) {
        self.projectsController.viewModel.store.targetType = ItemsType.projectsSearch(query: text ?? " ")
        //第一次搜索时才载入ResultView
        if isFirstSearch {
            setupResultView()
            isFirstSearch = false
        }
        else {
            self.projectsController.errorView.isHidden = true
            self.projectsController.request()
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.filter{ $0 != " " }
        if text == "" { return }
        searchWith(text: searchBar.text)
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //调用这个方法控制button的显示
        searchBar.setShowsCancelButton(true, animated: true)
        guard let cancelButton = searchBar.value(forKey: "_cancelButton") as? UIButton else {
            return
        }
        if String.preferredLanguage == "zh-Hans" {
            cancelButton.setTitle("取消", for: .normal)
        }
    }
    
    init(delegate: PushableControllerDelegate?) {
        self.projectsController = .init(viewModel: .init(store: .init(type: .projectsSearch(query: " "))), delegate: delegate)
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
