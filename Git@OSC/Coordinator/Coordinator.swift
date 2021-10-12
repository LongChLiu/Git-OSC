//
//  RootCoordinator.swift
//  Git@OSC
//
//  Created by strayRed on 2018/11/9.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

/*-------------------------------*/

/*-------------------------------*/

import Foundation
import UIKit
import RxSwift

extension Coordinator: PushableControllerDelegate {
    func pushUserControllerWith(userId: Int64, userName: String, navigation: UINavigationController?) {
        let userViewController = PageViewController(controllers: [getItemsControllerWith(type: .userEvents(id: userId)), getItemsControllerWith(type: .userProjs(id: userId)), getItemsControllerWith(type: .staredProjs(id: userId)), getItemsControllerWith(type: .watchedProjs(id: userId))], titles: [String.Local.events, String.Local.projects, "Star", "Watch"])
        userViewController.navigationItem.title = userName
        navigation?.pushViewControllerHideTabBar(userViewController, animated: true)
    }
    
    func pushItemsControllerWith(type: ItemsType, item: Item? = nil, navigation: UINavigationController?) {
        navigation?.pushViewControllerHideTabBar(getItemsControllerWith(type: type, item: item), animated: true)
    }
    
    func pushItemControllerWith(type: ItemType, item: Item? = nil, navigation: UINavigationController?) {
        var controller = UIViewController()
        switch type {
        case .projsDetails(_):
            controller = ProjectDetailsController(viewModel: .init(store: .init(type: type, item: item as? Project)), delegate: self)
        default: break
        }
        navigation?.pushViewControllerHideTabBar(controller, animated: true)
    }
    
   
    func pushImageControllerWith(type: BlobFileType, navigation: UINavigationController?) {
        let imageController = ImageViewController(viewModel: .init(type: type))
        navigation?.pushViewController(imageController, animated: true)
    }
    func pushHtmlControllerWith(type: BlobFileType, navigation: UINavigationController?) {
        let htmlController = HtmlViewController.init(viewModel: .init(type: type))
        navigation?.pushViewController(htmlController, animated: true)
    }
    
    
    func pushLoginControllerWith(navigation: UINavigationController?) {
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let controller: LoginController = castOrFatalError(sb.instantiateInitialViewController())
        navigation?.pushViewControllerHideTabBar(controller, animated: true)
    }
    
    func pushProjectsSearchControllerWith(navigation: UINavigationController?) {
        navigation?.pushViewControllerHideTabBar(ProjectsSearchController.init(delegate: self), animated: true)
    }
    
    func pushSettingControlelrWith(navigation: UINavigationController?) {
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let controller: SettingController = castOrFatalError(sb.instantiateInitialViewController())
        navigation?.pushViewControllerHideTabBar(controller, animated: true)
    }
    
    func pushMineControllerWith(navigation: UINavigationController?) {
        navigation?.pushViewControllerHideTabBar(MineController.init(delegate: self), animated: true)
    }
    
    func pushIssueCreateControllerWith(projectID: Int64?, navigation: UINavigationController?) {
        let sb = UIStoryboard(name: "IssueCreate", bundle: nil)
        let controller: IssueCreateController = castOrFatalError(sb.instantiateInitialViewController())
        controller.projectID = projectID
        navigation?.pushViewController(controller, animated: true)
    }
    
}



/// Coordinator负责Controller之间的调度和为Controller提供ViewModel对象
final class Coordinator {
    
    private(set) var rootController: RootViewController?
    
    init() {
        //项目
        let projectsController = PageViewController(controllers: [getItemsControllerWith(type: .featuredProjs), getItemsControllerWith(type: .popularProjs), getItemsControllerWith(type: .latestProjs)], titles: [String.Local.featured, String.Local.popular, String.Local.latest])
        projectsController.navigationItem.title = String.Local.projects
        let projrctsNaviController = UINavigationController(rootViewController: projectsController)
        
        //发现
        let discoverNaviController = UINavigationController(rootViewController: LanguageListController.init(viewModel: .init(store: .init(type: .languageList)), delegate: self))
        
        ///我的
        let mineNaviControlelr: UINavigationController
        
        if CurrentUserManger.isLogin.value {
            mineNaviControlelr = UINavigationController(rootViewController: getMinePageController())
        }else {
            mineNaviControlelr = UINavigationController(rootViewController: getLoginController())
        }
        
        rootController = RootViewController(childControllers: [projrctsNaviController, discoverNaviController, mineNaviControlelr], titles: [String.Local.projects, String.Local.discover, String.Local.mine], normalImgs: [#imageLiteral(resourceName: "projects"), #imageLiteral(resourceName: "discover"), #imageLiteral(resourceName: "mine")], selectedImgs: [#imageLiteral(resourceName: "projects_selected"), #imageLiteral(resourceName: "discover_selected"), #imageLiteral(resourceName: "mine_selected")])
    }
    
    private func getLoginController() -> UIViewController {
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let controller: LoginController = castOrFatalError(sb.instantiateInitialViewController())
        controller.delegate = self
        return controller
    }
    
    ///我的TabBar部分
    private func getMinePageController() -> UIViewController {
        let userId = CurrentUserManger.id
        
        return MinePageController(controllers:
                                    [
                                        getItemsControllerWith(type: .selfEvents),
                                     
                                        getItemsControllerWith(type: .userProjs(id: userId)),
                                     
                                        getItemsControllerWith(type: .staredProjs(id: userId)),
                                     
                                        getItemsControllerWith(type: .watchedProjs(id: userId))
                                    ],
                                  
                                  titles: [String.Local.events,String.Local.projects, "Star", "Watch"],
                                  delegate: self
        );
    }
    
    
    private func getItemsControllerWith(type: ItemsType, item: Item? = nil) -> UIViewController {
        
        switch type {
            
            case .featuredProjs, .popularProjs, .latestProjs, .userProjs(_), .languagedProjs(_), .staredProjs(_), .watchedProjs(_):
                
                return ProjectsController(viewModel: .init(store: .init(type: type)), delegate: self)
                
            case .userEvents(_), .selfEvents:
                
                return EventsController(viewModel: .init(store: .init(type: type)), delegate: self)
                
            case .files(let info):
                return FileTreeController(viewModel: .init(store: .init(type: type)), fileInfo: info, delegate: self)
                
            case .projectCommits(_):
                return ProjectCommitsController(viewModel: .init(store: .init(type: type)), delegate: self)
                
            case .commitsDetails(_, _):
                guard let item = item as? ProjectCommit else  { break }
                return ProjectCommitDetailsController(viewModel: .init(store: .init(type: type), commit: item), delegate: self)
                
            case .projectIssues(_):
                return IssuesController(viewModel: .init(store: .init(type: type)), delegate: self)
                
            case .issueNotes(_, _):
                guard let item = item as? Issue else  { break }
                return IssueNotesController(viewModel: .init(store: .init(type: type), issue: item), delegate: self)
            
        default: break
            
        }
        fatalError("Unexpected controller type")
    }
    
    

}
