//
//  LaunchViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
}

extension LaunchViewController {
    // MARK: - Set UI
    private func setUI() {
        self.view.backgroundColor = .white
    }
}
