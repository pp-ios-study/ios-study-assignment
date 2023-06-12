//
//  StarRateView.swift
//  
//
//  Created by 최승명 on 2023/06/11.
//

import UIKit

import SnapKit

public final class StarRateView: UIView {
    
    // MARK: - UI
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    private lazy var starFillImage: UIImage? = {
        return UIImage(systemName: "star.fill")!.withRenderingMode(.alwaysTemplate)
    }()
    
    private lazy var starEmptyImage: UIImage? = {
        return UIImage(systemName: "star")!.withRenderingMode(.alwaysTemplate)
    }()
    private var buttons: [UIButton] = []
    
    // MARK: - Properties
    private var starNumber: Int = 5
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setButton()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    private func setUI() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.bottom.equalTo(self.snp.bottom)
            $0.top.equalTo(self.snp.top)
        }
    }
    
    private func setButton() {
        for _ in 0..<5 {
            let button = UIButton()
            button.setImage(starEmptyImage, for: .normal)
            button.setImage(starFillImage, for: .selected)
            button.tintColor = .lightGray
            button.isUserInteractionEnabled = false
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    public func setScore(score: Int) {
        for i in 0..<score {
            buttons[i].isSelected = true
        }
    }
}
