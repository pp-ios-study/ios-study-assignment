//
//  SearchDescriptionCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/19.
//

import UIKit

protocol TextViewUpdate: AnyObject {
    func updateTextView()
}

final class SearchDescriptionCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var appDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byCharWrapping
        return textView
    }()
    private lazy var readModebutton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(onTouchedReadMoreButton), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func onTouchedReadMoreButton() {
        readModebutton.isHidden = true
        
        appDescriptionTextView.textContainer.maximumNumberOfLines = 0
        appDescriptionTextView.invalidateIntrinsicContentSize()
        
        delegate?.updateTextView()
    }
    
    // MARK: - Properties
    weak var delegate: TextViewUpdate?
    
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
extension SearchDescriptionCell {
    private func setUI() {
        self.selectionStyle = .none
        
        self.contentView.addSubview(appDescriptionTextView)
        appDescriptionTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(readModebutton)
        readModebutton.snp.makeConstraints {
            $0.trailing.equalTo(appDescriptionTextView.snp.trailing)
            $0.bottom.equalTo(appDescriptionTextView.snp.bottom).offset(10)
        }
    }

    public func configureCell(text: String) {
        appDescriptionTextView.text = text
    }
}
