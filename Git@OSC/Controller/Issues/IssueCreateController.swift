//
//  IssueCreateController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/30.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssueCreateController: UITableViewController, NetAccessableControllerType, IndicatorPresentable, TextHUDPresentable, NightModeChangable {
    
    let viewModel: IssueCreateViewModel = .init()
    
    var disposeBag: DisposeBag = .init()
    
    var delegate: PushableControllerDelegate?
    
    var projectID: Int64? 
    
    @IBOutlet var cells: [UITableViewCell]!
    @IBOutlet weak var submitButton: ThemeButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    lazy var tableViewDelegate =  {
        return RxTableViewSectionedReloadDelegate.init(tableView: self.tableView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNmBindingWith(tableView: tableView)
        cells.forEach {[weak self] in self?.setupNmBindingWith(cells: $0) }
        
        Observable.just([SectionTextView(text: "标题"), SectionTextView(text: "描述")]).bind(to: tableView.rx.headerViews(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        Observable<[CGFloat]>.just([40, 40, 40]).bind(to: tableView.rx.headerHeights(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        Observable<[[CGFloat]]>.just([[44], [100], [44]]).bind(to: tableView.rx.cellHeights(delegate: tableViewDelegate)).disposed(by: disposeBag)
        
        submitButton.setTitle("提交", for: .normal)
        
        titleTextField.tintColor = .normalText
        titleTextField.textColor = .normalText
        descriptionTextView.tintColor = .normalText
        descriptionTextView.textColor = .normalText
        
        tableView.rx.itemSelected.bind { [weak self] (indxPath) in
            switch indxPath.section {
            case 0: self?.titleTextField.becomeFirstResponder()
            case 1: self?.descriptionTextView.becomeFirstResponder()
            default: break
            }
        }.disposed(by: disposeBag)
        
        
        Observable.combineLatest(titleTextField.rx.text, descriptionTextView.rx.text) { (title, description) -> Bool in
            title != ""
        }.bind(to: submitButton.rx.isEnabled).disposed(by: disposeBag)
        
        let textViewReturnFilter = descriptionTextView.rx.text.changed.filter { $0?.last == "\n" }.share(replay: 1)
        
        //过滤换行
        textViewReturnFilter.bind { [weak self] (text) in
            self?.descriptionTextView.text = String(text?.dropLast() ?? [])
        }.disposed(by: disposeBag)
        
        Observable.merge([titleTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(), textViewReturnFilter.mapAsVoid()]).bind { [weak self] (_) in
            guard let self = self else { return }
            if self.titleTextField.isFirstResponder {
                self.descriptionTextView.becomeFirstResponder()
                return
            }
            if self.descriptionTextView.isFirstResponder {
                if self.submitButton.isEnabled { self.request() }
                self.view.endEditing(true)
        }
            }.disposed(by: disposeBag)

        setupIndicatorWith(backgroundStyle: .clear)
        setupTextHUD()
        
        submitButton.rx.tap.bind {[weak self] (_) in
            self?.request()
        }.disposed(by: disposeBag)
        
   

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func request() {
        self.viewModel.setActionRequestAsMain(.createIssue(proID: self.projectID!, title: self.titleTextField.text ?? "", description: self.descriptionTextView.text))
        self.bindRequestViews()
        viewModel.request.bind(to: textHUD.rx.textShow).disposed(by: disposeBag)
        viewModel.request.subscribe(onCompleted: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
