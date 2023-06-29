//
//  SearchDetailScreenshotCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/19.
//

import UIKit

import Kingfisher

final class SearchDetailScreenshotCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "미리보기"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = .black
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 392 / 3 * 2, height: 696 / 3 * 2)
        
        let collectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(ScreenshotCollectionViewCell.self)
        
        return collectionView
    }()
    private lazy var deviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        label.textColor = .lightGray

        let imgAttachment = NSTextAttachment()
        imgAttachment.image = UIImage(systemName: "iphone.gen3")
        imgAttachment.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(10), height:CGFloat(12))
        
        let attributedString = NSAttributedString(attachment: imgAttachment)
        let lblString = NSMutableAttributedString(string: " iPhone")
        lblString.insert(attributedString, at: 0)
        
        label.attributedText = lblString
        return label
    }()
    
    // MARK: - Properties
    private var screenshotUrlList: [String] = []
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    private func setUI() {
        self.selectionStyle = .none
        
        self.contentView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.height.equalTo(696 / 3 * 2)
            $0.top.equalTo(headerLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.contentView.addSubview(deviceLabel)
        deviceLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    public func configureCell(screenshotUrlList: [String]) {
        self.screenshotUrlList = screenshotUrlList
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView
extension SearchDetailScreenshotCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        screenshotUrlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(
            ScreenshotCollectionViewCell.self,
            for: indexPath
        ) else {
            return UICollectionViewCell()
        }
        cell.configureCell(url: screenshotUrlList[indexPath.row])
        return cell
    }
}

extension SearchDetailScreenshotCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - UICollectionViewCell
fileprivate final class ScreenshotCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var screenshot: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set UI
extension ScreenshotCollectionViewCell {
    private func setUI() {
        self.contentView.addSubview(screenshot)
        screenshot.snp.makeConstraints {
            $0.width.equalTo(392 / 3 * 2)
            $0.height.equalTo(696 / 3 * 2)
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    fileprivate func configureCell(url: String) {
        let url =  URL(string: url)
        screenshot.kf.setImage(with: url)
    }
}
