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
        tableView.registerCell(SearchHistoryTableViewCell.self)
        tableView.registerCell(SearchItemTableViewCell.self)
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
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        setNavigation()
        setUI()
        setTapGesture()
    }
    
    // MARK: - Set Navigation
    private func setNavigation() {
        guard let navigationController = self.navigationController else { return }
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
            guard let cell = tableView.dequeueCell(SearchHistoryTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            return cell
        case .typing:
            guard let cell = tableView.dequeueCell(SearchItemTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
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
