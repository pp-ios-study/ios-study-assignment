//
//  SearchHistoryCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/04.
//

import UIKit

import RxSwift

final class SearchHistoryCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var searchHistoryTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemBlue
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 20)
        return label
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set UI
extension SearchHistoryCell {
    private func setUI() {
        self.selectionStyle = .none
        
        self.contentView.addSubview(searchHistoryTextLabel)
        searchHistoryTextLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.equalToSuperview().offset(20)
            $0.top.greaterThanOrEqualToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureCell(text: String) {
        searchHistoryTextLabel.text = text
    }
}
