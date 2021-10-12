//
//  SettingController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/23.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift

class SettingController: UITableViewController, Bindable, NightModeChangable, IndicatorPresentable, TextHUDPresentable {
    var disposeBag: DisposeBag = .init()
    @IBOutlet var cells: [UITableViewCell]!
    @IBOutlet var normalLabels: [UILabel]!
    @IBOutlet weak var nightModeSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNmBindingWith(tableView: tableView)
        cells.forEach { self.setupNmBindingWith(cells: $0) }
        normalLabels.forEach {
            self.setupNmBindingWith(normalLabels: $0)
            $0.font = UIFont.middle.normal
        }
        
        setupTextHUD()
        setupIndicatorWith(backgroundStyle: .clear)
        
        nightModeSwitch.onTintColor = .theme
        
        nightModeSwitch.isOn = CurrentUserManger.isNightMode.value
        
        nightModeSwitch.rx.isOn.bind(to: CurrentUserManger.saveNightMode()).disposed(by: disposeBag)
        
        
        
        let cellSelected = self.tableView.rx.itemSelected.filter { $0 == IndexPath.init(row: 0, section: 0) }.map { _ in }.share(replay: 1)
        cellSelected.bind(to: indicator.rx.show).disposed(by: disposeBag)
        let result = cellSelected.bind(to: CurrentUserManger.cleanCache(via: disposeBag))
        result.map{_ in }.drive(indicator.rx.hide).disposed(by: disposeBag)
        result.drive(textHUD.rx.textShow).disposed(by: disposeBag)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    deinit {
        print("SettingController deinit")
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
