//
//  ViewController.swift
//  ShorternUrl
//
//  Created by CuongNVT on 1/10/20.
//  Copyright © 2020 CuongNVT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var entryTf: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shorternLb: UILabel!
    
    // MARK: - Variable
    let homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        observableView()
        // Add gesture
        shorternLb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOpenUrl(gesture:))))
    }

    // MARK: - Private func
    private func setupUI() {
        shorternLb.layer.cornerRadius = 5
        shorternLb.layer.masksToBounds = true
        shorternLb.layer.borderWidth = 1.0
        shorternLb.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func observableView() {
        // Observe tableView
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName: "UrlTableViewCell", bundle: nil), forCellReuseIdentifier: "UrlTableViewCell")
        homeViewModel.arrOriginUrl.asObserver().bind(to: tableView.rx.items(cellIdentifier: "UrlTableViewCell", cellType: UrlTableViewCell.self)) { row, tuple, cell in
            cell.updateUI(urlStr: tuple.0, date: tuple.1)
        }.disposed(by: disposeBag)
        
        // Observe textField
        entryTf.rx.text
        .distinctUntilChanged()
        .debounce(.seconds(2), scheduler: MainScheduler.instance)
        .asObservable().bind(to: homeViewModel.urlEntryTextField)
        .disposed(by: disposeBag)
        
        // Observe get url shortern
        homeViewModel.shorternUrls.observeOn(MainScheduler.instance).subscribe { (event) in
            print(event)
            switch event {
            case .next(let result):
                switch result {
                case .success(let text, _):
                    self.shorternLb.text = text
                case .failure(let error):
                    self.ErrorMessage(error: error.localizedDescription)
                }
            case .completed: print("Complete shortern url")
            case .error( _): print("Error shortern url")
            }
        }.disposed(by: disposeBag)
    }
    
    private func ErrorMessage(error: String) {
        let ErrorMessageAlert = UIAlertController(title:"Error", message: error, preferredStyle: .alert)
        ErrorMessageAlert.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))
        self.present(ErrorMessageAlert, animated: true, completion: nil)
    }
    
    // MARK: - Objc func
    @objc func didOpenUrl(gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            if let text = (gesture.view as? UILabel)?.text {
               guard let url = URL(string: text) else { return }
                UIApplication.shared.open(url, options: [:]) { [weak self] (isSuccess) in
                    guard !isSuccess else {
                        return
                    }
                    self?.ErrorMessage(error: "Error open url")
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(origin: CGPoint.zero, size: tableView.frame.size)
        let label = UILabel(frame: frame)
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.text = "List Shortern URL"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
