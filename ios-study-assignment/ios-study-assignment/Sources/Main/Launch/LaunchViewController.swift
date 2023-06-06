//
//  LaunchViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: LaunchViewModelProtocol
    
    // MARK: - Init
    init(viewModel: LaunchViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch()
    }
}

// MARK: - Set UI
extension LaunchViewController {
    private func setUI() {
        self.view.backgroundColor = .white
    }
}
