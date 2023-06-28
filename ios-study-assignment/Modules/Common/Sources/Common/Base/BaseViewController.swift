//
//  BaseViewController.swift
//  
//
//  Created by 최승명 on 2023/06/28.
//

import UIKit

import RxSwift

open class BaseViewController: UIViewController {
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
    }
}

// MARK: - Set UI
extension BaseViewController {
    func setBackgroundColor() {
        self.view.backgroundColor = .white
    }
}
