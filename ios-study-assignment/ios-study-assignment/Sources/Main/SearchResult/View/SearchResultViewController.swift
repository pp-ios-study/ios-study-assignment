//
//  SearchResultViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/04.
//

import UIKit

import Common
import Domain
import RxSwift
import RxCocoa

final class SearchResultViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.generateLayout())
        collectionView.isScrollEnabled = true
        collectionView.registerCell(SearchResultCell.self)
        return collectionView
    }()
    private lazy var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Properties
    private let viewModel: SearchViewModelProtocol
    
    // MARK: - Init
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        setUI()
    }
}

// MARK: - Set UI
extension SearchResultViewController {
    private func setUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Set Collection View
extension SearchResultViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.generateSearchItemLayout()
        }
        
        return layout
    }
    
    private func generateSearchItemLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(342)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(342)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
}

// MARK: - UISearchResultsUpdating
extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}

// MARK: - Binding
extension SearchResultViewController {
    private func bind() {
        // input
        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(Search.self)
        )
        .bind(to: viewModel.searchItemCellDidTap)
        .disposed(by: disposeBag)
        
        // output
        viewModel.searchList
            .bind(to: collectionView.rx.items(
                cellIdentifier: SearchResultCell.reuseIdentifier,
                cellType: SearchResultCell.self
            )) { (row, item, cell) in
                cell.configureCell(appInfo: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.isEmpty
            .asDriver(onErrorJustReturn: false)
            .drive { isEmpty in
                self.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
