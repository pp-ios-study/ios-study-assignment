//
//  SearchResultCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/11.
//

import UIKit

import Common
import Domain
import Kingfisher

final class SearchResultCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var appLogoImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var appTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.numberOfLines = 1
        return label
    }()
    private lazy var appDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        return label
    }()
    private lazy var appRatingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return label
    }()
    private lazy var screenshotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var appScreenShotImage1: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var appScreenShotImage2: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var appScreenShotImage3: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var starRateView: StarRateView = StarRateView()
    
    private var appScreenShotImageList: [UIImageView] = []
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set UI
extension SearchResultCell {
    private func setUI() {
        self.contentView.addSubview(appLogoImage)
        appLogoImage.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
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
            $0.centerY.equalTo(appLogoImage.snp.centerY)
        }
        
        self.contentView.addSubview(starRateView)
        starRateView.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(12)
            $0.leading.equalTo(appLogoImage.snp.trailing).offset(20)
            $0.bottom.equalTo(appLogoImage.snp.bottom)
        }
        
        self.contentView.addSubview(appRatingLabel)
        appRatingLabel.snp.makeConstraints {
            $0.leading.equalTo(starRateView.snp.trailing).offset(5)
            $0.centerY.equalTo(starRateView.snp.centerY).offset(2)
        }
        
        self.contentView.addSubview(screenshotStackView)
        screenshotStackView.snp.makeConstraints {
            $0.height.equalTo(232)
            $0.top.equalTo(appLogoImage.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        // 392 / 696
        screenshotStackView.addArrangedSubview(appScreenShotImage1)
        screenshotStackView.addArrangedSubview(appScreenShotImage2)
        screenshotStackView.addArrangedSubview(appScreenShotImage3)
        
        appScreenShotImageList = [appScreenShotImage1, appScreenShotImage2, appScreenShotImage3]
    }
    
    private func setLayer() {
        appLogoImage.layer.cornerRadius = 12
        appLogoImage.clipsToBounds = true
        
        appScreenShotImage1.layer.cornerRadius = 12
        appScreenShotImage1.clipsToBounds = true
        
        appScreenShotImage2.layer.cornerRadius = 12
        appScreenShotImage2.clipsToBounds = true
        
        appScreenShotImage3.layer.cornerRadius = 12
        appScreenShotImage3.clipsToBounds = true
    }
    
    public func configureCell(appInfo: Search) {
        appTitleLabel.text = appInfo.trackName
        appDescriptionLabel.text = appInfo.artistName
        
        starRateView.setScore(score: Int(appInfo.averageUserRating ?? 0))
        appRatingLabel.text = (appInfo.userRatingCount ?? 0).suffixNumber()
        
        let logoURL = URL(string: appInfo.artworkUrl512 ?? "")
        let processor = DownsamplingImageProcessor(size: appLogoImage.frame.size)
        appLogoImage.kf.setImage(
            with: logoURL,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
        
        guard let screenshotUrlList = appInfo.screenshotUrls else { return }
        for i in 0..<screenshotUrlList.count {
            if i >= self.appScreenShotImageList.count {
                return
            }

            let url = URL(string: screenshotUrlList[i])
            let processor = DownsamplingImageProcessor(size: appScreenShotImageList[i].frame.size)
            appScreenShotImageList[i].kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
    }
}
