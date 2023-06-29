//
//  SearchDetailTitleCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/19.
//

import UIKit

import Domain
import Kingfisher

final class SearchDetailTitleCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var appLogoImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        return label
    }()
    private lazy var appDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
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
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayer()
    }
}

// MARK: - Set UI
extension SearchDetailTitleCell {
    private func setUI() {
        self.selectionStyle = .none
        
        self.contentView.addSubview(appLogoImage)
        appLogoImage.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(appTitleLabel)
        appTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(appLogoImage.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
        }
        
        self.contentView.addSubview(appDescriptionLabel)
        appDescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(appLogoImage.snp.trailing).offset(20)
            $0.top.equalTo(appTitleLabel.snp.bottom).offset(5)
        }
    }
    
    private func setLayer() {
        appLogoImage.layer.cornerRadius = 12
        appLogoImage.clipsToBounds = true
    }
    
    public func configureCell(appInfo: Search) {
        appTitleLabel.text = appInfo.trackName
        appDescriptionLabel.text = appInfo.artistName
        
        let logoURL = URL(string: appInfo.artworkUrl512 ?? "")
        appLogoImage.kf.setImage(with: logoURL)
    }
}
