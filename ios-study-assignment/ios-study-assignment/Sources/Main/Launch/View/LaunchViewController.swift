//
//  LaunchViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import UIKit

import Common
import RxSwift
import RxCocoa

final class LaunchViewController: BaseViewController {
    
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
        
        bind()
    }
}

// MARK: - Binding
extension LaunchViewController {
    private func bind() {
        self.rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
    }
}
