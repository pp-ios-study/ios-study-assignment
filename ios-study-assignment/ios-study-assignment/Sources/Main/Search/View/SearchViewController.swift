//
//  SearchViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/26.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController {
    
    //MARK: - Enum
    enum InputState {
        case history
        case typing
    }
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(SearchMatchItemCell.self)
        tableView.registerCell(SearchHistoryCell.self)
        return tableView
    }()
    private var searchController: UISearchController!
    private var searchListViewController: SearchListViewController!
    
    // MARK: - Properties
    private var inputText: String = ""
    private var inputState: InputState = .history
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
        
        bind()
        
        setNavigation()
        setUI()
        setTapGesture()
        
        requestSearchHistory()
    }
    
    // MARK: - Set Navigation
    private func setNavigation() {
        searchListViewController = SearchListViewController()
        
        searchController = UISearchController(searchResultsController: searchListViewController)
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.delegate = self
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
    func setTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboardTouchOutside() {
        if inputState == .typing {
            return
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Binding
    private func bind() {
        viewModel.historyList
            .subscribe(onNext: { searchHistoryList in
                self.originalSearchHistoryList = searchHistoryList.map { $0.id }
                self.searchHistoryList = searchHistoryList.map { $0.id }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        guard let searchController = self.navigationItem.searchController else { return }
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
    
    // MARK: - Realm
    /// 검색어 저장
    /// - parameter keyword: 검색어
    private func saveSearchHistory(with keyword: String) {
        viewModel.saveKeyword(keyword: keyword)
        
        requestSearchHistory()
    }
    
    private func requestSearchHistory() {
        viewModel.getSearchHistory()
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    /// 검색창을 눌렀을 때
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    /// 키보드에서 search 버튼을 눌렀을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        inputText = searchBar.text ?? ""
        
        if !inputText.isEmpty {
            saveSearchHistory(with: inputText)
            
            searchController.showsSearchResultsController = true
        }
    }
    
    /// 검색창의 취소 버튼을 눌렀을 때
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.showsSearchResultsController = false
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    /// 검색창에서 텍스트 입력을 시작 했을 때
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    /// 검색창에서 텍스트 입력이 끝났을 때
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        inputState = .history
        searchHistoryList = originalSearchHistoryList
        
        return true
    }
    
    /// 검색창에서 텍스트를 입려중일 때
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchController.showsSearchResultsController = false
        
        inputState = .typing
        searchHistoryList = originalSearchHistoryList.filter({ $0.contains(searchText) })
    }
}

// MARK: - UITableView
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch inputState {
        case .history:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch inputState {
        case .history:
            guard let cell = tableView.dequeueCell(
                SearchHistoryCell.self,
                for: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configureCell(text: searchHistoryList[indexPath.row])
            return cell
        case .typing:
            guard let cell = tableView.dequeueCell(
                SearchMatchItemCell.self,
                for: indexPath
            ) else {
                return UITableViewCell()
            }
//            cell.configureCell(keyword: searchHistoryList[indexPath.row])
            return cell
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
