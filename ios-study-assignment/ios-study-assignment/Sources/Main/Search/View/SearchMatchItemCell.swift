//
//  SearchMatchItemCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/04.
//

import UIKit

import RxSwift

class SearchMatchItemCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .lightGray
        return imageView
    }()
    private lazy var searchHistoryTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        return label
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
extension SearchMatchItemCell {
    private func setUI() {
        self.contentView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(searchHistoryTextLabel)
        searchHistoryTextLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.equalTo(cellImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureCell(text: String) {
        searchHistoryTextLabel.text = text
    }
}
