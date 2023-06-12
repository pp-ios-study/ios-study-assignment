//
//  SearchViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/26.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

class SearchViewController: UIViewController {
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(SearchMatchItemCell.self)
        tableView.registerCell(SearchHistoryCell.self)
        return tableView
    }()
    private var searchController: UISearchController!
    private var searchListViewController: SearchListViewController!
    
    // MARK: - Properties
    private var originalSearchHistoryList: [String] = []
    private var searchHistoryList: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let viewModel: SearchViewModelProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
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
        
        setNavigation()
        setUI()
        setTableViewItem()
        setTapGesture()
        
        bind()
        
        requestSearchHistory()
    }
    
    // MARK: - Set Navigation
    private func setNavigation() {
        searchListViewController = SearchListViewController(viewModel: viewModel)
        
        searchController = UISearchController(searchResultsController: searchListViewController)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchResultsUpdater = searchListViewController
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.showsSearchResultsController = false
        
        self.navigationItem.title = "검색"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    // MARK: Set UI
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Set Gesture
    private func setTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboardTouchOutside() {
//        if inputState == .typing {
//            return
//        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Binding
    private func bind() {
        viewModel.title
            .bind(to: searchController.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isShowResult
            .bind(to: searchController.rx.showsSearchResultsController)
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
    }
    
    // MARK: - Fetch
    private func requestSearchHistory() {
        viewModel.fetchData()
    }
}

// MARK: - UITableView
/*
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch inputState {
        case .history:
            return "최근 검색어"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch inputState {
        case .history:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        searchController.searchBar.text = searchHistoryList[indexPath.row]
        searchController.searchBar.resignFirstResponder()
        searchController.showsSearchResultsController = true
        searchController.isActive = true
    }
}
 */

// MARK: - Set Table View
extension SearchViewController {
    private func setTableViewItem() {
        typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel>
        let dataSource = DataSource { dataSource, tableView, indexPath, item in
            switch item {
            case .history(let text):
                guard let cell = tableView.dequeueCell(
                    SearchHistoryCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.configureCell(text: text)
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
