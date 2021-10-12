//
//  HtmlViewModel.swift
//  Git@OSC
//
//  Created by strayRed on 2019/5/29.
//  Copyright © 2019 Git@OSC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

final class HtmlViewModel: SampleViewModelType {

    var targetType: BlobFileType
    
    lazy var request: Observable<String> = { return self.sampleRequestObservable() }()
    
    init(type: BlobFileType) {
        self.targetType = type
    }

    func sampleRequestObservable() -> Observable<String> {
        return Observable<String>.create {[weak self] observer in
            guard let self = self else { return Disposables.create() }
            switch self.targetType {
            case .code(_), .readme(_):
                HttpsManager.request(with: self.targetType).responseJSON(completionHandler: ResponseHandler.handleResponseResult(observer: observer, target: self.targetType) { [weak self] in self?.handleSuccess(via: $0, observer: observer) } )
                //commitChanged返回data
            case .commitChanged(_, _):
                HttpsManager.request(with: self.targetType).responseData(completionHandler: ResponseHandler.handleResponseResult(observer: observer, target: self.targetType) { [weak self] in self?.handleSuccess(via: $0, observer: observer) } )
            default: fatalError("Unexpected type")
            }
            return Disposables.create()
        }
    }
    
    private func handleSuccess<T>(via value: T, observer: AnyObserver<String>) {
        if let htmlString = JSON(value).dictionary?["content"]?.string {
            switch self.targetType {
            //项目详情里的readme不用处理html
            case .readme(_): observer.onNext(htmlString)
                //代码里的html则需要处理
            default :  observer.onNext(self.getEditedHtml(from: htmlString))
            }
        }
        //commit changed files
        if let data = value as? Data, let htmlString = String(data: data, encoding: String.Encoding.utf8) {
            observer.onNext(self.getEditedHtml(from: htmlString))
        }
        observer.onCompleted()
    }
    
    ///拼接html
    private func getEditedHtml(from string: String) -> String {
        func getEscapeHtml(from string: String) -> String{
            var result = string
            
        
            
            result = result.replacingOccurrences(of: "&", with: "&amp;", options: String.CompareOptions.literal, range: Range(NSRange(location: 0, length: result.count), in: result))
            result = result.replacingOccurrences(of: "<", with: "&lt;", options: String.CompareOptions.literal, range: Range(NSRange(location: 0, length: result.count), in: result))
            result = result.replacingOccurrences(of: ">", with: "&gt;", options: String.CompareOptions.literal, range: Range(NSRange(location: 0, length: result.count), in: result))
            result = result.replacingOccurrences(of: "\"", with: "&quot;", options: String.CompareOptions.literal, range: Range(NSRange(location: 0, length: result.count), in: result))
            result = result.replacingOccurrences(of: "'", with: "&#39;", options: String.CompareOptions.literal, range: Range(NSRange(location: 0, length: result.count), in: result))
            return result
        }
        var language = ""
        switch targetType {
        case .code(let info):
            language = info[File.language] ?? ""
        case .commitChanged(_, let path):
            language = path.pathFileName.FileExtensionName
        default: break
        }
        let highlightJsPath = Bundle.main.path(forResource: "highlight.pack", ofType: "js") ?? ""
        let theme = "github"
        let themeCssPath = Bundle.main.path(forResource: theme, ofType: "css") ?? ""
        let codeCssPath = Bundle.main.path(forResource: "code", ofType: "css") ?? ""
        let formatPath = Bundle.main.path(forResource: "code", ofType: "html") ?? ""
        do {
            let format = try String.init(contentsOfFile: formatPath, encoding: String.Encoding.utf8)
            
            return String(format: format, themeCssPath, codeCssPath, highlightJsPath, language, getEscapeHtml(from: string))
            
        } catch (_) {
            return String.Local.unkownError
        }
    }
    
}
