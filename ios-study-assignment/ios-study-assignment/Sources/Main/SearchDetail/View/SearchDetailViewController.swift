//
//  SearchDetailViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/19.
//

import UIKit

import Domain

final class SearchDetailViewController: UIViewController {
    
    // MARK: - UI
    private lazy var tableView: UITableView = UITableView()
    
    // MARK: - Properties
    private var appInfo: Search?
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Set UI
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Set Table View
    private func setTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        tableView.registerCell(SearchDetailTitleCell.self)
        tableView.registerCell(SearchSummaryCell.self)
        tableView.registerCell(SearchReleaseNoteCell.self)
        tableView.registerCell(SearchScreenshotCell.self)
        tableView.registerCell(SearchDescriptionCell.self)
    }
}

// MARK: - UITableView
extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appInfo = appInfo else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueCell(
                SearchDetailTitleCell.self,
                for: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configureCell(appInfo: appInfo)
            return cell
        case 1:
            guard let cell = tableView.dequeueCell(
                SearchSummaryCell.self,
                for: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configureCell(appInfo: appInfo)
            return cell
        case 2:
            if let releaseNotes = appInfo.releaseNotes {
                guard let cell = tableView.dequeueCell(
                    SearchReleaseNoteCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.delegate = self
                cell.configureCell(text: releaseNotes)
                return cell
            } else {
                return UITableViewCell()
            }
        case 3:
            guard let cell = tableView.dequeueCell(
                SearchScreenshotCell.self,
                for: indexPath
            ) else {
                return UITableViewCell()
            }
            cell.configureCell(screenshotUrlList: appInfo.screenshotUrls ?? [String]())
            return cell
        case 4:
            if let description = appInfo.description {
                guard let cell = tableView.dequeueCell(
                    SearchDescriptionCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.delegate = self
                cell.configureCell(text: description)
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Delegate
extension SearchDetailViewController: TextViewUpdate {
    func updateTextView() {
        tableView.reloadData()
    }
}
