//
//  ApiManager.swift
//  ShorternUrl
//
//  Created by CuongNVT on 1/10/20.
//  Copyright © 2020 CuongNVT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

typealias CompleteResult = (_ result: Result) -> Void

// MARK: - Enum
enum myError: Error {
    case errorRx(String)
}

enum Result {
    case success(String, String)
    case failure(myError)
}

// MARK: - Class API
class ApiManager {
    // MARK: - Property
    static let shared: ApiManager = {
        return ApiManager()
    }()
    
    public let shorternUrlAPI : PublishSubject<Result> = PublishSubject()
    
    // MARK: - Func
    func ShortenURL(URLToSorten:String) {
        if verifyUrl(urlString:URLToSorten) != false {
            guard let apiEndpoint = URL(string: "http://tinyurl.com/api-create.php?url=\(URLToSorten)") else {
                let error = myError.errorRx("http://tinyurl.com/api-create.php?url=\(URLToSorten)")
                shorternUrlAPI.onNext(.failure(error))
                return
            }
            didGetApi(url: apiEndpoint, complete: { [weak self] response in
                switch response {
                case .success(let shortURL, let date):
                    self?.shorternUrlAPI.onNext(.success(shortURL, date))
                case .failure(let error):
                    self?.shorternUrlAPI.onNext(.failure(error))
                }
            })
        } else {
            let error = myError.errorRx("\(URLToSorten) doesn't seem to be a valid URL or is blank")
            shorternUrlAPI.onNext(.failure(error))
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func didGetApi(url: URL, complete: @escaping CompleteResult) {
        let configuration = URLSessionConfiguration.default
        let sessionAPI = URLSession(configuration: configuration)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = sessionAPI.dataTask(with: request as URLRequest) { [weak self] (data, response, error) in
            guard let data = data else { return }
            guard let urlShortPare = String(data: data, encoding: .utf8) else {
                complete(.failure(myError.errorRx("Error pare data url")))
                return
            }
            let date = self?.didGetCurrentDate() ?? ""
            complete(.success(urlShortPare, date))
        }
        dataTask.resume()
    }
    
    func didGetCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US")
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
