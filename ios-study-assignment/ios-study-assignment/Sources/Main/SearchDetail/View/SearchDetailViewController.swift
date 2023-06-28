//
//  SearchDetailViewController.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/19.
//

import UIKit

import Common
import Domain
import RxCocoa
import RxDataSources
import RxSwift

final class SearchDetailViewController: BaseViewController {
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.registerCell(SearchDetailTitleCell.self)
        tableView.registerCell(SearchDetailSummaryCell.self)
        tableView.registerCell(SearchDetailReleaseNoteCell.self)
        tableView.registerCell(SearchDetailScreenshotCell.self)
        tableView.registerCell(SearchDetailDescriptionCell.self)
        return tableView
    }()
    
    // MARK: - Properties
    private let viewModel: SearchDetailViewModelProtocol
    
    // MARK: - Init
    init(viewModel: SearchDetailViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableViewItem()
        
        bind()
    }
}

// MARK: - Set UI
extension SearchDetailViewController {
    private func setUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Set Table View
extension SearchDetailViewController {
    private func setTableViewItem() {
        typealias DataSource = RxTableViewSectionedReloadDataSource<DetailSectionModel>
        let dataSource = DataSource { dataSource, tableView, indexPath, item in
            switch item {
            case .title(let appInfo):
                guard let cell = tableView.dequeueCell(
                    SearchDetailTitleCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.configureCell(appInfo: appInfo)
                return cell
            case .summary(let appInfo):
                guard let cell = tableView.dequeueCell(
                    SearchDetailSummaryCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.configureCell(appInfo: appInfo)
                return cell
            case .releaseNote(let appInfo):
                if let releaseNotes = appInfo.releaseNotes {
                    guard let cell = tableView.dequeueCell(
                        SearchDetailReleaseNoteCell.self,
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
            case .screenshot(let appInfo):
                guard let cell = tableView.dequeueCell(
                    SearchDetailScreenshotCell.self,
                    for: indexPath
                ) else {
                    return UITableViewCell()
                }
                cell.configureCell(screenshotUrlList: appInfo.screenshotUrls ?? [String]())
                return cell
            case .description(let appInfo):
                if let description = appInfo.description {
                    guard let cell = tableView.dequeueCell(
                        SearchDetailDescriptionCell.self,
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
            }
        }
        
        viewModel.item
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}

// MARK: - Binding
extension SearchDetailViewController {
    func bind() {
        // Input
        self.rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        self.rx.viewWillDisappear
            .bind(to: viewModel.viewWillDisappear)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.isLargeTitle
            .bind(to: self.navigationController!.navigationBar.rx.prefersLargeTitles)
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension SearchDetailViewController: TextViewUpdate {
    func updateTextView() {
        tableView.reloadData()
    }
}
