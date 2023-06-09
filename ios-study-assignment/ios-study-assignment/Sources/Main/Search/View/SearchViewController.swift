//
//  SearchViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/26.
//

import UIKit

import Common
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class SearchViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(SearchMatchItemCell.self)
        tableView.registerCell(SearchHistoryCell.self)
        return tableView
    }()
    private var searchController: UISearchController!
    private var searchListViewController: SearchResultViewController!
    
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
        
        setSearchBar()
        setNavigation()
        setUI()
        setTableViewItem()
        setTapGesture()
        
        bind()
    }
}

// MARK: Set UI
extension SearchViewController {
    private func setSearchBar() {
        searchListViewController = SearchResultViewController(viewModel: viewModel)
        
        searchController = UISearchController(searchResultsController: searchListViewController)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchResultsUpdater = searchListViewController
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.showsSearchResultsController = false
    }
    
    private func setNavigation() {
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = "검색"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    private func setUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Set Gesture
extension SearchViewController {
    private func setTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboardTouchOutside() {
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - Set Table View
extension SearchViewController {
    private func setTableViewItem() {
        typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel>
        let dataSource = DataSource { [viewModel] dataSource, tableView, indexPath, item in
            switch item {
            case .history(let text):
                guard let cell = tableView.dequeueCell(
                    SearchHistoryCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.configureCell(text: text, viewModel: viewModel)
                return cell
            case .typing(let text):
                guard let cell = tableView.dequeueCell(
                    SearchMatchItemCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.configureCell(text: text)
                return cell
            }
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].headerTitle
        }
        
        viewModel.item
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - Binding
extension SearchViewController {
    private func bind() {
        // input
        self.rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.text)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .bind(to: viewModel.searchButtonClicked)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .bind(to: viewModel.cancelButtonClicked)
            .disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(SectionModel.SearchItem.self)
        )
        .bind(to: viewModel.historyCellDidTap)
        .disposed(by: disposeBag)
        
        // output
        viewModel.title
            .bind(to: searchController.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isShowResult
            .bind(to: searchController.rx.showsSearchResultsController)
            .disposed(by: disposeBag)
        
        viewModel.isShowResult
            .bind(to: searchController.rx.isActive)
            .disposed(by: disposeBag)
        
        viewModel.isLargeTitle
            .bind(to: self.navigationController!.navigationBar.rx.prefersLargeTitles)
            .disposed(by: disposeBag)
    }
}
