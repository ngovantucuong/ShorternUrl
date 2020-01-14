//
//  ViewModel.swift
//  ShorternUrl
//
//  Created by CuongNVT on 1/10/20.
//  Copyright © 2020 CuongNVT. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class HomeViewModel {
    // MARK: - Property
    public let urlEntryTextField: PublishSubject<String?> = PublishSubject<String?>()
    public let shorternUrls: PublishSubject<Result> = PublishSubject()
    let disposeBag = DisposeBag()
    var arrOriginUrl: BehaviorSubject<[(String, String)]> = BehaviorSubject(value: [])
    var arrData: [(String, String)] = []
    
    // MARK: - Init
    init() {
        // Observe 
        urlEntryTextField.asObserver().distinctUntilChanged().subscribe { (event) in
            switch event {
            case .next(let str):
                self.didGetShorternUrl(shorternUrl: str ?? "")
            case .error(let error):
                print(error)
            case .completed:
                print("Complete TextField")
            }
        }.disposed(by: disposeBag)
        
        ApiManager.shared.shorternUrlAPI.asObserver().subscribe { [weak self] (event) in
            switch event {
            case .next(let result):
                switch result {
                case .success(let urlStr, let date):
                    self?.shorternUrls.onNext(.success(urlStr, date))
                    self?.arrData.append((urlStr, date))
                    self?.arrOriginUrl.onNext(self?.arrData ?? [])
                case .failure(let error):
                    self?.shorternUrls.onNext(.failure(error))
                }
            case .error(let error): print(error.localizedDescription)
            case .completed: print("Complete API")
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Func
    func didGetShorternUrl(shorternUrl: String) {
        guard !shorternUrl.isEmpty else { return }
        ApiManager.shared.ShortenURL(URLToSorten: shorternUrl)
        
    }
    
    
}
