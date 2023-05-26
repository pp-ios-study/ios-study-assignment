//
//  SearchViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/26.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
}

extension SearchViewController {
    // MARK: - Set UI
    private func setUI() {
        self.view.backgroundColor = .white
    }
}
