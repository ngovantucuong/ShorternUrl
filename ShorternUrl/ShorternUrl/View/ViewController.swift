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
    
    // MARK: - Variable
    var homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    // MARK: - Private func
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        entryTf.rx.text.orEmpty.bind(to: homeViewModel.urlEntryTextField).disposed(by: disposeBag)
        homeViewModel.ShortenURL(URLToSorten: "entryTf.rx.text", topVC: self)
        homeViewModel.urlShorten.asObserver().bind(to: entryTf.rx.textInput)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}
