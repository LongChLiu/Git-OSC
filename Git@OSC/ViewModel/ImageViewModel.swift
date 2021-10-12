//
//  ImageViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/29.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

final class ImageViewModel: SampleViewModelType {
    
    var targetType: BlobFileType
    
    lazy var request: Observable<UIImage> = { return self.sampleRequestObservable() }()
    
    
    init(type: BlobFileType) {
        self.targetType = type
    }
    
    
    //代码里的图片和分支提交里的图片都用这个方法请求
    func sampleRequestObservable() -> Observable<UIImage> {
        //有缓存直接返回
        if let image = SDImageCache.shared.imageFromCache(forKey: targetType.url.absoluteString) {
            return Observable.just(image)
        }
        
        return createSampleRequest(with: { [weak self] (observer) in
            guard let self = self else { return  }
            HttpsManager.request(with: self.targetType).responseData(completionHandler: ResponseHandler.handleResponseResult(observer: observer, target: self.targetType, success: { [weak self] (data) in
                guard let self = self else { return }
                if let image = UIImage(data: data) {
                    observer.onNext(image)
                    observer.onCompleted()
                    //手动存储缓存
                    SDImageCache.shared.store(image, forKey: self.targetType.url.absoluteString, completion: nil)
                }
                else {
                    observer.onError(RequestError.noData(self.targetType.noDataDescription))
                }

            }))
        })
    }
}
