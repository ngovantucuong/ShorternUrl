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
    public let urlEntryTextField: PublishSubject<String> = PublishSubject()
    public let urlShorten: PublishSubject<String> = PublishSubject()
    
    func ShortenURL(URLToSorten:String, topVC: UIViewController) -> String {
        if verifyUrl(urlString:URLToSorten) != false{
            guard let apiEndpoint = URL(string: "http://tinyurl.com/api-create.php?url=\(URLToSorten)")else {
                self.ErrorMessage(error:("Error: doesn't seem to be a valid URL") as String, topVC: topVC)
                return "" as String
            }
            do {
                let shortURL = try String(contentsOf: apiEndpoint, encoding: String.Encoding.ascii)
                self.urlShorten.onNext(shortURL)
                self.urlShorten.onCompleted()
                return shortURL as String
            } catch let Error{
                self.ErrorMessage(error:Error.localizedDescription, topVC: topVC)
                return URLToSorten as String
            }
        }else{
            self.ErrorMessage(error:"\(URLToSorten) doesn't seem to be a valid URL or is blank", topVC: topVC)
            return "" as String
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
    func ErrorMessage(error:String, topVC: UIViewController) {
        let ErrorMessageAlert = UIAlertController(title:"Error", message: error, preferredStyle: .alert)
        ErrorMessageAlert.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))
        topVC.present(ErrorMessageAlert, animated: true, completion: nil)
        print("Error:\(error)")
    }
}
