//
//  LoginController.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/9.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginController: UITableViewController, NetAccessableControllerType, Bindable, IndicatorPresentable, TextHUDPresentable {
    
    let disposeBag: DisposeBag = .init()
    
    weak var delegate: PushableControllerDelegate?
    
    let viewModel: LoginViewModel = .init()

    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
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
       return 3
    }
    
    func setupSubViews() {
        //headerView
        let view = UIView.init(frame: .init(origin: .zero, size: .init(width: CGFloat.screenWidth, height: 150)))
        let imageView = UIImageView.init(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
        view.addSubview(imageView)
        imageView.center = view.center
        imageView.image = #imageLiteral(resourceName: "loginLogo")
        tableView.tableHeaderView = view
        loginButton.setTitle(String.Local.login, for: .normal)
        
        setupIndicatorWith(backgroundStyle: .clear)
        setupTextHUD()
        
        navigationItem.title = String.Local.login
        emailTextField.text = CurrentUserManger.loginInfo.0
        passwordTextField.text = CurrentUserManger.loginInfo.1
       
        //return按钮
        Observable.merge([emailTextField.rx.controlEvent(.editingDidEndOnExit).asObservable(), passwordTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()]).bind { [weak self] (_) in
            guard let self = self else { return }
            if self.emailTextField.isFirstResponder {
                self.passwordTextField.becomeFirstResponder()
            }
            if self.passwordTextField.isFirstResponder && self.loginButton.isEnabled { self.request() }
        }.disposed(by: disposeBag)
        
        Observable.combineLatest(emailTextField.rx.text, passwordTextField.rx.text) { (email, password) -> Bool in
            email != "" && password != ""
        }.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        loginButton.rx.tap.bind { [weak self] (_) in
            
            self?.request()
            
        }.disposed(by: disposeBag)

    }

    func request() {
        Observable.just(()).bind(to: indicator.rx.show).disposed(by: disposeBag)
        //重新设置网络请求api
        self.viewModel.setActionRequestAsMain(.login(email: emailTextField.text, password: passwordTextField.text))

        self.viewModel.request.subscribe(onCompleted: { [weak self] in
            //保存账号密码
            CurrentUserManger.save(email: self?.emailTextField.text, password: self?.passwordTextField.text)
        }).disposed(by: disposeBag)
        
        self.viewModel.request.bind(to: CurrentUserManger.saveAccountInfo()).disposed(by: disposeBag)
        view.endEditing(true)
        bindRequestViews()
        
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
