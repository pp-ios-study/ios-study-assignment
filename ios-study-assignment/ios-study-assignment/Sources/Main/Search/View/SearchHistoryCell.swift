//
//  SearchHistoryCell.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/04.
//

import UIKit

import RxSwift
import RxCocoa

final class SearchHistoryCell: UITableViewCell {
    
    // MARK: - UI
    private lazy var searchHistoryTextLabel: UITextField = {
        let label = UITextField()
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
    
    // MARK: - Properties
    private var viewModel: SearchViewModelProtocol?
    private let disposeBag: DisposeBag = DisposeBag()
    
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
    
    func configureCell(text: String, viewModel: SearchViewModelProtocol) {
        searchHistoryTextLabel.text = text
        
        self.viewModel = viewModel
        
        bind()
    }
}

// MARK: - Binding
extension SearchHistoryCell {
    func bind() {
        guard let viewModel = self.viewModel else { return }
        
        Observable.zip(deleteButton.rx.tap, searchHistoryTextLabel.rx.text.orEmpty)
            .bind(to: viewModel.historyCellDeleteButtonDidTap)
            .disposed(by: disposeBag)
    }
}
