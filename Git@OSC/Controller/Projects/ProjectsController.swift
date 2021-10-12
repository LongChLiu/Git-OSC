//
//  ProjectTableViewController.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/12.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Alamofire

class ProjectsController: UIViewController, ItemsController {
    
    lazy var tableViewDelegate: RxTableViewSectionedReloadDelegate = .init(tableView: self.tableView)
    
    let isRefreshable: Bool = true
    
    let isPageable: Bool = true
    
    let tableView: UITableView = .init()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    let cellInfo: [(String, RegisteredViewType)] = [("ProjectCell", .xib)]
    
    let viewModel: ItemsViewModel<ProjectsStore>
    
    weak var delegate: PushableControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews() { [weak self] indexPath in
            guard let project = self?.viewModel.itemsValue[indexPath.row] else { return }
            self?.delegate?.pushItemControllerWith(type: ItemType.projsDetails(project.id), item: project, navigation: self?.navigationController)
        }
    }
    
    required init(viewModel: ItemsViewModel<ProjectsStore>, delegate: Delegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func cellReuseIdentifier(for indexPath: IndexPath) -> String {
        return "ProjectCell"
    }
    
    deinit {
        print("ProjectsController deinit")
    }

    
    // MARK: - Table view data source



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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
