//
//  ProjectDetailsViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/3.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import SwiftyJSON

class ProjectDetailsViewModel: ItemViewModelType {
    
    typealias S = ProjectStore
    
    lazy var request: Observable<()> = { return self.requestObservable() }()
    
    lazy var dataSource: Driver<Project?> = { return self.dataSource() }()
    
    lazy var requestParam: [String : Any]? = { return self.defaultParam }()
    
    let store: ProjectStore
    
    let uuid = UUID()
    
    let initItem: BehaviorRelay<Project?>

    required init(store: ProjectStore) {
        self.store = store
        initItem = BehaviorRelay(value: store.item)
    }
    
    var contents: Driver<[Section]> {
        return dataSource.map { project in
            guard let project = project else { return [] }
            var items = self.normalItems as [RenderableObject]
            items.insert(project, at: 0)
            return [Section(items: [project, project]), Section(items: items)] }
    }
    
    var navigationTitle: Driver<String?> {
        return dataSource.map { $0?.name }
    }
    
}

extension ProjectDetailsViewModel {
    var normalItems: [NormalObject] {
        let ownerString = NSMutableAttributedString(string: String.Local.owner + " ", attributes: TextAttributes().foregroundColor(.gray).font(UIFont.middle.normal))
        
        let ownerName = NSMutableAttributedString(string: itemValue?.owner?.name ?? "", attributes: TextAttributes().foregroundColor(.normalText).font(UIFont.middle.normal))

        ownerString.append(ownerName)
        
        return [NormalObject(image: UIImage(named: "projectDetails_owner"), attributedText: ownerString), NormalObject(image: UIImage(named: "projectDetails_readme"), text: String.Local.readme), NormalObject(image: UIImage(named: "projectDetails_code"), text: String.Local.code), NormalObject(image: UIImage(named: "projectDetails_issue"), text: String.Local.issue), NormalObject(image: UIImage(named: "projectDetails_branch"), text: String.Local.branch)]
    }
    
    func actionRequestWith<T>(api: ActionAPI) -> Observable<T>? {
        return Observable<String>.create({ (observer) -> Disposable in
            HttpsManager.request(with: api).responseString(completionHandler: ResponseHandler.handleResponseResult(observer: observer, target: api, success: { (string) in
                let json = JSON.init(parseJSON: string)
                if let count = json.dictionary?["count"]?.stringValue {
                    observer.onNext(count)
                    observer.onCompleted()
                }
                else {
                    observer.onError(RequestError.parseFailed(String.Local.parseFailed))
                }
            }))
            return Disposables.create()
        }) as? Observable<T>
    }
    
}
