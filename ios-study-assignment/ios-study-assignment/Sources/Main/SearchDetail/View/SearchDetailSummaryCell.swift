//
//  SearchDetailSummaryCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/19.
//

import UIKit

import Common
import Domain

final class SearchDetailSummaryCell: UITableViewCell {
    
    // MARK: - Enum
    enum NumberState {
        case underThousand
        case thousand
        case upperThousand
    }
    
    // MARK: - UI
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()
    // 리뷰
    private lazy var reviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var reviewCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return label
    }()
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        return label
    }()
    private lazy var starRateView: StarRateView = StarRateView()
    // 구분선
    private lazy var separator1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    private lazy var separator2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    // 연령
    private lazy var ageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var ageSubLabel1: UILabel = {
        let label = UILabel()
        label.text = "연령"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return label
    }()
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        return label
    }()
    private lazy var ageSubLabel2: UILabel = {
        let label = UILabel()
        label.text = "세"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return label
    }()
    // 지원언어
    private lazy var languageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var languageSubLabel1: UILabel = {
        let label = UILabel()
        label.text = "언어"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return label
    }()
    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        return label
    }()
    private lazy var languageSubLabel2: UILabel = {
        let label = UILabel()
        label.text = "+ 0개 언어"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return label
    }()
    
    // MARK: - Properties
    private var numberState: NumberState = .underThousand
    
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
extension SearchDetailSummaryCell {
    private func setUI() {
        self.selectionStyle = .none
        
        reviewStackView.addArrangedSubview(reviewCountLabel)
        reviewStackView.addArrangedSubview(ratingLabel)
        reviewStackView.addArrangedSubview(starRateView)
        starRateView.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(20)
        }
        
        ageStackView.addArrangedSubview(ageSubLabel1)
        ageStackView.addArrangedSubview(ageLabel)
        ageStackView.addArrangedSubview(ageSubLabel2)
        
        languageStackView.addArrangedSubview(languageSubLabel1)
        languageStackView.addArrangedSubview(languageLabel)
        languageStackView.addArrangedSubview(languageSubLabel2)
        
        stackView.addArrangedSubview(reviewStackView)
        stackView.addArrangedSubview(separator1)
        separator1.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        stackView.addArrangedSubview(ageStackView)
        stackView.addArrangedSubview(separator2)
        separator2.snp.makeConstraints {
            $0.width.equalTo(1)
        }
        stackView.addArrangedSubview(languageStackView)

        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.top.greaterThanOrEqualToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    public func configureCell(appInfo: Search) {
        reviewCountLabel.text = (appInfo.userRatingCount ?? 0).suffixNumber()  + "개의 평가"
        ratingLabel.text = "\(round(appInfo.averageUserRating! * 10) / 10)"
        starRateView.setScore(score: Int(appInfo.averageUserRating ?? 0))
        
        ageLabel.text = appInfo.contentAdvisoryRating != nil ? "\(appInfo.contentAdvisoryRating!)" : ""
        
        if let regionCode = NSLocale.current.language.region?.identifier, let languageCodeList = appInfo.languageCodesISO2A {
            languageLabel.text = languageCodeList.contains(regionCode) ? regionCode : languageCodeList.first
        } else {
            languageLabel.text = ""
        }
        
        languageSubLabel2.text = "+ \(appInfo.languageCodesISO2A?.count ?? 0)개 언어"
    }
}
